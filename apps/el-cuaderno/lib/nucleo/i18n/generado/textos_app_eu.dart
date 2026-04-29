import 'textos_app.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class TextosAppEu extends TextosApp {
  TextosAppEu([String locale = 'eu']) : super(locale);

  @override
  String get tituloApp => 'TODO_EU · El Cuaderno';

  @override
  String get subtituloBienvenida => 'TODO_EU · Una herramienta para anotar lo que ves vivo cerca de ti.';

  @override
  String get saludoSinNombre => 'TODO_EU · Hola.';

  @override
  String saludoConNombre(String nombre) {
    return 'TODO_EU · Hola, $nombre.';
  }

  @override
  String get navCuaderno => 'TODO_EU · cuaderno';

  @override
  String get navMapa => 'TODO_EU · mapa';

  @override
  String get navMisterios => 'TODO_EU · misterios';

  @override
  String get navTutor => 'TODO_EU · tutor';

  @override
  String get seccionSitSpot => 'TODO_EU · Tu sit spot';

  @override
  String get seccionMisteriosAbiertos => 'TODO_EU · Misterios abiertos';

  @override
  String get seccionUltimaPagina => 'TODO_EU · Última página';

  @override
  String get sitSpotInvitacion => 'TODO_EU · Cuando estés en algún sitio al aire libre que te guste — un parque, un árbol, una esquina — puedes hacerlo tu sit spot. Toca aquí cuando estés.';

  @override
  String sitSpotUltimaVisita(String cuando) {
    return 'TODO_EU · Última visita: $cuando';
  }

  @override
  String get ultimaPaginaVacia => 'TODO_EU · Aún no has anotado nada. Cuando lo hagas, aparecerá aquí.';

  @override
  String get misteriosVacio => 'TODO_EU · Aún no tienes Misterios abiertos. El sistema te propondrá alguno pronto.';

  @override
  String get navProximamente => 'TODO_EU · Próximamente.';

  @override
  String get observacionTitulo => 'TODO_EU · nueva observación';

  @override
  String observacionCabecera(String hora) {
    return 'TODO_EU · Hoy · $hora';
  }

  @override
  String get observacionCajaFoto => 'TODO_EU · foto';

  @override
  String get observacionCajaDibujo => 'TODO_EU · dibujo';

  @override
  String get observacionCajaPlaceholder => 'TODO_EU · Cuando llegue Sprint 5, aquí podrás añadir foto o dibujo.';

  @override
  String get observacionEtiquetaQueViste => 'TODO_EU · qué viste';

  @override
  String get observacionPlaceholderQueViste => 'TODO_EU · describe lo que has visto, sin nombrarlo si no estás segura';

  @override
  String get observacionEtiquetaCreesQueEs => 'TODO_EU · crees que es';

  @override
  String get observacionPlaceholderCreesQueEs => 'TODO_EU · si quieres, propón un nombre';

  @override
  String get confianzaConsenso => 'TODO_EU · consenso';

  @override
  String get confianzaHipotesisActiva => 'TODO_EU · hipótesis activa';

  @override
  String get confianzaNoSegura => 'TODO_EU · no estoy segura';

  @override
  String get confianzaConsensoTooltip => 'TODO_EU · lo has confirmado con una clave o con el Tutor';

  @override
  String get confianzaNoSeguraTooltip => 'TODO_EU · no pasa nada, anótalo así';

  @override
  String get observacionAvisoFalta => 'TODO_EU · haz una nota antes de guardar';

  @override
  String get observacionBotonGuardar => 'TODO_EU · Guardar en el cuaderno';

  @override
  String get tutorSaludoCanonico => 'TODO_EU · Soy el Tutor del Cuaderno. Pregúntame lo que necesites.';

  @override
  String get tutorPlaceholderInput => 'TODO_EU · escribe tu pregunta';

  @override
  String get tutorBotonEnviar => 'TODO_EU · Enviar';

  @override
  String get tutorRespuestaCanned => 'TODO_EU · El Tutor todavía no está conectado. Vuelve en unas semanas.';
}
