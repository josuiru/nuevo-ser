import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'ambiente_archivo.dart';
import 'voz_personaje.dart';

/// Catálogo de escenas cinemáticas del Arco 2 — *La llegada de las
/// palabras* (doc 08). Estado: esqueleto. Sólo la cinemática de
/// apertura 2.0.1 está implementada para validar que el orquestador
/// puede encadenar el Arco 1 con el Arco 2 cruzando el flag de
/// cierre `arco_1_cerrado_por_la_cronista`. Las restantes 33 escenas
/// del doc 08 se irán añadiendo arco a arco siguiendo el mismo
/// patrón que el Arco 1 (cinemáticas + Brechas + Mosaico de cierre).
///
/// El Arco 2 introduce el manejo de fuentes textuales — Maren ha
/// trabajado el Arco 1 sin texto (sólo objetos, paisaje, restos).
/// Aquí entra la inscripción romana, la crónica visigoda, el dato
/// epigráfico, y con ellos los sesgos del autor que sí firma.
class EscenasArco2 {
  EscenasArco2._();

  /// Lista ordenada de escenas del Arco 2 disponibles para el
  /// orquestador. Por ahora sólo la apertura — al añadir Brechas /
  /// estaciones del arco crece como `EscenasArco1.todas`.
  static const List<EscenaCinematica> todas = [
    primerDiaDelArco,
  ];

  /// Flags institucionales adicionales que el orquestador activa al
  /// cerrar una escena del Arco 2. Mismo patrón que en Arco 1 — los
  /// flags hito ("arco_2_iniciado") viajan aquí en lugar de inflar
  /// el contrato `EscenaCinematica` de la plataforma.
  static const Map<String, Set<String>> flagsDeCierrePorEscena = {
    'escena_2_0_1_vista': {
      'arco_2_iniciado',
    },
  };

  /// 2.0.1 — *El primer día del arco*. Activa: tras el cierre del
  /// Arco 1 (flag `arco_1_cerrado_por_la_cronista` que la 1.Z
  /// activó al final). Lugar: patio del Archivo. Personajes: Isaura,
  /// Maren. La escena establece la nueva regla del oficio: a partir
  /// de aquí Maren tiene texto. Isaura le advierte que tener texto
  /// no hace el oficio más fácil — anticipo del Arco 2 entero, donde
  /// la pedagogía es aprender a leer fuentes textuales con la misma
  /// honestidad con la que leyó objetos en el Arco 1.
  ///
  /// Tono: corto, deliberadamente parco. El doc 08 §2.0.1 lo escribe
  /// con líneas mínimas (tres-cuatro palabras por turno) para marcar
  /// el inicio del trimestre — el peso narrativo viene en 2.1.1
  /// cuando bajan al sótano.
  static const EscenaCinematica primerDiaDelArco = EscenaCinematica(
    id: '2.0.1',
    titulo: 'El primer día del arco',
    flagDeSalida: 'escena_2_0_1_vista',
    flagsRequeridos: {'arco_1_cerrado_por_la_cronista'},
    ambiente: AmbienteArchivo.patioArchivo,
    planos: [
      // Encuadre temporal — primer lunes del trimestre nuevo.
      // Diciembre, semanas después del cierre del Arco 1.
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Iruña. Lunes de diciembre, nueve de la mañana. Patio del '
            'Archivo. Isaura espera con el bastón apoyado, mirando al '
            'capitel del claustro. Maren entra con un cuaderno nuevo '
            'en la mochila — el blanco de Aprendiz I.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Bienvenida.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Hola.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Has descansado?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Isaura asiente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Hoy bajamos.',
      ),

      // Maren mira hacia la escalera del sótano — primer indicio del
      // espacio nuevo del arco. Pompaelo está literalmente debajo de
      // la calle Curia: el Archivo lo conecta por una galería técnica.
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren mira hacia la escalera del sótano.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿A Pompaelo?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'A Pompaelo.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
      ),

      // Línea pedagógica clave — encuadra todo el arco. El Arco 1 fue
      // sin texto (objetos, paisaje, huesos). Ahora entra la palabra
      // escrita y con ella autorías, fechas, sesgos, omisiones.
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Hasta ahora has trabajado sin texto. A partir de hoy, '
            'tienes texto. No te creas que eso lo hace más fácil.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Ya me lo imagino.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'No te lo imaginas.',
        pausaPrevia: Duration(milliseconds: 800),
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Isaura empieza a caminar hacia las escaleras. Maren la '
            'sigue.',
      ),
    ],
  );
}
