import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_cuaderno/pantalla_pagina_misterio.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  Misterio crearMisterio({String id = 'mist-1'}) => Misterio(
        id: id,
        pregunta: '¿Qué seres vivos aparecen tras la lluvia?',
        descripcionCorta:
            'Vuelve al mismo sitio antes y después de llover. Anota qué cambia.',
        estado: NivelConfianza.hipotesisActiva,
        abierto: true,
      );

  setUp(() {
    repositorio = RepositorioMemoria();
  });

  Future<void> bombear(
    WidgetTester tester, {
    required Misterio misterio,
    Future<void> Function(String)? alAbrirNuevaObservacion,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaPaginaMisterio(
          repositorio: repositorio,
          misterio: misterio,
          alAbrirNuevaObservacion: alAbrirNuevaObservacion,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> sembrarObservacion({
    required String id,
    required String queVio,
    String? misterioId,
    DateTime? cuandoOcurrio,
  }) async {
    await repositorio.guardarObservacion(Observacion(
      id: id,
      cuandoCreada: cuandoOcurrio ?? DateTime(2026, 4, 30),
      cuandoOcurrio: cuandoOcurrio ?? DateTime(2026, 4, 30),
      dondeNombre: 'parque',
      queVio: queVio,
      confianza: NivelConfianza.hipotesisActiva,
      misterioId: misterioId,
    ));
  }

  testWidgets('muestra cabecera con pregunta + descripción + estado',
      (tester) async {
    await bombear(tester, misterio: crearMisterio());
    expect(
      find.text('¿Qué seres vivos aparecen tras la lluvia?'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Vuelve al mismo sitio'),
      findsOneWidget,
    );
    expect(find.text('hipótesis activa'), findsOneWidget);
  });

  testWidgets(
    'sin observaciones ancladas: muestra microcopia de estado vacío',
    (tester) async {
      await bombear(tester, misterio: crearMisterio());
      expect(
        find.textContaining('Todavía no has anotado nada para este misterio'),
        findsOneWidget,
      );
    },
  );

  testWidgets('lista observaciones ancladas a este misterio', (tester) async {
    await sembrarObservacion(
      id: 'obs-1',
      queVio: 'tres caracoles en la base del olmo',
      misterioId: 'mist-1',
    );
    await sembrarObservacion(
      id: 'obs-2',
      queVio: 'una lombriz cruzando el sendero',
      misterioId: 'mist-1',
    );
    // Una observación ajena al misterio NO debe aparecer.
    await sembrarObservacion(
      id: 'obs-3',
      queVio: 'pájaro pequeño marrón',
      misterioId: 'otro',
    );
    await bombear(tester, misterio: crearMisterio());
    expect(
      find.textContaining('tres caracoles en la base del olmo'),
      findsOneWidget,
    );
    expect(
      find.textContaining('una lombriz cruzando el sendero'),
      findsOneWidget,
    );
    expect(find.textContaining('pájaro pequeño marrón'), findsNothing);
  });

  testWidgets(
    'sin alAbrirNuevaObservacion: el botón "anotar evidencia" no aparece',
    (tester) async {
      await bombear(tester, misterio: crearMisterio());
      expect(
        find.text('anotar evidencia para este misterio'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'con alAbrirNuevaObservacion: pulsar el botón invoca el callback con el id',
    (tester) async {
      String? idRecibido;
      await bombear(
        tester,
        misterio: crearMisterio(id: 'mist-lluvia-7'),
        alAbrirNuevaObservacion: (id) async {
          idRecibido = id;
        },
      );
      expect(find.text('anotar evidencia para este misterio'), findsOneWidget);
      await tester.tap(find.text('anotar evidencia para este misterio'));
      await tester.pumpAndSettle();
      expect(idRecibido, 'mist-lluvia-7');
    },
  );

  testWidgets(
    'tras volver del callback, recarga las observaciones ancladas',
    (tester) async {
      // El test simula el flujo: la página se monta vacía → el niño
      // pulsa "anotar evidencia" → al volver, hay una observación
      // nueva → la página debe haberla recargado.
      await bombear(
        tester,
        misterio: crearMisterio(id: 'mist-1'),
        alAbrirNuevaObservacion: (id) async {
          await sembrarObservacion(
            id: 'obs-nueva',
            queVio: 'evidencia recién anotada',
            misterioId: id,
          );
        },
      );
      expect(
        find.textContaining('Todavía no has anotado nada para este misterio'),
        findsOneWidget,
      );
      await tester.tap(find.text('anotar evidencia para este misterio'));
      await tester.pumpAndSettle();
      expect(find.textContaining('evidencia recién anotada'), findsOneWidget);
      expect(
        find.textContaining('Todavía no has anotado nada para este misterio'),
        findsNothing,
      );
    },
  );
}
