import 'package:intl/intl.dart' as intl;

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
  String get observacionCajaPlaceholder => 'TODO_EU · Si quieres, añade una foto o un dibujo.';

  @override
  String get observacionFotoTomar => 'TODO_EU · tomar foto';

  @override
  String get observacionFotoElegir => 'TODO_EU · elegir foto';

  @override
  String get observacionFotoQuitar => 'TODO_EU · quitar foto';

  @override
  String get observacionDibujoComenzar => 'TODO_EU · hacer dibujo';

  @override
  String get observacionDibujoQuitar => 'TODO_EU · quitar dibujo';

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

  @override
  String get ajustesTitulo => 'TODO_EU · Ajustes';

  @override
  String ajustesIdiomaActual(String idioma) {
    return 'TODO_EU · Idioma del cuaderno: $idioma';
  }

  @override
  String get ajustesIdiomaCambiar => 'TODO_EU · Cambiar idioma';

  @override
  String get ajustesExportar => 'TODO_EU · Exportar mi cuaderno';

  @override
  String get ajustesExportarDescripcion => 'TODO_EU · Recibe una copia legible de tus observaciones y Misterios. El cuaderno es tuyo.';

  @override
  String get ajustesExportarDialogoTitulo => 'TODO_EU · Tu cuaderno como texto';

  @override
  String get ajustesExportarDialogoCerrar => 'TODO_EU · Cerrar';

  @override
  String get ajustesVistaCuidador => 'TODO_EU · Vista del cuidador';

  @override
  String get ajustesVistaCuidadorDescripcion => 'TODO_EU · Una página discreta para una persona adulta que te acompaña.';

  @override
  String get ajustesBorrar => 'TODO_EU · Borrar mi cuaderno';

  @override
  String get ajustesBorrarDescripcion => 'TODO_EU · Borrar todas tus observaciones, Misterios y sit spot. No se puede deshacer.';

  @override
  String get ajustesBorrarDialogoTitulo => 'TODO_EU · ¿Borrar todo?';

  @override
  String ajustesBorrarDialogoCuerpo(int observaciones, int misterios, int sitSpots) {
    return 'TODO_EU · Si continúas, se borrarán $observaciones observaciones, $misterios Misterios y $sitSpots sit spot. No se puede deshacer.';
  }

  @override
  String get ajustesBorrarDialogoSeguir => 'TODO_EU · Seguir';

  @override
  String get ajustesBorrarDialogoCancelar => 'TODO_EU · Cancelar';

  @override
  String get ajustesBorrarConfirmacionTitulo => 'TODO_EU · ¿Estás segura?';

  @override
  String get ajustesBorrarConfirmacionCuerpo => 'TODO_EU · Escribe «borrar» abajo para confirmar.';

  @override
  String get ajustesBorrarConfirmacionPalabra => 'TODO_EU · borrar';

  @override
  String get ajustesBorrarConfirmacionPlaceholder => 'TODO_EU · escribe la palabra';

  @override
  String get ajustesBorrarConfirmacionBoton => 'TODO_EU · Borrar todo';

  @override
  String get ajustesBorradoCompleto => 'TODO_EU · Listo. Tu cuaderno está vacío.';

  @override
  String get bienvenidaTitulo => 'TODO_EU · ¿Cómo te llamas?';

  @override
  String get bienvenidaCuerpo => 'TODO_EU · Tu nombre se queda en este cuaderno. No sale al servidor a menos que tú decidas vincularlo más tarde.';

  @override
  String get bienvenidaPlaceholderNombre => 'TODO_EU · tu nombre';

  @override
  String get bienvenidaBotonContinuar => 'TODO_EU · Continuar';

  @override
  String get ajustesSyncObsTitulo => 'TODO_EU · Sincronizar mis observaciones';

  @override
  String get ajustesSyncObsDescripcion => 'TODO_EU · Sube las observaciones nuevas a tu cuenta del servidor para no perderlas si cambias de dispositivo.';

  @override
  String get ajustesSyncObsBoton => 'TODO_EU · Subir ahora';

  @override
  String get ajustesSyncObsEnVuelo => 'TODO_EU · Subiendo…';

  @override
  String get ajustesSyncObsSinToken => 'TODO_EU · Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón subirá tus observaciones.';

  @override
  String get ajustesSyncObsNadaPendiente => 'TODO_EU · No hay observaciones pendientes — todo subido.';

  @override
  String ajustesSyncObsTodasEnviadas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODO_EU · Se han subido $count observaciones.',
      one: 'TODO_EU · Se ha subido una observación.',
    );
    return '$_temp0';
  }

  @override
  String ajustesSyncObsParcial(int enviadas, int pendientes) {
    return 'TODO_EU · Subidas $enviadas, quedan $pendientes para el siguiente intento.';
  }

  @override
  String ajustesSyncObsRechazadas(int enviadas, int rechazadas) {
    return 'TODO_EU · Subidas $enviadas, el servidor ha rechazado $rechazadas. Vuelve a abrirlas para revisarlas.';
  }

  @override
  String get ajustesCuentaTitulo => 'TODO_EU · Cuenta del adulto';

  @override
  String get ajustesCuentaDescripcion => 'TODO_EU · Si tienes una cuenta de Nuevo Ser, puedes vincularla aquí. Sirve para subir tus observaciones, recibir el resumen escrito del cuidador y conectar el Tutor real.';

  @override
  String get ajustesCuentaPlaceholderEmail => 'TODO_EU · correo del adulto';

  @override
  String get ajustesCuentaPlaceholderPassword => 'TODO_EU · contraseña';

  @override
  String get ajustesCuentaBotonEntrar => 'TODO_EU · Iniciar sesión';

  @override
  String get ajustesCuentaEntrando => 'TODO_EU · Entrando…';

  @override
  String ajustesCuentaSesionIniciada(String email) {
    return 'TODO_EU · Sesión iniciada como $email.';
  }

  @override
  String get ajustesCuentaSesionIniciadaSinEmail => 'TODO_EU · Sesión iniciada.';

  @override
  String get ajustesCuentaCerrarSesion => 'TODO_EU · Cerrar sesión';

  @override
  String get ajustesCuentaErrorCredenciales => 'TODO_EU · El correo o la contraseña no coinciden con ninguna cuenta.';

  @override
  String get ajustesCuentaErrorSinPerfil => 'TODO_EU · La cuenta del adulto no tiene ningún niño asociado todavía.';

  @override
  String get ajustesCuentaErrorRed => 'TODO_EU · No se ha podido conectar con el servidor. Inténtalo en un momento.';

  @override
  String get ajustesCuentaErrorVacio => 'TODO_EU · Escribe el correo y la contraseña antes de continuar.';

  @override
  String get ajustesTutorDebugTitulo => 'TODO_EU · Tutor (debug)';

  @override
  String get ajustesTutorDebugDescripcion => 'TODO_EU · Pega aquí un token del backend para activar el Tutor real. Visible sólo en debug.';

  @override
  String get ajustesTutorDebugPlaceholder => 'TODO_EU · JWT del backend';

  @override
  String get ajustesTutorDebugBotonGuardar => 'TODO_EU · Guardar token';

  @override
  String get ajustesTutorDebugBotonBorrar => 'TODO_EU · Borrar token';

  @override
  String get ajustesTutorDebugGuardado => 'TODO_EU · Token guardado. Vuelve al Tutor para probarlo.';

  @override
  String get ajustesTutorDebugBorrado => 'TODO_EU · Token borrado. El Tutor vuelve a la respuesta canónica.';

  @override
  String get cuidadorTitulo => 'TODO_EU · Página del cuidador';

  @override
  String get cuidadorAviso => 'TODO_EU · Esta es la única vista que comparte el juego con quien te acompaña. No verá tus observaciones ni lo que escribes — solo este resumen y una pregunta para hablar.';

  @override
  String cuidadorSemanaActual(String isoWeek) {
    return 'TODO_EU · Semana $isoWeek';
  }

  @override
  String get cuidadorPreguntaCabecera => 'TODO_EU · Una pregunta para la cena';

  @override
  String get cuidadorMetricasCabecera => 'TODO_EU · Esta semana';

  @override
  String cuidadorMetricaObservaciones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODO_EU · $count observaciones',
      one: 'TODO_EU · Una observación',
      zero: 'TODO_EU · Sin observaciones',
    );
    return '$_temp0';
  }

  @override
  String cuidadorMetricaMisterios(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODO_EU · $count Misterios',
      one: 'TODO_EU · Un Misterio',
      zero: 'TODO_EU · Sin Misterios anclados',
    );
    return '$_temp0';
  }

  @override
  String cuidadorMetricaSitSpot(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODO_EU · $count visitas al sit spot',
      one: 'TODO_EU · Una visita al sit spot',
      zero: 'TODO_EU · Sin visitas al sit spot',
    );
    return '$_temp0';
  }

  @override
  String get cuidadorSincronizarBoton => 'TODO_EU · Compartir resumen con el adulto';

  @override
  String get cuidadorSincronizarEnVuelo => 'TODO_EU · Pidiéndolo…';

  @override
  String get cuidadorSincronizarSinToken => 'TODO_EU · Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón pedirá un resumen escrito.';

  @override
  String get cuidadorSincronizarErrorRed => 'TODO_EU · Hoy no se ha podido conectar. Puedes volver a intentarlo más tarde.';

  @override
  String get cuidadorSincronizarSinResumen => 'TODO_EU · El servidor no ha podido generar un resumen esta vez. La pregunta de abajo sigue valiendo.';

  @override
  String get cuidadorResumenCabecera => 'TODO_EU · Esta semana, en una frase';
}
