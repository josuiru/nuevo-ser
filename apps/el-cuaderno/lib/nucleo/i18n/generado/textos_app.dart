import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'textos_app_ca.dart';
import 'textos_app_es.dart';
import 'textos_app_eu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of TextosApp
/// returned by `TextosApp.of(context)`.
///
/// Applications need to include `TextosApp.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generado/textos_app.dart';
///
/// return MaterialApp(
///   localizationsDelegates: TextosApp.localizationsDelegates,
///   supportedLocales: TextosApp.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the TextosApp.supportedLocales
/// property.
abstract class TextosApp {
  TextosApp(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static TextosApp of(BuildContext context) {
    return Localizations.of<TextosApp>(context, TextosApp)!;
  }

  static const LocalizationsDelegate<TextosApp> delegate = _TextosAppDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('es'),
    Locale('eu')
  ];

  /// Nombre del juego (provisional, biblia §10.1).
  ///
  /// In es, this message translates to:
  /// **'El Cuaderno'**
  String get tituloApp;

  /// Bajada de la pantalla de bienvenida (doc 13 §1.1). En S1 no se muestra todavía — se introducirá en el flujo de onboarding del Sprint 2.
  ///
  /// In es, this message translates to:
  /// **'Una herramienta para anotar lo que ves vivo cerca de ti.'**
  String get subtituloBienvenida;

  /// Saludo del cuaderno cuando el niño aún no ha puesto nombre.
  ///
  /// In es, this message translates to:
  /// **'Hola.'**
  String get saludoSinNombre;

  /// Saludo del cuaderno con el nombre del niño.
  ///
  /// In es, this message translates to:
  /// **'Hola, {nombre}.'**
  String saludoConNombre(String nombre);

  /// Pestaña 1 del bottom nav (sentence case sin mayúscula inicial — el botón es del oficio, no un título).
  ///
  /// In es, this message translates to:
  /// **'cuaderno'**
  String get navCuaderno;

  /// No description provided for @navMapa.
  ///
  /// In es, this message translates to:
  /// **'mapa'**
  String get navMapa;

  /// No description provided for @navMisterios.
  ///
  /// In es, this message translates to:
  /// **'misterios'**
  String get navMisterios;

  /// No description provided for @navTutor.
  ///
  /// In es, this message translates to:
  /// **'tutor'**
  String get navTutor;

  /// Cabecera de la sección que aloja la tarjeta del sit spot.
  ///
  /// In es, this message translates to:
  /// **'Tu sit spot'**
  String get seccionSitSpot;

  /// Cabecera de la sección de Misterios abiertos del niño.
  ///
  /// In es, this message translates to:
  /// **'Misterios abiertos'**
  String get seccionMisteriosAbiertos;

  /// Cabecera de la sección que muestra la observación más reciente.
  ///
  /// In es, this message translates to:
  /// **'Última página'**
  String get seccionUltimaPagina;

  /// Invitación discreta a configurar sit spot, sin urgencia (doc 13 §2.1).
  ///
  /// In es, this message translates to:
  /// **'Cuando estés en algún sitio al aire libre que te guste — un parque, un árbol, una esquina — puedes hacerlo tu sit spot. Toca aquí cuando estés.'**
  String get sitSpotInvitacion;

  /// Línea que muestra cuándo fue la última vez que el niño visitó el sit spot.
  ///
  /// In es, this message translates to:
  /// **'Última visita: {cuando}'**
  String sitSpotUltimaVisita(String cuando);

  /// Estado vacío de la sección 'última página' (doc 13 §11.10).
  ///
  /// In es, this message translates to:
  /// **'Aún no has anotado nada. Cuando lo hagas, aparecerá aquí.'**
  String get ultimaPaginaVacia;

  /// Estado vacío de la sección de Misterios.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes Misterios abiertos. El sistema te propondrá alguno pronto.'**
  String get misteriosVacio;

  /// Placeholder de las pestañas Mapa y Misterios en S1 — el bottom nav está, pero solo Cuaderno y Tutor llevan a algo.
  ///
  /// In es, this message translates to:
  /// **'Próximamente.'**
  String get navProximamente;

  /// Título de la pantalla de Nueva Observación.
  ///
  /// In es, this message translates to:
  /// **'nueva observación'**
  String get observacionTitulo;

  /// Cabecera fija con metadatos automáticos (doc 13 §3.2). En S1 solo hora — clima y lugar entrarán en sprints posteriores con la geolocalización.
  ///
  /// In es, this message translates to:
  /// **'Hoy · {hora}'**
  String observacionCabecera(String hora);

  /// No description provided for @observacionCajaFoto.
  ///
  /// In es, this message translates to:
  /// **'foto'**
  String get observacionCajaFoto;

  /// No description provided for @observacionCajaDibujo.
  ///
  /// In es, this message translates to:
  /// **'dibujo'**
  String get observacionCajaDibujo;

  /// Microcopia honesta para el placeholder gris de foto/dibujo en S1 — la cámara y el canvas táctil no están operativos todavía.
  ///
  /// In es, this message translates to:
  /// **'Cuando llegue Sprint 5, aquí podrás añadir foto o dibujo.'**
  String get observacionCajaPlaceholder;

  /// Etiqueta del campo obligatorio (doc 13 §3.2).
  ///
  /// In es, this message translates to:
  /// **'qué viste'**
  String get observacionEtiquetaQueViste;

  /// Placeholder del campo de descripción libre. Itálica (estilo se aplica en el widget).
  ///
  /// In es, this message translates to:
  /// **'describe lo que has visto, sin nombrarlo si no estás segura'**
  String get observacionPlaceholderQueViste;

  /// Etiqueta del campo opcional de identificación propuesta.
  ///
  /// In es, this message translates to:
  /// **'crees que es'**
  String get observacionEtiquetaCreesQueEs;

  /// Placeholder del campo opcional.
  ///
  /// In es, this message translates to:
  /// **'si quieres, propón un nombre'**
  String get observacionPlaceholderCreesQueEs;

  /// No description provided for @confianzaConsenso.
  ///
  /// In es, this message translates to:
  /// **'consenso'**
  String get confianzaConsenso;

  /// No description provided for @confianzaHipotesisActiva.
  ///
  /// In es, this message translates to:
  /// **'hipótesis activa'**
  String get confianzaHipotesisActiva;

  /// No description provided for @confianzaNoSegura.
  ///
  /// In es, this message translates to:
  /// **'no estoy segura'**
  String get confianzaNoSegura;

  /// No description provided for @confianzaConsensoTooltip.
  ///
  /// In es, this message translates to:
  /// **'lo has confirmado con una clave o con el Tutor'**
  String get confianzaConsensoTooltip;

  /// No description provided for @confianzaNoSeguraTooltip.
  ///
  /// In es, this message translates to:
  /// **'no pasa nada, anótalo así'**
  String get confianzaNoSeguraTooltip;

  /// Mensaje de validación amable bajo el botón Guardar (doc 13 §3.2). Sin rojo, sin icono de error, sin 'campo obligatorio'.
  ///
  /// In es, this message translates to:
  /// **'haz una nota antes de guardar'**
  String get observacionAvisoFalta;

  /// Botón principal de la pantalla de observación. Sentence case con mayúscula inicial porque es una acción explícita (criterio de UI: botones llevan inicial; cabeceras de sección no).
  ///
  /// In es, this message translates to:
  /// **'Guardar en el cuaderno'**
  String get observacionBotonGuardar;

  /// Frase canónica de presentación del Tutor (doc 04 §3.1, doc 13 §6.2). Idéntica siempre.
  ///
  /// In es, this message translates to:
  /// **'Soy el Tutor del Cuaderno. Pregúntame lo que necesites.'**
  String get tutorSaludoCanonico;

  /// No description provided for @tutorPlaceholderInput.
  ///
  /// In es, this message translates to:
  /// **'escribe tu pregunta'**
  String get tutorPlaceholderInput;

  /// No description provided for @tutorBotonEnviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar'**
  String get tutorBotonEnviar;

  /// Respuesta única del Tutor en S1. La conexión real con Claude API entra en Sprint 4 — esta microcopia es deliberada, no un placeholder técnico (README documenta el motivo).
  ///
  /// In es, this message translates to:
  /// **'El Tutor todavía no está conectado. Vuelve en unas semanas.'**
  String get tutorRespuestaCanned;

  /// Título de la pantalla de Ajustes.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get ajustesTitulo;

  /// Texto que muestra el idioma activo en Ajustes.
  ///
  /// In es, this message translates to:
  /// **'Idioma del cuaderno: {idioma}'**
  String ajustesIdiomaActual(String idioma);

  /// No description provided for @ajustesIdiomaCambiar.
  ///
  /// In es, this message translates to:
  /// **'Cambiar idioma'**
  String get ajustesIdiomaCambiar;

  /// No description provided for @ajustesExportar.
  ///
  /// In es, this message translates to:
  /// **'Exportar mi cuaderno'**
  String get ajustesExportar;

  /// No description provided for @ajustesExportarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Recibe una copia legible de tus observaciones y Misterios. El cuaderno es tuyo.'**
  String get ajustesExportarDescripcion;

  /// No description provided for @ajustesExportarDialogoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Tu cuaderno como texto'**
  String get ajustesExportarDialogoTitulo;

  /// No description provided for @ajustesExportarDialogoCerrar.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get ajustesExportarDialogoCerrar;

  /// No description provided for @ajustesVistaCuidador.
  ///
  /// In es, this message translates to:
  /// **'Vista del cuidador'**
  String get ajustesVistaCuidador;

  /// No description provided for @ajustesVistaCuidadorDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Una página discreta para una persona adulta que te acompaña.'**
  String get ajustesVistaCuidadorDescripcion;

  /// No description provided for @ajustesBorrar.
  ///
  /// In es, this message translates to:
  /// **'Borrar mi cuaderno'**
  String get ajustesBorrar;

  /// No description provided for @ajustesBorrarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Borrar todas tus observaciones, Misterios y sit spot. No se puede deshacer.'**
  String get ajustesBorrarDescripcion;

  /// No description provided for @ajustesBorrarDialogoTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Borrar todo?'**
  String get ajustesBorrarDialogoTitulo;

  /// Cuerpo del primer diálogo de borrado, con el reparto.
  ///
  /// In es, this message translates to:
  /// **'Si continúas, se borrarán {observaciones} observaciones, {misterios} Misterios y {sitSpots} sit spot. No se puede deshacer.'**
  String ajustesBorrarDialogoCuerpo(int observaciones, int misterios, int sitSpots);

  /// No description provided for @ajustesBorrarDialogoSeguir.
  ///
  /// In es, this message translates to:
  /// **'Seguir'**
  String get ajustesBorrarDialogoSeguir;

  /// No description provided for @ajustesBorrarDialogoCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get ajustesBorrarDialogoCancelar;

  /// No description provided for @ajustesBorrarConfirmacionTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Estás segura?'**
  String get ajustesBorrarConfirmacionTitulo;

  /// No description provided for @ajustesBorrarConfirmacionCuerpo.
  ///
  /// In es, this message translates to:
  /// **'Escribe «borrar» abajo para confirmar.'**
  String get ajustesBorrarConfirmacionCuerpo;

  /// Palabra exacta que el niño debe escribir para confirmar el borrado. Equivalente i18n del 'DELETE' de muchas apps adultas.
  ///
  /// In es, this message translates to:
  /// **'borrar'**
  String get ajustesBorrarConfirmacionPalabra;

  /// No description provided for @ajustesBorrarConfirmacionPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'escribe la palabra'**
  String get ajustesBorrarConfirmacionPlaceholder;

  /// No description provided for @ajustesBorrarConfirmacionBoton.
  ///
  /// In es, this message translates to:
  /// **'Borrar todo'**
  String get ajustesBorrarConfirmacionBoton;

  /// No description provided for @ajustesBorradoCompleto.
  ///
  /// In es, this message translates to:
  /// **'Listo. Tu cuaderno está vacío.'**
  String get ajustesBorradoCompleto;

  /// Bloque opt-in que sube las observaciones pendientes al servidor. Lo dispara el adulto/niño explícitamente; sin sync automático.
  ///
  /// In es, this message translates to:
  /// **'Sincronizar mis observaciones'**
  String get ajustesSyncObsTitulo;

  /// No description provided for @ajustesSyncObsDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Sube las observaciones nuevas a tu cuenta del servidor para no perderlas si cambias de dispositivo.'**
  String get ajustesSyncObsDescripcion;

  /// No description provided for @ajustesSyncObsBoton.
  ///
  /// In es, this message translates to:
  /// **'Subir ahora'**
  String get ajustesSyncObsBoton;

  /// No description provided for @ajustesSyncObsEnVuelo.
  ///
  /// In es, this message translates to:
  /// **'Subiendo…'**
  String get ajustesSyncObsEnVuelo;

  /// No description provided for @ajustesSyncObsSinToken.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón subirá tus observaciones.'**
  String get ajustesSyncObsSinToken;

  /// No description provided for @ajustesSyncObsNadaPendiente.
  ///
  /// In es, this message translates to:
  /// **'No hay observaciones pendientes — todo subido.'**
  String get ajustesSyncObsNadaPendiente;

  /// No description provided for @ajustesSyncObsTodasEnviadas.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{Se ha subido una observación.} other{Se han subido {count} observaciones.}}'**
  String ajustesSyncObsTodasEnviadas(int count);

  /// No description provided for @ajustesSyncObsParcial.
  ///
  /// In es, this message translates to:
  /// **'Subidas {enviadas}, quedan {pendientes} para el siguiente intento.'**
  String ajustesSyncObsParcial(int enviadas, int pendientes);

  /// No description provided for @ajustesSyncObsRechazadas.
  ///
  /// In es, this message translates to:
  /// **'Subidas {enviadas}, el servidor ha rechazado {rechazadas}. Vuelve a abrirlas para revisarlas.'**
  String ajustesSyncObsRechazadas(int enviadas, int rechazadas);

  /// Bloque visible sólo en builds de debug. Permite pegar un JWT del backend para probar el Tutor real end-to-end sin pantalla de login.
  ///
  /// In es, this message translates to:
  /// **'Tutor (debug)'**
  String get ajustesTutorDebugTitulo;

  /// No description provided for @ajustesTutorDebugDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Pega aquí un token del backend para activar el Tutor real. Visible sólo en debug.'**
  String get ajustesTutorDebugDescripcion;

  /// No description provided for @ajustesTutorDebugPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'JWT del backend'**
  String get ajustesTutorDebugPlaceholder;

  /// No description provided for @ajustesTutorDebugBotonGuardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar token'**
  String get ajustesTutorDebugBotonGuardar;

  /// No description provided for @ajustesTutorDebugBotonBorrar.
  ///
  /// In es, this message translates to:
  /// **'Borrar token'**
  String get ajustesTutorDebugBotonBorrar;

  /// No description provided for @ajustesTutorDebugGuardado.
  ///
  /// In es, this message translates to:
  /// **'Token guardado. Vuelve al Tutor para probarlo.'**
  String get ajustesTutorDebugGuardado;

  /// No description provided for @ajustesTutorDebugBorrado.
  ///
  /// In es, this message translates to:
  /// **'Token borrado. El Tutor vuelve a la respuesta canónica.'**
  String get ajustesTutorDebugBorrado;

  /// Título de la pantalla del cuidador.
  ///
  /// In es, this message translates to:
  /// **'Página del cuidador'**
  String get cuidadorTitulo;

  /// Microcopia que aclara la frontera de privacidad para el adulto que abra esta pantalla con el niño (doc 15 §1).
  ///
  /// In es, this message translates to:
  /// **'Esta es la única vista que comparte el juego con quien te acompaña. No verá tus observaciones ni lo que escribes — solo este resumen y una pregunta para hablar.'**
  String get cuidadorAviso;

  /// No description provided for @cuidadorSemanaActual.
  ///
  /// In es, this message translates to:
  /// **'Semana {isoWeek}'**
  String cuidadorSemanaActual(String isoWeek);

  /// No description provided for @cuidadorPreguntaCabecera.
  ///
  /// In es, this message translates to:
  /// **'Una pregunta para la cena'**
  String get cuidadorPreguntaCabecera;

  /// No description provided for @cuidadorMetricasCabecera.
  ///
  /// In es, this message translates to:
  /// **'Esta semana'**
  String get cuidadorMetricasCabecera;

  /// No description provided for @cuidadorMetricaObservaciones.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Sin observaciones} =1{Una observación} other{{count} observaciones}}'**
  String cuidadorMetricaObservaciones(int count);

  /// No description provided for @cuidadorMetricaMisterios.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Sin Misterios anclados} =1{Un Misterio} other{{count} Misterios}}'**
  String cuidadorMetricaMisterios(int count);

  /// No description provided for @cuidadorMetricaSitSpot.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Sin visitas al sit spot} =1{Una visita al sit spot} other{{count} visitas al sit spot}}'**
  String cuidadorMetricaSitSpot(int count);

  /// Botón opt-in que sube el agregado semanal al backend para que el LLM server-side genere el resumen y la pregunta para la cena. Sin push: lo dispara el adulto explícitamente cuando está con el niño.
  ///
  /// In es, this message translates to:
  /// **'Compartir resumen con el adulto'**
  String get cuidadorSincronizarBoton;

  /// No description provided for @cuidadorSincronizarEnVuelo.
  ///
  /// In es, this message translates to:
  /// **'Pidiéndolo…'**
  String get cuidadorSincronizarEnVuelo;

  /// No description provided for @cuidadorSincronizarSinToken.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay cuenta vinculada con el servidor. Cuando la haya, este botón pedirá un resumen escrito.'**
  String get cuidadorSincronizarSinToken;

  /// No description provided for @cuidadorSincronizarErrorRed.
  ///
  /// In es, this message translates to:
  /// **'Hoy no se ha podido conectar. Puedes volver a intentarlo más tarde.'**
  String get cuidadorSincronizarErrorRed;

  /// No description provided for @cuidadorSincronizarSinResumen.
  ///
  /// In es, this message translates to:
  /// **'El servidor no ha podido generar un resumen esta vez. La pregunta de abajo sigue valiendo.'**
  String get cuidadorSincronizarSinResumen;

  /// Cabecera del párrafo cualitativo que el LLM server-side genera. Solo se muestra si el sync trae un texto no vacío.
  ///
  /// In es, this message translates to:
  /// **'Esta semana, en una frase'**
  String get cuidadorResumenCabecera;
}

class _TextosAppDelegate extends LocalizationsDelegate<TextosApp> {
  const _TextosAppDelegate();

  @override
  Future<TextosApp> load(Locale locale) {
    return SynchronousFuture<TextosApp>(lookupTextosApp(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ca', 'es', 'eu'].contains(locale.languageCode);

  @override
  bool shouldReload(_TextosAppDelegate old) => false;
}

TextosApp lookupTextosApp(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca': return TextosAppCa();
    case 'es': return TextosAppEs();
    case 'eu': return TextosAppEu();
  }

  throw FlutterError(
    'TextosApp.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
