import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Resultado del análisis de una foto de arbolado urbano por Claude
/// vision. Salida estructurada para que la app pueda pre-rellenar el
/// formulario de incidencia o tratamiento tras revisión humana.
class ResultadoAnalisisIA {
  /// Tipo del análisis: "especie" si pidió identificar la especie del
  /// árbol, "plaga" si pidió diagnóstico fitosanitario.
  final String tipoAnalisis;

  // Identificación de especie (sólo si tipoAnalisis = 'especie').
  final String especieNombreComun;
  final String especieNombreCientifico;

  // Diagnóstico fitosanitario (sólo si tipoAnalisis = 'plaga').
  final String plagaNombreComun;
  final String plagaNombreCientifico;
  final String tipoPlaga;
  final int? severidad;
  final String manejoCultural;
  final bool declaracionOficialSugerida;
  final bool riesgoSanitarioPublicoSugerido;

  // Comunes a ambos tipos.
  final double confianza;
  final String advertencia;

  ResultadoAnalisisIA({
    required this.tipoAnalisis,
    this.especieNombreComun = '',
    this.especieNombreCientifico = '',
    this.plagaNombreComun = '',
    this.plagaNombreCientifico = '',
    this.tipoPlaga = '',
    this.severidad,
    this.manejoCultural = '',
    this.declaracionOficialSugerida = false,
    this.riesgoSanitarioPublicoSugerido = false,
    required this.confianza,
    this.advertencia = '',
  });
}

class ErrorIA implements Exception {
  final String mensaje;
  ErrorIA(this.mensaje);
  @override
  String toString() => 'ErrorIA: $mensaje';
}

/// Modo de análisis de la foto. La cámara apícola es una sola foto y un
/// solo prompt; aquí distinguimos porque el operario puede querer
/// identificar la **especie** (al censar un árbol nuevo sin chapa) o
/// diagnosticar una **plaga** (al levantar una incidencia).
enum ModoAnalisisIA { identificarEspecie, diagnosticarPlaga }

/// Cliente de la API Messages de Anthropic con vision. Identifica
/// especies arbóreas urbanas habituales en Iberia o diagnostica plagas
/// y enfermedades. Responde JSON estricto que la app parsea a
/// `ResultadoAnalisisIA`.
class ClienteAnthropic {
  static const _modelo = 'claude-haiku-4-5';
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  static const _version = '2023-06-01';

  final String claveApi;
  ClienteAnthropic(this.claveApi);

  Future<ResultadoAnalisisIA> analizarFoto({
    required File foto,
    required ModoAnalisisIA modo,
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
    final promptUsuario = _construirPrompt(modo, observacionesUsuario);
    final promptSistema =
        modo == ModoAnalisisIA.identificarEspecie ? _promptEspecies : _promptPlagas;

    final cuerpo = jsonEncode({
      'model': _modelo,
      'max_tokens': 1024,
      'system': promptSistema,
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
    return _parsearJson(texto, modo);
  }
}

/// System prompt para identificación de especies arbóreas urbanas.
const String _promptEspecies = '''
Eres un ingeniero técnico forestal especializado en arbolado urbano peninsular (España, Portugal). Te paso una foto de un árbol urbano (tronco, corteza, hoja, fruto, copa) y debes identificar la especie.

LISTA CANÓNICA DE ESPECIES URBANAS FRECUENTES EN IBERIA (no exhaustiva — si ves algo distinto, lo describes igual):
- Plátano de sombra (Platanus × hispanica), tilo (Tilia), fresno (Fraxinus), arce negundo, almendro ornamental, robinia, jacarandá.
- Pino piñonero, pino carrasco, ciprés mediterráneo, cedro, ginkgo.
- Palmera datilera (Phoenix dactylifera), palmera canaria (Phoenix canariensis).
- Naranjo amargo, magnolio, ficus, sófora, lagerstroemia, paulownia, catalpa.
- Encina, alcornoque, melojo, olmo siberiano, olmo común, almez, abedul.

REGLAS ESTRICTAS:

1. Responde SOLO con JSON, sin texto antes ni después. Sin bloques de código markdown.

2. Estructura del JSON:
{
  "tipo_analisis": "especie",
  "especie_nombre_comun": "nombre habitual en español",
  "especie_nombre_cientifico": "binomial latino",
  "confianza": número decimal 0.0-1.0,
  "advertencia": "vacío si confianza alta; si la foto es ambigua o sólo se ve corteza, lo dices aquí"
}

3. Si la foto NO es de un árbol o no puedes identificar nada, devuelve confianza=0.0 y advertencia explicativa.

4. Si dudas entre dos especies similares (p. ej. tilo común vs tilo plateado), da la más probable y baja la confianza; explícalo en advertencia.
''';

/// System prompt para diagnóstico de plagas urbanas.
const String _promptPlagas = '''
Eres un ingeniero técnico forestal especializado en sanidad de arbolado urbano peninsular (España, Portugal). Te paso una foto de un árbol urbano con un posible problema sanitario (hoja con manchas, tronco con galerías, ramas marchitas, bolsones, etc.) y debes diagnosticarlo.

LISTA CANÓNICA DE PATOLOGÍAS URBANAS COMUNES EN IBERIA:
- Plagas de insectos: procesionaria del pino (Thaumetopoea pityocampa) — RIESGO SANITARIO PÚBLICO, picudo rojo de las palmeras (Rhynchophorus ferrugineus) — DECLARACIÓN OBLIGATORIA, lagarta peluda (Lymantria dispar) — RIESGO SANITARIO, escolítidos del olmo, mineradores foliares, cochinilla algodonosa, psyla de la acacia.
- Enfermedades fúngicas: anthracnosis del plátano, oídio del plátano, mancha negra del peral, grafiosis del olmo (Ophiostoma), chancro del ciprés, hongos de pudrición de madera.
- Enfermedades bacterianas: fuego bacteriano (Erwinia amylovora) — DECLARACIÓN OBLIGATORIA.
- Trastornos abióticos: salinidad, heridas de máquina de siega, golpe de calor urbano, fitotoxicidad por herbicida, contaminación atmosférica.

REGLAS ESTRICTAS:

1. Responde SOLO con JSON, sin texto antes ni después. Sin bloques de código markdown.

2. Estructura del JSON:
{
  "tipo_analisis": "plaga",
  "plaga_nombre_comun": "nombre habitual en español",
  "plaga_nombre_cientifico": "binomial latino o vacío para abióticos",
  "tipo_plaga": "plaga_insecto" | "enfermedad_fungica" | "enfermedad_bacteriana" | "plaga_invasora" | "trastorno_abiotico" | "indeterminado",
  "severidad": número entero 1-5 estimado (5 = mortalidad / colapso, 1 = síntomas incipientes), o null,
  "confianza": número decimal 0.0-1.0,
  "manejo_cultural": "recomendaciones de manejo NO QUÍMICO en 2-3 frases (poda sanitaria, retirada de hoja caída, trampeo de feromonas, mejora de riego, etc.). NO menciones marcas comerciales de fitosanitarios.",
  "declaracion_oficial_sugerida": true | false (true SOLO para picudo rojo, fuego bacteriano u otras patologías reguladas),
  "riesgo_sanitario_publico_sugerido": true | false (true para procesionaria del pino, lagarta peluda — pelos urticantes en personas),
  "advertencia": "vacío si confianza alta; si la foto es ambigua o sólo es daño abiótico ambiguo, lo dices aquí"
}

3. NUNCA recomiendes productos fitosanitarios concretos por nombre comercial. Esto es un compromiso legal de la app: solo manejo cultural.

4. Si la foto NO es de arbolado urbano o no se ve patología, devuelve tipo_plaga="indeterminado", confianza=0.0, advertencia explicativa.

5. Sé conservador con la severidad: 5 sólo para mortalidad o colapso inminente, 1 para síntomas muy localizados.

6. Si dudas entre plagas similares (p. ej. anthracnosis vs oídio del plátano), da la más probable, baja la confianza y explícalo en advertencia.
''';

String _construirPrompt(ModoAnalisisIA modo, String observaciones) {
  final ctx = StringBuffer()
    ..writeln('Cultivo: Arbolado urbano peninsular');
  if (observaciones.trim().isNotEmpty) {
    ctx.writeln('\nObservaciones del usuario: ${observaciones.trim()}');
  }
  ctx.writeln(modo == ModoAnalisisIA.identificarEspecie
      ? '\nIdentifica la especie del árbol visible en la foto.'
      : '\nDiagnostica el problema sanitario visible en la foto.');
  return ctx.toString();
}

ResultadoAnalisisIA _parsearJson(String texto, ModoAnalisisIA modo) {
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
    if (modo == ModoAnalisisIA.identificarEspecie) {
      return ResultadoAnalisisIA(
        tipoAnalisis: 'especie',
        especieNombreComun: (json['especie_nombre_comun'] as String?) ?? '',
        especieNombreCientifico: (json['especie_nombre_cientifico'] as String?) ?? '',
        confianza: ((json['confianza'] as num?)?.toDouble() ?? 0).clamp(0, 1).toDouble(),
        advertencia: (json['advertencia'] as String?) ?? '',
      );
    }
    return ResultadoAnalisisIA(
      tipoAnalisis: 'plaga',
      plagaNombreComun: (json['plaga_nombre_comun'] as String?) ?? '',
      plagaNombreCientifico: (json['plaga_nombre_cientifico'] as String?) ?? '',
      tipoPlaga: (json['tipo_plaga'] as String?) ?? 'indeterminado',
      severidad: (json['severidad'] as num?)?.toInt(),
      confianza: ((json['confianza'] as num?)?.toDouble() ?? 0).clamp(0, 1).toDouble(),
      manejoCultural: (json['manejo_cultural'] as String?) ?? '',
      declaracionOficialSugerida:
          (json['declaracion_oficial_sugerida'] as bool?) ?? false,
      riesgoSanitarioPublicoSugerido:
          (json['riesgo_sanitario_publico_sugerido'] as bool?) ?? false,
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
