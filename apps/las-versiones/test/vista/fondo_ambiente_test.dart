import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'package:las_versiones/dominio/ambiente_archivo.dart';
import 'package:las_versiones/vista/fondo_ambiente.dart';

void main() {
  group('FondoAmbiente', () {
    testWidgets(
      'cualquier ambiente expande el fondo a todo el espacio del padre '
      'mediante SizedBox.expand — el motivo concreto (foto o '
      'CustomPaint) lo decide el widget internamente',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: FondoAmbiente(ambiente: AmbienteArchivo.bibliotecaArchivo),
            ),
          ),
        ));

        expect(find.byType(FondoAmbiente), findsOneWidget);
        // El SizedBox.expand interno garantiza que el fondo ocupa todo
        // el espacio disponible del padre, independientemente de si el
        // motivo concreto es Image o CustomPaint.
        expect(
          find.descendant(
            of: find.byType(FondoAmbiente),
            matching: find.byType(SizedBox),
          ),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'el ambiente neutro del core no rompe — cae al motivo neutro sin '
      'lanzar excepción',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: FondoAmbiente(ambiente: AmbienteEscenaNeutro()),
            ),
          ),
        ));
        expect(find.byType(FondoAmbiente), findsOneWidget);
      },
    );

    testWidgets(
      'el fondo es decorativo — se excluye de la semántica accesible',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: FondoAmbiente(ambiente: AmbienteArchivo.dolmenAralar),
          ),
        ));
        expect(
          find.descendant(
            of: find.byType(FondoAmbiente),
            matching: find.byType(ExcludeSemantics),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ambiente sin foto asociada — cae al motivo procedural, sin Image '
      'en el árbol. Probado con `cocheIsaura` (espacio íntimo en '
      'movimiento sin candidata libre razonable; desde F2-29 el motivo '
      'procedural es `interiorCoche` con ventanilla lateral + horizonte '
      '+ postes desplazándose, ya no `neutro` genérico)',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: FondoAmbiente(ambiente: AmbienteArchivo.cocheIsaura),
            ),
          ),
        ));

        expect(find.byType(Image), findsNothing);
        expect(
          find.descendant(
            of: find.byType(FondoAmbiente),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ambiente con foto asociada — renderiza Image dentro del Stack '
      'fotográfico (la foto va sobre el fondo oscuro y bajo la veladura)',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: FondoAmbiente(ambiente: AmbienteArchivo.monasterioLeyre),
            ),
          ),
        ));

        expect(
          find.descendant(
            of: find.byType(FondoAmbiente),
            matching: find.byType(Image),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'todos los ambientes catalogados en AmbienteArchivo se renderizan '
      'sin lanzar — barrido smoke por todas las categorías visuales',
      (tester) async {
        const ambientes = <AmbienteArchivo>[
          AmbienteArchivo.salaEvaluacion,
          AmbienteArchivo.archivoNocturno,
          AmbienteArchivo.sierraAmanecer,
          AmbienteArchivo.cuevaInterior,
          AmbienteArchivo.patioArchivo,
          AmbienteArchivo.aticoArchivo,
          AmbienteArchivo.salonConcilio,
          AmbienteArchivo.cocinaArchivo,
          AmbienteArchivo.cocinaCasaMaren,
          AmbienteArchivo.cuartoCasaMaren,
          AmbienteArchivo.cocheIsaura,
          AmbienteArchivo.cocheAitor,
          AmbienteArchivo.cocheMarina,
          AmbienteArchivo.dolmenAralar,
          AmbienteArchivo.bosqueHayas,
          AmbienteArchivo.salaGrabadosParietales,
          AmbienteArchivo.yacimientoIrulegi,
          AmbienteArchivo.museoNavarra,
          AmbienteArchivo.pompeloSubterranea,
          AmbienteArchivo.iglesiaSanCernin,
          AmbienteArchivo.mezquitaCatedralTudela,
          AmbienteArchivo.monasterioLeyre,
          AmbienteArchivo.colegiataRoncesvalles,
          AmbienteArchivo.estellaConjuntoRomanico,
          AmbienteArchivo.calleNavarreria,
          AmbienteArchivo.pasoRoncesvalles,
        ];
        for (final ambiente in ambientes) {
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: FondoAmbiente(ambiente: ambiente),
              ),
            ),
          ));
          expect(
            tester.takeException(),
            isNull,
            reason:
                'el ambiente ${ambiente.identificador} debe pintarse sin excepción',
          );
        }
      },
    );
  });
}
