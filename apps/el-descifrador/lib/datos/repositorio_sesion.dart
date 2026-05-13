// Repositorio de sesión persistente del descifrador.
//
// Persiste qué piezas están en cada bandeja (entrada / resuelto) y
// la decisión tomada por pieza. La bandeja "en curso" es transitoria
// y no se persiste — al cerrar la app, una pieza en curso vuelve a
// entrada.
//
// Almacén: shared_preferences por perfil.
// Key: nuevoser.descifrador.perfil.<id>.sesion
// Formato: JSON con piezasResueltas (Map<idPieza, identificadorDecision>).
//
// El corpus original se carga siempre desde CargadorCorpus al iniciar.
// Reconciliación: piezas en corpus que no están en resueltas → bandeja
// entrada. Piezas en resueltas pero ya no en corpus (eliminadas entre
// versiones) → se ignoran silenciosamente.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/decision_documento.dart';

/// Resultado de cargar la sesión persistida. Mapas que la PantallaMesa
/// usa para reconstruir el EstadoSesion al combinarlos con el corpus.
class SesionPersistida {
  const SesionPersistida(this.decisionesPorPieza);

  /// Piezas ya decididas con la decisión que se tomó sobre cada una.
  /// El ID corresponde a `PiezaCorpus.id`.
  final Map<String, DecisionDocumento> decisionesPorPieza;

  bool get vacia => decisionesPorPieza.isEmpty;
}

/// Repositorio persistente de la sesión.
class RepositorioSesion {
  RepositorioSesion({
    required this.idPerfil,
    SharedPreferences? preferenciasInyectadas,
  }) : _preferenciasInyectadas = preferenciasInyectadas;

  final String idPerfil;
  final SharedPreferences? _preferenciasInyectadas;

  String get _clave => 'nuevoser.descifrador.perfil.$idPerfil.sesion';

  Future<SharedPreferences> _preferencias() async {
    return _preferenciasInyectadas ?? await SharedPreferences.getInstance();
  }

  /// Carga la sesión persistida. Si el perfil es nuevo o el JSON está
  /// corrupto, devuelve sesión vacía — la pérdida de estado de sesión
  /// no es catastrófica (las piezas siguen en el corpus, vuelven a
  /// bandeja de entrada).
  Future<SesionPersistida> cargar() async {
    final preferencias = await _preferencias();
    final json = preferencias.getString(_clave);
    if (json == null || json.isEmpty) {
      return const SesionPersistida({});
    }
    try {
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      final decisiones = <String, DecisionDocumento>{};
      final resueltas = mapa['piezas_resueltas'] as Map<String, dynamic>?;
      if (resueltas != null) {
        for (final entrada in resueltas.entries) {
          final valor = entrada.value;
          if (valor is String) {
            try {
              decisiones[entrada.key] =
                  DecisionDocumento.desdeIdentificador(valor);
            } on ArgumentError {
              // Decisión desconocida (cambio entre versiones).
              // Ignoramos esta pieza; vuelve a entrada.
            }
          }
        }
      }
      return SesionPersistida(decisiones);
    } catch (_) {
      return const SesionPersistida({});
    }
  }

  /// Registra que una pieza ha sido resuelta con una decisión.
  Future<void> registrarPiezaResuelta(
    String idPieza,
    DecisionDocumento decision,
  ) async {
    final preferencias = await _preferencias();
    final sesion = await cargar();
    final actualizadas = Map<String, DecisionDocumento>.from(
      sesion.decisionesPorPieza,
    );
    actualizadas[idPieza] = decision;
    await preferencias.setString(
      _clave,
      jsonEncode({
        'piezas_resueltas': {
          for (final entrada in actualizadas.entries)
            entrada.key: entrada.value.identificadorTecnico,
        },
      }),
    );
  }

  /// Borra toda la sesión persistida del perfil.
  Future<void> borrar() async {
    final preferencias = await _preferencias();
    await preferencias.remove(_clave);
  }
}
