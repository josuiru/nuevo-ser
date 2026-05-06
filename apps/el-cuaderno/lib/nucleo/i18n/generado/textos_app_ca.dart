// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'textos_app.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class TextosAppCa extends TextosApp {
  TextosAppCa([String locale = 'ca']) : super(locale);

  @override
  String get tituloApp => 'El Quadern';

  @override
  String get subtituloBienvenida =>
      'Una eina per anotar el que veus viu prop teu.';

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
  String get sitSpotInvitacion =>
      'TODO_CA · Cuando estés en algún sitio al aire libre que te guste — un parque, un árbol, una esquina — puedes hacerlo tu sit spot. Toca aquí cuando estés.';

  @override
  String sitSpotUltimaVisita(String cuando) {
    return 'TODO_CA · Última visita: $cuando';
  }

  @override
  String get ultimaPaginaVacia =>
      'TODO_CA · Aún no has anotado nada. Cuando lo hagas, aparecerá aquí.';

  @override
  String get misteriosVacio =>
      'TODO_CA · Aún no tienes Misterios abiertos. El sistema te propondrá alguno pronto.';

  @override
  String get misteriosFueraDeContexto =>
      'TODO_CA · Hoy no hay Misterios para tu lugar y esta estación. Vuelve a mirar al cambiar el tiempo.';

  @override
  String get navProximamente => 'Aviat.';

  @override
  String get homeFabAnotar => 'TODO_CA · anotar';

  @override
  String get homeFabAnotarTooltip => 'TODO_CA · anotar lo que ves';

  @override
  String get homeOrientacionConMisterios =>
      'TODO_CA · Estos son los Misterios que tu cuaderno tiene abiertos. Ábrelos para leerlos; cuando veas algo en tu sit spot que tenga que ver, anótalo.';

  @override
  String get seccionTusPreguntas => 'TODO_CA · Tus preguntas';

  @override
  String get seccionMisteriosDelCuaderno => 'TODO_CA · Misterios del cuaderno';

  @override
  String get tusPreguntasVacio =>
      'TODO_CA · Aún no has formulado ninguna pregunta. Cuando se te ocurra una mientras observas tu lugar, anótala aquí.';

  @override
  String get preguntaFabFormular => 'TODO_CA · formular pregunta';

  @override
  String get preguntaFormularTitulo => 'TODO_CA · Tu pregunta';

  @override
  String get preguntaFormularIntro =>
      'TODO_CA · Una pregunta tuya. La que llevas dándole vueltas, la que se te acaba de ocurrir, la que nadie te ha contado. Escríbela como te suene; no hace falta que esté bien hecha — sólo que sea la tuya.';

  @override
  String get preguntaFormularPlaceholder => '¿…?';

  @override
  String get preguntaFormularBotonGuardar => 'TODO_CA · Guardar mi pregunta';

  @override
  String get preguntaFormularBotonIdeas => 'TODO_CA · necesito ideas';

  @override
  String get preguntaIdeasTitulo =>
      'TODO_CA · Si necesitas un punto de partida';

  @override
  String get preguntaIdeasIntro =>
      'TODO_CA · No tienes que usar ninguno. Si te ayuda alguno, púlsalo y empieza desde ahí.';

  @override
  String get preguntaIdea1 => 'TODO_CA · ¿siempre … cuando …?';

  @override
  String get preguntaIdea2 => 'TODO_CA · ¿qué pasa cuando …?';

  @override
  String get preguntaIdea3 => 'TODO_CA · ¿se parece … a …?';

  @override
  String get preguntaIdea4 => 'TODO_CA · ¿cómo cambia … con el tiempo?';

  @override
  String get preguntaIdea5 => 'TODO_CA · ¿qué hace … cuando …?';

  @override
  String get preguntaPaginaTitulo => 'TODO_CA · Tu pregunta';

  @override
  String preguntaPaginaFormulada(String fecha) {
    return 'TODO_CA · Formulada el $fecha';
  }

  @override
  String get preguntaPaginaEvidenciaVacia =>
      'TODO_CA · Todavía no has anotado nada para tu pregunta. Vuelve al lugar y mira; cuando veas algo que tenga que ver, anótalo y ánclalo aquí.';

  @override
  String get preguntaPaginaCabeceraEvidencia =>
      'TODO_CA · Lo que ya has anotado';

  @override
  String get preguntaPaginaBorrar => 'TODO_CA · borrar esta pregunta';

  @override
  String get preguntaPaginaConfirmaBorrar =>
      'TODO_CA · Vas a borrar esta pregunta tuya. Las observaciones que tuvieras ancladas se conservan en el cuaderno. No se puede deshacer.';

  @override
  String get preguntaPaginaBotonEvidencia =>
      'TODO_CA · anotar evidencia para esta pregunta';

  @override
  String get preguntaPaginaBotonCerrar =>
      'TODO_CA · ya tengo mi respuesta sobre esta pregunta';

  @override
  String get preguntaCerrarTitulo => 'TODO_CA · Tu respuesta';

  @override
  String get preguntaCerrarIntro =>
      'TODO_CA · Cuenta con tus palabras lo que has aprendido. No hay respuesta correcta — esto no se corrige ni se nota; sólo se guarda en tu cuaderno.';

  @override
  String get preguntaCerrarPlaceholder => 'TODO_CA · tu respuesta';

  @override
  String get preguntaCerrarBoton => 'TODO_CA · Guardar mi respuesta';

  @override
  String get preguntaPaginaBloqueRespuesta => 'TODO_CA · Tu respuesta';

  @override
  String preguntaPaginaCerradaEl(String fecha) {
    return 'TODO_CA · Cerrada el $fecha';
  }

  @override
  String get preguntaPaginaReabrir => 'TODO_CA · reabrir esta pregunta';

  @override
  String get preguntaPaginaConfirmaReabrir =>
      'TODO_CA · Si la reabres, tu respuesta se borra y la pregunta vuelve a la lista de abiertas. Las anotaciones que ya tenías se conservan.';

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
  String get observacionCajaPlaceholder =>
      'TODO_CA · Si quieres, añade una foto o un dibujo.';

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
  String get observacionPlaceholderQueViste =>
      'descriu el que has vist, sense posar-li nom si no n\'estàs segura';

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
  String get confianzaConsensoTooltip =>
      'ho has confirmat amb una clau o amb el Tutor';

  @override
  String get confianzaNoSeguraTooltip => 'no passa res, anota-ho així';

  @override
  String get observacionAvisoFalta => 'fes una nota abans de desar';

  @override
  String get observacionBotonGuardar => 'Desar al quadern';

  @override
  String get tutorSaludoCanonico =>
      'Soc el Tutor del Quadern. Pregunta\'m el que necessitis.';

  @override
  String get tutorPlaceholderInput => 'escriu la teva pregunta';

  @override
  String get tutorBotonEnviar => 'Enviar';

  @override
  String get tutorRespuestaCanned =>
      'El Tutor encara no està connectat. Torna en unes setmanes.';

  @override
  String get tutorErrorRed =>
      'TODO_CA · Ahora mismo no llego al cuaderno. Espera un momento y vuelve a probar.';

  @override
  String get ajustesTitulo => 'Configuració';

  @override
  String get atlasTitulo => 'TODO_CA · Tu atlas';

  @override
  String get atlasSubtitulo =>
      'TODO_CA · no es un trofeo. es lo que has visto.';

  @override
  String get atlasSeccionPrimerasVeces => 'TODO_CA · Tus primeras veces';

  @override
  String get atlasSeccionLoQueHasVisto => 'TODO_CA · Lo que has visto';

  @override
  String get atlasConteoSingular => 'TODO_CA · 1 vez';

  @override
  String atlasConteoPlural(int conteo) {
    return 'TODO_CA · $conteo veces';
  }

  @override
  String get atlasVacioCabecera => 'TODO_CA · Tu atlas todavía está vacío.';

  @override
  String get atlasVacioCuerpo =>
      'TODO_CA · Cuando vayas anotando lo que crees que ves, esto se irá llenando solo. No hay prisa.';

  @override
  String get atlasEnlaceDesdeCuaderno => 'TODO_CA · ver tu atlas';

  @override
  String get seccionEcos => 'TODO_CA · Hace un tiempo, por aquí';

  @override
  String get ecoCabeceraUnMes => 'TODO_CA · hace un mes, por estas fechas…';

  @override
  String get ecoCabeceraSeisMeses =>
      'TODO_CA · hace seis meses, por estas fechas…';

  @override
  String get ecoCabeceraUnAno => 'TODO_CA · hace un año, por estas fechas…';

  @override
  String get paginaSitSpotResumenMesCabecera => 'TODO_CA · Este mes aquí';

  @override
  String paginaSitSpotResumenMesVisitas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODO_CA · Has venido $count veces este mes.',
      two: 'TODO_CA · Has venido dos veces este mes.',
      one: 'TODO_CA · Has venido una vez este mes.',
    );
    return '$_temp0';
  }

  @override
  String paginaSitSpotResumenMesPrimeraUltima(String primera, String ultima) {
    return 'TODO_CA · La primera fue el $primera. La última, el $ultima.';
  }

  @override
  String get lecturaTitulo => 'TODO_CA · Leer tus páginas';

  @override
  String get lecturaTooltip => 'TODO_CA · leer tus páginas';

  @override
  String lecturaPaginaIndicador(int pagina, int total) {
    return 'TODO_CA · $pagina de $total';
  }

  @override
  String get lecturaVacioCuerpo =>
      'TODO_CA · Aún no has anotado nada. Cuando lo hagas, podrás abrir tu cuaderno como un libro.';

  @override
  String get ajustesMapaOnlineEtiqueta => 'TODO_CA · Activar el mapa';

  @override
  String get ajustesMapaOnlineCuerpo =>
      'TODO_CA · Si lo activas, el dispositivo se conectará a internet para mostrar la zona del mundo donde estés. La pestaña \"mapa\" sólo funciona con esto encendido. Más adelante el mapa podrá descargarse una vez y dejará de salir a internet.';

  @override
  String get detalleCompartirFotoOpcion =>
      'TODO_CA · compartir foto a tu adulto';

  @override
  String get detalleCompartirFotoTextoAdjunto =>
      'TODO_CA · Mira lo que he visto en mi cuaderno. ¿Sabes qué es?';

  @override
  String get compararVisitasTitulo => 'TODO_CA · Comparar dos visitas';

  @override
  String get compararVisitasEnlace => 'TODO_CA · comparar dos visitas';

  @override
  String get compararVisitasIntro =>
      'TODO_CA · elige dos momentos. mira qué cambia.';

  @override
  String get compararVisitasColumnaIzquierda => 'TODO_CA · primer momento';

  @override
  String get compararVisitasColumnaDerecha => 'TODO_CA · segundo momento';

  @override
  String get compararVisitasInsuficientesCabecera =>
      'TODO_CA · Necesitas dos visitas para comparar.';

  @override
  String get compararVisitasInsuficientesCuerpo =>
      'TODO_CA · Cuando vuelvas a tu sit spot otro día y anotes algo, podrás comparar lo que viste antes con lo que ves ahora.';

  @override
  String get imprimirPlantillaBloque =>
      'TODO_CA · Imprimir páginas en blanco para el campo';

  @override
  String get imprimirPlantillaBloqueDescripcion =>
      'TODO_CA · Genera un PDF para llevar el cuaderno en papel a una salida. Sin pantallas, sin pilas.';

  @override
  String get imprimirPlantillaTitulo => 'TODO_CA · Páginas para el campo';

  @override
  String get imprimirPlantillaIntro =>
      'TODO_CA · A veces el campo se mira mejor sin pantalla. Aquí preparas tu cuaderno en papel para llevarlo en la mochila.';

  @override
  String get imprimirPlantillaContenido =>
      'TODO_CA · Cada página tiene espacio para la fecha, dónde estabas, qué viste, lo que crees que es y un recuadro grande para dibujar.';

  @override
  String get imprimirPlantillaSelectorCabecera => 'TODO_CA · Cuántas páginas';

  @override
  String imprimirPlantillaOpcionPaginas(int paginas) {
    return 'TODO_CA · $paginas páginas';
  }

  @override
  String get imprimirPlantillaBoton => 'TODO_CA · Imprimir o compartir';

  @override
  String get imprimirPlantillaNotaFinal =>
      'TODO_CA · Si no tienes impresora, también puedes guardar el PDF en el móvil y enseñárselo a quien sí la tenga.';

  @override
  String get detalleObservacionPrimeraVez =>
      'TODO_CA · primera vez que anotas algo así en el cuaderno.';

  @override
  String get acercaTitulo => 'TODO_CA · Cómo se usa este cuaderno';

  @override
  String get acercaBloque => 'TODO_CA · Cómo se usa este cuaderno';

  @override
  String get acercaBloqueDescripcion =>
      'TODO_CA · Qué es, cómo anotar, cómo acompañar. Para ti, para tu adulto y para tu maestra.';

  @override
  String ajustesIdiomaActual(String idioma) {
    return 'TODO_CA · Idioma del cuaderno: $idioma';
  }

  @override
  String get ajustesIdiomaCambiar => 'TODO_CA · Cambiar idioma';

  @override
  String get ajustesExportar => 'TODO_CA · Exportar mi cuaderno';

  @override
  String get ajustesExportarDescripcion =>
      'TODO_CA · Recibe una copia legible de tus observaciones y Misterios. El cuaderno es tuyo.';

  @override
  String get ajustesExportarPdf => 'TODO_CA · Exportar como PDF';

  @override
  String get ajustesExportarPdfDescripcion =>
      'TODO_CA · Una copia para imprimir o llevar a un papel. El sistema te preguntará dónde guardarla.';

  @override
  String get ajustesExportarDialogoTitulo => 'TODO_CA · Tu cuaderno como texto';

  @override
  String get ajustesExportarDialogoCerrar => 'TODO_CA · Cerrar';

  @override
  String get ajustesVistaCuidador => 'TODO_CA · Vista del cuidador';

  @override
  String get ajustesVistaCuidadorDescripcion =>
      'TODO_CA · Una página discreta para una persona adulta que te acompaña.';

  @override
  String get ajustesBorrar => 'TODO_CA · Borrar mi cuaderno';

  @override
  String get ajustesBorrarDescripcion =>
      'TODO_CA · Borrar todas tus observaciones, Misterios y sit spot. No se puede deshacer.';

  @override
  String get ajustesBorrarDialogoTitulo => 'TODO_CA · ¿Borrar todo?';

  @override
  String ajustesBorrarDialogoCuerpo(
      int observaciones, int misterios, int sitSpots) {
    return 'TODO_CA · Si continúas, se borrarán $observaciones observaciones, $misterios Misterios y $sitSpots sit spot. No se puede deshacer.';
  }

  @override
  String get ajustesBorrarDialogoSeguir => 'TODO_CA · Seguir';

  @override
  String get ajustesBorrarDialogoCancelar => 'TODO_CA · Cancelar';

  @override
  String get ajustesBorrarConfirmacionTitulo => 'TODO_CA · ¿Estás segura?';

  @override
  String get ajustesBorrarConfirmacionCuerpo =>
      'TODO_CA · Escribe «borrar» abajo para confirmar.';

  @override
  String get ajustesBorrarConfirmacionPalabra => 'TODO_CA · borrar';

  @override
  String get ajustesBorrarConfirmacionPlaceholder =>
      'TODO_CA · escribe la palabra';

  @override
  String get ajustesBorrarConfirmacionBoton => 'TODO_CA · Borrar todo';

  @override
  String get ajustesBorradoCompleto =>
      'TODO_CA · Listo. Tu cuaderno está vacío.';

  @override
  String get bienvenidaTitulo => 'Com et dius?';

  @override
  String get bienvenidaCuerpo =>
      'El teu nom es queda en aquest quadern. No surt al servidor tret que decideixis vincular-lo més endavant.';

  @override
  String get bienvenidaPlaceholderNombre => 'el teu nom';

  @override
  String get bienvenidaBotonContinuar => 'Continuar';

  @override
  String get ajustesSyncObsTitulo => 'TODO_CA · Sincronizar mis observaciones';

  @override
  String get ajustesSyncObsDescripcion =>
      'TODO_CA · Sube las observaciones nuevas a tu cuenta del servidor para no perderlas si cambias de dispositivo.';

  @override
  String get ajustesSyncObsBoton => 'TODO_CA · Subir ahora';

  @override
  String get ajustesSyncObsEnVuelo => 'TODO_CA · Subiendo…';

  @override
  String get ajustesSyncObsSinToken =>
      'TODO_CA · Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón subirá tus observaciones.';

  @override
  String get ajustesSyncObsNadaPendiente =>
      'TODO_CA · No hay observaciones pendientes — todo subido.';

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
  String get ajustesCuentaDescripcion =>
      'TODO_CA · Si tienes una cuenta de Nuevo Ser, puedes vincularla aquí. Sirve para subir tus observaciones, recibir el resumen escrito del cuidador y conectar el Tutor real.';

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
  String get ajustesCuentaSesionIniciadaSinEmail =>
      'TODO_CA · Sesión iniciada.';

  @override
  String get ajustesCuentaCerrarSesion => 'TODO_CA · Cerrar sesión';

  @override
  String get ajustesCuentaErrorCredenciales =>
      'TODO_CA · El correo o la contraseña no coinciden con ninguna cuenta.';

  @override
  String get ajustesCuentaErrorSinPerfil =>
      'TODO_CA · La cuenta del adulto no tiene ningún niño asociado todavía.';

  @override
  String get ajustesCuentaErrorRed =>
      'TODO_CA · No se ha podido conectar con el servidor. Inténtalo en un momento.';

  @override
  String get ajustesCuentaErrorVacio =>
      'TODO_CA · Escribe el correo y la contraseña antes de continuar.';

  @override
  String get ajustesTutorDebugTitulo => 'TODO_CA · Tutor (debug)';

  @override
  String get ajustesTutorDebugDescripcion =>
      'TODO_CA · Pega aquí un token del backend para activar el Tutor real. Visible sólo en debug.';

  @override
  String get ajustesTutorDebugPlaceholder => 'TODO_CA · JWT del backend';

  @override
  String get ajustesTutorDebugBotonGuardar => 'TODO_CA · Guardar token';

  @override
  String get ajustesTutorDebugBotonBorrar => 'TODO_CA · Borrar token';

  @override
  String get ajustesTutorDebugGuardado =>
      'TODO_CA · Token guardado. Vuelve al Tutor para probarlo.';

  @override
  String get ajustesTutorDebugBorrado =>
      'TODO_CA · Token borrado. El Tutor vuelve a la respuesta canónica.';

  @override
  String get cuidadorTitulo => 'TODO_CA · Página del cuidador';

  @override
  String get cuidadorAviso =>
      'TODO_CA · Esta es la única vista que comparte el juego con quien te acompaña. No verá tus observaciones ni lo que escribes — solo este resumen y una pregunta para hablar.';

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
  String get cuidadorSincronizarBoton =>
      'TODO_CA · Compartir resumen con el adulto';

  @override
  String get cuidadorSincronizarEnVuelo => 'TODO_CA · Pidiéndolo…';

  @override
  String get cuidadorSincronizarSinToken =>
      'TODO_CA · Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón pedirá un resumen escrito.';

  @override
  String get cuidadorSincronizarErrorRed =>
      'TODO_CA · Hoy no se ha podido conectar. Puedes volver a intentarlo más tarde.';

  @override
  String get cuidadorSincronizarSinResumen =>
      'TODO_CA · El servidor no ha podido generar un resumen esta vez. La pregunta de abajo sigue valiendo.';

  @override
  String get cuidadorResumenCabecera => 'TODO_CA · Esta semana, en una frase';
}
