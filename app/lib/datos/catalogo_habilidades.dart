import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../dominio/habilidad.dart';

/// Carga y expone el catálogo de 66 habilidades desde
/// `assets/data/skills.json`. Singleton perezoso; las habilidades son
/// inmutables después de cargarse.
class CatalogoHabilidades {
  CatalogoHabilidades._({
    required this.version,
    required this.dominios,
    required this.habilidades,
    required this.reglasDecaimiento,
    required this.rangos,
  });

  static CatalogoHabilidades? _instancia;
  static Future<CatalogoHabilidades>? _cargaEnCurso;

  final String version;
  final Map<String, String> dominios;
  final Map<String, Habilidad> habilidades;
  final ReglasDecaimiento reglasDecaimiento;
  final List<String> rangos;

  static Future<CatalogoHabilidades> cargar() async {
    if (_instancia != null) return _instancia!;
    return _cargaEnCurso ??= _cargarDesdeAsset();
  }

  static Future<CatalogoHabilidades> _cargarDesdeAsset() async {
    final texto = await rootBundle.loadString('assets/data/skills.json');
    final json = jsonDecode(texto) as Map<String, dynamic>;

    final habilidadesPorId = <String, Habilidad>{};
    for (final entrada in (json['skills'] as List)) {
      final h = Habilidad.desdeJson(entrada as Map<String, dynamic>);
      habilidadesPorId[h.identificador] = h;
    }

    final decaimiento = json['decay_rules'] as Map<String, dynamic>;
    final reglas = ReglasDecaimiento(
      diasMaestriaACompetente:
          (decaimiento['mastery_to_competent_days'] as num).toInt(),
      diasCompetenteAEnDesarrollo:
          (decaimiento['competent_to_developing_days'] as num).toInt(),
      nivelSuelo: (decaimiento['floor_level'] as num).toInt(),
    );

    _instancia = CatalogoHabilidades._(
      version: json['version'] as String,
      dominios:
          (json['domains'] as Map<String, dynamic>).cast<String, String>(),
      habilidades: habilidadesPorId,
      reglasDecaimiento: reglas,
      rangos: (json['ranks'] as List).cast<String>(),
    );
    _cargaEnCurso = null;
    return _instancia!;
  }

  Habilidad? porId(String id) => habilidades[id];

  List<Habilidad> delDominio(String dominio) =>
      habilidades.values.where((h) => h.dominio == dominio).toList();

  /// Todas las habilidades que el distrito puede presentar.
  List<Habilidad> delDistrito(String idDistrito) => habilidades.values
      .where((h) =>
          h.distritos.contains(idDistrito) || h.distritos.contains('todos'))
      .toList();
}

class ReglasDecaimiento {
  final int diasMaestriaACompetente;
  final int diasCompetenteAEnDesarrollo;
  final int nivelSuelo;

  const ReglasDecaimiento({
    required this.diasMaestriaACompetente,
    required this.diasCompetenteAEnDesarrollo,
    required this.nivelSuelo,
  });
}
