import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';
import 'app_localizations_eu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('eu')
  ];

  /// No description provided for @appTitulo.
  ///
  /// In es, this message translates to:
  /// **'Solera Zunbeltz'**
  String get appTitulo;

  /// No description provided for @navHoy.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get navHoy;

  /// No description provided for @navFincas.
  ///
  /// In es, this message translates to:
  /// **'Fincas'**
  String get navFincas;

  /// No description provided for @navSeguimiento.
  ///
  /// In es, this message translates to:
  /// **'Seguimiento'**
  String get navSeguimiento;

  /// No description provided for @navAjustes.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get navAjustes;

  /// No description provided for @onboardingTitulo.
  ///
  /// In es, this message translates to:
  /// **'Solera Zunbeltz'**
  String get onboardingTitulo;

  /// No description provided for @onboardingCuerpo.
  ///
  /// In es, this message translates to:
  /// **'La herramienta del Espacio Test Agrario: gestiona las fincas, reparte las tareas de mantenimiento y lleva el seguimiento del testaje. Funciona sin cobertura en el monte.'**
  String get onboardingCuerpo;

  /// No description provided for @onboardingBoton.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get onboardingBoton;

  /// No description provided for @hoyTitulo.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get hoyTitulo;

  /// No description provided for @hoyResumenTareas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =0{Sin tareas abiertas} =1{1 tarea abierta} other{{n} tareas abiertas}}'**
  String hoyResumenTareas(int n);

  /// No description provided for @hoyVacio.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay nada registrado. Empieza por marcar una infraestructura en el mapa de Fincas.'**
  String get hoyVacio;

  /// No description provided for @hoyVerTablero.
  ///
  /// In es, this message translates to:
  /// **'Ver tareas'**
  String get hoyVerTablero;

  /// No description provided for @ajustesIdioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get ajustesIdioma;

  /// No description provided for @ajustesIdiomaCastellano.
  ///
  /// In es, this message translates to:
  /// **'Castellano'**
  String get ajustesIdiomaCastellano;

  /// No description provided for @ajustesIdiomaEuskera.
  ///
  /// In es, this message translates to:
  /// **'Euskara'**
  String get ajustesIdiomaEuskera;

  /// No description provided for @ajustesAcercaDe.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get ajustesAcercaDe;

  /// No description provided for @ajustesVersion.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String ajustesVersion(String version);

  /// No description provided for @ajustesProvisional.
  ///
  /// In es, this message translates to:
  /// **'Versión provisional — pendiente de validación de los contenidos normativos por los técnicos competentes.'**
  String get ajustesProvisional;

  /// No description provided for @comunGuardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get comunGuardar;

  /// No description provided for @comunCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get comunCancelar;

  /// No description provided for @comunBorrar.
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get comunBorrar;

  /// No description provided for @comunFecha.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get comunFecha;

  /// No description provided for @mapaNuevoPunto.
  ///
  /// In es, this message translates to:
  /// **'Nuevo punto'**
  String get mapaNuevoPunto;

  /// No description provided for @mapaUsarGps.
  ///
  /// In es, this message translates to:
  /// **'Usar GPS actual'**
  String get mapaUsarGps;

  /// No description provided for @mapaUsarCentro.
  ///
  /// In es, this message translates to:
  /// **'Usar centro del mapa'**
  String get mapaUsarCentro;

  /// No description provided for @mapaElegirFinca.
  ///
  /// In es, this message translates to:
  /// **'¿En qué finca?'**
  String get mapaElegirFinca;

  /// No description provided for @mapaSinPuntos.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay puntos. Pulsa «Nuevo punto» para marcar el primero.'**
  String get mapaSinPuntos;

  /// No description provided for @mapaGpsNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'GPS no disponible — rellena la ubicación a mano.'**
  String get mapaGpsNoDisponible;

  /// No description provided for @mapaCapas.
  ///
  /// In es, this message translates to:
  /// **'Capas'**
  String get mapaCapas;

  /// No description provided for @mapaMapa.
  ///
  /// In es, this message translates to:
  /// **'Mapa'**
  String get mapaMapa;

  /// No description provided for @mapaGps.
  ///
  /// In es, this message translates to:
  /// **'GPS'**
  String get mapaGps;

  /// No description provided for @mapaTablero.
  ///
  /// In es, this message translates to:
  /// **'Tareas'**
  String get mapaTablero;

  /// No description provided for @puntoNuevoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo punto de infraestructura'**
  String get puntoNuevoTitulo;

  /// No description provided for @puntoFinca.
  ///
  /// In es, this message translates to:
  /// **'Finca'**
  String get puntoFinca;

  /// No description provided for @puntoTipo.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get puntoTipo;

  /// No description provided for @puntoNombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get puntoNombre;

  /// No description provided for @puntoEstado.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get puntoEstado;

  /// No description provided for @puntoNotas.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get puntoNotas;

  /// No description provided for @puntoFotos.
  ///
  /// In es, this message translates to:
  /// **'Fotos'**
  String get puntoFotos;

  /// No description provided for @puntoLatitud.
  ///
  /// In es, this message translates to:
  /// **'Latitud'**
  String get puntoLatitud;

  /// No description provided for @puntoLongitud.
  ///
  /// In es, this message translates to:
  /// **'Longitud'**
  String get puntoLongitud;

  /// No description provided for @puntoGuardado.
  ///
  /// In es, this message translates to:
  /// **'Punto guardado'**
  String get puntoGuardado;

  /// No description provided for @fichaPuntoTareas.
  ///
  /// In es, this message translates to:
  /// **'Tareas del punto'**
  String get fichaPuntoTareas;

  /// No description provided for @fichaSinTareas.
  ///
  /// In es, this message translates to:
  /// **'Sin tareas en este punto.'**
  String get fichaSinTareas;

  /// No description provided for @fichaNuevaTarea.
  ///
  /// In es, this message translates to:
  /// **'Nueva tarea'**
  String get fichaNuevaTarea;

  /// No description provided for @fichaBorrarPunto.
  ///
  /// In es, this message translates to:
  /// **'Borrar punto'**
  String get fichaBorrarPunto;

  /// No description provided for @fichaCoordenadas.
  ///
  /// In es, this message translates to:
  /// **'Coordenadas'**
  String get fichaCoordenadas;

  /// No description provided for @fichaSinCoordenadas.
  ///
  /// In es, this message translates to:
  /// **'Sin coordenadas'**
  String get fichaSinCoordenadas;

  /// No description provided for @tareaNuevaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Nueva tarea'**
  String get tareaNuevaTitulo;

  /// No description provided for @tareaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get tareaTitulo;

  /// No description provided for @tareaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get tareaDescripcion;

  /// No description provided for @tareaResponsable.
  ///
  /// In es, this message translates to:
  /// **'Responsable'**
  String get tareaResponsable;

  /// No description provided for @tareaPrioridad.
  ///
  /// In es, this message translates to:
  /// **'Prioridad'**
  String get tareaPrioridad;

  /// No description provided for @tareaEstado.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get tareaEstado;

  /// No description provided for @tareaFechaObjetivo.
  ///
  /// In es, this message translates to:
  /// **'Fecha objetivo'**
  String get tareaFechaObjetivo;

  /// No description provided for @tareaSinFecha.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha'**
  String get tareaSinFecha;

  /// No description provided for @tareaFotosAntes.
  ///
  /// In es, this message translates to:
  /// **'Fotos antes'**
  String get tareaFotosAntes;

  /// No description provided for @tareaFotosDespues.
  ///
  /// In es, this message translates to:
  /// **'Fotos después'**
  String get tareaFotosDespues;

  /// No description provided for @tareaCoste.
  ///
  /// In es, this message translates to:
  /// **'Coste (€)'**
  String get tareaCoste;

  /// No description provided for @tareaGuardada.
  ///
  /// In es, this message translates to:
  /// **'Tarea guardada'**
  String get tareaGuardada;

  /// No description provided for @tareaTituloObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Pon un título a la tarea.'**
  String get tareaTituloObligatorio;

  /// No description provided for @tableroTitulo.
  ///
  /// In es, this message translates to:
  /// **'Tareas de mantenimiento'**
  String get tableroTitulo;

  /// No description provided for @tableroTodas.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get tableroTodas;

  /// No description provided for @tableroFiltroFinca.
  ///
  /// In es, this message translates to:
  /// **'Finca'**
  String get tableroFiltroFinca;

  /// No description provided for @tableroFiltroEstado.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get tableroFiltroEstado;

  /// No description provided for @tableroSinTareas.
  ///
  /// In es, this message translates to:
  /// **'No hay tareas con estos filtros.'**
  String get tableroSinTareas;

  /// No description provided for @tableroPartePdf.
  ///
  /// In es, this message translates to:
  /// **'Parte PDF'**
  String get tableroPartePdf;

  /// No description provided for @tableroGenerandoPdf.
  ///
  /// In es, this message translates to:
  /// **'Generando parte…'**
  String get tableroGenerandoPdf;

  /// No description provided for @tareaDeFinca.
  ///
  /// In es, this message translates to:
  /// **'Tarea de finca'**
  String get tareaDeFinca;

  /// No description provided for @parteTitulo.
  ///
  /// In es, this message translates to:
  /// **'Parte de mantenimiento'**
  String get parteTitulo;

  /// No description provided for @parteSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Espacio Test Agrario Zunbeltz · documento PROVISIONAL'**
  String get parteSubtitulo;

  /// No description provided for @parteProvisional.
  ///
  /// In es, this message translates to:
  /// **'DOCUMENTO PROVISIONAL — formato pendiente de validación.'**
  String get parteProvisional;

  /// No description provided for @parteResumenTareas.
  ///
  /// In es, this message translates to:
  /// **'Tareas incluidas: {n}'**
  String parteResumenTareas(int n);

  /// No description provided for @parteColPunto.
  ///
  /// In es, this message translates to:
  /// **'Punto'**
  String get parteColPunto;

  /// No description provided for @parteColTarea.
  ///
  /// In es, this message translates to:
  /// **'Tarea'**
  String get parteColTarea;

  /// No description provided for @parteColResponsable.
  ///
  /// In es, this message translates to:
  /// **'Responsable'**
  String get parteColResponsable;

  /// No description provided for @parteColPrioridad.
  ///
  /// In es, this message translates to:
  /// **'Prioridad'**
  String get parteColPrioridad;

  /// No description provided for @parteColEstado.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get parteColEstado;

  /// No description provided for @parteColFecha.
  ///
  /// In es, this message translates to:
  /// **'Fecha objetivo'**
  String get parteColFecha;

  /// No description provided for @parteSinResponsable.
  ///
  /// In es, this message translates to:
  /// **'Sin asignar'**
  String get parteSinResponsable;

  /// No description provided for @segTitulo.
  ///
  /// In es, this message translates to:
  /// **'Seguimiento'**
  String get segTitulo;

  /// No description provided for @segIndicadores.
  ///
  /// In es, this message translates to:
  /// **'Indicadores del periodo'**
  String get segIndicadores;

  /// No description provided for @segTodasFincas.
  ///
  /// In es, this message translates to:
  /// **'Todas las fincas'**
  String get segTodasFincas;

  /// No description provided for @segAlimentacion.
  ///
  /// In es, this message translates to:
  /// **'Alimentación (kg)'**
  String get segAlimentacion;

  /// No description provided for @segPariciones.
  ///
  /// In es, this message translates to:
  /// **'Pariciones'**
  String get segPariciones;

  /// No description provided for @segProductos.
  ///
  /// In es, this message translates to:
  /// **'Productos comercializados'**
  String get segProductos;

  /// No description provided for @segIngresos.
  ///
  /// In es, this message translates to:
  /// **'Ingresos'**
  String get segIngresos;

  /// No description provided for @segGastos.
  ///
  /// In es, this message translates to:
  /// **'Gastos'**
  String get segGastos;

  /// No description provided for @segBalance.
  ///
  /// In es, this message translates to:
  /// **'Balance'**
  String get segBalance;

  /// No description provided for @segPestanaActividad.
  ///
  /// In es, this message translates to:
  /// **'Actividad'**
  String get segPestanaActividad;

  /// No description provided for @segPestanaEconomico.
  ///
  /// In es, this message translates to:
  /// **'Económico'**
  String get segPestanaEconomico;

  /// No description provided for @segNuevaActividad.
  ///
  /// In es, this message translates to:
  /// **'Registrar actividad'**
  String get segNuevaActividad;

  /// No description provided for @segNuevoApunte.
  ///
  /// In es, this message translates to:
  /// **'Apunte económico'**
  String get segNuevoApunte;

  /// No description provided for @segSinRegistros.
  ///
  /// In es, this message translates to:
  /// **'Sin registros todavía.'**
  String get segSinRegistros;

  /// No description provided for @segInformePdf.
  ///
  /// In es, this message translates to:
  /// **'Informe de seguimiento (PDF)'**
  String get segInformePdf;

  /// No description provided for @segGenerandoInforme.
  ///
  /// In es, this message translates to:
  /// **'Generando informe…'**
  String get segGenerandoInforme;

  /// No description provided for @actNuevaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Registrar actividad'**
  String get actNuevaTitulo;

  /// No description provided for @actTipo.
  ///
  /// In es, this message translates to:
  /// **'Tipo de actividad'**
  String get actTipo;

  /// No description provided for @actCantidad.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get actCantidad;

  /// No description provided for @actLote.
  ///
  /// In es, this message translates to:
  /// **'Lote / rebaño'**
  String get actLote;

  /// No description provided for @actNotas.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get actNotas;

  /// No description provided for @actGuardada.
  ///
  /// In es, this message translates to:
  /// **'Actividad registrada'**
  String get actGuardada;

  /// No description provided for @actCantidadObligatoria.
  ///
  /// In es, this message translates to:
  /// **'Indica una cantidad mayor que cero.'**
  String get actCantidadObligatoria;

  /// No description provided for @apuNuevoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo apunte económico'**
  String get apuNuevoTitulo;

  /// No description provided for @apuTipo.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get apuTipo;

  /// No description provided for @apuConcepto.
  ///
  /// In es, this message translates to:
  /// **'Concepto'**
  String get apuConcepto;

  /// No description provided for @apuImporte.
  ///
  /// In es, this message translates to:
  /// **'Importe (€)'**
  String get apuImporte;

  /// No description provided for @apuNotas.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get apuNotas;

  /// No description provided for @apuGuardado.
  ///
  /// In es, this message translates to:
  /// **'Apunte guardado'**
  String get apuGuardado;

  /// No description provided for @apuImporteObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Indica un importe mayor que cero.'**
  String get apuImporteObligatorio;

  /// No description provided for @informeSegTitulo.
  ///
  /// In es, this message translates to:
  /// **'Informe de seguimiento'**
  String get informeSegTitulo;

  /// No description provided for @informeSegResumenPeriodo.
  ///
  /// In es, this message translates to:
  /// **'Registros: {actividades} · apuntes: {apuntes}'**
  String informeSegResumenPeriodo(int actividades, int apuntes);

  /// No description provided for @informeSegTablaActividad.
  ///
  /// In es, this message translates to:
  /// **'Registros de actividad'**
  String get informeSegTablaActividad;

  /// No description provided for @informeSegTablaEconomico.
  ///
  /// In es, this message translates to:
  /// **'Apuntes económicos'**
  String get informeSegTablaEconomico;

  /// No description provided for @informeSegColTipo.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get informeSegColTipo;

  /// No description provided for @informeSegColCantidad.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get informeSegColCantidad;

  /// No description provided for @informeSegColConcepto.
  ///
  /// In es, this message translates to:
  /// **'Concepto'**
  String get informeSegColConcepto;

  /// No description provided for @informeSegColImporte.
  ///
  /// In es, this message translates to:
  /// **'Importe (€)'**
  String get informeSegColImporte;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es', 'eu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
    case 'eu':
      return AppLocalizationsEu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
