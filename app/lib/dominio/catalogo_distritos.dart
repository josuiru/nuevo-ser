import 'package:flutter/material.dart';

import 'distrito.dart';
import 'fragmento_en_tejado.dart';

/// Catálogo fijo de distritos del MVP. Posiciones en el mapa siguen la
/// biblia §3.4: Tejados en el centro, Canales al oeste, Mercado al este,
/// Industria al sur, Puerto más al sur todavía, Afueras al noroeste, y
/// la Montaña en lo alto (inalcanzable).
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
      TipoFragmentoEnTejado.unitario: 0.65,
      TipoFragmentoEnTejado.espejo: 0.25,
      TipoFragmentoEnTejado.decimal: 0.1,
    },
    saludoPrimeraVisita: 'Tejados. Lo básico. Aquí te haces la mano.',
  );

  static const Distrito canales = Distrito(
    identificador: 'canales',
    nombre: 'Barrio de los Canales',
    descripcionCorta: 'Donde los Fragmentos se juntan.',
    colorAcento: Color(0xFFFF9A6B),
    esquirlasParaDesbloquear: 20,
    xMapa: 0.22,
    yMapa: 0.55,
    mezclaPuzzles: {
      TipoFragmentoEnTejado.unitario: 0.2,
      TipoFragmentoEnTejado.espejo: 0.25,
      TipoFragmentoEnTejado.dual: 0.45,
      TipoFragmentoEnTejado.decimal: 0.1,
    },
    saludoPrimeraVisita:
        'Canales. Aquí los Fragmentos vienen de dos en dos. Fúndelos.',
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
      TipoFragmentoEnTejado.porcentaje: 0.4,
      TipoFragmentoEnTejado.proporcional: 0.3,
      TipoFragmentoEnTejado.espejo: 0.15,
      TipoFragmentoEnTejado.unitario: 0.15,
    },
    saludoPrimeraVisita:
        'Mercado de la Luz. Aquí todo se intercambia. Presta atención.',
  );

  static const Distrito industria = Distrito(
    identificador: 'industria',
    nombre: 'Zona Industrial',
    descripcionCorta: 'Medidas exactas, decimales.',
    colorAcento: Color(0xFF7EE8D7),
    esquirlasParaDesbloquear: 60,
    xMapa: 0.5,
    yMapa: 0.72,
    mezclaPuzzles: {
      TipoFragmentoEnTejado.decimal: 0.45,
      TipoFragmentoEnTejado.impropio: 0.2,
      TipoFragmentoEnTejado.unitario: 0.2,
      TipoFragmentoEnTejado.porcentaje: 0.15,
    },
    saludoPrimeraVisita:
        'Industria. Aquí no valen los aproximados. Cifra por cifra.',
  );

  static const Distrito puerto = Distrito(
    identificador: 'puerto',
    nombre: 'Puerto Silencioso',
    descripcionCorta: 'Aguas profundas. Pesos pesados.',
    colorAcento: Color(0xFF4DC9FF),
    esquirlasParaDesbloquear: 80,
    xMapa: 0.5,
    yMapa: 0.88,
    mezclaPuzzles: {
      TipoFragmentoEnTejado.unitario: 0.35,
      TipoFragmentoEnTejado.impropio: 0.3,
      TipoFragmentoEnTejado.dual: 0.2,
      TipoFragmentoEnTejado.espejo: 0.15,
    },
    saludoPrimeraVisita:
        'Puerto. Aquí los Fragmentos son grandes. No tengas prisa.',
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
      TipoFragmentoEnTejado.proporcional: 0.3,
      TipoFragmentoEnTejado.porcentaje: 0.2,
      TipoFragmentoEnTejado.decimal: 0.2,
      TipoFragmentoEnTejado.espejo: 0.15,
      TipoFragmentoEnTejado.dual: 0.15,
    },
    saludoPrimeraVisita:
        'Afueras. Aquí se ve el horizonte. Y la Montaña.',
  );

  static const List<Distrito> todos = [
    tejados,
    canales,
    mercado,
    industria,
    puerto,
    afueras,
  ];
}
