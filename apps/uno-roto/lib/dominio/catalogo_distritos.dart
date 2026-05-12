import 'package:flutter/material.dart';

import 'distrito.dart';
import 'fragmento_en_tejado.dart';

/// Catálogo fijo de distritos del MVP. Posiciones en el mapa siguen la
/// biblia §3.4: Tejados en el centro, Canales al oeste, Mercado al este,
/// Industria al sur, Puerto más al sur todavía, Afueras al noroeste, y
/// la Montaña en lo alto (Era 3).
class CatalogoDistritos {
  CatalogoDistritos._();

  static const Distrito tejados = Distrito(
    identificador: 'tejados',
    nombre: 'Tejados del Centro',
    descripcionCorta: 'Donde Sora te enseñó a cortar.',
    colorAcento: Color(0xFF8A5CFF),
    esquirlasParaDesbloquear: 0,
    xMapa: 0.5,
    yMapa: 0.45,
    mezclaPuzzles: {
      TipoFragmentoEnTejado.unitario: 0.16,
      TipoFragmentoEnTejado.sumaBasica: 0.07,
      TipoFragmentoEnTejado.lecturaFraccion: 0.09,
      TipoFragmentoEnTejado.lecturaDecimal: 0.07,
      TipoFragmentoEnTejado.comparacion: 0.10,
      TipoFragmentoEnTejado.comparacionUnidad: 0.08,
      TipoFragmentoEnTejado.comparacionMedia: 0.07,
      TipoFragmentoEnTejado.espejo: 0.10,
      TipoFragmentoEnTejado.multiplos: 0.08,
      TipoFragmentoEnTejado.simplificar: 0.07,
      TipoFragmentoEnTejado.amplificar: 0.07,
      TipoFragmentoEnTejado.porcentaje: 0.04,
    },
    saludoPrimeraVisita: 'Tejados. Lo básico. Aquí te haces la mano.',
  );

  static const Distrito canales = Distrito(
    identificador: 'canales',
    nombre: 'Barrio de los Canales',
    descripcionCorta: 'Donde los Fragmentos se transforman.',
    colorAcento: Color(0xFFFF9A6B),
    esquirlasParaDesbloquear: 20,
    xMapa: 0.22,
    yMapa: 0.55,
    mezclaPuzzles: {
      TipoFragmentoEnTejado.dual: 0.12,
      TipoFragmentoEnTejado.comparacionDecimal: 0.08,
      TipoFragmentoEnTejado.comparacionDistinta: 0.08,
      TipoFragmentoEnTejado.redondeoDecimal: 0.08,
      TipoFragmentoEnTejado.mixtoAImpropio: 0.08,
      TipoFragmentoEnTejado.espejo: 0.08,
      TipoFragmentoEnTejado.simplificar: 0.08,
      TipoFragmentoEnTejado.amplificar: 0.08,
      TipoFragmentoEnTejado.ordenarDecimales: 0.07,
      TipoFragmentoEnTejado.ordenarFracciones: 0.07,
      TipoFragmentoEnTejado.unitario: 0.06,
      TipoFragmentoEnTejado.decimal: 0.06,
      TipoFragmentoEnTejado.jerarquia: 0.06,
    },
    saludoPrimeraVisita:
        'Canales. Aquí los Fragmentos se transforman. Compáralos.',
  );

  static const Distrito mercado = Distrito(
    identificador: 'mercado',
    nombre: 'Mercado de la Luz',
    descripcionCorta: 'Porcentajes y proporciones, intercambios.',
    colorAcento: Color(0xFFFF7ED0),
    esquirlasParaDesbloquear: 40,
    xMapa: 0.78,
    yMapa: 0.55,
    mezclaPuzzles: {
      TipoFragmentoEnTejado.porcentaje: 0.10,
      TipoFragmentoEnTejado.porcentajeCantidad: 0.10,
      TipoFragmentoEnTejado.porcentajeDe: 0.08,
      TipoFragmentoEnTejado.proporcional: 0.10,
      TipoFragmentoEnTejado.razon: 0.08,
      TipoFragmentoEnTejado.reglaDeTres: 0.08,
      TipoFragmentoEnTejado.fraccionDeCantidad: 0.08,
      TipoFragmentoEnTejado.aumentoDescuento: 0.08,
      TipoFragmentoEnTejado.escala: 0.07,
      TipoFragmentoEnTejado.espejo: 0.06,
      TipoFragmentoEnTejado.unitario: 0.05,
      TipoFragmentoEnTejado.decimal: 0.06,
      TipoFragmentoEnTejado.dual: 0.06,
    },
    saludoPrimeraVisita:
        'Mercado de la Luz. Proporciones e intercambios.',
  );

  static const Distrito industria = Distrito(
    identificador: 'industria',
    nombre: 'Zona Industrial',
    descripcionCorta: 'Medidas exactas y operaciones.',
    colorAcento: Color(0xFF7EE8D7),
    esquirlasParaDesbloquear: 60,
    xMapa: 0.5,
    yMapa: 0.72,
    mezclaPuzzles: {
      TipoFragmentoEnTejado.decimal: 0.11,
      TipoFragmentoEnTejado.operacionDecimal: 0.11,
      TipoFragmentoEnTejado.longitud: 0.08,
      TipoFragmentoEnTejado.masaCapacidad: 0.08,
      TipoFragmentoEnTejado.tiempo: 0.07,
      TipoFragmentoEnTejado.superficie: 0.07,
      TipoFragmentoEnTejado.angulo: 0.06,
      TipoFragmentoEnTejado.jerarquia: 0.07,
      TipoFragmentoEnTejado.jerarquiaFracciones: 0.05,
      TipoFragmentoEnTejado.operacionMixta: 0.06,
      TipoFragmentoEnTejado.ordenarDecimales: 0.06,
      TipoFragmentoEnTejado.lecturaDecimal: 0.06,
      TipoFragmentoEnTejado.impropio: 0.06,
      TipoFragmentoEnTejado.dual: 0.06,
    },
    saludoPrimeraVisita:
        'Industria. Medidas exactas, cifra por cifra.',
  );

  static const Distrito puerto = Distrito(
    identificador: 'puerto',
    nombre: 'Puerto Silencioso',
    descripcionCorta: 'Aguas profundas. Divisibilidad y orden.',
    colorAcento: Color(0xFF4DC9FF),
    esquirlasParaDesbloquear: 80,
    xMapa: 0.5,
    yMapa: 0.88,
    mezclaPuzzles: {
      TipoFragmentoEnTejado.divisibilidad: 0.09,
      TipoFragmentoEnTejado.divisores: 0.08,
      TipoFragmentoEnTejado.mcmMcd: 0.08,
      TipoFragmentoEnTejado.primo: 0.08,
      TipoFragmentoEnTejado.multiplos: 0.07,
      TipoFragmentoEnTejado.impropio: 0.08,
      TipoFragmentoEnTejado.dual: 0.12,
      TipoFragmentoEnTejado.espejo: 0.10,
      TipoFragmentoEnTejado.media: 0.08,
      TipoFragmentoEnTejado.modaMediana: 0.06,
      TipoFragmentoEnTejado.probabilidad: 0.06,
      TipoFragmentoEnTejado.probabilidadPorcentaje: 0.05,
      TipoFragmentoEnTejado.decimal: 0.05,
    },
    saludoPrimeraVisita:
        'Puerto. Divisibilidad y estadística. Las aguas están muy claras.',
  );

  static const Distrito afueras = Distrito(
    identificador: 'afueras',
    nombre: 'Afueras',
    descripcionCorta: 'Donde los datos cuentan historias.',
    colorAcento: Color(0xFFB392FF),
    esquirlasParaDesbloquear: 100,
    xMapa: 0.22,
    yMapa: 0.28,
    mezclaPuzzles: {
      TipoFragmentoEnTejado.poligono: 0.08,
      TipoFragmentoEnTejado.perimetro: 0.08,
      TipoFragmentoEnTejado.areaRectangulo: 0.08,
      TipoFragmentoEnTejado.areaTriangulo: 0.07,
      TipoFragmentoEnTejado.circulo: 0.07,
      TipoFragmentoEnTejado.volumen: 0.06,
      TipoFragmentoEnTejado.simetria: 0.06,
      TipoFragmentoEnTejado.graficoBarras: 0.07,
      TipoFragmentoEnTejado.graficoCircular: 0.07,
      TipoFragmentoEnTejado.ecuacionLineal: 0.06,
      TipoFragmentoEnTejado.proporcional: 0.06,
      TipoFragmentoEnTejado.porcentaje: 0.06,
      TipoFragmentoEnTejado.escala: 0.06,
      TipoFragmentoEnTejado.razon: 0.06,
      TipoFragmentoEnTejado.decimal: 0.06,
    },
    saludoPrimeraVisita:
        'Afueras. Geometría, gráficos y horizonte.',
  );

  static const Distrito montana = Distrito(
    identificador: 'montana',
    nombre: 'La Montaña',
    descripcionCorta: 'Donde los Fragmentos son abstractos.',
    colorAcento: Color(0xFFFFE4B5),
    esquirlasParaDesbloquear: 150,
    xMapa: 0.5,
    yMapa: 0.15,
    mezclaPuzzles: {
      TipoFragmentoEnTejado.potenciaNatural: 0.13,
      TipoFragmentoEnTejado.raizCuadrada: 0.13,
      TipoFragmentoEnTejado.pitagoras: 0.13,
      TipoFragmentoEnTejado.ecuacionAmbosLados: 0.12,
      TipoFragmentoEnTejado.enteroSigno: 0.12,
      TipoFragmentoEnTejado.valorAbsoluto: 0.12,
      TipoFragmentoEnTejado.sistemaDosXDos: 0.12,
      TipoFragmentoEnTejado.relacionLineal: 0.13,
    },
    saludoPrimeraVisita:
        'La Montaña. Ábaco, álgebra y abstracción.',
  );

  static const List<Distrito> todos = [
    tejados,
    canales,
    mercado,
    industria,
    puerto,
    afueras,
    montana,
  ];
}
