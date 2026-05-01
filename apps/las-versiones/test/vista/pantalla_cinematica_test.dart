import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'package:las_versiones/dominio/ambiente_archivo.dart';
import 'package:las_versiones/dominio/voz_personaje.dart';
import 'package:las_versiones/vista/pantalla_cinematica.dart';

void main() {
  group('PantallaCinematica — tap durante PlanoAmbiente', () {
    testWidgets(
      'tap durante un PlanoAmbiente avanza al siguiente plano sin '
      'esperar la duración entera — UX clave en móvil para no obligar '
      'al jugador a esperar 4-7s por plano',
      (tester) async {
        var terminada = false;
        const escena = EscenaCinematica(
          id: 'test_skip_ambiente',
          titulo: 'test',
          flagDeSalida: 'test_visto',
          ambiente: AmbienteArchivo.aticoArchivo,
          planos: [
            PlanoAmbiente(
              duracion: Duration(seconds: 60),
              textoLectura: 'Texto de la primera acotación',
            ),
            PlanoAmbiente(
              duracion: Duration(seconds: 60),
              textoLectura: 'Texto de la segunda acotación',
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp(
          home: PantallaCinematica(
            escena: escena,
            alTerminar: () => terminada = true,
          ),
        ));
        await tester.pump();

        expect(find.text('Texto de la primera acotación'), findsOneWidget);
        expect(find.text('Texto de la segunda acotación'), findsNothing);

        // Tap durante la duración del PlanoAmbiente debe saltar al
        // siguiente sin esperar 60s.
        await tester.tap(find.byType(PantallaCinematica));
        await tester.pump();

        expect(find.text('Texto de la primera acotación'), findsNothing);
        expect(find.text('Texto de la segunda acotación'), findsOneWidget);
        expect(terminada, isFalse);

        // Segundo tap salta el segundo plano y termina la escena.
        await tester.tap(find.byType(PantallaCinematica));
        await tester.pump();
        expect(terminada, isTrue);
      },
    );

    testWidgets(
      'tap durante la pausaPrevia de un PlanoDialogo NO interrumpe '
      'el ritmo — la pausa previa es deliberada y se respeta',
      (tester) async {
        const escena = EscenaCinematica(
          id: 'test_pausa_dialogo',
          titulo: 'test',
          flagDeSalida: 'test_visto',
          ambiente: AmbienteArchivo.aticoArchivo,
          planos: [
            PlanoDialogo(
              voz: VozPersonaje.maren,
              texto: 'Frase con pausa previa.',
              pausaPrevia: Duration(milliseconds: 200),
            ),
            PlanoAmbiente(
              duracion: Duration(milliseconds: 50),
              textoLectura: 'Acotación posterior',
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp(
          home: PantallaCinematica(
            escena: escena,
            alTerminar: () {},
          ),
        ));
        await tester.pump();

        // Tap durante la pausaPrevia (≤200ms) del diálogo no debe avanzar.
        await tester.tap(find.byType(PantallaCinematica));
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('Acotación posterior'), findsNothing,
            reason: 'la pausa previa del diálogo se respeta');

        // Drenar timers pendientes para que el test termine limpio.
        await tester.pumpAndSettle(const Duration(seconds: 2));
      },
    );
  });
}
