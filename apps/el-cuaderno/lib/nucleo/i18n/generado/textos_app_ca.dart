import 'package:intl/intl.dart' as intl;

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

  @override
  String get ajustesTitulo => 'TODO_CA · Ajustes';

  @override
  String ajustesIdiomaActual(String idioma) {
    return 'TODO_CA · Idioma del cuaderno: $idioma';
  }

  @override
  String get ajustesIdiomaCambiar => 'TODO_CA · Cambiar idioma';

  @override
  String get ajustesExportar => 'TODO_CA · Exportar mi cuaderno';

  @override
  String get ajustesExportarDescripcion => 'TODO_CA · Recibe una copia legible de tus observaciones y Misterios. El cuaderno es tuyo.';

  @override
  String get ajustesExportarDialogoTitulo => 'TODO_CA · Tu cuaderno como texto';

  @override
  String get ajustesExportarDialogoCerrar => 'TODO_CA · Cerrar';

  @override
  String get ajustesVistaCuidador => 'TODO_CA · Vista del cuidador';

  @override
  String get ajustesVistaCuidadorDescripcion => 'TODO_CA · Una página discreta para una persona adulta que te acompaña.';

  @override
  String get ajustesBorrar => 'TODO_CA · Borrar mi cuaderno';

  @override
  String get ajustesBorrarDescripcion => 'TODO_CA · Borrar todas tus observaciones, Misterios y sit spot. No se puede deshacer.';

  @override
  String get ajustesBorrarDialogoTitulo => 'TODO_CA · ¿Borrar todo?';

  @override
  String ajustesBorrarDialogoCuerpo(int observaciones, int misterios, int sitSpots) {
    return 'TODO_CA · Si continúas, se borrarán $observaciones observaciones, $misterios Misterios y $sitSpots sit spot. No se puede deshacer.';
  }

  @override
  String get ajustesBorrarDialogoSeguir => 'TODO_CA · Seguir';

  @override
  String get ajustesBorrarDialogoCancelar => 'TODO_CA · Cancelar';

  @override
  String get ajustesBorrarConfirmacionTitulo => 'TODO_CA · ¿Estás segura?';

  @override
  String get ajustesBorrarConfirmacionCuerpo => 'TODO_CA · Escribe «borrar» abajo para confirmar.';

  @override
  String get ajustesBorrarConfirmacionPalabra => 'TODO_CA · borrar';

  @override
  String get ajustesBorrarConfirmacionPlaceholder => 'TODO_CA · escribe la palabra';

  @override
  String get ajustesBorrarConfirmacionBoton => 'TODO_CA · Borrar todo';

  @override
  String get ajustesBorradoCompleto => 'TODO_CA · Listo. Tu cuaderno está vacío.';

  @override
  String get ajustesSyncObsTitulo => 'TODO_CA · Sincronizar mis observaciones';

  @override
  String get ajustesSyncObsDescripcion => 'TODO_CA · Sube las observaciones nuevas a tu cuenta del servidor para no perderlas si cambias de dispositivo.';

  @override
  String get ajustesSyncObsBoton => 'TODO_CA · Subir ahora';

  @override
  String get ajustesSyncObsEnVuelo => 'TODO_CA · Subiendo…';

  @override
  String get ajustesSyncObsSinToken => 'TODO_CA · Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón subirá tus observaciones.';

  @override
  String get ajustesSyncObsNadaPendiente => 'TODO_CA · No hay observaciones pendientes — todo subido.';

  @override
  String ajustesSyncObsTodasEnviadas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODO_CA · Se han subido $count observaciones.',
      one: 'TODO_CA · Se ha subido una observación.',
    );
    return '$_temp0';
  }

  @override
  String ajustesSyncObsParcial(int enviadas, int pendientes) {
    return 'TODO_CA · Subidas $enviadas, quedan $pendientes para el siguiente intento.';
  }

  @override
  String ajustesSyncObsRechazadas(int enviadas, int rechazadas) {
    return 'TODO_CA · Subidas $enviadas, el servidor ha rechazado $rechazadas. Vuelve a abrirlas para revisarlas.';
  }

  @override
  String get ajustesTutorDebugTitulo => 'TODO_CA · Tutor (debug)';

  @override
  String get ajustesTutorDebugDescripcion => 'TODO_CA · Pega aquí un token del backend para activar el Tutor real. Visible sólo en debug.';

  @override
  String get ajustesTutorDebugPlaceholder => 'TODO_CA · JWT del backend';

  @override
  String get ajustesTutorDebugBotonGuardar => 'TODO_CA · Guardar token';

  @override
  String get ajustesTutorDebugBotonBorrar => 'TODO_CA · Borrar token';

  @override
  String get ajustesTutorDebugGuardado => 'TODO_CA · Token guardado. Vuelve al Tutor para probarlo.';

  @override
  String get ajustesTutorDebugBorrado => 'TODO_CA · Token borrado. El Tutor vuelve a la respuesta canónica.';

  @override
  String get cuidadorTitulo => 'TODO_CA · Página del cuidador';

  @override
  String get cuidadorAviso => 'TODO_CA · Esta es la única vista que comparte el juego con quien te acompaña. No verá tus observaciones ni lo que escribes — solo este resumen y una pregunta para hablar.';

  @override
  String cuidadorSemanaActual(String isoWeek) {
    return 'TODO_CA · Semana $isoWeek';
  }

  @override
  String get cuidadorPreguntaCabecera => 'TODO_CA · Una pregunta para la cena';

  @override
  String get cuidadorMetricasCabecera => 'TODO_CA · Esta semana';

  @override
  String cuidadorMetricaObservaciones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODO_CA · $count observaciones',
      one: 'TODO_CA · Una observación',
      zero: 'TODO_CA · Sin observaciones',
    );
    return '$_temp0';
  }

  @override
  String cuidadorMetricaMisterios(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODO_CA · $count Misterios',
      one: 'TODO_CA · Un Misterio',
      zero: 'TODO_CA · Sin Misterios anclados',
    );
    return '$_temp0';
  }

  @override
  String cuidadorMetricaSitSpot(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODO_CA · $count visitas al sit spot',
      one: 'TODO_CA · Una visita al sit spot',
      zero: 'TODO_CA · Sin visitas al sit spot',
    );
    return '$_temp0';
  }

  @override
  String get cuidadorSincronizarBoton => 'TODO_CA · Compartir resumen con el adulto';

  @override
  String get cuidadorSincronizarEnVuelo => 'TODO_CA · Pidiéndolo…';

  @override
  String get cuidadorSincronizarSinToken => 'TODO_CA · Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón pedirá un resumen escrito.';

  @override
  String get cuidadorSincronizarErrorRed => 'TODO_CA · Hoy no se ha podido conectar. Puedes volver a intentarlo más tarde.';

  @override
  String get cuidadorSincronizarSinResumen => 'TODO_CA · El servidor no ha podido generar un resumen esta vez. La pregunta de abajo sigue valiendo.';

  @override
  String get cuidadorResumenCabecera => 'TODO_CA · Esta semana, en una frase';
}
