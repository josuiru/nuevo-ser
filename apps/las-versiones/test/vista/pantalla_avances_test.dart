import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:las_versiones/dominio/avances.dart';
import 'package:las_versiones/vista/pantalla_avances.dart';

AvancesArchivo _avances({
  int brechasCompletadas = 0,
  int entradasCuaderno = 0,
  int mosaicosEntregados = 0,
}) {
  return AvancesArchivo(
    arcos: const [
      AvanceArco(
        id: 'arco_1',
        titulo: 'Arco 1 — La voz que falta',
        cinematicasVistas: 23,
        cinematicasTotal: 23,
        cerrado: true,
      ),
      AvanceArco(
        id: 'arco_2',
        titulo: 'Arco 2 — El oficio del silencio',
        cinematicasVistas: 12,
        cinematicasTotal: 34,
        cerrado: false,
      ),
      AvanceArco(
        id: 'arco_3',
        titulo: 'Arco 3 — La forja del reino',
        cinematicasVistas: 0,
        cinematicasTotal: 49,
        cerrado: false,
      ),
    ],
    brechasCompletadas: brechasCompletadas,
    brechasTotal: 8,
    entradasCuaderno: entradasCuaderno,
    entradasCuadernoTotal: 50,
    mosaicosEntregados: mosaicosEntregados,
    mosaicosTotal: 2,
  );
}

void main() {
  group('PantallaAvances', () {
    testWidgets(
      'render mínimo — bloques POR ARCO y EN GLOBAL + las 3 filas '
      'de arco con sus contadores',
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: PantallaAvances(avances: _avances()),
        ));

        expect(find.text('AVANCES'), findsOneWidget);
        expect(find.text('POR ARCO'), findsOneWidget);
        expect(find.text('EN GLOBAL'), findsOneWidget);

        expect(find.textContaining('Arco 1'), findsOneWidget);
        expect(find.textContaining('Arco 2'), findsOneWidget);
        expect(find.textContaining('Arco 3'), findsOneWidget);

        expect(find.text('23 de 23 cinemáticas'), findsOneWidget);
        expect(find.text('12 de 34 cinemáticas'), findsOneWidget);
        expect(find.text('0 de 49 cinemáticas'), findsOneWidget);
      },
    );

    testWidgets(
      'arco cerrado se etiqueta CERRADO; arco con vistas pero sin '
      'cerrar se etiqueta EN MARCHA; arco sin abrir se etiqueta '
      'SIN ABRIR',
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: PantallaAvances(avances: _avances()),
        ));

        expect(find.text('CERRADO'), findsOneWidget);
        expect(find.text('EN MARCHA'), findsOneWidget);
        expect(find.text('SIN ABRIR'), findsOneWidget);
      },
    );

    testWidgets(
      'contadores globales muestran X / Y de Brechas, Cuaderno y '
      'Mosaicos',
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: PantallaAvances(
              avances: _avances(
            brechasCompletadas: 5,
            entradasCuaderno: 18,
            mosaicosEntregados: 1,
          )),
        ));

        expect(find.text('5 / 8'), findsOneWidget);
        expect(find.text('18 / 50'), findsOneWidget);
        expect(find.text('1 / 2'), findsOneWidget);
      },
    );
  });

  group('calcularAvances', () {
    test(
      'sin flags ni cuaderno ni mosaicos — todo a cero, los 3 arcos '
      'sin abrir y sin cerrar',
      () {
        final resultado = calcularAvances(
          flagsActivos: const {},
          idsCuadernoRegistrados: const {},
          mosaicoArco1Entregado: false,
          mosaicoArco2Entregado: false,
        );
        expect(resultado.arcos, hasLength(3));
        for (final arco in resultado.arcos) {
          expect(arco.cinematicasVistas, 0);
          expect(arco.cerrado, false);
        }
        expect(resultado.brechasCompletadas, 0);
        expect(resultado.entradasCuaderno, 0);
        expect(resultado.mosaicosEntregados, 0);
        expect(resultado.mosaicosTotal, 2);
      },
    );

    test(
      'flag arco_1_cerrado_por_la_cronista marca el arco 1 como '
      'cerrado',
      () {
        final resultado = calcularAvances(
          flagsActivos: const {'arco_1_cerrado_por_la_cronista'},
          idsCuadernoRegistrados: const {},
          mosaicoArco1Entregado: true,
          mosaicoArco2Entregado: false,
        );
        final arco1 =
            resultado.arcos.firstWhere((a) => a.id == 'arco_1');
        expect(arco1.cerrado, true);
        expect(resultado.mosaicosEntregados, 1);
      },
    );
  });
}
