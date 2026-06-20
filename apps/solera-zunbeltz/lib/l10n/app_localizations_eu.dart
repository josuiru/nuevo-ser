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
  String get navCuaderno => 'Koadernoa';

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
  String get cuadernoProximamente => 'Abeltzaintza-koadernoa';

  @override
  String get cuadernoProximamenteCuerpo =>
      'Animaliak, sortak, larreratzea eta eguneroko gertaerak. Geroagoko fase batean eskuragarri.';

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
      'Behin-behineko bertsioa — eduki arautzaileak teknikari eskudunek baliozkotzeko zain.';
}
