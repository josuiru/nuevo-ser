import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ResultadoAnalisisIA {
  final String nombreDefecto;
  final String tipo; // textura / corteza / color / sabor / otro
  final int? severidad;
  final double confianza;
  final String descripcion;
  final String posibleCausa;
  final String accionRecomendada;
  final String advertencia;

  ResultadoAnalisisIA({
    required this.nombreDefecto,
    required this.tipo,
    this.severidad,
    required this.confianza,
    this.descripcion = '',
    this.posibleCausa = '',
    this.accionRecomendada = '',
    this.advertencia = '',
  });
}

class ErrorIA implements Exception {
  final String mensaje;
  ErrorIA(this.mensaje);
  @override
  String toString() => 'ErrorIA: $mensaje';
}

/// Cliente Anthropic con vision para identificación de defectos
/// en queso artesanal. Analiza fotos de corte y corteza.
class ClienteAnthropicQuesero {
  static const _modelo = 'claude-haiku-4-5';
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  static const _version = '2023-06-01';

  final String claveApi;
  ClienteAnthropicQuesero(this.claveApi);

  Future<ResultadoAnalisisIA> analizarFoto({
    required File foto,
    String observaciones = '',
  }) async {
    final bytes = await foto.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      throw ErrorIA(
        'La foto pesa más de 5 MB. Reduce el tamaño antes de enviarla.',
      );
    }
    final base64Foto = base64Encode(bytes);
    final mediaType = _detectarTipoMedia(foto.path);

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
              'text': _construirPrompt(observaciones),
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
      throw ErrorIA('Clave inválida. Revísala en Ajustes > IA.');
    }
    if (respuesta.statusCode == 429) {
      throw ErrorIA('Límite de peticiones. Espera unos minutos.');
    }
    if (respuesta.statusCode != 200) {
      throw ErrorIA('Error HTTP ${respuesta.statusCode}: ${respuesta.body}');
    }

    final json = jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;
    final contenido = (json['content'] as List?) ?? [];
    String texto = '';
    for (final bloque in contenido) {
      if (bloque is Map && bloque['type'] == 'text') {
        texto += bloque['text']?.toString() ?? '';
      }
    }
    if (texto.isEmpty) throw ErrorIA('Respuesta vacía de la IA.');
    return _parsearJson(texto);
  }
}

const String _promptSistema = '''
Eres un maestro quesero con formación en tecnología de alimentos y análisis sensorial. Te paso la foto de un queso artesanal (corte o corteza) y debes identificar posibles defectos o alteraciones.

CATÁLOGO DE DEFECTOS COMUNES EN QUESO ARTESANAL (no exhaustivo):
- Textura: ojos excesivos (mecánica o fermentación contaminante), falta de ojos, ojos irregulares, hendiduras internas, textura harinosa, gomosa, pegajosa, cristales de tirosina.
- Corteza: grietas, moho superficial no deseado, ácaros, separación corteza-pasta, corteza excesivamente seca o húmeda, manchas anormales.
- Color: color anormal de la pasta, manchas grises, distribución irregular del color, vetas de color no deseadas.
- Sabor/olor (si se describe en observaciones): amargor, acidez excesiva, picante anómalo, rancidez, sabores a moho, sabores metálicos.
- Hinchazón: hinchazón precoz (primeros días), hinchazón tardía (semanas/meses, posible contaminación por clostridios butíricos).
- Otros: exudado excesivo, costra anormal, deformación, ataque de insectos, roedores.

REGLAS ESTRICTAS:
1. Responde SOLO con JSON, sin texto antes ni después.
2. Estructura del JSON:
{
  "nombre_defecto": "nombre del defecto en español",
  "tipo": "textura" | "corteza" | "color" | "sabor" | "hinchazon" | "otro",
  "severidad": número entero 1-5 (1=sutil, 5=masivo/impropio para consumo),
  "confianza": número decimal 0.0-1.0,
  "descripcion": "descripción breve de lo que observas en la foto",
  "posible_causa": "qué pudo causarlo (en 1-2 frases)",
  "accion_recomendada": "acción correctiva o de manejo (limpieza cava, ajuste HR, revisar pH, derivar a analítica...)",
  "advertencia": "si la foto es borrosa, hay poca luz, o el diagnóstico incierto, dilo aquí. Vacío si confianza alta."
}
3. NO emitas juicios sobre seguridad alimentaria. Si hay duda, recomienda derivar a analítica.
4. NO recomiendes productos comerciales. Solo acciones de manejo.
5. Si no ves ningún defecto, devuelve tipo="otro", confianza=0, y explica que el queso parece visualmente correcto.
6. Sé conservador con severidad: 5 solo para alteraciones graves (moho generalizado, hinchazón severa, claramente no apto).
''';

String _construirPrompt(String observaciones) {
  if (observaciones.trim().isNotEmpty) {
    return 'Observaciones del quesero: ${observaciones.trim()}\n\nAnaliza el queso de la foto e identifica defectos.';
  }
  return 'Analiza el queso de la foto e identifica posibles defectos visibles.';
}

ResultadoAnalisisIA _parsearJson(String texto) {
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
      nombreDefecto: (json['nombre_defecto'] as String?) ?? 'Sin identificar',
      tipo: (json['tipo'] as String?) ?? 'otro',
      severidad: (json['severidad'] as num?)?.toInt(),
      confianza: ((json['confianza'] as num?)?.toDouble() ?? 0).clamp(0, 1),
      descripcion: (json['descripcion'] as String?) ?? '',
      posibleCausa: (json['posible_causa'] as String?) ?? '',
      accionRecomendada: (json['accion_recomendada'] as String?) ?? '',
      advertencia: (json['advertencia'] as String?) ?? '',
    );
  } catch (e) {
    throw ErrorIA('La respuesta no era JSON válido: $e\nTexto: $limpio');
  }
}

String _detectarTipoMedia(String ruta) {
  final lower = ruta.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.gif')) return 'image/gif';
  if (lower.endsWith('.webp')) return 'image/webp';
  return 'image/jpeg';
}
