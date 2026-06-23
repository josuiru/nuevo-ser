// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class AppLocalizationsEu extends AppLocalizations {
  AppLocalizationsEu([String locale = 'eu']) : super(locale);

  @override
  String get appTitulo => 'Solera Zunbeltz';

  @override
  String get navHoy => 'Gaur';

  @override
  String get navFincas => 'Finkak';

  @override
  String get navSeguimiento => 'Jarraipena';

  @override
  String get navAjustes => 'Ezarpenak';

  @override
  String get onboardingTitulo => 'Solera Zunbeltz';

  @override
  String get onboardingCuerpo =>
      'Nekazaritza Saiakuntza Guneko tresna: kudeatu finkak, banatu mantentze-lanak eta egin saiakuntzaren jarraipena. Estaldurarik gabe ere funtzionatzen du mendian.';

  @override
  String get onboardingBoton => 'Hasi';

  @override
  String get hoyTitulo => 'Gaur';

  @override
  String hoyResumenTareas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n zeregin zabalik',
      one: 'Zeregin 1 zabalik',
      zero: 'Zereginik gabe',
    );
    return '$_temp0';
  }

  @override
  String get hoyVacio =>
      'Oraindik ez dago ezer erregistratuta. Hasi azpiegitura bat mapan markatuz, Finketan.';

  @override
  String get hoyVerTablero => 'Ikusi zereginak';

  @override
  String get ajustesIdioma => 'Hizkuntza';

  @override
  String get ajustesIdiomaCastellano => 'Gaztelania';

  @override
  String get ajustesIdiomaEuskera => 'Euskara';

  @override
  String get ajustesAcercaDe => 'Honi buruz';

  @override
  String ajustesVersion(String version) {
    return '$version bertsioa';
  }

  @override
  String get ajustesProvisional =>
      'Aurretiazko bertsioa. Sortzen dituen parte eta txostenak orientagarriak dira eta haien formatua baliozkotzeke dago. Paper-lan ofiziala (ustiategi-liburua, PAC koadernoa, trazabilitatea…) geroagoko faseetan iritsiko da.';

  @override
  String get comunGuardar => 'Gorde';

  @override
  String get comunCancelar => 'Utzi';

  @override
  String get comunBorrar => 'Ezabatu';

  @override
  String get comunFecha => 'Data';

  @override
  String get mapaNuevoPunto => 'Puntu berria';

  @override
  String get mapaUsarGps => 'Erabili uneko GPSa';

  @override
  String get mapaUsarCentro => 'Erabili maparen erdigunea';

  @override
  String get mapaElegirFinca => 'Zein finkatan?';

  @override
  String get mapaSinPuntos =>
      'Oraindik ez dago punturik. Ukitu mapa edo sakatu «Puntu berria» lehena markatzeko.';

  @override
  String get mapaTocaParaAnadir => 'Ukitu mapa puntu bat gehitzeko';

  @override
  String get mapaTocaNuevaUbicacion => 'Ukitu puntuaren kokaleku berria';

  @override
  String get puntoRecolocado => 'Puntua birkokatuta';

  @override
  String get fichaRecolocar => 'Kokatu berriro mapan';

  @override
  String get mapaGpsNoDisponible =>
      'GPSa ez dago eskuragarri — bete kokapena eskuz.';

  @override
  String get mapaCapas => 'Geruzak';

  @override
  String get mapaMapa => 'Mapa';

  @override
  String get mapaGps => 'GPS';

  @override
  String get mapaTablero => 'Zereginak';

  @override
  String get puntoNuevoTitulo => 'Azpiegitura-puntu berria';

  @override
  String get puntoFinca => 'Finka';

  @override
  String get puntoTipo => 'Mota';

  @override
  String get puntoNombre => 'Izena';

  @override
  String get puntoEstado => 'Egoera';

  @override
  String get puntoNotas => 'Oharrak';

  @override
  String get puntoFotos => 'Argazkiak';

  @override
  String get puntoLatitud => 'Latitudea';

  @override
  String get puntoLongitud => 'Longitudea';

  @override
  String get puntoGuardado => 'Puntua gordeta';

  @override
  String get fichaPuntoTareas => 'Puntuaren zereginak';

  @override
  String get fichaSinTareas => 'Puntu honetan zereginik ez.';

  @override
  String get fichaNuevaTarea => 'Zeregin berria';

  @override
  String get fichaBorrarPunto => 'Ezabatu puntua';

  @override
  String get fichaCoordenadas => 'Koordenatuak';

  @override
  String get fichaSinCoordenadas => 'Koordenaturik gabe';

  @override
  String get tareaNuevaTitulo => 'Zeregin berria';

  @override
  String get tareaTitulo => 'Izenburua';

  @override
  String get tareaDescripcion => 'Deskribapena';

  @override
  String get tareaResponsable => 'Arduraduna';

  @override
  String get tareaPrioridad => 'Lehentasuna';

  @override
  String get tareaEstado => 'Egoera';

  @override
  String get tareaFechaObjetivo => 'Helburu-data';

  @override
  String get tareaSinFecha => 'Datarik gabe';

  @override
  String get tareaFotosAntes => 'Aurreko argazkiak';

  @override
  String get tareaFotosDespues => 'Ondorengo argazkiak';

  @override
  String get tareaCoste => 'Kostua (€)';

  @override
  String get tareaGuardada => 'Zeregina gordeta';

  @override
  String get tareaTituloObligatorio => 'Jarri izenburua zereginari.';

  @override
  String get tableroTitulo => 'Mantentze-zereginak';

  @override
  String get tableroTodas => 'Guztiak';

  @override
  String get tableroFiltroFinca => 'Finka';

  @override
  String get tableroFiltroEstado => 'Egoera';

  @override
  String get tableroSinTareas => 'Ez dago zereginik iragazki hauekin.';

  @override
  String get tableroPartePdf => 'PDF txostena';

  @override
  String get tableroGenerandoPdf => 'Txostena sortzen…';

  @override
  String get tareaDeFinca => 'Finkaren zeregina';

  @override
  String get parteTitulo => 'Mantentze-txostena';

  @override
  String get parteSubtitulo =>
      'Zunbeltz Nekazaritza Saiakuntza Gunea · BEHIN-BEHINEKO dokumentua';

  @override
  String get parteProvisional =>
      'BEHIN-BEHINEKO DOKUMENTUA — formatua baliozkotzeke.';

  @override
  String parteResumenTareas(int n) {
    return 'Sartutako zereginak: $n';
  }

  @override
  String get parteColPunto => 'Puntua';

  @override
  String get parteColTarea => 'Zeregina';

  @override
  String get parteColResponsable => 'Arduraduna';

  @override
  String get parteColPrioridad => 'Lehentasuna';

  @override
  String get parteColEstado => 'Egoera';

  @override
  String get parteColFecha => 'Helburu-data';

  @override
  String get parteSinResponsable => 'Esleitu gabe';

  @override
  String get segTitulo => 'Jarraipena';

  @override
  String get segIndicadores => 'Aldiko adierazleak';

  @override
  String get segTodasFincas => 'Finka guztiak';

  @override
  String get segAlimentacion => 'Elikadura (kg)';

  @override
  String get segPariciones => 'Erditzeak';

  @override
  String get segProductos => 'Merkaturatutako produktuak';

  @override
  String get segIngresos => 'Sarrerak';

  @override
  String get segGastos => 'Gastuak';

  @override
  String get segBalance => 'Balantzea';

  @override
  String get segPestanaActividad => 'Jarduera';

  @override
  String get segPestanaEconomico => 'Ekonomikoa';

  @override
  String get segNuevaActividad => 'Erregistratu jarduera';

  @override
  String get segNuevoApunte => 'Apunte ekonomikoa';

  @override
  String get segSinRegistros => 'Oraindik erregistrorik ez.';

  @override
  String get segInformePdf => 'Jarraipen-txostena (PDF)';

  @override
  String get segGenerandoInforme => 'Txostena sortzen…';

  @override
  String get actNuevaTitulo => 'Erregistratu jarduera';

  @override
  String get actTipo => 'Jarduera mota';

  @override
  String get actCantidad => 'Kopurua';

  @override
  String get actLote => 'Sorta / artaldea';

  @override
  String get actNotas => 'Oharrak';

  @override
  String get actGuardada => 'Jarduera erregistratuta';

  @override
  String get actCantidadObligatoria => 'Adierazi zerotik gorako kopuru bat.';

  @override
  String get apuNuevoTitulo => 'Apunte ekonomiko berria';

  @override
  String get apuTipo => 'Mota';

  @override
  String get apuConcepto => 'Kontzeptua';

  @override
  String get apuImporte => 'Zenbatekoa (€)';

  @override
  String get apuNotas => 'Oharrak';

  @override
  String get apuGuardado => 'Apuntea gordeta';

  @override
  String get apuImporteObligatorio => 'Adierazi zerotik gorako zenbateko bat.';

  @override
  String get informeSegTitulo => 'Jarraipen-txostena';

  @override
  String informeSegResumenPeriodo(int actividades, int apuntes) {
    return 'Erregistroak: $actividades · apunteak: $apuntes';
  }

  @override
  String get informeSegTablaActividad => 'Jarduera-erregistroak';

  @override
  String get informeSegTablaEconomico => 'Apunte ekonomikoak';

  @override
  String get informeSegColTipo => 'Mota';

  @override
  String get informeSegColCantidad => 'Kopurua';

  @override
  String get informeSegColConcepto => 'Kontzeptua';

  @override
  String get informeSegColImporte => 'Zenbatekoa (€)';

  @override
  String get meteoTitulo => 'Iragarpena';

  @override
  String get meteoHoy => 'Gaur';

  @override
  String get meteoSinConexion =>
      'Ezin izan da iragarpena lortu. Egiaztatu konexioa eta saiatu berriro.';

  @override
  String get meteoReintentar => 'Saiatu berriro';

  @override
  String get meteoOrientativo =>
      'Iragarpen orientagarria (Open-Meteo). Ez du ordezkatzen abeltzainaren ezta albaitariaren irizpidea.';

  @override
  String get avisoHelada => 'Izotza';

  @override
  String get avisoLluvia => 'Euria';

  @override
  String get avisoViento => 'Haize bortitza';

  @override
  String get avisoCalor => 'Beroa';

  @override
  String get avisoBuenManejo => 'Lan egiteko egun ona';

  @override
  String get acercaTitulo => 'Saiakuntza Guneari buruz';

  @override
  String get acercaIntro =>
      'Zunbeltz Nafarroako lehen Nekazaritza eta Abeltzaintza Saiakuntza Gunea da: ekintzaileek abeltzaintza ekologiko estentsiboko proiektu bat denbora-tarte mugatu batean probatzeko inkubagailua, abeltzain adituen laguntzarekin, Zunbeltz (231 ha) eta La Planilla (197 ha) finketan. Nafarroako Gobernuak, Andiako Mankomunitateak eta inguruko udalerriek bultzatua, EBren finantzaketarekin, eta Zunbeltz Elkarteak kudeatua.';

  @override
  String get acercaEnlaces => 'Estekak';

  @override
  String get acercaFuentes => 'Informazioa iturri publikoetatik.';

  @override
  String get navProyectos => 'Proiektuak';

  @override
  String get proyectosTitulo => 'Test-proiektuak';

  @override
  String get proyectosVacio =>
      'Oraindik ez dago proiekturik. Sakatu + lehena gehitzeko.';

  @override
  String get proyectoNuevo => 'Proiektu berria';

  @override
  String get proyectoNombre => 'Proiektuaren izena';

  @override
  String get proyectoPersona => 'Tester pertsona';

  @override
  String get proyectoActividad => 'Jarduera / bertikala';

  @override
  String get proyectoFinca => 'Finka (laguntza)';

  @override
  String get proyectoSinFinca => 'Finkarik gabe';

  @override
  String get proyectoFechaInicio => 'Hasiera';

  @override
  String get proyectoFechaFin => 'Amaiera';

  @override
  String get proyectoGuardado => 'Proiektua gordeta';

  @override
  String get proyectoNombreObligatorio => 'Jarri izena proiektuari.';

  @override
  String get proyectoBorrar => 'Ezabatu proiektua';

  @override
  String get rentTitulo => 'Errentagarritasuna';

  @override
  String get rentVentas => 'Salmentak';

  @override
  String get rentOtrosIngresos => 'Beste sarrera batzuk';

  @override
  String get rentGastos => 'Gastuak';

  @override
  String get rentBalance => 'Balantzea';

  @override
  String get rentMargen => 'Marjina';

  @override
  String get rentProyeccion => 'Urteko proiekzioa';

  @override
  String get detProduccion => 'Ekoizpena';

  @override
  String get detValidacion => 'Balidazioa';

  @override
  String get detComercial => 'Merkaturatzea';

  @override
  String get detEconomico => 'Ekonomikoa';

  @override
  String get detSinDatos => 'Oraindik daturik ez.';

  @override
  String get detInformePdf => 'Proiektuaren txostena (PDF)';

  @override
  String get comNuevaTitulo => 'Salmenta berria';

  @override
  String get comProducto => 'Produktua';

  @override
  String get comCanal => 'Kanala';

  @override
  String get comCantidad => 'Kopurua';

  @override
  String get comUnidad => 'Unitatea';

  @override
  String get comPrecio => 'Unitateko prezioa (€)';

  @override
  String get comIngreso => 'Sarrera (€)';

  @override
  String get comGuardada => 'Salmenta gordeta';

  @override
  String get valNuevaTitulo => 'Produktuaren balidazio berria';

  @override
  String get valDescripcion => 'Zer balidatzen da?';

  @override
  String get valResultado => 'Emaitza';

  @override
  String get valValoracion => 'Balorazioa';

  @override
  String get valSinValorar => 'Baloratu gabe';

  @override
  String get valGuardada => 'Balidazioa gordeta';

  @override
  String get infProyTitulo => 'Test-proiektuaren txostena';

  @override
  String infProyResumen(String nombre, String persona) {
    return 'Proiektua: $nombre · testerra: $persona';
  }

  @override
  String get comparativaPdf => 'Konparaketa (PDF)';

  @override
  String get comparativaTitulo => 'Test-proiektuen konparaketa';

  @override
  String get comparativaColProyecto => 'Proiektua';

  @override
  String get comparativaColTester => 'Testerra';

  @override
  String get comparativaTotal => 'Guztira';

  @override
  String get periodoEtiqueta => 'Aldia';

  @override
  String get periodoTodo => 'Dena';

  @override
  String get periodoAnio => 'Aurten';

  @override
  String get periodoTrimestre => 'Hiruhileko hau';

  @override
  String get periodoTrimestreAnterior => 'Aurreko hiruhilekoa';

  @override
  String get detDesgloseGastos => 'Gastuen banakapena';

  @override
  String get detIvaSoportado => 'Jasandako BEZa';

  @override
  String get detIvaRepercutido => 'Jasanarazitako BEZa';

  @override
  String get apuCategoria => 'Kategoria';

  @override
  String get apuIva => 'BEZ';

  @override
  String get comIva => 'BEZ';

  @override
  String get ivaNoFiscal =>
      'Kalkulu orientagarria. Ez da zerga-aitorpenerako modulua: araubidea (REAGP / orokorra) zuen aholkulariak zehazten du.';

  @override
  String get detExportarCsv => 'Esportatu CSV';
}
