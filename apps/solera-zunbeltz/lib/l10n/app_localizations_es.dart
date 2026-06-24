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
  String get navSeguimiento => 'Seguimiento';

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
      'Versión preliminar. Los partes e informes que genera son orientativos y su formato está pendiente de validación. El papeleo oficial (libro de explotación, cuaderno PAC, trazabilidad…) llega en fases posteriores.';

  @override
  String get comunGuardar => 'Guardar';

  @override
  String get comunCancelar => 'Cancelar';

  @override
  String get comunBorrar => 'Borrar';

  @override
  String get comunFecha => 'Fecha';

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
      'Aún no hay puntos. Toca el mapa o pulsa «Nuevo punto» para marcar el primero.';

  @override
  String get mapaTocaParaAnadir => 'Toca el mapa para añadir un punto';

  @override
  String get mapaTocaNuevaUbicacion => 'Toca la nueva ubicación del punto';

  @override
  String get puntoRecolocado => 'Punto recolocado';

  @override
  String get fichaRecolocar => 'Recolocar en el mapa';

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

  @override
  String get segTitulo => 'Seguimiento';

  @override
  String get segIndicadores => 'Indicadores del periodo';

  @override
  String get segTodasFincas => 'Todas las fincas';

  @override
  String get segAlimentacion => 'Alimentación (kg)';

  @override
  String get segPariciones => 'Pariciones';

  @override
  String get segProductos => 'Productos comercializados';

  @override
  String get segIngresos => 'Ingresos';

  @override
  String get segGastos => 'Gastos';

  @override
  String get segBalance => 'Balance';

  @override
  String get segPestanaActividad => 'Actividad';

  @override
  String get segPestanaEconomico => 'Económico';

  @override
  String get segNuevaActividad => 'Registrar actividad';

  @override
  String get segNuevoApunte => 'Apunte económico';

  @override
  String get segSinRegistros => 'Sin registros todavía.';

  @override
  String get segInformePdf => 'Informe de seguimiento (PDF)';

  @override
  String get segGenerandoInforme => 'Generando informe…';

  @override
  String get actNuevaTitulo => 'Registrar actividad';

  @override
  String get actTipo => 'Tipo de actividad';

  @override
  String get actCantidad => 'Cantidad';

  @override
  String get actLote => 'Lote / rebaño';

  @override
  String get actNotas => 'Notas';

  @override
  String get actGuardada => 'Actividad registrada';

  @override
  String get actCantidadObligatoria => 'Indica una cantidad mayor que cero.';

  @override
  String get apuNuevoTitulo => 'Nuevo apunte económico';

  @override
  String get apuTipo => 'Tipo';

  @override
  String get apuConcepto => 'Concepto';

  @override
  String get apuImporte => 'Importe (€)';

  @override
  String get apuNotas => 'Notas';

  @override
  String get apuGuardado => 'Apunte guardado';

  @override
  String get apuImporteObligatorio => 'Indica un importe mayor que cero.';

  @override
  String get informeSegTitulo => 'Informe de seguimiento';

  @override
  String informeSegResumenPeriodo(int actividades, int apuntes) {
    return 'Registros: $actividades · apuntes: $apuntes';
  }

  @override
  String get informeSegTablaActividad => 'Registros de actividad';

  @override
  String get informeSegTablaEconomico => 'Apuntes económicos';

  @override
  String get informeSegColTipo => 'Tipo';

  @override
  String get informeSegColCantidad => 'Cantidad';

  @override
  String get informeSegColConcepto => 'Concepto';

  @override
  String get informeSegColImporte => 'Importe (€)';

  @override
  String get meteoTitulo => 'Previsión';

  @override
  String get meteoHoy => 'Hoy';

  @override
  String get meteoSinConexion =>
      'No se pudo obtener la previsión. Revisa la conexión e inténtalo de nuevo.';

  @override
  String get meteoReintentar => 'Reintentar';

  @override
  String get meteoOrientativo =>
      'Previsión orientativa (Open-Meteo). No sustituye el criterio del ganadero ni del veterinario.';

  @override
  String get avisoHelada => 'Helada';

  @override
  String get avisoLluvia => 'Lluvia';

  @override
  String get avisoViento => 'Viento fuerte';

  @override
  String get avisoCalor => 'Calor';

  @override
  String get avisoBuenManejo => 'Buen día de manejo';

  @override
  String get acercaTitulo => 'Acerca del Espacio Test';

  @override
  String get acercaIntro =>
      'Zunbeltz es el primer Espacio Test Agroganadero de Navarra: una incubadora donde personas emprendedoras prueban un proyecto de ganadería ecológica extensiva durante un periodo acotado, con acompañamiento de ganaderas y ganaderos expertos, sobre las fincas de Zunbeltz (231 ha) y La Planilla (197 ha). Impulsado por el Gobierno de Navarra, la Mancomunidad de Andía y los municipios de la zona, con financiación de la UE, y gestionado por la Asociación Zunbeltz Elkartea.';

  @override
  String get acercaEnlaces => 'Enlaces';

  @override
  String get acercaFuentes => 'Información de fuentes públicas.';

  @override
  String get navProyectos => 'Proyectos';

  @override
  String get proyectosTitulo => 'Proyectos de test';

  @override
  String get proyectosVacio =>
      'Aún no hay proyectos. Pulsa + para añadir el primero.';

  @override
  String get proyectoNuevo => 'Nuevo proyecto';

  @override
  String get proyectoNombre => 'Nombre del proyecto';

  @override
  String get proyectoPersona => 'Persona tester';

  @override
  String get proyectoActividad => 'Actividad / vertical';

  @override
  String get proyectoFinca => 'Finca (apoyo)';

  @override
  String get proyectoSinFinca => 'Sin finca';

  @override
  String get proyectoFechaInicio => 'Inicio';

  @override
  String get proyectoFechaFin => 'Fin';

  @override
  String get proyectoGuardado => 'Proyecto guardado';

  @override
  String get proyectoNombreObligatorio => 'Pon un nombre al proyecto.';

  @override
  String get proyectoBorrar => 'Borrar proyecto';

  @override
  String get rentTitulo => 'Rentabilidad';

  @override
  String get rentVentas => 'Ventas';

  @override
  String get rentOtrosIngresos => 'Otros ingresos';

  @override
  String get rentGastos => 'Gastos';

  @override
  String get rentBalance => 'Balance';

  @override
  String get rentMargen => 'Margen';

  @override
  String get rentProyeccion => 'Proyección anual';

  @override
  String get detProduccion => 'Producción';

  @override
  String get detValidacion => 'Validación';

  @override
  String get detComercial => 'Comercialización';

  @override
  String get detEconomico => 'Económico';

  @override
  String get detSinDatos => 'Sin datos todavía.';

  @override
  String get detInformePdf => 'Informe del proyecto (PDF)';

  @override
  String get comNuevaTitulo => 'Nueva venta';

  @override
  String get comProducto => 'Producto';

  @override
  String get comCanal => 'Canal';

  @override
  String get comCantidad => 'Cantidad';

  @override
  String get comUnidad => 'Unidad';

  @override
  String get comPrecio => 'Precio unitario (€)';

  @override
  String get comIngreso => 'Ingreso (€)';

  @override
  String get comGuardada => 'Venta guardada';

  @override
  String get valNuevaTitulo => 'Nueva validación de producto';

  @override
  String get valDescripcion => '¿Qué se valida?';

  @override
  String get valResultado => 'Resultado';

  @override
  String get valValoracion => 'Valoración';

  @override
  String get valSinValorar => 'Sin valorar';

  @override
  String get valGuardada => 'Validación guardada';

  @override
  String get infProyTitulo => 'Informe del proyecto de test';

  @override
  String infProyResumen(String nombre, String persona) {
    return 'Proyecto: $nombre · tester: $persona';
  }

  @override
  String get comparativaPdf => 'Comparativa (PDF)';

  @override
  String get comparativaTitulo => 'Comparativa de proyectos de test';

  @override
  String get comparativaColProyecto => 'Proyecto';

  @override
  String get comparativaColTester => 'Tester';

  @override
  String get comparativaTotal => 'Total';

  @override
  String get periodoEtiqueta => 'Periodo';

  @override
  String get periodoTodo => 'Todo';

  @override
  String get periodoAnio => 'Este año';

  @override
  String get periodoTrimestre => 'Este trimestre';

  @override
  String get periodoTrimestreAnterior => 'Trimestre anterior';

  @override
  String get detDesgloseGastos => 'Desglose de gastos';

  @override
  String get detIvaSoportado => 'IVA soportado';

  @override
  String get detIvaRepercutido => 'IVA repercutido';

  @override
  String get apuCategoria => 'Categoría';

  @override
  String get apuIva => 'IVA';

  @override
  String get comIva => 'IVA';

  @override
  String get ivaNoFiscal =>
      'Cálculo orientativo. No es un módulo de declaración fiscal: el régimen (REAGP / general) lo define vuestro asesor.';

  @override
  String get detExportarCsv => 'Exportar CSV';

  @override
  String get enviarCoordinador => 'Enviar al coordinador';

  @override
  String get enviarCoordinadorTexto =>
      'Informe del proyecto de test para el coordinador del Espacio Test Zunbeltz.';

  @override
  String get enviarCoordinadorSinDestino =>
      'Configura el correo del coordinador en Ajustes.';

  @override
  String get ajustesCoordinador => 'Coordinador (envío de informes)';

  @override
  String get ajustesCoordinadorVacio => 'Sin configurar';

  @override
  String get coordinadorCorreo => 'Correo del coordinador';
}
