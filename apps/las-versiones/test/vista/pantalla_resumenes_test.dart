import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:las_versiones/dominio/mosaico_arco_1.dart';
import 'package:las_versiones/vista/pantalla_resumenes.dart';

void main() {
  group('PantallaResumenes', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized()
          .platformDispatcher
          .views
          .first
          .physicalSize = const Size(900, 3500);
      TestWidgetsFlutterBinding.ensureInitialized()
          .platformDispatcher
          .views
          .first
          .devicePixelRatio = 1.0;
    });
    tearDown(() {
      TestWidgetsFlutterBinding.ensureInitialized()
          .platformDispatcher
          .views
          .first
          .resetPhysicalSize();
      TestWidgetsFlutterBinding.ensureInitialized()
          .platformDispatcher
          .views
          .first
          .resetDevicePixelRatio();
    });

    testWidgets(
      'render mínimo — los dos Mosaicos con su título y formato',
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: const PantallaResumenes(
            mosaicoArco1Entregado: false,
            mosaicoArco2Entregado: false,
            marcasArco1: {},
            marcasArco2: {},
          ),
        ));

        expect(find.text('RESÚMENES'), findsOneWidget);
        expect(find.textContaining('Mosaico del Arco 1'), findsOneWidget);
        expect(find.textContaining('Mosaico del Arco 2'), findsOneWidget);
        expect(
          find.textContaining('Cómic mudo'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Audio-guía'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Mosaico no entregado se etiqueta PENDIENTE; entregado se '
      'etiqueta ENTREGADO',
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: const PantallaResumenes(
            mosaicoArco1Entregado: true,
            mosaicoArco2Entregado: false,
            marcasArco1: {},
            marcasArco2: {},
          ),
        ));

        expect(find.text('ENTREGADO'), findsOneWidget);
        expect(find.text('PENDIENTE'), findsOneWidget);
      },
    );

    testWidgets(
      'sin marcas, todas las piezas aparecen como SIN MARCAR',
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: const PantallaResumenes(
            mosaicoArco1Entregado: false,
            mosaicoArco2Entregado: false,
            marcasArco1: {},
            marcasArco2: {},
          ),
        ));

        expect(find.text('SIN MARCAR'), findsWidgets);
        // 8 viñetas del M1 + 8 fragmentos del M2 = 16 piezas sin marcar.
        expect(find.text('SIN MARCAR'), findsNWidgets(16));
      },
    );

    testWidgets(
      'piezas con marcas muestran el chip del nivel correspondiente',
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: PantallaResumenes(
            mosaicoArco1Entregado: true,
            mosaicoArco2Entregado: true,
            marcasArco1: {
              MosaicoArco1.vinetas.first.id: NivelConfianza.solido,
              MosaicoArco1.vinetas[1].id: NivelConfianza.probable,
              MosaicoArco1.vinetas[2].id: NivelConfianza.disputado,
            },
            marcasArco2: const {},
          ),
        ));

        expect(find.text('SÓLIDO'), findsOneWidget);
        expect(find.text('PROBABLE'), findsOneWidget);
        expect(find.text('DISPUTADO'), findsOneWidget);
      },
    );

    testWidgets(
      'el contador "X de Y piezas marcadas" refleja correctamente lo '
      'declarado',
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: PantallaResumenes(
            mosaicoArco1Entregado: true,
            mosaicoArco2Entregado: false,
            marcasArco1: {
              MosaicoArco1.vinetas[0].id: NivelConfianza.solido,
              MosaicoArco1.vinetas[1].id: NivelConfianza.probable,
            },
            marcasArco2: const {},
          ),
        ));

        expect(find.text('2 de 8 piezas marcadas'), findsOneWidget);
        expect(find.text('0 de 8 piezas marcadas'), findsOneWidget);
      },
    );
  });
}
