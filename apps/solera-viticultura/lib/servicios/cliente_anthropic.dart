import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Resultado del análisis de una foto de cepa por Claude vision.
/// Salida estructurada para que la app pueda pre-rellenar el
/// formulario de incidencia tras revisión humana.
class ResultadoAnalisisIA {
  final String nombreComun;
  final String nombreCientifico;
  final String tipo;
  final int? severidad;
  final double confianza;
  final String manejoCultural;
  final String advertencia;

  ResultadoAnalisisIA({
    required this.nombreComun,
    required this.nombreCientifico,
    required this.tipo,
    this.severidad,
    required this.confianza,
    required this.manejoCultural,
    this.advertencia = '',
  });
}

class ErrorIA implements Exception {
  final String mensaje;
  ErrorIA(this.mensaje);
  @override
  String toString() => 'ErrorIA: $mensaje';
}

/// Cliente de la API Messages de Anthropic con vision. Identifica
/// plagas, enfermedades y trastornos de vid por foto. Responde JSON
/// estricto que la app parsea a `ResultadoAnalisisIA`.
///
/// Cuando entre el catálogo curado de F1-5, este cliente añadirá
/// matching de la respuesta contra el catálogo (paralelo al patrón
/// de agro). Hasta entonces el diagnóstico es libre y se marca como
/// tal en el modal de revisión.
class ClienteAnthropic {
  static const _modelo = 'claude-haiku-4-5';
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  static const _version = '2023-06-01';

  final String claveApi;
  ClienteAnthropic(this.claveApi);

  /// Analiza una foto de la cepa y devuelve un diagnóstico
  /// estructurado. La foto se sube como base64 en el cuerpo del
  /// mensaje (evita tener que subirla antes a un servidor público).
  Future<ResultadoAnalisisIA> analizarFoto({
    required File foto,
    String observacionesUsuario = '',
  }) async {
    final bytes = await foto.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      throw ErrorIA(
        'La foto pesa más de 5 MB y la API la rechazará. '
        'Reduce el tamaño antes de enviarla.',
      );
    }
    final base64Foto = base64Encode(bytes);
    final mediaType = _detectarTipoMedia(foto.path);
    final promptUsuario = _construirPrompt(observacionesUsuario);

    final cuerpo = jsonEncode({
      'model': _modelo,
      'max_tokens': 1024,
      'system': _promptSistema,
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'image',
              'source': {
                'type': 'base64',
                'media_type': mediaType,
                'data': base64Foto,
              },
            },
            {
              'type': 'text',
              'text': promptUsuario,
            },
          ],
        },
      ],
    });

    final respuesta = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'x-api-key': claveApi,
        'anthropic-version': _version,
        'content-type': 'application/json',
      },
      body: cuerpo,
    ).timeout(const Duration(seconds: 60));

    if (respuesta.statusCode == 401) {
      throw ErrorIA('Clave Anthropic inválida o caducada. Revisa Ajustes.');
    }
    if (respuesta.statusCode == 429) {
      throw ErrorIA('Rate limit alcanzado en Anthropic. Espera unos minutos.');
    }
    if (respuesta.statusCode != 200) {
      throw ErrorIA('Error HTTP ${respuesta.statusCode}: ${respuesta.body}');
    }

    final json = jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;
    final contenido = (json['content'] as List?) ?? const [];
    String texto = '';
    for (final bloque in contenido) {
      if (bloque is Map && bloque['type'] == 'text') {
        texto += bloque['text']?.toString() ?? '';
      }
    }
    if (texto.isEmpty) {
      throw ErrorIA('Respuesta vacía de la IA.');
    }
    return _parsearJson(texto);
  }
}

/// System prompt vid-específico. Lista canónica de plagas,
/// enfermedades y trastornos esperables en *Vitis vinifera* en
/// climas peninsulares. Cuando entre el catálogo curado de F1-5
/// con asesor agronómico, esta lista se contrastará automáticamente
/// para distinguir "diagnóstico validado por catálogo Solera" del
/// "diagnóstico libre de la IA" — patrón análogo al de agro.
const String _promptSistema = '''
Eres un agrónomo experto en viticultura, especializado en *Vitis vinifera* en climas peninsulares (España, Portugal, sur de Francia). Te paso una foto de una cepa, hoja, racimo o sarmiento con un posible problema sanitario y debes diagnosticarlo.

LISTA CANÓNICA DE INCIDENCIAS COMUNES EN VID (no exhaustiva — si ves algo distinto, lo describes igual):
- Enfermedades fúngicas: mildiu (*Plasmopara viticola*), oídio (*Erysiphe necator*), botritis o podredumbre gris (*Botrytis cinerea*), black-rot (*Guignardia bidwellii*), excoriosis (*Phomopsis viticola*), eutipiosis (*Eutypa lata*), yesca, brazo muerto.
- Plagas de insectos: polilla del racimo (*Lobesia botrana*), mosquito verde (*Empoasca vitis*), trips, ácaros eriófidos (acariosis y erinosis), filoxera (síntomas en raíz, raramente foliar en patrón resistente).
- Trastornos abióticos: corrimiento, golpe de calor, granizo, deficiencia hídrica, deficiencia nutricional (potasio, magnesio, hierro), fitotoxicidad por herbicida.

REGLAS ESTRICTAS:

1. Responde SOLO con JSON, sin texto antes ni después. Sin bloques de código markdown.

2. Estructura del JSON:
{
  "nombre_comun": "nombre habitual en español de la plaga/enfermedad/trastorno",
  "nombre_cientifico": "nombre científico binomial si aplica, vacío si es un trastorno fisiológico/abiótico",
  "tipo": "plaga" | "enfermedad" | "fisiologico" | "abiotico" | "indeterminado",
  "severidad": número entero 1-5 estimado, o null si no es valorable,
  "confianza": número decimal 0.0-1.0 (cuánta confianza tienes en el diagnóstico),
  "manejo_cultural": "recomendaciones de manejo NO QUÍMICO en 2-3 frases (poda sanitaria, deshojado, eliminar restos, ajuste de riego, recogida de racimos afectados, etc.). NO menciones nombres comerciales de productos fitosanitarios.",
  "advertencia": "si la foto es de baja calidad, hay dudas, o el síntoma es ambiguo, lo dices aquí. Vacío si confianza alta."
}

3. NUNCA recomiendes productos fitosanitarios concretos por nombre comercial. Esto es un compromiso legal de la app: solo manejo cultural en v0.1.

4. Si la foto NO es de vid o no ves un problema, devuelve tipo="indeterminado", confianza=0.0, advertencia explicativa.

5. Sé conservador con la severidad: 5 solo para daños masivos / muerte de la cepa, 1 para síntomas incipientes muy localizados.

6. Si dudas entre dos especies (p. ej. mildiu vs black-rot en hoja), da la más probable y baja la confianza; explícalo en advertencia.
''';

String _construirPrompt(String observaciones) {
  final ctx = StringBuffer()
    ..writeln('Cultivo: Vid (*Vitis vinifera*)');
  if (observaciones.trim().isNotEmpty) {
    ctx.writeln('\nObservaciones del usuario: ${observaciones.trim()}');
  }
  ctx.writeln('\nDiagnostica el problema visible en la foto.');
  return ctx.toString();
}

ResultadoAnalisisIA _parsearJson(String texto) {
  // El modelo a veces envuelve en ```json ... ``` aunque pidamos lo contrario.
  var limpio = texto.trim();
  if (limpio.startsWith('```')) {
    final primerSalto = limpio.indexOf('\n');
    if (primerSalto != -1) limpio = limpio.substring(primerSalto + 1);
    if (limpio.endsWith('```')) {
      limpio = limpio.substring(0, limpio.length - 3).trim();
    }
  }
  try {
    final json = jsonDecode(limpio) as Map<String, dynamic>;
    return ResultadoAnalisisIA(
      nombreComun: (json['nombre_comun'] as String?) ?? 'Sin diagnóstico',
      nombreCientifico: (json['nombre_cientifico'] as String?) ?? '',
      tipo: (json['tipo'] as String?) ?? 'indeterminado',
      severidad: (json['severidad'] as num?)?.toInt(),
      confianza: ((json['confianza'] as num?)?.toDouble() ?? 0).clamp(0, 1).toDouble(),
      manejoCultural: (json['manejo_cultural'] as String?) ?? '',
      advertencia: (json['advertencia'] as String?) ?? '',
    );
  } catch (e) {
    throw ErrorIA('La respuesta de la IA no era JSON válido: $e\nTexto recibido: $limpio');
  }
}

String _detectarTipoMedia(String ruta) {
  final lower = ruta.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.gif')) return 'image/gif';
  if (lower.endsWith('.webp')) return 'image/webp';
  return 'image/jpeg';
}
