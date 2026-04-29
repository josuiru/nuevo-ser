import 'escena_cinematica.dart';
import 'plano_escena.dart';
import 'voz_personaje.dart';

/// Variantes recurrentes de "Las máquinas desajustadas" (doc 09 §3.7).
/// Análogas a 1.8 (entrenamiento con Sora) y 2.4 (puentes con Rexán),
/// pero ambientadas con Vadic en la Zona Industrial. 3 mini-cinemáticas
/// que se rotan durante el Arco 3 entre 3.6 y 3.18.
class VariantesMaquinas {
  /// 3.7a — La máquina que miente. Vadic mide en externo, contrasta
  /// con la lectura del aparato. Habilidad de fondo: comparación
  /// decimal (DEC.02) y la noción de error pequeño · multitud.
  static const EscenaCinematica maquinaMiente = EscenaCinematica(
    id: '3.7a',
    titulo: 'Máquinas — la máquina miente',
    flagDeSalida: 'variante_3_7_a_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Sala de mezclas. Una máquina marca 0,25 l. Vadic acerca un medidor externo y lee 0,3 l.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vadic,
        texto: '0,3. Correcto. La máquina miente por 0,05.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vadic,
        texto: 'Lo que tiene el desajuste. No parece mucho.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vadic,
        texto: 'Multiplícalo por mil mezclas al día.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
    ],
  );

  /// 3.7b — Conversiones de unidades. Vadic pide explicar el porqué,
  /// no solo el cómo. Habilidad de fondo: MED.01/MED.02.
  static const EscenaCinematica conversiones = EscenaCinematica(
    id: '3.7b',
    titulo: 'Máquinas — conversiones',
    flagDeSalida: 'variante_3_7_b_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Mesa de Vadic. Una libreta con cifras: 3 kg, 0,4 l, 250 g, 1,2 kg, 750 ml.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vadic,
        texto: 'Correcto.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vadic,
        texto: 'Ahora explícame por qué.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura: 'Vadic escucha. Asiente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vadic,
        texto: 'Bien.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
    ],
  );

  /// 3.7c — m² no es m. Vadic corrige el error de aplicar el factor
  /// lineal a una superficie. Habilidad de fondo: MED.05.
  static const EscenaCinematica metroCuadrado = EscenaCinematica(
    id: '3.7c',
    titulo: 'Máquinas — el metro cuadrado',
    flagDeSalida: 'variante_3_7_c_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Plano sobre la mesa. Vadic señala un cuadrado de 1 m² y pregunta cuántos cm² entran dentro.',
      ),
      PlanoEleccion(
        voz: VozPersonaje.vadic,
        textoPrompt: '¿Cuántos centímetros cuadrados hay en un metro cuadrado?',
        opciones: [
          OpcionEleccion(
            textoJugador: '100.',
            textoRespuesta:
                'No. Un metro es cien centímetros. Pero estamos midiendo área. Piénsalo otra vez.',
          ),
          OpcionEleccion(
            textoJugador: '10.000.',
            textoRespuesta: 'Ahora. Otra vez.',
          ),
        ],
      ),
    ],
  );

  static const List<EscenaCinematica> todas = [
    maquinaMiente,
    conversiones,
    metroCuadrado,
  ];

  static EscenaCinematica? elegirSiguiente(
    Set<String> usadasRecientemente,
  ) {
    for (final variante in todas) {
      if (!usadasRecientemente.contains(variante.id)) {
        return variante;
      }
    }
    return null;
  }
}
