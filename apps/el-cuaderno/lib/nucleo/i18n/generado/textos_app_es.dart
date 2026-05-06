// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'textos_app.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class TextosAppEs extends TextosApp {
  TextosAppEs([String locale = 'es']) : super(locale);

  @override
  String get tituloApp => 'El Cuaderno';

  @override
  String get subtituloBienvenida =>
      'Una herramienta para anotar lo que ves vivo cerca de ti.';

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
  String get sitSpotInvitacion =>
      'Cuando estés en algún sitio al aire libre que te guste — un parque, un árbol, una esquina — puedes hacerlo tu sit spot. Toca aquí cuando estés.';

  @override
  String sitSpotUltimaVisita(String cuando) {
    return 'Última visita: $cuando';
  }

  @override
  String get ultimaPaginaVacia =>
      'Aún no has anotado nada. Cuando lo hagas, aparecerá aquí.';

  @override
  String get misteriosVacio =>
      'Aún no tienes Misterios abiertos. El sistema te propondrá alguno pronto.';

  @override
  String get misteriosFueraDeContexto =>
      'Hoy no hay Misterios para tu lugar y esta estación. Vuelve a mirar al cambiar el tiempo.';

  @override
  String get navProximamente => 'Próximamente.';

  @override
  String get homeFabAnotar => 'anotar';

  @override
  String get homeFabAnotarTooltip => 'anotar lo que ves';

  @override
  String get homeOrientacionConMisterios =>
      'Estos son los Misterios que tu cuaderno tiene abiertos. Ábrelos para leerlos; cuando veas algo en tu sit spot que tenga que ver, anótalo.';

  @override
  String get seccionTusPreguntas => 'Tus preguntas';

  @override
  String get seccionMisteriosDelCuaderno => 'Misterios del cuaderno';

  @override
  String get tusPreguntasVacio =>
      'Aún no has formulado ninguna pregunta. Cuando se te ocurra una mientras observas tu lugar, anótala aquí.';

  @override
  String get preguntaFabFormular => 'formular pregunta';

  @override
  String get preguntaFormularTitulo => 'Tu pregunta';

  @override
  String get preguntaFormularIntro =>
      'Una pregunta tuya. La que llevas dándole vueltas, la que se te acaba de ocurrir, la que nadie te ha contado. Escríbela como te suene; no hace falta que esté bien hecha — sólo que sea la tuya.';

  @override
  String get preguntaFormularPlaceholder => '¿…?';

  @override
  String get preguntaFormularBotonGuardar => 'Guardar mi pregunta';

  @override
  String get preguntaFormularBotonIdeas => 'necesito ideas';

  @override
  String get preguntaIdeasTitulo => 'Si necesitas un punto de partida';

  @override
  String get preguntaIdeasIntro =>
      'No tienes que usar ninguno. Si te ayuda alguno, púlsalo y empieza desde ahí.';

  @override
  String get preguntaIdea1 => '¿siempre … cuando …?';

  @override
  String get preguntaIdea2 => '¿qué pasa cuando …?';

  @override
  String get preguntaIdea3 => '¿se parece … a …?';

  @override
  String get preguntaIdea4 => '¿cómo cambia … con el tiempo?';

  @override
  String get preguntaIdea5 => '¿qué hace … cuando …?';

  @override
  String get preguntaPaginaTitulo => 'Tu pregunta';

  @override
  String preguntaPaginaFormulada(String fecha) {
    return 'Formulada el $fecha';
  }

  @override
  String get preguntaPaginaEvidenciaVacia =>
      'Todavía no has anotado nada para tu pregunta. Vuelve al lugar y mira; cuando veas algo que tenga que ver, anótalo y ánclalo aquí.';

  @override
  String get preguntaPaginaCabeceraEvidencia => 'Lo que ya has anotado';

  @override
  String get preguntaPaginaBorrar => 'borrar esta pregunta';

  @override
  String get preguntaPaginaConfirmaBorrar =>
      'Vas a borrar esta pregunta tuya. Las observaciones que tuvieras ancladas se conservan en el cuaderno. No se puede deshacer.';

  @override
  String get preguntaPaginaBotonEvidencia =>
      'anotar evidencia para esta pregunta';

  @override
  String get preguntaPaginaBotonCerrar =>
      'ya tengo mi respuesta sobre esta pregunta';

  @override
  String get preguntaCerrarTitulo => 'Tu respuesta';

  @override
  String get preguntaCerrarIntro =>
      'Cuenta con tus palabras lo que has aprendido. No hay respuesta correcta — esto no se corrige ni se nota; sólo se guarda en tu cuaderno.';

  @override
  String get preguntaCerrarPlaceholder => 'tu respuesta';

  @override
  String get preguntaCerrarBoton => 'Guardar mi respuesta';

  @override
  String get preguntaPaginaBloqueRespuesta => 'Tu respuesta';

  @override
  String preguntaPaginaCerradaEl(String fecha) {
    return 'Cerrada el $fecha';
  }

  @override
  String get preguntaPaginaReabrir => 'reabrir esta pregunta';

  @override
  String get preguntaPaginaConfirmaReabrir =>
      'Si la reabres, tu respuesta se borra y la pregunta vuelve a la lista de abiertas. Las anotaciones que ya tenías se conservan.';

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
  String get observacionCajaPlaceholder =>
      'Si quieres, añade una foto o un dibujo.';

  @override
  String get observacionFotoTomar => 'tomar foto';

  @override
  String get observacionFotoElegir => 'elegir foto';

  @override
  String get observacionFotoQuitar => 'quitar foto';

  @override
  String get observacionDibujoComenzar => 'hacer dibujo';

  @override
  String get observacionDibujoQuitar => 'quitar dibujo';

  @override
  String get observacionEtiquetaQueViste => 'qué viste';

  @override
  String get observacionPlaceholderQueViste =>
      'describe lo que has visto, sin nombrarlo si no estás segura';

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
  String get confianzaConsensoTooltip =>
      'lo has confirmado con una clave o con el Tutor';

  @override
  String get confianzaNoSeguraTooltip => 'no pasa nada, anótalo así';

  @override
  String get observacionAvisoFalta => 'haz una nota antes de guardar';

  @override
  String get observacionBotonGuardar => 'Guardar en el cuaderno';

  @override
  String get tutorSaludoCanonico =>
      'Soy el Tutor del Cuaderno. Pregúntame lo que necesites.';

  @override
  String get tutorPlaceholderInput => 'escribe tu pregunta';

  @override
  String get tutorBotonEnviar => 'Enviar';

  @override
  String get tutorRespuestaCanned =>
      'El Tutor todavía no está conectado. Vuelve en unas semanas.';

  @override
  String get tutorErrorRed =>
      'Ahora mismo no llego al cuaderno. Espera un momento y vuelve a probar.';

  @override
  String get ajustesTitulo => 'Ajustes';

  @override
  String get atlasTitulo => 'Tu atlas';

  @override
  String get atlasSubtitulo => 'no es un trofeo. es lo que has visto.';

  @override
  String get atlasSeccionPrimerasVeces => 'Tus primeras veces';

  @override
  String get atlasSeccionLoQueHasVisto => 'Lo que has visto';

  @override
  String get atlasConteoSingular => '1 vez';

  @override
  String atlasConteoPlural(int conteo) {
    return '$conteo veces';
  }

  @override
  String get atlasVacioCabecera => 'Tu atlas todavía está vacío.';

  @override
  String get atlasVacioCuerpo =>
      'Cuando vayas anotando lo que crees que ves, esto se irá llenando solo. No hay prisa.';

  @override
  String get atlasEnlaceDesdeCuaderno => 'ver tu atlas';

  @override
  String get seccionEcos => 'Hace un tiempo, por aquí';

  @override
  String get ecoCabeceraUnMes => 'hace un mes, por estas fechas…';

  @override
  String get ecoCabeceraSeisMeses => 'hace seis meses, por estas fechas…';

  @override
  String get ecoCabeceraUnAno => 'hace un año, por estas fechas…';

  @override
  String get paginaSitSpotResumenMesCabecera => 'Este mes aquí';

  @override
  String paginaSitSpotResumenMesVisitas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Has venido $count veces este mes.',
      two: 'Has venido dos veces este mes.',
      one: 'Has venido una vez este mes.',
    );
    return '$_temp0';
  }

  @override
  String paginaSitSpotResumenMesPrimeraUltima(String primera, String ultima) {
    return 'La primera fue el $primera. La última, el $ultima.';
  }

  @override
  String get lecturaTitulo => 'Leer tus páginas';

  @override
  String get lecturaTooltip => 'leer tus páginas';

  @override
  String lecturaPaginaIndicador(int pagina, int total) {
    return '$pagina de $total';
  }

  @override
  String get lecturaVacioCuerpo =>
      'Aún no has anotado nada. Cuando lo hagas, podrás abrir tu cuaderno como un libro.';

  @override
  String get ajustesMapaOnlineEtiqueta => 'Activar el mapa';

  @override
  String get ajustesMapaOnlineCuerpo =>
      'Si lo activas, el dispositivo se conectará a internet para mostrar la zona del mundo donde estés. La pestaña \"mapa\" sólo funciona con esto encendido. Más adelante el mapa podrá descargarse una vez y dejará de salir a internet.';

  @override
  String get detalleCompartirFotoOpcion => 'compartir foto a tu adulto';

  @override
  String get detalleCompartirFotoTextoAdjunto =>
      'Mira lo que he visto en mi cuaderno. ¿Sabes qué es?';

  @override
  String get compararVisitasTitulo => 'Comparar dos visitas';

  @override
  String get compararVisitasEnlace => 'comparar dos visitas';

  @override
  String get compararVisitasIntro => 'elige dos momentos. mira qué cambia.';

  @override
  String get compararVisitasColumnaIzquierda => 'primer momento';

  @override
  String get compararVisitasColumnaDerecha => 'segundo momento';

  @override
  String get compararVisitasInsuficientesCabecera =>
      'Necesitas dos visitas para comparar.';

  @override
  String get compararVisitasInsuficientesCuerpo =>
      'Cuando vuelvas a tu sit spot otro día y anotes algo, podrás comparar lo que viste antes con lo que ves ahora.';

  @override
  String get imprimirPlantillaBloque =>
      'Imprimir páginas en blanco para el campo';

  @override
  String get imprimirPlantillaBloqueDescripcion =>
      'Genera un PDF para llevar el cuaderno en papel a una salida. Sin pantallas, sin pilas.';

  @override
  String get imprimirPlantillaTitulo => 'Páginas para el campo';

  @override
  String get imprimirPlantillaIntro =>
      'A veces el campo se mira mejor sin pantalla. Aquí preparas tu cuaderno en papel para llevarlo en la mochila.';

  @override
  String get imprimirPlantillaContenido =>
      'Cada página tiene espacio para la fecha, dónde estabas, qué viste, lo que crees que es y un recuadro grande para dibujar.';

  @override
  String get imprimirPlantillaSelectorCabecera => 'Cuántas páginas';

  @override
  String imprimirPlantillaOpcionPaginas(int paginas) {
    return '$paginas páginas';
  }

  @override
  String get imprimirPlantillaBoton => 'Imprimir o compartir';

  @override
  String get imprimirPlantillaNotaFinal =>
      'Si no tienes impresora, también puedes guardar el PDF en el móvil y enseñárselo a quien sí la tenga.';

  @override
  String get detalleObservacionPrimeraVez =>
      'primera vez que anotas algo así en el cuaderno.';

  @override
  String get acercaTitulo => 'Cómo se usa este cuaderno';

  @override
  String get acercaBloque => 'Cómo se usa este cuaderno';

  @override
  String get acercaBloqueDescripcion =>
      'Qué es, cómo anotar, cómo acompañar. Para ti, para tu adulto y para tu maestra.';

  @override
  String ajustesIdiomaActual(String idioma) {
    return 'Idioma del cuaderno: $idioma';
  }

  @override
  String get ajustesIdiomaCambiar => 'Cambiar idioma';

  @override
  String get ajustesExportar => 'Exportar mi cuaderno';

  @override
  String get ajustesExportarDescripcion =>
      'Recibe una copia legible de tus observaciones y Misterios. El cuaderno es tuyo.';

  @override
  String get ajustesExportarPdf => 'Exportar como PDF';

  @override
  String get ajustesExportarPdfDescripcion =>
      'Una copia para imprimir o llevar a un papel. El sistema te preguntará dónde guardarla.';

  @override
  String get ajustesExportarDialogoTitulo => 'Tu cuaderno como texto';

  @override
  String get ajustesExportarDialogoCerrar => 'Cerrar';

  @override
  String get ajustesVistaCuidador => 'Vista del cuidador';

  @override
  String get ajustesVistaCuidadorDescripcion =>
      'Una página discreta para una persona adulta que te acompaña.';

  @override
  String get ajustesBorrar => 'Borrar mi cuaderno';

  @override
  String get ajustesBorrarDescripcion =>
      'Borrar todas tus observaciones, Misterios y sit spot. No se puede deshacer.';

  @override
  String get ajustesBorrarDialogoTitulo => '¿Borrar todo?';

  @override
  String ajustesBorrarDialogoCuerpo(
      int observaciones, int misterios, int sitSpots) {
    return 'Si continúas, se borrarán $observaciones observaciones, $misterios Misterios y $sitSpots sit spot. No se puede deshacer.';
  }

  @override
  String get ajustesBorrarDialogoSeguir => 'Seguir';

  @override
  String get ajustesBorrarDialogoCancelar => 'Cancelar';

  @override
  String get ajustesBorrarConfirmacionTitulo => '¿Estás segura?';

  @override
  String get ajustesBorrarConfirmacionCuerpo =>
      'Escribe «borrar» abajo para confirmar.';

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
  String get bienvenidaCuerpo =>
      'Tu nombre se queda en este cuaderno. No sale al servidor a menos que tú decidas vincularlo más tarde.';

  @override
  String get bienvenidaPlaceholderNombre => 'tu nombre';

  @override
  String get bienvenidaBotonContinuar => 'Continuar';

  @override
  String get ajustesSyncObsTitulo => 'Sincronizar mis observaciones';

  @override
  String get ajustesSyncObsDescripcion =>
      'Sube las observaciones nuevas a tu cuenta del servidor para no perderlas si cambias de dispositivo.';

  @override
  String get ajustesSyncObsBoton => 'Subir ahora';

  @override
  String get ajustesSyncObsEnVuelo => 'Subiendo…';

  @override
  String get ajustesSyncObsSinToken =>
      'Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón subirá tus observaciones.';

  @override
  String get ajustesSyncObsNadaPendiente =>
      'No hay observaciones pendientes — todo subido.';

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
  String get ajustesCuentaTitulo => 'Cuenta del adulto';

  @override
  String get ajustesCuentaDescripcion =>
      'Si tienes una cuenta de Nuevo Ser, puedes vincularla aquí. Sirve para subir tus observaciones, recibir el resumen escrito del cuidador y conectar el Tutor real.';

  @override
  String get ajustesCuentaPlaceholderEmail => 'correo del adulto';

  @override
  String get ajustesCuentaPlaceholderPassword => 'contraseña';

  @override
  String get ajustesCuentaBotonEntrar => 'Iniciar sesión';

  @override
  String get ajustesCuentaEntrando => 'Entrando…';

  @override
  String ajustesCuentaSesionIniciada(String email) {
    return 'Sesión iniciada como $email.';
  }

  @override
  String get ajustesCuentaSesionIniciadaSinEmail => 'Sesión iniciada.';

  @override
  String get ajustesCuentaCerrarSesion => 'Cerrar sesión';

  @override
  String get ajustesCuentaErrorCredenciales =>
      'El correo o la contraseña no coinciden con ninguna cuenta.';

  @override
  String get ajustesCuentaErrorSinPerfil =>
      'La cuenta del adulto no tiene ningún niño asociado todavía.';

  @override
  String get ajustesCuentaErrorRed =>
      'No se ha podido conectar con el servidor. Inténtalo en un momento.';

  @override
  String get ajustesCuentaErrorVacio =>
      'Escribe el correo y la contraseña antes de continuar.';

  @override
  String get ajustesTutorDebugTitulo => 'Tutor (debug)';

  @override
  String get ajustesTutorDebugDescripcion =>
      'Pega aquí un token del backend para activar el Tutor real. Visible sólo en debug.';

  @override
  String get ajustesTutorDebugPlaceholder => 'JWT del backend';

  @override
  String get ajustesTutorDebugBotonGuardar => 'Guardar token';

  @override
  String get ajustesTutorDebugBotonBorrar => 'Borrar token';

  @override
  String get ajustesTutorDebugGuardado =>
      'Token guardado. Vuelve al Tutor para probarlo.';

  @override
  String get ajustesTutorDebugBorrado =>
      'Token borrado. El Tutor vuelve a la respuesta canónica.';

  @override
  String get cuidadorTitulo => 'Página del cuidador';

  @override
  String get cuidadorAviso =>
      'Esta es la única vista que comparte el juego con quien te acompaña. No verá tus observaciones ni lo que escribes — solo este resumen y una pregunta para hablar.';

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
  String get cuidadorSincronizarSinToken =>
      'Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón pedirá un resumen escrito.';

  @override
  String get cuidadorSincronizarErrorRed =>
      'Hoy no se ha podido conectar. Puedes volver a intentarlo más tarde.';

  @override
  String get cuidadorSincronizarSinResumen =>
      'El servidor no ha podido generar un resumen esta vez. La pregunta de abajo sigue valiendo.';

  @override
  String get cuidadorResumenCabecera => 'Esta semana, en una frase';
}
