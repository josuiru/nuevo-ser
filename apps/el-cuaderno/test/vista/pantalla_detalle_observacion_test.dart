import 'dart:io';
import 'dart:typed_data';

import 'package:el_cuaderno/datos/almacenador_medios.dart';
import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_observacion/pantalla_detalle_observacion.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Almacenador con dirRaiz fija a `/fake-medios` para que las rutas
/// resueltas en tests sean predecibles sin tocar filesystem real.
AlmacenadorMedios _AlmacenadorMediosFake() => AlmacenadorMedios(
      proveedorDirRaiz: () async => Directory('/fake-medios'),
    );

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
    DateTime? cuandoOcurrio,
  }) =>
      Observacion(
        id: id,
        cuandoCreada: cuandoOcurrio ?? DateTime(2026, 4, 28),
        cuandoOcurrio: cuandoOcurrio ?? DateTime(2026, 4, 28),
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

  Future<void> bombear(
    WidgetTester tester,
    Observacion obs, {
    DateTime Function()? proveedorAhora,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(MaterialApp(
      theme: TemaCuaderno.claro(),
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      locale: const Locale('es'),
      home: PantallaDetalleObservacion(
        repositorio: repositorio,
        observacion: obs,
        proveedorAhora: proveedorAhora,
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('cabecera con fecha + donde + queVio', (tester) async {
    await bombear(
      tester,
      crear(dondeNombre: 'El Roble Grande'),
    );
    expect(find.text('28/04/2026 · el roble grande'), findsOneWidget);
    expect(find.text('tres caracoles tras la lluvia'), findsOneWidget);
  });

  testWidgets('creesQueEs + confianza solo si están presentes',
      (tester) async {
    await bombear(
      tester,
      crear(creesQueEs: 'caracol común', confianza: NivelConfianza.consenso),
    );
    expect(
      find.text('caracol común · consenso'),
      findsOneWidget,
    );
  });

  testWidgets('sin creesQueEs: la línea de identificación no aparece',
      (tester) async {
    await bombear(tester, crear());
    // El nivel de confianza ("hipótesis activa") sólo se muestra
    // junto a `creesQueEs`. Si no hay identificación propuesta, esa
    // etiqueta no debe aparecer en ningún sitio del árbol.
    expect(find.textContaining('hipótesis activa'), findsNothing);
    expect(find.textContaining('consenso'), findsNothing);
  });

  testWidgets('climaResumen aparece si está presente', (tester) async {
    await bombear(
      tester,
      crear(climaResumen: 'lluvia fina y viento'),
    );
    expect(
      find.text('tiempo: lluvia fina y viento'),
      findsOneWidget,
    );
  });

  testWidgets('coordenadas: muestra el aviso de privacidad', (tester) async {
    await bombear(
      tester,
      crear(dondeCoordenadas: const Coordenadas(lat: 42.8, lng: -1.6)),
    );
    expect(
      find.textContaining('posición anclada'),
      findsOneWidget,
    );
    expect(
      find.textContaining('no sale a internet'),
      findsOneWidget,
    );
  });

  testWidgets(
    'sin coordenadas/misterio/sit spot: la sección de anclajes no se monta',
    (tester) async {
      await bombear(tester, crear());
      expect(find.byIcon(Icons.my_location_outlined), findsNothing);
      expect(find.byIcon(Icons.help_outline), findsNothing);
      expect(find.byIcon(Icons.place_outlined), findsNothing);
    },
  );

  testWidgets(
    'misterio: si está en abiertos del repo, muestra la pregunta',
    (tester) async {
      // Sembramos un Misterio abierto y la observación lo referencia.
      // El motor real lo abre por contexto; aquí lo construimos a
      // mano para no acoplar el test al seed.
      await repositorio.guardarMisterio(Misterio(
        id: 'm-1',
        pregunta: '¿Qué seres vivos aparecen tras la lluvia?',
        descripcionCorta: 'pista corta',
        estado: NivelConfianza.hipotesisActiva,
        abierto: true,
      ));
      await bombear(tester, crear(misterioId: 'm-1'));
      expect(
        find.textContaining('¿Qué seres vivos aparecen tras la lluvia?'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'misterio que ya no existe en abiertos: el bloque se omite',
    (tester) async {
      await bombear(tester, crear(misterioId: 'm-fantasma'));
      expect(find.byIcon(Icons.help_outline), findsNothing);
    },
  );

  testWidgets(
    'sit spot activo: muestra el nombre',
    (tester) async {
      await repositorio.establecerSitSpot(SitSpot(
        id: 'ss-1',
        nombre: 'El Roble Grande',
        dondeNombre: 'parque',
        creadoEn: DateTime(2026, 3, 1),
      ));
      await bombear(tester, crear(sitSpotId: 'ss-1'));
      expect(
        find.text('anotada en El Roble Grande'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'sit spot ya jubilado: también muestra el nombre',
    (tester) async {
      await repositorio.establecerSitSpot(SitSpot(
        id: 'ss-viejo',
        nombre: 'El banco del río',
        dondeNombre: 'orilla sur',
        creadoEn: DateTime(2026, 1, 1),
        retiradoEn: DateTime(2026, 4, 1),
      ));
      await bombear(tester, crear(sitSpotId: 'ss-viejo'));
      expect(
        find.text('anotada en El banco del río'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'sin AlmacenadorMedios: bloques de foto/dibujo no se montan',
    (tester) async {
      await bombear(
        tester,
        crear(
          fotoRutaLocal: 'medios/obs-1_foto.jpg',
          dibujoRutaLocal: 'medios/obs-1_dibujo.png',
        ),
      );
      // Sin almacenador no se resuelve la ruta absoluta y el bloque
      // no aparece. Etiquetas "foto"/"dibujo" no se montan.
      expect(find.text('foto'), findsNothing);
      expect(find.text('dibujo'), findsNothing);
    },
  );

  testWidgets(
    'borrar: pide confirmación y NO toca el repo si se cancela',
    (tester) async {
      final obs = crear(id: 'obs-1');
      await repositorio.guardarObservacion(obs);
      await bombear(tester, obs);

      await tester.tap(find.byTooltip('opciones de la página'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('borrar este registro'));
      await tester.pumpAndSettle();

      expect(find.text('Borrar este registro'), findsOneWidget);
      expect(
        find.textContaining('No se puede deshacer'),
        findsOneWidget,
      );

      await tester.tap(find.widgetWithText(TextButton, 'cancelar'));
      await tester.pumpAndSettle();

      // La observación sigue existiendo.
      final despues = await repositorio.obtenerObservacionPorId('obs-1');
      expect(despues, isNotNull);
    },
  );

  testWidgets(
    'editar: abre PantallaEditarObservacion y refresca al volver',
    (tester) async {
      final obs = crear(id: 'obs-1', queVio: 'texto original');
      await repositorio.guardarObservacion(obs);
      await bombear(tester, obs);

      expect(find.text('texto original'), findsOneWidget);

      await tester.tap(find.byTooltip('opciones de la página'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('editar este registro'));
      await tester.pumpAndSettle();

      // Estamos en PantallaEditarObservacion: AppBar dice "editar página".
      expect(find.text('editar página'), findsOneWidget);

      // Editamos queVio y guardamos.
      await tester.enterText(
        find.widgetWithText(TextField, 'texto original'),
        'texto corregido',
      );
      await tester.pump();
      await tester.tap(find.text('guardar cambios'));
      await tester.pumpAndSettle();

      // De vuelta al detalle: muestra el queVio actualizado.
      expect(find.text('Página del cuaderno'), findsOneWidget);
      expect(find.text('texto corregido'), findsOneWidget);
      expect(find.text('texto original'), findsNothing);
    },
  );

  testWidgets(
    'sugerencia: si no hay misterioId y el texto encaja, aparece el chip',
    (tester) async {
      await repositorio.guardarMisterio(Misterio(
        id: 'seed-misterio-lluvia',
        pregunta: 'Después de llover, ¿qué seres vivos aparecen?',
        descripcionCorta: 'pista corta',
        estado: NivelConfianza.consenso,
        abierto: true,
      ));
      await bombear(
        tester,
        crear(queVio: 'tres caracoles tras la lluvia'),
      );
      expect(find.text('esto suena al Misterio:'), findsOneWidget);
      expect(
        find.text('Después de llover, ¿qué seres vivos aparecen?'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'sugerencia: sin texto que encaje, el chip no se monta',
    (tester) async {
      await repositorio.guardarMisterio(Misterio(
        id: 'seed-misterio-lluvia',
        pregunta: 'Después de llover, ¿qué seres vivos aparecen?',
        descripcionCorta: 'pista corta',
        estado: NivelConfianza.consenso,
        abierto: true,
      ));
      await bombear(
        tester,
        crear(queVio: 'una piedra rara junto al camino'),
      );
      expect(find.text('esto suena al Misterio:'), findsNothing);
    },
  );

  testWidgets(
    'sugerencia: si la observación ya tiene misterioId, no se sugiere nada',
    (tester) async {
      await repositorio.guardarMisterio(Misterio(
        id: 'seed-misterio-lluvia',
        pregunta: 'Después de llover, ¿qué seres vivos aparecen?',
        descripcionCorta: 'pista corta',
        estado: NivelConfianza.consenso,
        abierto: true,
      ));
      await bombear(
        tester,
        crear(
          queVio: 'tres caracoles tras la lluvia',
          misterioId: 'seed-misterio-lluvia',
        ),
      );
      // El bloque del Misterio ya anclado aparece, pero el chip de
      // sugerencia (cabecera "esto suena al Misterio:") no.
      expect(find.text('esto suena al Misterio:'), findsNothing);
      expect(
        find.textContaining('anclada al misterio'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'sugerencia: anclar persiste el misterioId en el repo y oculta el chip',
    (tester) async {
      final obs = crear(
        id: 'obs-1',
        queVio: 'tres caracoles tras la lluvia',
      );
      await repositorio.guardarObservacion(obs);
      await repositorio.guardarMisterio(Misterio(
        id: 'seed-misterio-lluvia',
        pregunta: 'Después de llover, ¿qué seres vivos aparecen?',
        descripcionCorta: 'pista corta',
        estado: NivelConfianza.consenso,
        abierto: true,
      ));
      await bombear(tester, obs);

      expect(find.text('esto suena al Misterio:'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'anclar'));
      await tester.pumpAndSettle();

      // El chip desaparece tras anclar y aparece el bloque "anclada al
      // misterio" en la sección de anclajes.
      expect(find.text('esto suena al Misterio:'), findsNothing);
      expect(
        find.textContaining('anclada al misterio'),
        findsOneWidget,
      );

      final guardada = await repositorio.obtenerObservacionPorId('obs-1');
      expect(guardada?.misterioId, 'seed-misterio-lluvia');
    },
  );

  testWidgets(
    'sugerencia: rechazar oculta el chip y no toca el repo',
    (tester) async {
      final obs = crear(
        id: 'obs-1',
        queVio: 'tres caracoles tras la lluvia',
      );
      await repositorio.guardarObservacion(obs);
      await repositorio.guardarMisterio(Misterio(
        id: 'seed-misterio-lluvia',
        pregunta: 'Después de llover, ¿qué seres vivos aparecen?',
        descripcionCorta: 'pista corta',
        estado: NivelConfianza.consenso,
        abierto: true,
      ));
      await bombear(tester, obs);

      expect(find.text('esto suena al Misterio:'), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'no'));
      await tester.pumpAndSettle();

      expect(find.text('esto suena al Misterio:'), findsNothing);

      final guardada = await repositorio.obtenerObservacionPorId('obs-1');
      expect(guardada?.misterioId, isNull);
    },
  );

  testWidgets(
    'fuera de temporada: muestra "vuelve en otoño" bajo el misterio anclado',
    (tester) async {
      // Lluvia aplica en primavera+otoño. Hoy = 1 julio (verano).
      await repositorio.guardarMisterio(Misterio(
        id: 'seed-misterio-lluvia',
        pregunta: 'Después de llover, ¿qué seres vivos aparecen?',
        descripcionCorta: 'pista corta',
        estado: NivelConfianza.consenso,
        abierto: true,
        seasons: const ['primavera', 'otono'],
      ));
      await bombear(
        tester,
        crear(misterioId: 'seed-misterio-lluvia'),
        proveedorAhora: () => DateTime(2026, 7, 1),
      );
      expect(find.text('vuelve en otoño'), findsOneWidget);
    },
  );

  testWidgets(
    'en temporada: el aviso "vuelve en X" no se muestra',
    (tester) async {
      // Lluvia aplica en primavera+otoño. Hoy = 15 abril (primavera).
      await repositorio.guardarMisterio(Misterio(
        id: 'seed-misterio-lluvia',
        pregunta: 'Después de llover, ¿qué seres vivos aparecen?',
        descripcionCorta: 'pista corta',
        estado: NivelConfianza.consenso,
        abierto: true,
        seasons: const ['primavera', 'otono'],
      ));
      await bombear(
        tester,
        crear(misterioId: 'seed-misterio-lluvia'),
        proveedorAhora: () => DateTime(2026, 4, 15),
      );
      expect(find.textContaining('vuelve en'), findsNothing);
    },
  );

  testWidgets(
    'misterio atemporal: nunca muestra "vuelve en X"',
    (tester) async {
      // Líquenes aplican siempre (seasons vacía).
      await repositorio.guardarMisterio(Misterio(
        id: 'seed-misterio-liquenes',
        pregunta: '¿Cómo es el liquen de mi sit spot?',
        descripcionCorta: 'pista corta',
        estado: NivelConfianza.consenso,
        abierto: true,
      ));
      await bombear(
        tester,
        crear(misterioId: 'seed-misterio-liquenes'),
        proveedorAhora: () => DateTime(2026, 7, 1),
      );
      expect(find.textContaining('vuelve en'), findsNothing);
    },
  );

  testWidgets(
    'cigarras (solo verano) en invierno: muestra "vuelve en verano"',
    (tester) async {
      await repositorio.guardarMisterio(Misterio(
        id: 'seed-misterio-cigarras-fin',
        pregunta: '¿Cuándo se callan las cigarras?',
        descripcionCorta: 'pista corta',
        estado: NivelConfianza.consenso,
        abierto: true,
        seasons: const ['verano'],
      ));
      await bombear(
        tester,
        crear(misterioId: 'seed-misterio-cigarras-fin'),
        proveedorAhora: () => DateTime(2026, 1, 15),
      );
      expect(find.text('vuelve en verano'), findsOneWidget);
    },
  );

  testWidgets(
    'borrar: confirmar elimina la observación del repo y cierra la pantalla',
    (tester) async {
      final obs = crear(id: 'obs-1', queVio: 'esto se borra');
      await repositorio.guardarObservacion(obs);
      // Wrapper con un botón antes para detectar el pop tras borrar.
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
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) => PantallaDetalleObservacion(
                      repositorio: repositorio,
                      observacion: obs,
                    ),
                  ),
                ),
                child: const Text('abrir detalle'),
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('abrir detalle'));
      await tester.pumpAndSettle();

      expect(find.text('esto se borra'), findsOneWidget);

      await tester.tap(find.byTooltip('opciones de la página'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('borrar este registro'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'borrar'));
      await tester.pumpAndSettle();

      // Tras confirmar, el detalle se cierra y volvemos al wrapper.
      expect(find.text('abrir detalle'), findsOneWidget);
      expect(find.text('esto se borra'), findsNothing);
      // Y el repo ya no la conserva.
      final despues = await repositorio.obtenerObservacionPorId('obs-1');
      expect(despues, isNull);
    },
  );

  group('compartir foto a tu adulto', () {
    testWidgets(
      'sin foto anclada → la opción NO aparece en el menú overflow',
      (tester) async {
        await bombear(tester, crear()); // sin fotoRutaLocal
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        expect(find.text('compartir foto a tu adulto'), findsNothing);
      },
    );

    testWidgets(
      'con foto anclada y AlmacenadorMedios → la opción aparece',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(MaterialApp(
          theme: TemaCuaderno.claro(),
          localizationsDelegates: TextosApp.localizationsDelegates,
          supportedLocales: TextosApp.supportedLocales,
          locale: const Locale('es'),
          home: PantallaDetalleObservacion(
            repositorio: repositorio,
            observacion: crear(fotoRutaLocal: 'medios/o1_foto.jpg'),
            almacenadorMedios: _AlmacenadorMediosFake(),
            constructorMiniatura: (_) =>
                const SizedBox(key: ValueKey('mini-stub')),
          ),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        expect(find.text('compartir foto a tu adulto'), findsOneWidget);
      },
    );

    testWidgets(
      'pulsar la opción invoca el lanzador con la ruta absoluta y el '
      'texto pedagógico de acompañamiento',
      (tester) async {
        String? rutaRecibida;
        String? textoRecibido;
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(MaterialApp(
          theme: TemaCuaderno.claro(),
          localizationsDelegates: TextosApp.localizationsDelegates,
          supportedLocales: TextosApp.supportedLocales,
          locale: const Locale('es'),
          home: PantallaDetalleObservacion(
            repositorio: repositorio,
            observacion: crear(fotoRutaLocal: 'medios/o1_foto.jpg'),
            almacenadorMedios: _AlmacenadorMediosFake(),
            constructorMiniatura: (_) =>
                const SizedBox(key: ValueKey('mini-stub')),
            lanzadorCompartirFoto: ({
              required String rutaAbsolutaFoto,
              required String texto,
            }) async {
              rutaRecibida = rutaAbsolutaFoto;
              textoRecibido = texto;
            },
          ),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        await tester.tap(find.text('compartir foto a tu adulto'));
        await tester.pumpAndSettle();

        expect(
          rutaRecibida,
          '/fake-medios/medios/o1_foto.jpg',
          reason: 'el lanzador recibe la ruta absoluta resuelta por '
              'AlmacenadorMedios, no la relativa',
        );
        expect(
          textoRecibido,
          'Mira lo que he visto en mi cuaderno. ¿Sabes qué es?',
        );
      },
    );
  });

  group('compartir esta página como PDF', () {
    testWidgets(
      'la opción aparece en el menú overflow',
      (tester) async {
        await bombear(tester, crear());
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        expect(
          find.text('compartir esta página como PDF'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'pulsar la opción invoca el lanzador con bytes %PDF válidos',
      (tester) async {
        Uint8List? bytesRecibidos;
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(MaterialApp(
          theme: TemaCuaderno.claro(),
          localizationsDelegates: TextosApp.localizationsDelegates,
          supportedLocales: TextosApp.supportedLocales,
          locale: const Locale('es'),
          home: PantallaDetalleObservacion(
            repositorio: repositorio,
            observacion: crear(creesQueEs: 'caracol común'),
            nombrePerfilActivo: 'Maren',
            lanzadorPdf: (bytes) async {
              bytesRecibidos = bytes;
            },
          ),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        await tester.tap(find.text('compartir esta página como PDF'));
        // El generador es asíncrono — bombeamos suficientes ticks para
        // que termine antes de comprobar.
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 200));
        }
        await tester.pumpAndSettle();

        expect(bytesRecibidos, isNotNull);
        expect(bytesRecibidos!.length, greaterThan(500));
        expect(
          String.fromCharCodes(bytesRecibidos!.take(4)),
          '%PDF',
        );
      },
    );
  });
}
