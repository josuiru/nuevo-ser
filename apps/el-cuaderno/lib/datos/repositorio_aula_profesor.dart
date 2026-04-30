import 'package:shared_preferences/shared_preferences.dart';

import '../vista/pantalla_profesor/pantalla_login_profesor.dart'
    show RepositorioAulaProfesorContrato;

/// Persiste el `classroom_id` activo del profesor (la última aula que
/// abrió). Pareja del `RepositorioCuentaBackend` que guarda token +
/// email del adulto — éste sólo guarda la elección de "qué aula ver".
///
/// La decisión de soportar "varias aulas por profesor" en la UI queda
/// para B7-pantalla-profesor-multi-aula. Por ahora el flujo es:
/// crea/elige una aula → la persiste → al volver a abrir, recupera y
/// muestra. Cambiar de aula es manual.
///
/// Mismo patrón de callbacks invertidos que los repositorios de
/// `nuevo_ser_core/storage/`: recibe `prefs` + `clave` para que cada
/// juego decida su namespace.
///
/// Implementa [RepositorioAulaProfesorContrato] para que la pantalla
/// del profesor lo consuma sin importar este fichero — los tests
/// pueden inyectar un fake con la misma firma.
class RepositorioAulaProfesor implements RepositorioAulaProfesorContrato {
  RepositorioAulaProfesor({
    required this.prefs,
    required this.clave,
  });

  final Future<SharedPreferences> Function() prefs;
  final String clave;

  @override
  Future<int?> cargar() async {
    final almacen = await prefs();
    return almacen.getInt(clave);
  }

  @override
  Future<void> guardar(int classroomId) async {
    final almacen = await prefs();
    await almacen.setInt(clave, classroomId);
  }

  @override
  Future<void> borrar() async {
    final almacen = await prefs();
    await almacen.remove(clave);
  }
}
