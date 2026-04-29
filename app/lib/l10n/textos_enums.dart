import '../dominio/cuaderno.dart';
import '../dominio/habilidad.dart';
import '../dominio/problema_moda_mediana.dart';
import '../dominio/rango_narrativo.dart';
import '../dominio/ritmo_juego.dart';
import '../sonido/capa_audio.dart';
import 'app_localizations.dart';

/// Mapeo de enums del dominio a strings localizados. Se mantiene fuera
/// del dominio para no acoplarlo a Flutter ni a la capa de l10n —
/// `nombreVisible` (castellano hardcodeado) sigue existiendo y es el
/// fallback canónico.

extension RangoNarrativoTextos on RangoNarrativo {
  String nombreLocalizado(AppLocalizations textos) {
    switch (this) {
      case RangoNarrativo.aprendiz1:
        return textos.rangoAprendiz1;
      case RangoNarrativo.aprendiz2:
        return textos.rangoAprendiz2;
      case RangoNarrativo.aprendiz3:
        return textos.rangoAprendiz3;
      case RangoNarrativo.iniciado:
        return textos.rangoIniciado;
    }
  }
}

extension RitmoJuegoTextos on RitmoJuego {
  String nombreLocalizado(AppLocalizations textos) {
    switch (this) {
      case RitmoJuego.tranquilo:
        return textos.ritmoTranquilo;
      case RitmoJuego.estandar:
        return textos.ritmoEstandar;
      case RitmoJuego.exigente:
        return textos.ritmoExigente;
    }
  }

  String descripcionLocalizada(AppLocalizations textos) {
    switch (this) {
      case RitmoJuego.tranquilo:
        return textos.ritmoTranquiloDesc;
      case RitmoJuego.estandar:
        return textos.ritmoEstandarDesc;
      case RitmoJuego.exigente:
        return textos.ritmoExigenteDesc;
    }
  }
}

extension CapaAudioTextos on CapaAudio {
  String nombreLocalizado(AppLocalizations textos) {
    switch (this) {
      case CapaAudio.ambient:
        return textos.capaAmbient;
      case CapaAudio.musica:
        return textos.capaMusica;
      case CapaAudio.efectos:
        return textos.capaEfectos;
      case CapaAudio.narrativos:
        return textos.capaNarrativos;
    }
  }
}

extension CategoriaCuadernoTextos on CategoriaCuaderno {
  String nombreLocalizado(AppLocalizations textos) {
    switch (this) {
      case CategoriaCuaderno.personajes:
        return textos.catCuadernoPersonajes;
      case CategoriaCuaderno.fragmentos:
        return textos.catCuadernoFragmentos;
      case CategoriaCuaderno.lugares:
        return textos.catCuadernoLugares;
      case CategoriaCuaderno.historia:
        return textos.catCuadernoHistoria;
      case CategoriaCuaderno.naturaleza:
        return textos.catCuadernoNaturaleza;
      case CategoriaCuaderno.mitos:
        return textos.catCuadernoMitos;
    }
  }
}

extension ModoEstadisticoTextos on ModoEstadistico {
  String etiquetaLocalizada(AppLocalizations textos) {
    switch (this) {
      case ModoEstadistico.moda:
        return textos.estadisticoModa;
      case ModoEstadistico.mediana:
        return textos.estadisticoMediana;
    }
  }
}

extension NivelMaestriaTextos on NivelMaestria {
  String nombreLocalizado(AppLocalizations textos) {
    switch (this) {
      case NivelMaestria.inexplorada:
        return textos.habNivelInexplorada;
      case NivelMaestria.introducida:
        return textos.habNivelIntroducida;
      case NivelMaestria.enDesarrollo:
        return textos.habNivelEnDesarrollo;
      case NivelMaestria.competente:
        return textos.habNivelCompetente;
      case NivelMaestria.maestria:
        return textos.habNivelMaestria;
    }
  }
}
