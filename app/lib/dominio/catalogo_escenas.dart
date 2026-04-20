import 'escena_cinematica.dart';
import 'plano_escena.dart';
import 'voz_personaje.dart';

/// Catálogo de escenas narrativas implementadas. Empezamos por la 1.1
/// (La llegada) — doc 13 storyboard 1. Más escenas se añaden a medida
/// que la narrativa las necesita.
class CatalogoEscenas {
  static const EscenaCinematica llegada = EscenaCinematica(
    id: '1.1',
    titulo: 'La llegada',
    flagDeSalida: 'escena_1_1_vista',
    planos: [
      PlanoAmbiente(duracion: Duration(milliseconds: 2200)),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2600),
        textoLectura: 'Una ciudad nocturna se extiende abajo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Llegas tarde.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Siempre llegáis tarde.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura: 'Sora se gira despacio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: '¿Vienes a aprender?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Mm.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura: 'El mundo se abre.',
      ),
    ],
  );

  static const List<EscenaCinematica> todas = [llegada];

  static EscenaCinematica? porId(String id) {
    for (final escena in todas) {
      if (escena.id == id) return escena;
    }
    return null;
  }
}
