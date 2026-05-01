import 'package:shared_preferences/shared_preferences.dart';

/// Borra **todo** el estado local del juego.
///
/// El criterio es purgar cualquier clave del `SharedPreferences` cuyo
/// nombre empiece por el prefijo `nuevoser.lasversiones.` — esto cubre
/// el idioma elegido, los flags narrativos, las fases de Brecha
/// activas, las entradas del Cuaderno, los Mosaicos, las preguntas
/// formuladas, las evaluaciones de fuentes, las reconstrucciones y la
/// cuenta del backend (token + email). Cualquier repositorio nuevo del
/// juego que respete el namespace queda cubierto sin tener que
/// modificar este helper.
///
/// Existe para que la `PantallaAjustes` pueda ofrecerle a la Cronista
/// un botón de "RESETEAR ARCHIVO" cuando quiera empezar de cero —
/// originalmente añadido (F2-21) tras una prueba real en la que la
/// Cronista se vio sin escape porque no había ningún acceso a ajustes
/// dentro del juego.
///
/// El parámetro `prefijoNamespace` se pasa explícito (no constante) por
/// dos motivos: (1) los tests pueden inyectar un prefijo distinto sin
/// tocar `main.dart`, y (2) si en el futuro el juego adopta multi-
/// perfil con `GestorPerfiles`, sólo habrá que pasar el prefijo del
/// perfil activo en lugar del namespace global para resetear sólo a
/// ese perfil.
class ReseteoArchivo {
  final Future<SharedPreferences> Function() prefs;
  final String prefijoNamespace;

  const ReseteoArchivo({
    required this.prefs,
    this.prefijoNamespace = 'nuevoser.lasversiones.',
  });

  /// Borra todas las claves del `SharedPreferences` cuyo nombre empieza
  /// por [prefijoNamespace]. Devuelve el número de claves borradas para
  /// que los tests puedan afirmar que efectivamente se purgó algo.
  Future<int> borrarTodo() async {
    final almacen = await prefs();
    final clavesAEliminar = almacen
        .getKeys()
        .where((clave) => clave.startsWith(prefijoNamespace))
        .toList(growable: false);
    for (final clave in clavesAEliminar) {
      await almacen.remove(clave);
    }
    return clavesAEliminar.length;
  }
}
