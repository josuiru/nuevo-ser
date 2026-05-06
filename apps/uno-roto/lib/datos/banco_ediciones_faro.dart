import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../dominio/faro_de_azula.dart';

/// Ruta del asset con el banco extendido v0.2 (20 ediciones — la
/// tanda inicial v0.1 con E1..E10 + la extensión E11..E20). El JSON
/// del v0.1 queda archivado en disco como histórico, no se carga.
const String rutaAssetBancoFaroV02 = 'assets/data/faro_banco_v0_2.json';

/// Carga el banco del Faro desde el asset registrado en pubspec.
///
/// Se usa al arranque del juego para tener las 20 ediciones en
/// memoria; son ~60 KB de texto, no merece la pena diferirlo.
Future<List<EdicionFaro>> cargarBancoEdicionesFaro({
  String rutaAsset = rutaAssetBancoFaroV02,
}) async {
  final crudo = await rootBundle.loadString(rutaAsset);
  return parseBancoDesdeJson(crudo);
}

/// Parseo síncrono del JSON. Separado para que los tests lo
/// alimenten sin necesitar `rootBundle`.
///
/// Lanza [FormatException] si el JSON no tiene la forma esperada.
/// Es deliberado: el banco viene del propio repositorio (no es input
/// del usuario), así que un JSON roto debe reventar al iniciar y
/// avisar al equipo, no caer en silencio con una lista vacía.
List<EdicionFaro> parseBancoDesdeJson(String crudo) {
  final raiz = jsonDecode(crudo);
  if (raiz is! Map<String, dynamic>) {
    throw const FormatException('El banco del Faro debe ser un objeto raíz');
  }
  final ediciones = raiz['ediciones'];
  if (ediciones is! List) {
    throw const FormatException(
      'El banco del Faro debe tener un array "ediciones"',
    );
  }
  return ediciones
      .cast<Map<String, dynamic>>()
      .map(_parsearEdicion)
      .toList(growable: false);
}

EdicionFaro _parsearEdicion(Map<String, dynamic> j) {
  return EdicionFaro(
    numeroSemana: j['numeroSemana'] as int,
    anioOrden: j['anioOrden'] as int,
    numeroEdicion: j['numeroEdicion'] as int,
    portada: (j['portada'] as List)
        .cast<Map<String, dynamic>>()
        .map(_parsearNoticia)
        .toList(growable: false),
    cronica: _parsearCronica(j['cronica'] as Map<String, dynamic>),
    cartas: (j['cartas'] as List)
        .cast<Map<String, dynamic>>()
        .map(_parsearCarta)
        .toList(growable: false),
    acertijo: _parsearAcertijo(j['acertijo'] as Map<String, dynamic>),
  );
}

NoticiaPortada _parsearNoticia(Map<String, dynamic> j) {
  return NoticiaPortada(
    titulo: j['titulo'] as String,
    firma: j['firma'] as String?,
    cuerpo: j['cuerpo'] as String,
  );
}

Cronica _parsearCronica(Map<String, dynamic> j) {
  return Cronica(
    titulo: j['titulo'] as String,
    firma: j['firma'] as String,
    introduccion: j['introduccion'] as String,
    cuerpo: j['cuerpo'] as String,
  );
}

CartaAlDirector _parsearCarta(Map<String, dynamic> j) {
  return CartaAlDirector(
    pregunta: j['pregunta'] as String,
    firmante: j['firmante'] as String,
    respuesta: j['respuesta'] as String,
  );
}

Acertijo _parsearAcertijo(Map<String, dynamic> j) {
  return Acertijo(
    titulo: j['titulo'] as String,
    enunciado: j['enunciado'] as String,
    pista: j['pista'] as String?,
    solucionCanonica: j['solucionCanonica'] as String,
    explicacionSolucion: j['explicacionSolucion'] as String?,
    dificultad: _parsearDificultad(j['dificultad'] as String),
  );
}

NivelDificultadAcertijo _parsearDificultad(String etiqueta) {
  for (final nivel in NivelDificultadAcertijo.values) {
    if (nivel.name == etiqueta) return nivel;
  }
  throw FormatException(
    'Nivel de dificultad desconocido en el banco del Faro: "$etiqueta"',
  );
}
