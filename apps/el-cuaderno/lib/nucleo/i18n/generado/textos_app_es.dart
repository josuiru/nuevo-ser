import 'package:intl/intl.dart' as intl;

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

  @override
  String get ajustesTitulo => 'Ajustes';

  @override
  String ajustesIdiomaActual(String idioma) {
    return 'Idioma del cuaderno: $idioma';
  }

  @override
  String get ajustesIdiomaCambiar => 'Cambiar idioma';

  @override
  String get ajustesExportar => 'Exportar mi cuaderno';

  @override
  String get ajustesExportarDescripcion => 'Recibe una copia legible de tus observaciones y Misterios. El cuaderno es tuyo.';

  @override
  String get ajustesExportarDialogoTitulo => 'Tu cuaderno como texto';

  @override
  String get ajustesExportarDialogoCerrar => 'Cerrar';

  @override
  String get ajustesVistaCuidador => 'Vista del cuidador';

  @override
  String get ajustesVistaCuidadorDescripcion => 'Una página discreta para una persona adulta que te acompaña.';

  @override
  String get ajustesBorrar => 'Borrar mi cuaderno';

  @override
  String get ajustesBorrarDescripcion => 'Borrar todas tus observaciones, Misterios y sit spot. No se puede deshacer.';

  @override
  String get ajustesBorrarDialogoTitulo => '¿Borrar todo?';

  @override
  String ajustesBorrarDialogoCuerpo(int observaciones, int misterios, int sitSpots) {
    return 'Si continúas, se borrarán $observaciones observaciones, $misterios Misterios y $sitSpots sit spot. No se puede deshacer.';
  }

  @override
  String get ajustesBorrarDialogoSeguir => 'Seguir';

  @override
  String get ajustesBorrarDialogoCancelar => 'Cancelar';

  @override
  String get ajustesBorrarConfirmacionTitulo => '¿Estás segura?';

  @override
  String get ajustesBorrarConfirmacionCuerpo => 'Escribe «borrar» abajo para confirmar.';

  @override
  String get ajustesBorrarConfirmacionPalabra => 'borrar';

  @override
  String get ajustesBorrarConfirmacionPlaceholder => 'escribe la palabra';

  @override
  String get ajustesBorrarConfirmacionBoton => 'Borrar todo';

  @override
  String get ajustesBorradoCompleto => 'Listo. Tu cuaderno está vacío.';

  @override
  String get bienvenidaTitulo => '¿Cómo te llamas?';

  @override
  String get bienvenidaCuerpo => 'Tu nombre se queda en este cuaderno. No sale al servidor a menos que tú decidas vincularlo más tarde.';

  @override
  String get bienvenidaPlaceholderNombre => 'tu nombre';

  @override
  String get bienvenidaBotonContinuar => 'Continuar';

  @override
  String get ajustesSyncObsTitulo => 'Sincronizar mis observaciones';

  @override
  String get ajustesSyncObsDescripcion => 'Sube las observaciones nuevas a tu cuenta del servidor para no perderlas si cambias de dispositivo.';

  @override
  String get ajustesSyncObsBoton => 'Subir ahora';

  @override
  String get ajustesSyncObsEnVuelo => 'Subiendo…';

  @override
  String get ajustesSyncObsSinToken => 'Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón subirá tus observaciones.';

  @override
  String get ajustesSyncObsNadaPendiente => 'No hay observaciones pendientes — todo subido.';

  @override
  String ajustesSyncObsTodasEnviadas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se han subido $count observaciones.',
      one: 'Se ha subido una observación.',
    );
    return '$_temp0';
  }

  @override
  String ajustesSyncObsParcial(int enviadas, int pendientes) {
    return 'Subidas $enviadas, quedan $pendientes para el siguiente intento.';
  }

  @override
  String ajustesSyncObsRechazadas(int enviadas, int rechazadas) {
    return 'Subidas $enviadas, el servidor ha rechazado $rechazadas. Vuelve a abrirlas para revisarlas.';
  }

  @override
  String get ajustesTutorDebugTitulo => 'Tutor (debug)';

  @override
  String get ajustesTutorDebugDescripcion => 'Pega aquí un token del backend para activar el Tutor real. Visible sólo en debug.';

  @override
  String get ajustesTutorDebugPlaceholder => 'JWT del backend';

  @override
  String get ajustesTutorDebugBotonGuardar => 'Guardar token';

  @override
  String get ajustesTutorDebugBotonBorrar => 'Borrar token';

  @override
  String get ajustesTutorDebugGuardado => 'Token guardado. Vuelve al Tutor para probarlo.';

  @override
  String get ajustesTutorDebugBorrado => 'Token borrado. El Tutor vuelve a la respuesta canónica.';

  @override
  String get cuidadorTitulo => 'Página del cuidador';

  @override
  String get cuidadorAviso => 'Esta es la única vista que comparte el juego con quien te acompaña. No verá tus observaciones ni lo que escribes — solo este resumen y una pregunta para hablar.';

  @override
  String cuidadorSemanaActual(String isoWeek) {
    return 'Semana $isoWeek';
  }

  @override
  String get cuidadorPreguntaCabecera => 'Una pregunta para la cena';

  @override
  String get cuidadorMetricasCabecera => 'Esta semana';

  @override
  String cuidadorMetricaObservaciones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count observaciones',
      one: 'Una observación',
      zero: 'Sin observaciones',
    );
    return '$_temp0';
  }

  @override
  String cuidadorMetricaMisterios(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Misterios',
      one: 'Un Misterio',
      zero: 'Sin Misterios anclados',
    );
    return '$_temp0';
  }

  @override
  String cuidadorMetricaSitSpot(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count visitas al sit spot',
      one: 'Una visita al sit spot',
      zero: 'Sin visitas al sit spot',
    );
    return '$_temp0';
  }

  @override
  String get cuidadorSincronizarBoton => 'Compartir resumen con el adulto';

  @override
  String get cuidadorSincronizarEnVuelo => 'Pidiéndolo…';

  @override
  String get cuidadorSincronizarSinToken => 'Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón pedirá un resumen escrito.';

  @override
  String get cuidadorSincronizarErrorRed => 'Hoy no se ha podido conectar. Puedes volver a intentarlo más tarde.';

  @override
  String get cuidadorSincronizarSinResumen => 'El servidor no ha podido generar un resumen esta vez. La pregunta de abajo sigue valiendo.';

  @override
  String get cuidadorResumenCabecera => 'Esta semana, en una frase';
}
