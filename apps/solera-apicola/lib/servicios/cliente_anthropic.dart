import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Resultado del análisis de una foto del colmenar por Claude vision.
/// Salida estructurada para que la app pueda pre-rellenar el formulario
/// de incidencia tras revisión humana.
class ResultadoAnalisisIA {
  final String nombreComun;
  final String nombreCientifico;
  final String tipo;
  final int? severidad;
  final double confianza;
  final String manejoCultural;
  final String advertencia;
  final bool declaracionOficialSugerida;

  ResultadoAnalisisIA({
    required this.nombreComun,
    required this.nombreCientifico,
    required this.tipo,
    this.severidad,
    required this.confianza,
    required this.manejoCultural,
    this.advertencia = '',
    this.declaracionOficialSugerida = false,
  });
}

class ErrorIA implements Exception {
  final String mensaje;
  ErrorIA(this.mensaje);
  @override
  String toString() => 'ErrorIA: $mensaje';
}

/// Cliente de la API Messages de Anthropic con vision para diagnóstico
/// apícola. Identifica varroa, nosema, loque (americana y europea),
/// ascosferiosis, virus DWV/CBPV, vespa velutina y polilla de la cera
/// por foto. Responde JSON estricto que la app parsea a `ResultadoAnalisisIA`.
class ClienteAnthropic {
  static const _modelo = 'claude-haiku-4-5';
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  static const _version = '2023-06-01';

  final String claveApi;
  ClienteAnthropic(this.claveApi);

  /// Analiza una foto del colmenar y devuelve un diagnóstico estructurado.
  /// La foto se sube como base64 en el cuerpo del mensaje (evita tener
  /// que subirla antes a un servidor público).
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

/// System prompt apícola-específico. Lista canónica de plagas, patologías
/// y plagas físicas habituales en *Apis mellifera* en climas peninsulares.
/// El prompt incluye las 3 patologías de declaración obligatoria (loque
/// americana, escarabajo de las colmenas, vespa velutina) para que la IA
/// las identifique con la importancia adecuada.
const String _promptSistema = '''
Eres un veterinario apícola experto en sanidad de *Apis mellifera*, especializado en explotaciones peninsulares (España, Portugal, sur de Francia). Te paso una foto de una colmena, abeja, panal, larva o trampa con un posible problema sanitario o productivo y debes diagnosticarlo.

LISTA CANÓNICA DE INCIDENCIAS COMUNES EN APICULTURA IBÉRICA:
- Parásitos: varroosis (*Varroa destructor*), acariosis traqueal (*Acarapis woodi*).
- Infecciones bacterianas: loque americana (*Paenibacillus larvae*) — DECLARACIÓN OBLIGATORIA, loque europea (*Melissococcus plutonius*).
- Infecciones fúngicas: ascosferiosis o cría escayolada (*Ascosphaera apis*).
- Infecciones por microsporidios: nosemosis tipo apis (*Vairimorpha apis*), nosemosis tipo ceranae (*Vairimorpha ceranae*).
- Virosis: virus de las alas deformes (DWV), virus de la parálisis crónica (CBPV), virus de la cría sacciforme.
- Plagas físicas: polilla de la cera (*Galleria mellonella*), escarabajo de las colmenas (*Aethina tumida*) — DECLARACIÓN OBLIGATORIA.
- Depredadores: vespa velutina (*Vespa velutina*) — DECLARACIÓN OBLIGATORIA, abejaruco europeo (*Merops apiaster* — protegido).
- Trastornos abióticos: intoxicación por fitosanitarios, hambre invernal, robo entre colmenas, golpe de calor, ahogamiento, daño por granizo.

REGLAS ESTRICTAS:

1. Responde SOLO con JSON, sin texto antes ni después. Sin bloques de código markdown.

2. Estructura del JSON:
{
  "nombre_comun": "nombre habitual en español de la patología/plaga/trastorno",
  "nombre_cientifico": "nombre científico binomial si aplica, vacío si es un trastorno abiótico",
  "tipo": "parasito" | "infeccion" | "plaga_fisica" | "depredador" | "abiotico" | "indeterminado",
  "severidad": número entero 1-5 estimado, o null si no es valorable,
  "confianza": número decimal 0.0-1.0 (cuánta confianza tienes en el diagnóstico),
  "manejo_cultural": "recomendaciones de manejo NO QUÍMICO en 2-3 frases (renovación de panales, aireación, división, fortalecimiento de colonia, trampeo selectivo, reductor de piquera, etc.). NO menciones marcas comerciales de medicamentos zoosanitarios.",
  "advertencia": "si la foto es de baja calidad, hay dudas, o el síntoma es ambiguo, lo dices aquí. Vacío si confianza alta.",
  "declaracion_oficial_sugerida": true | false (true SOLO si el diagnóstico es loque americana, escarabajo de las colmenas o vespa velutina)
}

3. NUNCA recomiendes medicamentos zoosanitarios concretos por nombre comercial (Apivar, ApiBioxal, etc.). Esto es un compromiso legal de la app: solo manejo cultural y derivación al veterinario asesor en v0.1.

4. Para tratamiento de varroa, recuerda al apicultor que necesita receta del veterinario asesor antes de aplicar cualquier sustancia activa — no menciones la sustancia concreta en `manejo_cultural`.

5. Si la foto NO es de un colmenar / abeja / panal o no ves un problema, devuelve tipo="indeterminado", confianza=0.0, advertencia explicativa.

6. Sé conservador con la severidad: 5 solo para colapso inminente / mortalidad masiva, 1 para indicios incipientes muy localizados.

7. Si dudas entre dos patologías (p. ej. loque americana vs loque europea), da la más probable, baja la confianza y explícalo en advertencia. Recuerda que la loque americana es de declaración obligatoria — ante la duda, dilo.

8. El abejaruco europeo está protegido por ley en España — si lo identificas, en `manejo_cultural` indica explícitamente que NO se persigue y la única medida legal es manejar la ubicación del colmenar.
''';

String _construirPrompt(String observaciones) {
  final ctx = StringBuffer()
    ..writeln('Cultivo: Apicultura — *Apis mellifera*');
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
      declaracionOficialSugerida:
          (json['declaracion_oficial_sugerida'] as bool?) ?? false,
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
