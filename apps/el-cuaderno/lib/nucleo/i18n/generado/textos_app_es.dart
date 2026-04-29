import 'textos_app.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class TextosAppEs extends TextosApp {
  TextosAppEs([String locale = 'es']) : super(locale);

  @override
  String get tituloApp => 'El Cuaderno';

  @override
  String get subtituloBienvenida => 'Una herramienta para anotar lo que ves vivo cerca de ti.';

  @override
  String get saludoSinNombre => 'Hola.';

  @override
  String saludoConNombre(String nombre) {
    return 'Hola, $nombre.';
  }

  @override
  String get navCuaderno => 'cuaderno';

  @override
  String get navMapa => 'mapa';

  @override
  String get navMisterios => 'misterios';

  @override
  String get navTutor => 'tutor';

  @override
  String get seccionSitSpot => 'Tu sit spot';

  @override
  String get seccionMisteriosAbiertos => 'Misterios abiertos';

  @override
  String get seccionUltimaPagina => 'Última página';

  @override
  String get sitSpotInvitacion => 'Cuando estés en algún sitio al aire libre que te guste — un parque, un árbol, una esquina — puedes hacerlo tu sit spot. Toca aquí cuando estés.';

  @override
  String sitSpotUltimaVisita(String cuando) {
    return 'Última visita: $cuando';
  }

  @override
  String get ultimaPaginaVacia => 'Aún no has anotado nada. Cuando lo hagas, aparecerá aquí.';

  @override
  String get misteriosVacio => 'Aún no tienes Misterios abiertos. El sistema te propondrá alguno pronto.';

  @override
  String get navProximamente => 'Próximamente.';

  @override
  String get observacionTitulo => 'nueva observación';

  @override
  String observacionCabecera(String hora) {
    return 'Hoy · $hora';
  }

  @override
  String get observacionCajaFoto => 'foto';

  @override
  String get observacionCajaDibujo => 'dibujo';

  @override
  String get observacionCajaPlaceholder => 'Cuando llegue Sprint 5, aquí podrás añadir foto o dibujo.';

  @override
  String get observacionEtiquetaQueViste => 'qué viste';

  @override
  String get observacionPlaceholderQueViste => 'describe lo que has visto, sin nombrarlo si no estás segura';

  @override
  String get observacionEtiquetaCreesQueEs => 'crees que es';

  @override
  String get observacionPlaceholderCreesQueEs => 'si quieres, propón un nombre';

  @override
  String get confianzaConsenso => 'consenso';

  @override
  String get confianzaHipotesisActiva => 'hipótesis activa';

  @override
  String get confianzaNoSegura => 'no estoy segura';

  @override
  String get confianzaConsensoTooltip => 'lo has confirmado con una clave o con el Tutor';

  @override
  String get confianzaNoSeguraTooltip => 'no pasa nada, anótalo así';

  @override
  String get observacionAvisoFalta => 'haz una nota antes de guardar';

  @override
  String get observacionBotonGuardar => 'Guardar en el cuaderno';

  @override
  String get tutorSaludoCanonico => 'Soy el Tutor del Cuaderno. Pregúntame lo que necesites.';

  @override
  String get tutorPlaceholderInput => 'escribe tu pregunta';

  @override
  String get tutorBotonEnviar => 'Enviar';

  @override
  String get tutorRespuestaCanned => 'El Tutor todavía no está conectado. Vuelve en unas semanas.';
}
