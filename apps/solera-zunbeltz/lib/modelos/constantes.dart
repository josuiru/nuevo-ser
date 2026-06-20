// Catálogos y enumeraciones de Solera Zunbeltz (FZ-2).
//
// Las etiquetas llevan castellano y euskera porque la app es bilingüe desde
// el día uno. El euskera es borrador y debe pasar por revisión nativa (ver
// BLOQUEOS-PENDIENTES, 9-bis) — sobre todo la terminología agroganadera. En
// BD se persiste siempre el `codigo` (estable), nunca la etiqueta traducida.

/// Una opción de catálogo con su código estable y etiquetas bilingües.
class OpcionCatalogo {
  const OpcionCatalogo(this.codigo, this.es, this.eu);

  final String codigo;
  final String es;
  final String eu;

  /// Etiqueta en el idioma dado (`'eu'` → euskera; cualquier otro → es).
  String etiqueta(String idioma) => idioma == 'eu' ? eu : es;
}

/// Devuelve la opción cuyo `codigo` coincide, o `null` si no existe.
OpcionCatalogo? buscarOpcion(List<OpcionCatalogo> catalogo, String codigo) {
  for (final opcion in catalogo) {
    if (opcion.codigo == codigo) return opcion;
  }
  return null;
}

/// Tipos de punto de infraestructura que se marcan sobre el mapa.
const List<OpcionCatalogo> tiposPunto = [
  OpcionCatalogo('abrevadero', 'Abrevadero', 'Aska'),
  OpcionCatalogo('manga', 'Manga de manejo', 'Kudeaketa-manga'),
  OpcionCatalogo('cierre', 'Cierre / alambrada', 'Hesia'),
  OpcionCatalogo('refugio', 'Refugio / cabaña', 'Aterpea'),
  OpcionCatalogo('cuadra', 'Cuadra', 'Ukuilua'),
  OpcionCatalogo('almacen', 'Almacén', 'Biltegia'),
  OpcionCatalogo('balsa', 'Balsa / punto de agua', 'Urmaela'),
  OpcionCatalogo('comedero', 'Comedero', 'Askatokia'),
  OpcionCatalogo('cargadero', 'Cargadero', 'Zamalekua'),
  OpcionCatalogo('parcela', 'Parcela de pasto', 'Larre-saila'),
];

/// Estado de conservación de un punto de infraestructura.
const List<OpcionCatalogo> estadosPunto = [
  OpcionCatalogo('operativo', 'Operativo', 'Operatibo'),
  OpcionCatalogo('revisar', 'Revisar', 'Berrikusteke'),
  OpcionCatalogo('averiado', 'Averiado', 'Matxuratuta'),
];

/// Estado de una tarea de mantenimiento (coincide con la leyenda de la
/// presentación: pendiente / en curso / hecha / bloqueada).
const List<OpcionCatalogo> estadosTarea = [
  OpcionCatalogo('pendiente', 'Pendiente', 'Egiteke'),
  OpcionCatalogo('en_curso', 'En curso', 'Egiten'),
  OpcionCatalogo('hecha', 'Hecha', 'Eginda'),
  OpcionCatalogo('bloqueada', 'Bloqueada', 'Blokeatuta'),
];

/// Prioridad de una tarea de mantenimiento.
const List<OpcionCatalogo> prioridadesTarea = [
  OpcionCatalogo('baja', 'Baja', 'Baxua'),
  OpcionCatalogo('media', 'Media', 'Ertaina'),
  OpcionCatalogo('alta', 'Alta', 'Altua'),
];

/// Códigos por defecto (primer alta).
const String tipoPuntoPorDefecto = 'abrevadero';
const String estadoPuntoPorDefecto = 'operativo';
const String estadoTareaPorDefecto = 'pendiente';
const String prioridadTareaPorDefecto = 'media';
