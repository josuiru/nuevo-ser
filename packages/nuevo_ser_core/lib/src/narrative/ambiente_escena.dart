/// Contrato genérico del "ambiente" atmosférico de una escena
/// cinematográfica.
///
/// Es **clase abstracta** vacía — un marker. Cada juego define sus
/// ambientes según su worldbuilding: en Uno Roto el cielo con dos
/// lunas, niebla baja, lluvia, claridad de la Montaña; en Las
/// Versiones el archivo nocturno, una sala de evaluación, una sierra
/// al amanecer, el interior de una cueva.
///
/// El player de cinemáticas pasa el ambiente al `CustomPainter` del
/// juego, que es quien sabe pintarlo. La plataforma sólo lo transporta.
///
/// Para escenas que no quieren caracterizar el ambiente (la mayoría)
/// se ofrece [AmbienteEscenaNeutro] como valor por defecto.
///
/// El contrato se llama `AmbienteEscenaContrato` (no `AmbienteEscena`)
/// para dejar el nombre genérico `AmbienteEscena` libre a los juegos
/// que quieran usarlo en su propia capa, sin colisionar con el barrel
/// del core. Mismo patrón que `VozPersonajeContrato`.
abstract class AmbienteEscenaContrato {
  const AmbienteEscenaContrato();
}

/// Ambiente sin caracterización — el que asume cualquier escena que
/// no necesita atmósfera específica. Permite a `EscenaCinematica`
/// tener un default seguro sin obligar a cada juego a definir el suyo.
class AmbienteEscenaNeutro extends AmbienteEscenaContrato {
  const AmbienteEscenaNeutro();
}
