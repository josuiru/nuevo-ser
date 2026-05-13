// AssetBundle in-memory para tests.
//
// El CargadorCorpus de producción usa rootBundle. En tests, rootBundle
// tiene comportamiento inconsistente entre testWidgets sucesivos
// (cache compartida, microtasks pendientes que no completan con
// pump simple). Esta clase sustituye rootBundle por un Map plano
// que devuelve los strings directamente, sin async real.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class BundleEnMemoria extends CachingAssetBundle {
  BundleEnMemoria(this._recursos);

  final Map<String, String> _recursos;

  @override
  Future<ByteData> load(String key) async {
    final cadena = _recursos[key];
    if (cadena == null) {
      throw FlutterError('BundleEnMemoria: no hay recurso "$key"');
    }
    final bytes = Uint8List.fromList(utf8.encode(cadena));
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final cadena = _recursos[key];
    if (cadena == null) {
      throw FlutterError('BundleEnMemoria: no hay recurso "$key"');
    }
    return cadena;
  }
}

/// Bundle de prueba con solo la carta de Inês — útil para tests que
/// quieren aislar el flujo de una pieza sin solapamientos visuales
/// que compliquen el hit-testing.
BundleEnMemoria bundleSoloInes() {
  return BundleEnMemoria({
    'assets/corpus/manifiesto.json': '''
{
  "version": "0.1.0-test",
  "fecha_actualizacion": "2026-05-13",
  "piezas": ["assets/corpus/piezas/carta-ines-bacalao-001.json"]
}
''',
    'assets/corpus/piezas/carta-ines-bacalao-001.json': r'''
{
  "id": "carta-ines-bacalao-001",
  "tipo": "carta",
  "remitente": "ines_cocinera_lisboa",
  "destinatario": "joao-cocinero-puerto",
  "lengua_principal": "pt",
  "lenguas_infiltradas": ["es"],
  "ocasion": "Inês manda receta de bacalao a João del puerto.",
  "habilidades_atomicas": ["B6", "B3", "A10", "A5", "A9", "C5"],
  "operacion_central": "proponer",
  "dificultad": 2,
  "decisiones_validas": ["entregar", "archivar", "publicar"],
  "soporte": {
    "tipo": "carta manuscrita",
    "papel": "cuartilla",
    "tinta": "negra",
    "rasgos_visuales": ["mancha de aceite"]
  },
  "cruces_con_corpus": [],
  "texto_documento": "Caro João, le mando la receta del bacalao. Beijinhos, Inês.",
  "estado_validacion": "borrador_claude_2026_05_13_pendiente_humano"
}
'''
  });
}

/// Bundle de prueba con manifiesto + dos piezas (Inês y Niko) tal y
/// como están en assets/corpus/ de producción. Útil para tests que
/// quieren las mismas piezas que el juego real.
BundleEnMemoria bundleConPiezasReales() {
  return BundleEnMemoria({
    'assets/corpus/manifiesto.json': '''
{
  "version": "0.1.0-test",
  "fecha_actualizacion": "2026-05-13",
  "piezas": [
    "assets/corpus/piezas/carta-ines-bacalao-001.json",
    "assets/corpus/piezas/nota-companero-aprendiz-026.json"
  ]
}
''',
    'assets/corpus/piezas/carta-ines-bacalao-001.json': r'''
{
  "id": "carta-ines-bacalao-001",
  "tipo": "carta",
  "remitente": "ines_cocinera_lisboa",
  "destinatario": "joao-cocinero-puerto",
  "lengua_principal": "pt",
  "lenguas_infiltradas": ["es"],
  "ocasion": "Inês manda receta de bacalao a João del puerto.",
  "habilidades_atomicas": ["B6", "B3", "A10", "A5", "A9", "C5"],
  "operacion_central": "proponer",
  "dificultad": 2,
  "decisiones_validas": ["entregar", "archivar", "publicar"],
  "soporte": {
    "tipo": "carta manuscrita",
    "papel": "cuartilla",
    "tinta": "negra",
    "rasgos_visuales": ["mancha de aceite"]
  },
  "cruces_con_corpus": [],
  "texto_documento": "Caro João, le mando la receta del bacalao. Beijinhos, Inês.",
  "estado_validacion": "borrador_claude_2026_05_13_pendiente_humano"
}
''',
    'assets/corpus/piezas/nota-companero-aprendiz-026.json': r'''
{
  "id": "nota-companero-aprendiz-026",
  "tipo": "nota_breve",
  "remitente": "aprendiz-companero-niko",
  "destinatario": "aprendiz-jugador",
  "lengua_principal": "eu",
  "lenguas_infiltradas": ["es"],
  "ocasion": "Niko pide ayuda con carta en gallego.",
  "habilidades_atomicas": ["A1", "A5", "A9", "C3", "D4"],
  "operacion_central": "identificar",
  "dificultad": 2,
  "decisiones_validas": ["entregar", "archivar"],
  "soporte": {
    "tipo": "nota manuscrita rapida",
    "papel": "media cuartilla",
    "tinta": "lapicero",
    "rasgos_visuales": []
  },
  "cruces_con_corpus": [],
  "texto_documento": "Aprendiz: Lagundu didezu? Niko.",
  "estado_validacion": "borrador_claude_2026_05_13_pendiente_humano"
}
'''
  });
}
