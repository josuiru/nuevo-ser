// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitulo => 'Solera Zunbeltz';

  @override
  String get navHoy => 'Hoy';

  @override
  String get navFincas => 'Fincas';

  @override
  String get navCuaderno => 'Cuaderno';

  @override
  String get navAjustes => 'Ajustes';

  @override
  String get onboardingTitulo => 'Solera Zunbeltz';

  @override
  String get onboardingCuerpo =>
      'La herramienta del Espacio Test Agrario: gestiona las fincas, reparte las tareas de mantenimiento y lleva el seguimiento del testaje. Funciona sin cobertura en el monte.';

  @override
  String get onboardingBoton => 'Empezar';

  @override
  String get hoyTitulo => 'Hoy';

  @override
  String hoyResumenTareas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tareas abiertas',
      one: '1 tarea abierta',
      zero: 'Sin tareas abiertas',
    );
    return '$_temp0';
  }

  @override
  String get hoyVacio =>
      'Aún no hay nada registrado. Empieza por marcar una infraestructura en el mapa de Fincas.';

  @override
  String get hoyVerTablero => 'Ver tareas';

  @override
  String get cuadernoProximamente => 'Cuaderno ganadero';

  @override
  String get cuadernoProximamenteCuerpo =>
      'Animales, lotes, pastoreo y eventos del día a día. Disponible en una fase posterior.';

  @override
  String get ajustesIdioma => 'Idioma';

  @override
  String get ajustesIdiomaCastellano => 'Castellano';

  @override
  String get ajustesIdiomaEuskera => 'Euskara';

  @override
  String get ajustesAcercaDe => 'Acerca de';

  @override
  String ajustesVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get ajustesProvisional =>
      'Versión provisional — pendiente de validación de los contenidos normativos por los técnicos competentes.';

  @override
  String get comunGuardar => 'Guardar';

  @override
  String get comunCancelar => 'Cancelar';

  @override
  String get comunBorrar => 'Borrar';

  @override
  String get mapaNuevoPunto => 'Nuevo punto';

  @override
  String get mapaUsarGps => 'Usar GPS actual';

  @override
  String get mapaUsarCentro => 'Usar centro del mapa';

  @override
  String get mapaElegirFinca => '¿En qué finca?';

  @override
  String get mapaSinPuntos =>
      'Aún no hay puntos. Pulsa «Nuevo punto» para marcar el primero.';

  @override
  String get mapaGpsNoDisponible =>
      'GPS no disponible — rellena la ubicación a mano.';

  @override
  String get mapaCapas => 'Capas';

  @override
  String get mapaMapa => 'Mapa';

  @override
  String get mapaGps => 'GPS';

  @override
  String get mapaTablero => 'Tareas';

  @override
  String get puntoNuevoTitulo => 'Nuevo punto de infraestructura';

  @override
  String get puntoFinca => 'Finca';

  @override
  String get puntoTipo => 'Tipo';

  @override
  String get puntoNombre => 'Nombre';

  @override
  String get puntoEstado => 'Estado';

  @override
  String get puntoNotas => 'Notas';

  @override
  String get puntoFotos => 'Fotos';

  @override
  String get puntoLatitud => 'Latitud';

  @override
  String get puntoLongitud => 'Longitud';

  @override
  String get puntoGuardado => 'Punto guardado';

  @override
  String get fichaPuntoTareas => 'Tareas del punto';

  @override
  String get fichaSinTareas => 'Sin tareas en este punto.';

  @override
  String get fichaNuevaTarea => 'Nueva tarea';

  @override
  String get fichaBorrarPunto => 'Borrar punto';

  @override
  String get fichaCoordenadas => 'Coordenadas';

  @override
  String get fichaSinCoordenadas => 'Sin coordenadas';

  @override
  String get tareaNuevaTitulo => 'Nueva tarea';

  @override
  String get tareaTitulo => 'Título';

  @override
  String get tareaDescripcion => 'Descripción';

  @override
  String get tareaResponsable => 'Responsable';

  @override
  String get tareaPrioridad => 'Prioridad';

  @override
  String get tareaEstado => 'Estado';

  @override
  String get tareaFechaObjetivo => 'Fecha objetivo';

  @override
  String get tareaSinFecha => 'Sin fecha';

  @override
  String get tareaFotosAntes => 'Fotos antes';

  @override
  String get tareaFotosDespues => 'Fotos después';

  @override
  String get tareaCoste => 'Coste (€)';

  @override
  String get tareaGuardada => 'Tarea guardada';

  @override
  String get tareaTituloObligatorio => 'Pon un título a la tarea.';

  @override
  String get tableroTitulo => 'Tareas de mantenimiento';

  @override
  String get tableroTodas => 'Todas';

  @override
  String get tableroFiltroFinca => 'Finca';

  @override
  String get tableroFiltroEstado => 'Estado';

  @override
  String get tableroSinTareas => 'No hay tareas con estos filtros.';

  @override
  String get tableroPartePdf => 'Parte PDF';

  @override
  String get tableroGenerandoPdf => 'Generando parte…';

  @override
  String get tareaDeFinca => 'Tarea de finca';

  @override
  String get parteTitulo => 'Parte de mantenimiento';

  @override
  String get parteSubtitulo =>
      'Espacio Test Agrario Zunbeltz · documento PROVISIONAL';

  @override
  String get parteProvisional =>
      'DOCUMENTO PROVISIONAL — formato pendiente de validación.';

  @override
  String parteResumenTareas(int n) {
    return 'Tareas incluidas: $n';
  }

  @override
  String get parteColPunto => 'Punto';

  @override
  String get parteColTarea => 'Tarea';

  @override
  String get parteColResponsable => 'Responsable';

  @override
  String get parteColPrioridad => 'Prioridad';

  @override
  String get parteColEstado => 'Estado';

  @override
  String get parteColFecha => 'Fecha objetivo';

  @override
  String get parteSinResponsable => 'Sin asignar';
}
