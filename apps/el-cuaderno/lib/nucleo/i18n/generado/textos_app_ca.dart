import 'textos_app.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class TextosAppCa extends TextosApp {
  TextosAppCa([String locale = 'ca']) : super(locale);

  @override
  String get tituloApp => 'TODO_CA · El Cuaderno';

  @override
  String get subtituloBienvenida => 'TODO_CA · Una herramienta para anotar lo que ves vivo cerca de ti.';

  @override
  String get saludoSinNombre => 'TODO_CA · Hola.';

  @override
  String saludoConNombre(String nombre) {
    return 'TODO_CA · Hola, $nombre.';
  }

  @override
  String get navCuaderno => 'TODO_CA · cuaderno';

  @override
  String get navMapa => 'TODO_CA · mapa';

  @override
  String get navMisterios => 'TODO_CA · misterios';

  @override
  String get navTutor => 'TODO_CA · tutor';

  @override
  String get seccionSitSpot => 'TODO_CA · Tu sit spot';

  @override
  String get seccionMisteriosAbiertos => 'TODO_CA · Misterios abiertos';

  @override
  String get seccionUltimaPagina => 'TODO_CA · Última página';

  @override
  String get sitSpotInvitacion => 'TODO_CA · Cuando estés en algún sitio al aire libre que te guste — un parque, un árbol, una esquina — puedes hacerlo tu sit spot. Toca aquí cuando estés.';

  @override
  String sitSpotUltimaVisita(String cuando) {
    return 'TODO_CA · Última visita: $cuando';
  }

  @override
  String get ultimaPaginaVacia => 'TODO_CA · Aún no has anotado nada. Cuando lo hagas, aparecerá aquí.';

  @override
  String get misteriosVacio => 'TODO_CA · Aún no tienes Misterios abiertos. El sistema te propondrá alguno pronto.';

  @override
  String get navProximamente => 'TODO_CA · Próximamente.';

  @override
  String get observacionTitulo => 'TODO_CA · nueva observación';

  @override
  String observacionCabecera(String hora) {
    return 'TODO_CA · Hoy · $hora';
  }

  @override
  String get observacionCajaFoto => 'TODO_CA · foto';

  @override
  String get observacionCajaDibujo => 'TODO_CA · dibujo';

  @override
  String get observacionCajaPlaceholder => 'TODO_CA · Cuando llegue Sprint 5, aquí podrás añadir foto o dibujo.';

  @override
  String get observacionEtiquetaQueViste => 'TODO_CA · qué viste';

  @override
  String get observacionPlaceholderQueViste => 'TODO_CA · describe lo que has visto, sin nombrarlo si no estás segura';

  @override
  String get observacionEtiquetaCreesQueEs => 'TODO_CA · crees que es';

  @override
  String get observacionPlaceholderCreesQueEs => 'TODO_CA · si quieres, propón un nombre';

  @override
  String get confianzaConsenso => 'TODO_CA · consenso';

  @override
  String get confianzaHipotesisActiva => 'TODO_CA · hipótesis activa';

  @override
  String get confianzaNoSegura => 'TODO_CA · no estoy segura';

  @override
  String get confianzaConsensoTooltip => 'TODO_CA · lo has confirmado con una clave o con el Tutor';

  @override
  String get confianzaNoSeguraTooltip => 'TODO_CA · no pasa nada, anótalo así';

  @override
  String get observacionAvisoFalta => 'TODO_CA · haz una nota antes de guardar';

  @override
  String get observacionBotonGuardar => 'TODO_CA · Guardar en el cuaderno';

  @override
  String get tutorSaludoCanonico => 'TODO_CA · Soy el Tutor del Cuaderno. Pregúntame lo que necesites.';

  @override
  String get tutorPlaceholderInput => 'TODO_CA · escribe tu pregunta';

  @override
  String get tutorBotonEnviar => 'TODO_CA · Enviar';

  @override
  String get tutorRespuestaCanned => 'TODO_CA · El Tutor todavía no está conectado. Vuelve en unas semanas.';
}
