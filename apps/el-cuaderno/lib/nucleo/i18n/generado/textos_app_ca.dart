import 'package:intl/intl.dart' as intl;

import 'textos_app.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class TextosAppCa extends TextosApp {
  TextosAppCa([String locale = 'ca']) : super(locale);

  @override
  String get tituloApp => 'El Quadern';

  @override
  String get subtituloBienvenida => 'Una eina per anotar el que veus viu prop teu.';

  @override
  String get saludoSinNombre => 'Hola.';

  @override
  String saludoConNombre(String nombre) {
    return 'Hola, $nombre.';
  }

  @override
  String get navCuaderno => 'quadern';

  @override
  String get navMapa => 'mapa';

  @override
  String get navMisterios => 'misteris';

  @override
  String get navTutor => 'tutor';

  @override
  String get seccionSitSpot => 'El teu sit spot';

  @override
  String get seccionMisteriosAbiertos => 'Misteris oberts';

  @override
  String get seccionUltimaPagina => 'Última pàgina';

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
  String get misteriosFueraDeContexto => 'TODO_CA · Hoy no hay Misterios para tu lugar y esta estación. Vuelve a mirar al cambiar el tiempo.';

  @override
  String get navProximamente => 'Aviat.';

  @override
  String get observacionTitulo => 'observació nova';

  @override
  String observacionCabecera(String hora) {
    return 'TODO_CA · Hoy · $hora';
  }

  @override
  String get observacionCajaFoto => 'TODO_CA · foto';

  @override
  String get observacionCajaDibujo => 'TODO_CA · dibujo';

  @override
  String get observacionCajaPlaceholder => 'TODO_CA · Si quieres, añade una foto o un dibujo.';

  @override
  String get observacionFotoTomar => 'TODO_CA · tomar foto';

  @override
  String get observacionFotoElegir => 'TODO_CA · elegir foto';

  @override
  String get observacionFotoQuitar => 'TODO_CA · quitar foto';

  @override
  String get observacionDibujoComenzar => 'TODO_CA · hacer dibujo';

  @override
  String get observacionDibujoQuitar => 'TODO_CA · quitar dibujo';

  @override
  String get observacionEtiquetaQueViste => 'què has vist';

  @override
  String get observacionPlaceholderQueViste => 'descriu el que has vist, sense posar-li nom si no n\'estàs segura';

  @override
  String get observacionEtiquetaCreesQueEs => 'creus que és';

  @override
  String get observacionPlaceholderCreesQueEs => 'si vols, proposa un nom';

  @override
  String get confianzaConsenso => 'consens';

  @override
  String get confianzaHipotesisActiva => 'hipòtesi activa';

  @override
  String get confianzaNoSegura => 'no n\'estic segura';

  @override
  String get confianzaConsensoTooltip => 'ho has confirmat amb una clau o amb el Tutor';

  @override
  String get confianzaNoSeguraTooltip => 'no passa res, anota-ho així';

  @override
  String get observacionAvisoFalta => 'fes una nota abans de desar';

  @override
  String get observacionBotonGuardar => 'Desar al quadern';

  @override
  String get tutorSaludoCanonico => 'Soc el Tutor del Quadern. Pregunta\'m el que necessitis.';

  @override
  String get tutorPlaceholderInput => 'escriu la teva pregunta';

  @override
  String get tutorBotonEnviar => 'Enviar';

  @override
  String get tutorRespuestaCanned => 'El Tutor encara no està connectat. Torna en unes setmanes.';

  @override
  String get ajustesTitulo => 'Configuració';

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
  String get ajustesExportarPdf => 'TODO_CA · Exportar como PDF';

  @override
  String get ajustesExportarPdfDescripcion => 'TODO_CA · Una copia para imprimir o llevar a un papel. El sistema te preguntará dónde guardarla.';

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
  String get bienvenidaTitulo => 'Com et dius?';

  @override
  String get bienvenidaCuerpo => 'El teu nom es queda en aquest quadern. No surt al servidor tret que decideixis vincular-lo més endavant.';

  @override
  String get bienvenidaPlaceholderNombre => 'el teu nom';

  @override
  String get bienvenidaBotonContinuar => 'Continuar';

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
  String get ajustesCuentaTitulo => 'TODO_CA · Cuenta del adulto';

  @override
  String get ajustesCuentaDescripcion => 'TODO_CA · Si tienes una cuenta de Nuevo Ser, puedes vincularla aquí. Sirve para subir tus observaciones, recibir el resumen escrito del cuidador y conectar el Tutor real.';

  @override
  String get ajustesCuentaPlaceholderEmail => 'TODO_CA · correo del adulto';

  @override
  String get ajustesCuentaPlaceholderPassword => 'TODO_CA · contraseña';

  @override
  String get ajustesCuentaBotonEntrar => 'TODO_CA · Iniciar sesión';

  @override
  String get ajustesCuentaEntrando => 'TODO_CA · Entrando…';

  @override
  String ajustesCuentaSesionIniciada(String email) {
    return 'TODO_CA · Sesión iniciada como $email.';
  }

  @override
  String get ajustesCuentaSesionIniciadaSinEmail => 'TODO_CA · Sesión iniciada.';

  @override
  String get ajustesCuentaCerrarSesion => 'TODO_CA · Cerrar sesión';

  @override
  String get ajustesCuentaErrorCredenciales => 'TODO_CA · El correo o la contraseña no coinciden con ninguna cuenta.';

  @override
  String get ajustesCuentaErrorSinPerfil => 'TODO_CA · La cuenta del adulto no tiene ningún niño asociado todavía.';

  @override
  String get ajustesCuentaErrorRed => 'TODO_CA · No se ha podido conectar con el servidor. Inténtalo en un momento.';

  @override
  String get ajustesCuentaErrorVacio => 'TODO_CA · Escribe el correo y la contraseña antes de continuar.';

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
