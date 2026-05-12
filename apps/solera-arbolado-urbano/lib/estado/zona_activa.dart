import 'package:shared_preferences/shared_preferences.dart';

/// La "zona activa" es el sector seleccionado en el filtro principal
/// del mapa. Persiste entre arranques. Si vale `null` se muestran
/// todos los árboles del municipio.
class ZonaActivaPersistida {
  static const _clave = 'solera_arbolado_urbano.zona_activa.id';

  Future<int?> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_clave);
  }

  Future<void> guardar(int? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_clave);
    } else {
      await prefs.setInt(_clave, id);
    }
  }
}

/// Identificador del técnico activo (operario que firma actuaciones).
/// Persiste entre arranques para no obligar a re-seleccionar al iniciar
/// la app. Si es null, los eventos creados quedan sin tecnicoId — el
/// informe municipal lo marca como "Sin firmar" y se debe completar
/// antes de inspección.
class TecnicoActivoPersistido {
  static const _clave = 'solera_arbolado_urbano.tecnico_activo.id';

  Future<int?> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_clave);
  }

  Future<void> guardar(int? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_clave);
    } else {
      await prefs.setInt(_clave, id);
    }
  }
}
