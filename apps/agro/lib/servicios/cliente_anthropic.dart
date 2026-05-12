import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../datos/catalogo_cultivos.dart';
import '../datos/catalogo_plagas.dart';

/// Resultado del análisis de una foto por Claude vision. Salida
/// estructurada para que la app pueda contrastarla con el catálogo
/// curado y pre-rellenar el formulario de incidencia.
///
/// `coincidenciaCatalogo` se rellena por la app post-llamada cruzando
/// el `nombreCientifico` o `nombreComun` con `catalogo_plagas`. Si
/// hay match, la incidencia se etiqueta como "validada por catálogo
/// Solera"; si no, advertencia visible al usuario.
class ResultadoAnalisisIA {
  final String nombreComun;
  final String nombreCientifico;
  final String tipo;
  final int? severidad;
  final double confianza;
  final String manejoCultural;
  final String advertencia;
  final String? coincidenciaCatalogo;

  ResultadoAnalisisIA({
    required this.nombreComun,
    required this.nombreCientifico,
    required this.tipo,
    this.severidad,
    required this.confianza,
    required this.manejoCultural,
    this.advertencia = '',
    this.coincidenciaCatalogo,
  });
}

class ErrorIA implements Exception {
  final String mensaje;
  ErrorIA(this.mensaje);
  @override
  String toString() => 'ErrorIA: $mensaje';
}

class ClienteAnthropic {
  static const _modelo = 'claude-haiku-4-5';
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  static const _version = '2023-06-01';

  final String claveApi;
  ClienteAnthropic(this.claveApi);

  /// Analiza una foto de la planta y devuelve un diagnóstico
  /// estructurado. La foto se sube como base64 en el cuerpo del
  /// mensaje (evita tener que subir antes a un servidor público).
  Future<ResultadoAnalisisIA> analizarFoto({
    required File foto,
    required Cultivo cultivoContexto,
    String observacionesUsuario = '',
  }) async {
    final bytes = await foto.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      throw ErrorIA(
        'La foto pesa más de 5 MB y la API la rechazará. '
        'Reduce el tamaño antes de enviarla.',
      );
    }
    final mediaType = _detectarTipoMedia(foto.path);
    if (mediaType == null) {
      throw ErrorIA(
        'El fichero adjunto no parece una imagen (extensión no reconocida). '
        'Acepto JPG, PNG, GIF o WEBP.',
      );
    }
    final base64Foto = base64Encode(bytes);
    final promptUsuario = _construirPrompt(cultivoContexto, observacionesUsuario);

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
    final resultado = _parsearJson(texto);
    final coincidencia = _buscarCoincidenciaCatalogo(resultado.nombreCientifico, resultado.nombreComun);
    return ResultadoAnalisisIA(
      nombreComun: resultado.nombreComun,
      nombreCientifico: resultado.nombreCientifico,
      tipo: resultado.tipo,
      severidad: resultado.severidad,
      confianza: resultado.confianza,
      manejoCultural: resultado.manejoCultural,
      advertencia: resultado.advertencia,
      coincidenciaCatalogo: coincidencia,
    );
  }
}

const String _promptSistema = '''
Eres un agrónomo experto especializado en cultivos peninsulares (España, Portugal, sur de Francia). Te paso una foto de un cultivo con un posible problema sanitario y debes diagnosticarlo.

REGLAS ESTRICTAS:

1. Responde SOLO con JSON, sin texto antes ni después. Sin bloques de código markdown.

2. Estructura del JSON:
{
  "nombre_comun": "nombre habitual en español de la plaga/enfermedad/trastorno",
  "nombre_cientifico": "nombre científico binomial si aplica, vacío si es un trastorno fisiológico/abiótico",
  "tipo": "plaga" | "enfermedad" | "fisiologico" | "abiotico" | "indeterminado",
  "severidad": número entero 1-5 estimado, o null si no es valorable,
  "confianza": número decimal 0.0-1.0 (cuánta confianza tienes en el diagnóstico),
  "manejo_cultural": "recomendaciones de manejo NO QUÍMICO en 2-3 frases (poda, riego, trampeo, recogida, etc.). NO menciones nombres comerciales de productos fitosanitarios.",
  "advertencia": "si la foto es de baja calidad, hay dudas, o el síntoma es ambiguo, lo dices aquí. Vacío si confianza alta."
}

3. NUNCA recomiendes productos fitosanitarios concretos por nombre comercial. Esto es un compromiso legal de la app: solo manejo cultural en v1.

4. Si la foto NO es de un cultivo o no ves un problema, devuelve tipo="indeterminado", confianza=0.0, advertencia explicativa.

5. Sé conservador con la severidad: 5 solo para daños masivos / muerte de la planta, 1 para síntomas incipientes muy localizados.

6. Si dudas entre dos especies, da la más probable y baja la confianza.
''';

String _construirPrompt(Cultivo cultivo, String observaciones) {
  final ctx = StringBuffer()
    ..writeln('Cultivo: ${cultivo.nombreVisible} (${cultivo.nombreCientifico})')
    ..writeln('Categoría: ${cultivo.categoria.nombreVisible}');
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

/// Busca una plaga en el catálogo curado de Solera por matching de
/// nombre científico (preferente) o nombre común. Si encuentra,
/// devuelve el id; si no, null. Esto permite a la UI marcar el
/// diagnóstico como "validado por catálogo Solera" cuando coincide
/// con una plaga conocida y avisar cuando es un diagnóstico libre.
String? _buscarCoincidenciaCatalogo(String nombreCientifico, String nombreComun) {
  final cientificoNorm = _normalizar(nombreCientifico);
  final comunNorm = _normalizar(nombreComun);
  if (cientificoNorm.isEmpty && comunNorm.isEmpty) return null;
  for (final plaga in catalogoPlagas) {
    if (cientificoNorm.isNotEmpty &&
        plaga.nombreCientifico.isNotEmpty &&
        _normalizar(plaga.nombreCientifico).contains(cientificoNorm)) {
      return plaga.id;
    }
    if (comunNorm.isNotEmpty && _normalizar(plaga.nombreComun).contains(comunNorm)) {
      return plaga.id;
    }
  }
  return null;
}

String _normalizar(String texto) {
  return texto
      .toLowerCase()
      .replaceAll(RegExp(r'[áàä]'), 'a')
      .replaceAll(RegExp(r'[éèë]'), 'e')
      .replaceAll(RegExp(r'[íìï]'), 'i')
      .replaceAll(RegExp(r'[óòö]'), 'o')
      .replaceAll(RegExp(r'[úùü]'), 'u')
      .replaceAll('ñ', 'n')
      .trim();
}

/// Devuelve el media-type a partir de la extensión, o null si la
/// extensión no es de imagen reconocida por la API de Anthropic. Sin
/// validar la extensión, un PDF u otro fichero no-imagen se enviaría
/// como `image/jpeg` y la API devolvería un 400 confuso.
String? _detectarTipoMedia(String ruta) {
  final lower = ruta.toLowerCase();
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.gif')) return 'image/gif';
  if (lower.endsWith('.webp')) return 'image/webp';
  return null;
}
