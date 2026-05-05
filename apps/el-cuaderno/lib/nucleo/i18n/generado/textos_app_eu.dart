// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'textos_app.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class TextosAppEu extends TextosApp {
  TextosAppEu([String locale = 'eu']) : super(locale);

  @override
  String get tituloApp => 'Koadernoa';

  @override
  String get subtituloBienvenida =>
      'Zure inguruan ikusten duzun bizia idazteko tresna.';

  @override
  String get saludoSinNombre => 'Kaixo.';

  @override
  String saludoConNombre(String nombre) {
    return 'Kaixo, $nombre.';
  }

  @override
  String get navCuaderno => 'koadernoa';

  @override
  String get navMapa => 'mapa';

  @override
  String get navMisterios => 'misterioak';

  @override
  String get navTutor => 'tutorea';

  @override
  String get seccionSitSpot => 'Zure sit spot-a';

  @override
  String get seccionMisteriosAbiertos => 'Misterio irekiak';

  @override
  String get seccionUltimaPagina => 'Azken orria';

  @override
  String get sitSpotInvitacion =>
      'TODO_EU · Cuando estés en algún sitio al aire libre que te guste — un parque, un árbol, una esquina — puedes hacerlo tu sit spot. Toca aquí cuando estés.';

  @override
  String sitSpotUltimaVisita(String cuando) {
    return 'TODO_EU · Última visita: $cuando';
  }

  @override
  String get ultimaPaginaVacia =>
      'TODO_EU · Aún no has anotado nada. Cuando lo hagas, aparecerá aquí.';

  @override
  String get misteriosVacio =>
      'TODO_EU · Aún no tienes Misterios abiertos. El sistema te propondrá alguno pronto.';

  @override
  String get misteriosFueraDeContexto =>
      'TODO_EU · Hoy no hay Misterios para tu lugar y esta estación. Vuelve a mirar al cambiar el tiempo.';

  @override
  String get navProximamente => 'Laster etorriko da.';

  @override
  String get homeFabAnotar => 'TODO_EU · anotar';

  @override
  String get homeFabAnotarTooltip => 'TODO_EU · anotar lo que ves';

  @override
  String get homeOrientacionConMisterios =>
      'TODO_EU · Estos son los Misterios que tu cuaderno tiene abiertos. Ábrelos para leerlos; cuando veas algo en tu sit spot que tenga que ver, anótalo.';

  @override
  String get seccionTusPreguntas => 'TODO_EU · Tus preguntas';

  @override
  String get seccionMisteriosDelCuaderno => 'TODO_EU · Misterios del cuaderno';

  @override
  String get tusPreguntasVacio =>
      'TODO_EU · Aún no has formulado ninguna pregunta. Cuando se te ocurra una mientras observas tu lugar, anótala aquí.';

  @override
  String get preguntaFabFormular => 'TODO_EU · formular pregunta';

  @override
  String get preguntaFormularTitulo => 'TODO_EU · Tu pregunta';

  @override
  String get preguntaFormularIntro =>
      'TODO_EU · Una pregunta tuya. La que llevas dándole vueltas, la que se te acaba de ocurrir, la que nadie te ha contado. Escríbela como te suene; no hace falta que esté bien hecha — sólo que sea la tuya.';

  @override
  String get preguntaFormularPlaceholder => '¿…?';

  @override
  String get preguntaFormularBotonGuardar => 'TODO_EU · Guardar mi pregunta';

  @override
  String get preguntaFormularBotonIdeas => 'TODO_EU · necesito ideas';

  @override
  String get preguntaIdeasTitulo =>
      'TODO_EU · Si necesitas un punto de partida';

  @override
  String get preguntaIdeasIntro =>
      'TODO_EU · No tienes que usar ninguno. Si te ayuda alguno, púlsalo y empieza desde ahí.';

  @override
  String get preguntaIdea1 => 'TODO_EU · ¿siempre … cuando …?';

  @override
  String get preguntaIdea2 => 'TODO_EU · ¿qué pasa cuando …?';

  @override
  String get preguntaIdea3 => 'TODO_EU · ¿se parece … a …?';

  @override
  String get preguntaIdea4 => 'TODO_EU · ¿cómo cambia … con el tiempo?';

  @override
  String get preguntaIdea5 => 'TODO_EU · ¿qué hace … cuando …?';

  @override
  String get preguntaPaginaTitulo => 'TODO_EU · Tu pregunta';

  @override
  String preguntaPaginaFormulada(String fecha) {
    return 'TODO_EU · Formulada el $fecha';
  }

  @override
  String get preguntaPaginaEvidenciaVacia =>
      'TODO_EU · Todavía no has anotado nada para tu pregunta. Vuelve al lugar y mira; cuando veas algo que tenga que ver, anótalo y ánclalo aquí.';

  @override
  String get preguntaPaginaCabeceraEvidencia =>
      'TODO_EU · Lo que ya has anotado';

  @override
  String get preguntaPaginaBorrar => 'TODO_EU · borrar esta pregunta';

  @override
  String get preguntaPaginaConfirmaBorrar =>
      'TODO_EU · Vas a borrar esta pregunta tuya. Las observaciones que tuvieras ancladas se conservan en el cuaderno. No se puede deshacer.';

  @override
  String get preguntaPaginaBotonEvidencia =>
      'TODO_EU · anotar evidencia para esta pregunta';

  @override
  String get preguntaPaginaBotonCerrar =>
      'TODO_EU · ya tengo mi respuesta sobre esta pregunta';

  @override
  String get preguntaCerrarTitulo => 'TODO_EU · Tu respuesta';

  @override
  String get preguntaCerrarIntro =>
      'TODO_EU · Cuenta con tus palabras lo que has aprendido. No hay respuesta correcta — esto no se corrige ni se nota; sólo se guarda en tu cuaderno.';

  @override
  String get preguntaCerrarPlaceholder => 'TODO_EU · tu respuesta';

  @override
  String get preguntaCerrarBoton => 'TODO_EU · Guardar mi respuesta';

  @override
  String get preguntaPaginaBloqueRespuesta => 'TODO_EU · Tu respuesta';

  @override
  String preguntaPaginaCerradaEl(String fecha) {
    return 'TODO_EU · Cerrada el $fecha';
  }

  @override
  String get preguntaPaginaReabrir => 'TODO_EU · reabrir esta pregunta';

  @override
  String get preguntaPaginaConfirmaReabrir =>
      'TODO_EU · Si la reabres, tu respuesta se borra y la pregunta vuelve a la lista de abiertas. Las anotaciones que ya tenías se conservan.';

  @override
  String get observacionTitulo => 'behaketa berria';

  @override
  String observacionCabecera(String hora) {
    return 'TODO_EU · Hoy · $hora';
  }

  @override
  String get observacionCajaFoto => 'TODO_EU · foto';

  @override
  String get observacionCajaDibujo => 'TODO_EU · dibujo';

  @override
  String get observacionCajaPlaceholder =>
      'TODO_EU · Si quieres, añade una foto o un dibujo.';

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
  String get observacionEtiquetaQueViste => 'zer ikusi duzu';

  @override
  String get observacionPlaceholderQueViste =>
      'deskribatu ikusi duzuna, izenik gabe ziur ez bazaude';

  @override
  String get observacionEtiquetaCreesQueEs => 'zer dela uste duzu';

  @override
  String get observacionPlaceholderCreesQueEs =>
      'nahi baduzu, izen bat proposatu';

  @override
  String get confianzaConsenso => 'adostasuna';

  @override
  String get confianzaHipotesisActiva => 'hipotesi aktiboa';

  @override
  String get confianzaNoSegura => 'ez nago ziur';

  @override
  String get confianzaConsensoTooltip =>
      'gida batekin edo Tutorearekin egiaztatu duzu';

  @override
  String get confianzaNoSeguraTooltip =>
      'ez da ezer gertatzen, idatz ezazu horrela';

  @override
  String get observacionAvisoFalta => 'egin ohar bat gorde aurretik';

  @override
  String get observacionBotonGuardar => 'Koadernoan gorde';

  @override
  String get tutorSaludoCanonico =>
      'Koadernoaren Tutorea naiz. Galdetu behar duzuna.';

  @override
  String get tutorPlaceholderInput => 'idatzi zure galdera';

  @override
  String get tutorBotonEnviar => 'Bidali';

  @override
  String get tutorRespuestaCanned =>
      'Tutorea oraindik ez dago konektatuta. Itzuli aste batzuetan.';

  @override
  String get tutorErrorRed =>
      'TODO_EU · Ahora mismo no llego al cuaderno. Espera un momento y vuelve a probar.';

  @override
  String get ajustesTitulo => 'Ezarpenak';

  @override
  String get atlasTitulo => 'TODO_EU · Tu atlas';

  @override
  String get atlasSubtitulo =>
      'TODO_EU · no es un trofeo. es lo que has visto.';

  @override
  String get atlasSeccionPrimerasVeces => 'TODO_EU · Tus primeras veces';

  @override
  String get atlasSeccionLoQueHasVisto => 'TODO_EU · Lo que has visto';

  @override
  String get atlasConteoSingular => 'TODO_EU · 1 vez';

  @override
  String atlasConteoPlural(int conteo) {
    return 'TODO_EU · $conteo veces';
  }

  @override
  String get atlasVacioCabecera => 'TODO_EU · Tu atlas todavía está vacío.';

  @override
  String get atlasVacioCuerpo =>
      'TODO_EU · Cuando vayas anotando lo que crees que ves, esto se irá llenando solo. No hay prisa.';

  @override
  String get atlasEnlaceDesdeCuaderno => 'TODO_EU · ver tu atlas';

  @override
  String get seccionEcos => 'TODO_EU · Hace un tiempo, por aquí';

  @override
  String get ecoCabeceraUnMes => 'TODO_EU · hace un mes, por estas fechas…';

  @override
  String get ecoCabeceraSeisMeses =>
      'TODO_EU · hace seis meses, por estas fechas…';

  @override
  String get ecoCabeceraUnAno => 'TODO_EU · hace un año, por estas fechas…';

  @override
  String get paginaSitSpotResumenMesCabecera => 'TODO_EU · Este mes aquí';

  @override
  String paginaSitSpotResumenMesVisitas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TODO_EU · Has venido $count veces este mes.',
      two: 'TODO_EU · Has venido dos veces este mes.',
      one: 'TODO_EU · Has venido una vez este mes.',
    );
    return '$_temp0';
  }

  @override
  String paginaSitSpotResumenMesPrimeraUltima(String primera, String ultima) {
    return 'TODO_EU · La primera fue el $primera. La última, el $ultima.';
  }

  @override
  String get lecturaTitulo => 'TODO_EU · Leer tus páginas';

  @override
  String get lecturaTooltip => 'TODO_EU · leer tus páginas';

  @override
  String lecturaPaginaIndicador(int pagina, int total) {
    return 'TODO_EU · $pagina de $total';
  }

  @override
  String get lecturaVacioCuerpo =>
      'TODO_EU · Aún no has anotado nada. Cuando lo hagas, podrás abrir tu cuaderno como un libro.';

  @override
  String get ajustesMapaOnlineEtiqueta => 'TODO_EU · Activar el mapa';

  @override
  String get ajustesMapaOnlineCuerpo =>
      'TODO_EU · Si lo activas, el dispositivo se conectará a internet para mostrar la zona del mundo donde estés. La pestaña \"mapa\" sólo funciona con esto encendido. Más adelante el mapa podrá descargarse una vez y dejará de salir a internet.';

  @override
  String get compararVisitasTitulo => 'TODO_EU · Comparar dos visitas';

  @override
  String get compararVisitasEnlace => 'TODO_EU · comparar dos visitas';

  @override
  String get compararVisitasIntro =>
      'TODO_EU · elige dos momentos. mira qué cambia.';

  @override
  String get compararVisitasColumnaIzquierda => 'TODO_EU · primer momento';

  @override
  String get compararVisitasColumnaDerecha => 'TODO_EU · segundo momento';

  @override
  String get compararVisitasInsuficientesCabecera =>
      'TODO_EU · Necesitas dos visitas para comparar.';

  @override
  String get compararVisitasInsuficientesCuerpo =>
      'TODO_EU · Cuando vuelvas a tu sit spot otro día y anotes algo, podrás comparar lo que viste antes con lo que ves ahora.';

  @override
  String get imprimirPlantillaBloque =>
      'TODO_EU · Imprimir páginas en blanco para el campo';

  @override
  String get imprimirPlantillaBloqueDescripcion =>
      'TODO_EU · Genera un PDF para llevar el cuaderno en papel a una salida. Sin pantallas, sin pilas.';

  @override
  String get imprimirPlantillaTitulo => 'TODO_EU · Páginas para el campo';

  @override
  String get imprimirPlantillaIntro =>
      'TODO_EU · A veces el campo se mira mejor sin pantalla. Aquí preparas tu cuaderno en papel para llevarlo en la mochila.';

  @override
  String get imprimirPlantillaContenido =>
      'TODO_EU · Cada página tiene espacio para la fecha, dónde estabas, qué viste, lo que crees que es y un recuadro grande para dibujar.';

  @override
  String get imprimirPlantillaSelectorCabecera => 'TODO_EU · Cuántas páginas';

  @override
  String imprimirPlantillaOpcionPaginas(int paginas) {
    return 'TODO_EU · $paginas páginas';
  }

  @override
  String get imprimirPlantillaBoton => 'TODO_EU · Imprimir o compartir';

  @override
  String get imprimirPlantillaNotaFinal =>
      'TODO_EU · Si no tienes impresora, también puedes guardar el PDF en el móvil y enseñárselo a quien sí la tenga.';

  @override
  String get detalleObservacionPrimeraVez =>
      'TODO_EU · primera vez que anotas algo así en el cuaderno.';

  @override
  String get acercaTitulo => 'TODO_EU · Cómo se usa este cuaderno';

  @override
  String get acercaBloque => 'TODO_EU · Cómo se usa este cuaderno';

  @override
  String get acercaBloqueDescripcion =>
      'TODO_EU · Qué es, cómo anotar, cómo acompañar. Para ti, para tu adulto y para tu maestra.';

  @override
  String ajustesIdiomaActual(String idioma) {
    return 'TODO_EU · Idioma del cuaderno: $idioma';
  }

  @override
  String get ajustesIdiomaCambiar => 'TODO_EU · Cambiar idioma';

  @override
  String get ajustesExportar => 'TODO_EU · Exportar mi cuaderno';

  @override
  String get ajustesExportarDescripcion =>
      'TODO_EU · Recibe una copia legible de tus observaciones y Misterios. El cuaderno es tuyo.';

  @override
  String get ajustesExportarPdf => 'TODO_EU · Exportar como PDF';

  @override
  String get ajustesExportarPdfDescripcion =>
      'TODO_EU · Una copia para imprimir o llevar a un papel. El sistema te preguntará dónde guardarla.';

  @override
  String get ajustesExportarDialogoTitulo => 'TODO_EU · Tu cuaderno como texto';

  @override
  String get ajustesExportarDialogoCerrar => 'TODO_EU · Cerrar';

  @override
  String get ajustesVistaCuidador => 'TODO_EU · Vista del cuidador';

  @override
  String get ajustesVistaCuidadorDescripcion =>
      'TODO_EU · Una página discreta para una persona adulta que te acompaña.';

  @override
  String get ajustesBorrar => 'TODO_EU · Borrar mi cuaderno';

  @override
  String get ajustesBorrarDescripcion =>
      'TODO_EU · Borrar todas tus observaciones, Misterios y sit spot. No se puede deshacer.';

  @override
  String get ajustesBorrarDialogoTitulo => 'TODO_EU · ¿Borrar todo?';

  @override
  String ajustesBorrarDialogoCuerpo(
      int observaciones, int misterios, int sitSpots) {
    return 'TODO_EU · Si continúas, se borrarán $observaciones observaciones, $misterios Misterios y $sitSpots sit spot. No se puede deshacer.';
  }

  @override
  String get ajustesBorrarDialogoSeguir => 'TODO_EU · Seguir';

  @override
  String get ajustesBorrarDialogoCancelar => 'TODO_EU · Cancelar';

  @override
  String get ajustesBorrarConfirmacionTitulo => 'TODO_EU · ¿Estás segura?';

  @override
  String get ajustesBorrarConfirmacionCuerpo =>
      'TODO_EU · Escribe «borrar» abajo para confirmar.';

  @override
  String get ajustesBorrarConfirmacionPalabra => 'TODO_EU · borrar';

  @override
  String get ajustesBorrarConfirmacionPlaceholder =>
      'TODO_EU · escribe la palabra';

  @override
  String get ajustesBorrarConfirmacionBoton => 'TODO_EU · Borrar todo';

  @override
  String get ajustesBorradoCompleto =>
      'TODO_EU · Listo. Tu cuaderno está vacío.';

  @override
  String get bienvenidaTitulo => 'Nola duzu izena?';

  @override
  String get bienvenidaCuerpo =>
      'Zure izena koaderno honetan geratzen da. Ez da zerbitzarira joaten zuk gero lotzea erabakitzen ez baduzu.';

  @override
  String get bienvenidaPlaceholderNombre => 'zure izena';

  @override
  String get bienvenidaBotonContinuar => 'Jarraitu';

  @override
  String get ajustesSyncObsTitulo => 'TODO_EU · Sincronizar mis observaciones';

  @override
  String get ajustesSyncObsDescripcion =>
      'TODO_EU · Sube las observaciones nuevas a tu cuenta del servidor para no perderlas si cambias de dispositivo.';

  @override
  String get ajustesSyncObsBoton => 'TODO_EU · Subir ahora';

  @override
  String get ajustesSyncObsEnVuelo => 'TODO_EU · Subiendo…';

  @override
  String get ajustesSyncObsSinToken =>
      'TODO_EU · Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón subirá tus observaciones.';

  @override
  String get ajustesSyncObsNadaPendiente =>
      'TODO_EU · No hay observaciones pendientes — todo subido.';

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
  String get ajustesCuentaDescripcion =>
      'TODO_EU · Si tienes una cuenta de Nuevo Ser, puedes vincularla aquí. Sirve para subir tus observaciones, recibir el resumen escrito del cuidador y conectar el Tutor real.';

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
  String get ajustesCuentaSesionIniciadaSinEmail =>
      'TODO_EU · Sesión iniciada.';

  @override
  String get ajustesCuentaCerrarSesion => 'TODO_EU · Cerrar sesión';

  @override
  String get ajustesCuentaErrorCredenciales =>
      'TODO_EU · El correo o la contraseña no coinciden con ninguna cuenta.';

  @override
  String get ajustesCuentaErrorSinPerfil =>
      'TODO_EU · La cuenta del adulto no tiene ningún niño asociado todavía.';

  @override
  String get ajustesCuentaErrorRed =>
      'TODO_EU · No se ha podido conectar con el servidor. Inténtalo en un momento.';

  @override
  String get ajustesCuentaErrorVacio =>
      'TODO_EU · Escribe el correo y la contraseña antes de continuar.';

  @override
  String get ajustesTutorDebugTitulo => 'TODO_EU · Tutor (debug)';

  @override
  String get ajustesTutorDebugDescripcion =>
      'TODO_EU · Pega aquí un token del backend para activar el Tutor real. Visible sólo en debug.';

  @override
  String get ajustesTutorDebugPlaceholder => 'TODO_EU · JWT del backend';

  @override
  String get ajustesTutorDebugBotonGuardar => 'TODO_EU · Guardar token';

  @override
  String get ajustesTutorDebugBotonBorrar => 'TODO_EU · Borrar token';

  @override
  String get ajustesTutorDebugGuardado =>
      'TODO_EU · Token guardado. Vuelve al Tutor para probarlo.';

  @override
  String get ajustesTutorDebugBorrado =>
      'TODO_EU · Token borrado. El Tutor vuelve a la respuesta canónica.';

  @override
  String get cuidadorTitulo => 'TODO_EU · Página del cuidador';

  @override
  String get cuidadorAviso =>
      'TODO_EU · Esta es la única vista que comparte el juego con quien te acompaña. No verá tus observaciones ni lo que escribes — solo este resumen y una pregunta para hablar.';

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
  String get cuidadorSincronizarBoton =>
      'TODO_EU · Compartir resumen con el adulto';

  @override
  String get cuidadorSincronizarEnVuelo => 'TODO_EU · Pidiéndolo…';

  @override
  String get cuidadorSincronizarSinToken =>
      'TODO_EU · Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón pedirá un resumen escrito.';

  @override
  String get cuidadorSincronizarErrorRed =>
      'TODO_EU · Hoy no se ha podido conectar. Puedes volver a intentarlo más tarde.';

  @override
  String get cuidadorSincronizarSinResumen =>
      'TODO_EU · El servidor no ha podido generar un resumen esta vez. La pregunta de abajo sigue valiendo.';

  @override
  String get cuidadorResumenCabecera => 'TODO_EU · Esta semana, en una frase';
}
