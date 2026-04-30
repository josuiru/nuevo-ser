import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_observacion/pantalla_editar_observacion.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  Observacion crear({
    String id = 'obs-1',
    String queVio = 'tres caracoles tras la lluvia',
    String? creesQueEs,
    String dondeNombre = 'parque',
    NivelConfianza confianza = NivelConfianza.hipotesisActiva,
    String? climaResumen,
    Coordenadas? dondeCoordenadas,
    String? misterioId,
    String? sitSpotId,
    String? fotoRutaLocal,
    String? dibujoRutaLocal,
  }) =>
      Observacion(
        id: id,
        cuandoCreada: DateTime(2026, 4, 28),
        cuandoOcurrio: DateTime(2026, 4, 28),
        dondeNombre: dondeNombre,
        queVio: queVio,
        creesQueEs: creesQueEs,
        confianza: confianza,
        climaResumen: climaResumen,
        dondeCoordenadas: dondeCoordenadas,
        misterioId: misterioId,
        sitSpotId: sitSpotId,
        fotoRutaLocal: fotoRutaLocal,
        dibujoRutaLocal: dibujoRutaLocal,
      );

  setUp(() {
    repositorio = RepositorioMemoria();
  });

  Future<void> bombear(WidgetTester tester, Observacion obs) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(MaterialApp(
      theme: TemaCuaderno.claro(),
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      locale: const Locale('es'),
      home: PantallaEditarObservacion(
        repositorio: repositorio,
        observacion: obs,
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('prefill: muestra los campos con los valores actuales',
      (tester) async {
    await bombear(
      tester,
      crear(
        creesQueEs: 'caracol común',
        confianza: NivelConfianza.consenso,
        climaResumen: 'lluvia fina',
      ),
    );
    expect(find.text('tres caracoles tras la lluvia'), findsOneWidget);
    expect(find.text('caracol común'), findsOneWidget);
    expect(find.text('parque'), findsOneWidget);
    expect(find.text('lluvia fina'), findsOneWidget);
  });

  testWidgets(
    'guardar con queVio modificado actualiza el repo y devuelve la nueva',
    (tester) async {
      await repositorio.guardarObservacion(crear());
      Observacion? recibida;
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  recibida =
                      await Navigator.of(context).push<Observacion>(
                    MaterialPageRoute(
                      builder: (_) => PantallaEditarObservacion(
                        repositorio: repositorio,
                        observacion: crear(),
                      ),
                    ),
                  );
                },
                child: const Text('abrir editar'),
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('abrir editar'));
      await tester.pumpAndSettle();

      // Edita queVio.
      await tester.enterText(
        find.widgetWithText(TextField, 'tres caracoles tras la lluvia'),
        'tres caracoles grandes tras la lluvia',
      );
      await tester.pump();

      await tester.tap(find.text('guardar cambios'));
      await tester.pumpAndSettle();

      // El pop devolvió la nueva observación.
      expect(recibida, isNotNull);
      expect(recibida!.queVio, 'tres caracoles grandes tras la lluvia');

      // El repo persiste los cambios bajo el mismo id.
      final enRepo = await repositorio.obtenerObservacionPorId('obs-1');
      expect(enRepo, isNotNull);
      expect(enRepo!.queVio, 'tres caracoles grandes tras la lluvia');
    },
  );

  testWidgets(
    'guardar deshabilitado con queVio vacío',
    (tester) async {
      await bombear(tester, crear());
      await tester.enterText(
        find.widgetWithText(TextField, 'tres caracoles tras la lluvia'),
        '',
      );
      await tester.pump();
      final boton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'guardar cambios'),
      );
      expect(boton.onPressed, isNull);
    },
  );

  testWidgets(
    'guardar deshabilitado con dondeNombre vacío',
    (tester) async {
      await bombear(tester, crear());
      await tester.enterText(
        find.widgetWithText(TextField, 'parque'),
        '',
      );
      await tester.pump();
      final boton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'guardar cambios'),
      );
      expect(boton.onPressed, isNull);
    },
  );

  testWidgets(
    'consenso requiere creesQueEs no vacío',
    (tester) async {
      // Empezamos con creesQueEs no vacío y consenso para que la
      // validación pase, luego vaciamos creesQueEs y comprobamos
      // que el botón se deshabilita.
      await bombear(
        tester,
        crear(
          creesQueEs: 'caracol común',
          confianza: NivelConfianza.consenso,
        ),
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'caracol común'),
        '',
      );
      await tester.pump();
      final boton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'guardar cambios'),
      );
      expect(boton.onPressed, isNull);
    },
  );

  testWidgets(
    'campos no editables (foto, coords, misterio, sitspot) se preservan',
    (tester) async {
      final original = crear(
        fotoRutaLocal: 'medios/obs-1_foto.jpg',
        dibujoRutaLocal: 'medios/obs-1_dibujo.png',
        dondeCoordenadas: const Coordenadas(lat: 42.8, lng: -1.6),
        misterioId: 'mist-x',
        sitSpotId: 'ss-y',
      );
      await repositorio.guardarObservacion(original);
      Observacion? recibida;
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  recibida =
                      await Navigator.of(context).push<Observacion>(
                    MaterialPageRoute(
                      builder: (_) => PantallaEditarObservacion(
                        repositorio: repositorio,
                        observacion: original,
                      ),
                    ),
                  );
                },
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      // Cambiamos sólo queVio, pulsamos guardar.
      await tester.enterText(
        find.widgetWithText(TextField, 'tres caracoles tras la lluvia'),
        'corregido',
      );
      await tester.pump();
      await tester.tap(find.text('guardar cambios'));
      await tester.pumpAndSettle();

      expect(recibida!.queVio, 'corregido');
      expect(recibida!.fotoRutaLocal, 'medios/obs-1_foto.jpg');
      expect(recibida!.dibujoRutaLocal, 'medios/obs-1_dibujo.png');
      expect(
        recibida!.dondeCoordenadas,
        const Coordenadas(lat: 42.8, lng: -1.6),
      );
      expect(recibida!.misterioId, 'mist-x');
      expect(recibida!.sitSpotId, 'ss-y');
      expect(recibida!.id, 'obs-1');
      expect(recibida!.cuandoCreada, DateTime(2026, 4, 28));
    },
  );
}
