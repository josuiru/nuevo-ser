import 'dart:io';
import 'dart:typed_data';

import 'package:el_cuaderno/datos/almacenador_medios.dart';
import 'package:el_cuaderno/datos/cola_sync_observaciones.dart';
import 'package:el_cuaderno/datos/repositorio_mapa_online_opt_in.dart';
import 'package:el_cuaderno/datos/repositorio_presentacion_sit_spot.dart';
import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_ajustes/pantalla_ajustes.dart';
import 'package:el_cuaderno/vista/pantalla_sit_spot/pantalla_sit_spots_jubilados.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late RepositorioMemoria repositorio;
  late RepositorioIdiomaApp repoIdioma;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.elcuaderno.idioma_app': 'es',
    });
    repositorio = RepositorioMemoria();
    repoIdioma = RepositorioIdiomaApp(
      prefs: SharedPreferences.getInstance,
      clave: 'nuevoser.elcuaderno.idioma_app',
    );
  });

  Future<void> bombear(
    WidgetTester tester, {
    Future<void> Function()? alCambiarIdioma,
    RepositorioCuentaBackend? repoCuentaDebug,
    VoidCallback? alCambiarTokenDebug,
    Future<ResultadoSyncObservaciones?> Function()?
        intentarSincronizarObservaciones,
    AlmacenadorMedios? almacenadorMedios,
    RepositorioPresentacionSitSpot? repoPresentacionSitSpot,
    VoidCallback? alResetearPresentacionSitSpot,
    RepositorioMapaOnlineOptIn? repoMapaOnlineOptIn,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaAjustes(
          repositorio: repositorio,
          repoIdioma: repoIdioma,
          locale: const Locale('es'),
          alCambiarIdioma: alCambiarIdioma ?? () async {},
          repoCuentaDebug: repoCuentaDebug,
          alCambiarTokenDebug: alCambiarTokenDebug,
          intentarSincronizarObservaciones: intentarSincronizarObservaciones,
          almacenadorMedios: almacenadorMedios,
          repoPresentacionSitSpot: repoPresentacionSitSpot,
          alResetearPresentacionSitSpot: alResetearPresentacionSitSpot,
          repoMapaOnlineOptIn: repoMapaOnlineOptIn,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  RepositorioCuentaBackend crearRepoCuenta() => RepositorioCuentaBackend(
        prefs: SharedPreferences.getInstance,
        claveToken: 'nuevoser.elcuaderno.token_backend',
        claveEmail: 'nuevoser.elcuaderno.email_backend',
      );

  testWidgets('renderiza las cuatro acciones principales', (tester) async {
    await bombear(tester);
    expect(find.text('Idioma del cuaderno: castellano'), findsOneWidget);
    expect(find.text('Vista del cuidador'), findsOneWidget);
    expect(find.text('Exportar mi cuaderno'), findsOneWidget);
    expect(find.text('Borrar mi cuaderno'), findsOneWidget);
  });

  testWidgets('cambiar idioma invoca el callback', (tester) async {
    var llamado = false;
    await bombear(tester, alCambiarIdioma: () async {
      llamado = true;
    });
    await tester.tap(find.text('Cambiar idioma'));
    await tester.pumpAndSettle();
    expect(llamado, isTrue);
  });

  testWidgets('exportar abre dialog con SelectableText del JSON', (tester) async {
    await repositorio.guardarObservacion(Observacion(
      id: 'obs-1',
      cuandoCreada: DateTime(2026, 4, 30),
      cuandoOcurrio: DateTime(2026, 4, 30),
      dondeNombre: 'parque',
      queVio: 'cosa',
      confianza: NivelConfianza.hipotesisActiva,
    ));
    await bombear(tester);
    await tester.tap(find.text('Exportar mi cuaderno'));
    await tester.pumpAndSettle();
    expect(find.text('Tu cuaderno como texto'), findsOneWidget);
    expect(find.byType(SelectableText), findsOneWidget);
    // El JSON contiene la observación serializada.
    expect(find.textContaining('obs-1'), findsOneWidget);
  });

  testWidgets('borrar requiere doble confirmación + palabra clave', (tester) async {
    await repositorio.guardarObservacion(Observacion(
      id: 'obs-1',
      cuandoCreada: DateTime(2026, 4, 30),
      cuandoOcurrio: DateTime(2026, 4, 30),
      dondeNombre: 'parque',
      queVio: 'cosa',
      confianza: NivelConfianza.hipotesisActiva,
    ));
    await repositorio.guardarMisterio(Misterio(
      id: 'mist-1',
      pregunta: '¿?',
      descripcionCorta: '',
      estado: NivelConfianza.consenso,
      abierto: true,
    ));
    await bombear(tester);
    await tester.tap(find.text('Borrar mi cuaderno'));
    await tester.pumpAndSettle();
    // Primer dialog: explica el reparto.
    expect(find.text('¿Borrar todo?'), findsOneWidget);
    expect(find.textContaining('1 observaciones'), findsOneWidget);
    await tester.tap(find.text('Seguir'));
    await tester.pumpAndSettle();
    // Segundo dialog: pide la palabra-clave. Botón confirmar
    // deshabilitado hasta que coincida.
    expect(find.text('¿Estás segura?'), findsOneWidget);
    final botonConfirmar = find.widgetWithText(TextButton, 'Borrar todo');
    expect(tester.widget<TextButton>(botonConfirmar).onPressed, isNull);
    // Palabra mal: sigue deshabilitado.
    await tester.enterText(find.byType(TextField), 'no');
    await tester.pump();
    expect(tester.widget<TextButton>(botonConfirmar).onPressed, isNull);
    // Palabra correcta: habilita.
    await tester.enterText(find.byType(TextField), 'borrar');
    await tester.pump();
    expect(tester.widget<TextButton>(botonConfirmar).onPressed, isNotNull);
    await tester.tap(botonConfirmar);
    await tester.pumpAndSettle();
    // Repositorio queda vacío.
    expect(await repositorio.obtenerObservaciones(), isEmpty);
    expect(await repositorio.obtenerMisteriosAbiertos(), isEmpty);
  });

  testWidgets('sin repoCuentaDebug: el bloque "Tutor (debug)" no aparece',
      (tester) async {
    await bombear(tester);
    expect(find.text('Tutor (debug)'), findsNothing);
  });

  testWidgets(
      'con repoCuentaDebug + token vacío: bloque presente, botón borrar deshabilitado',
      (tester) async {
    final repoCuenta = crearRepoCuenta();
    await bombear(tester, repoCuentaDebug: repoCuenta);
    expect(find.text('Tutor (debug)'), findsOneWidget);
    final botonBorrar = find.widgetWithText(TextButton, 'Borrar token');
    expect(tester.widget<TextButton>(botonBorrar).onPressed, isNull);
  });

  testWidgets('guardar token: persiste, llama callback y muestra snackbar',
      (tester) async {
    final repoCuenta = crearRepoCuenta();
    var llamado = 0;
    await bombear(
      tester,
      repoCuentaDebug: repoCuenta,
      alCambiarTokenDebug: () => llamado++,
    );
    await tester.enterText(find.byType(TextField), 'jwt-de-prueba');
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar token'));
    await tester.pump(); // dispara los await internos
    await tester.pump();
    expect(await repoCuenta.cargarToken(), 'jwt-de-prueba');
    expect(llamado, 1);
    expect(
      find.text('Token guardado. Vuelve al Tutor para probarlo.'),
      findsOneWidget,
    );
    // Tras guardar, borrar token queda habilitado.
    final botonBorrar = find.widgetWithText(TextButton, 'Borrar token');
    expect(tester.widget<TextButton>(botonBorrar).onPressed, isNotNull);
  });

  testWidgets('borrar token: borra del repo, llama callback y deshabilita',
      (tester) async {
    final repoCuenta = crearRepoCuenta();
    await repoCuenta.guardarToken('jwt-existente');
    var llamado = 0;
    await bombear(
      tester,
      repoCuentaDebug: repoCuenta,
      alCambiarTokenDebug: () => llamado++,
    );
    final botonBorrar = find.widgetWithText(TextButton, 'Borrar token');
    expect(tester.widget<TextButton>(botonBorrar).onPressed, isNotNull);
    await tester.tap(botonBorrar);
    await tester.pump();
    await tester.pump();
    expect(await repoCuenta.cargarToken(), isNull);
    expect(llamado, 1);
    expect(
      find.text('Token borrado. El Tutor vuelve a la respuesta canónica.'),
      findsOneWidget,
    );
  });

  testWidgets(
      'sin closure de sync: el bloque "Sincronizar mis observaciones" no aparece',
      (tester) async {
    await bombear(tester);
    expect(find.text('Sincronizar mis observaciones'), findsNothing);
    expect(find.text('Subir ahora'), findsNothing);
  });

  testWidgets(
      'sync sin token: aviso "cuenta no vinculada" tras pulsar Subir ahora',
      (tester) async {
    var llamadas = 0;
    await bombear(
      tester,
      intentarSincronizarObservaciones: () async {
        llamadas++;
        return null; // null ↔ sin token desde la closure del orquestador.
      },
    );
    expect(find.text('Sincronizar mis observaciones'), findsOneWidget);
    await tester.tap(find.text('Subir ahora'));
    await tester.pump();
    await tester.pump();
    expect(llamadas, 1);
    expect(
      find.textContaining('Aún no hay cuenta vinculada'),
      findsOneWidget,
    );
  });

  testWidgets(
      'sync exitoso con todas enviadas: muestra plural ICU del count',
      (tester) async {
    await bombear(
      tester,
      intentarSincronizarObservaciones: () async => const ResultadoSyncObservaciones(
        enviadas: ['o-1', 'o-2', 'o-3'],
        rechazadas: [],
        dejadasParaReintento: [],
      ),
    );
    await tester.tap(find.text('Subir ahora'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Se han subido 3 observaciones.'), findsOneWidget);
  });

  testWidgets(
      'sync con dejadas para reintento: aviso "Subidas X, quedan Y"',
      (tester) async {
    await bombear(
      tester,
      intentarSincronizarObservaciones: () async => const ResultadoSyncObservaciones(
        enviadas: ['o-1'],
        rechazadas: [],
        dejadasParaReintento: ['o-2', 'o-3'],
      ),
    );
    await tester.tap(find.text('Subir ahora'));
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('Subidas 1'), findsOneWidget);
    expect(find.textContaining('quedan 2'), findsOneWidget);
  });

  testWidgets(
      'sync sin pendientes: aviso "todo subido"',
      (tester) async {
    await bombear(
      tester,
      intentarSincronizarObservaciones: () async => const ResultadoSyncObservaciones(
        enviadas: [],
        rechazadas: [],
        dejadasParaReintento: [],
      ),
    );
    await tester.tap(find.text('Subir ahora'));
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('No hay observaciones pendientes'), findsOneWidget);
  });

  testWidgets(
    'borrar mi cuaderno también purga el directorio de medios',
    (tester) async {
      late Directory dirRaiz;
      late AlmacenadorMedios almacenador;
      // Real I/O setup tiene que ocurrir fuera del fake-async del tester.
      await tester.runAsync(() async {
        dirRaiz = await Directory.systemTemp.createTemp(
          'el_cuaderno_borrar_medios_test_',
        );
        almacenador = AlmacenadorMedios(
          proveedorDirRaiz: () async => dirRaiz,
        );
        await almacenador.guardarBytes(
          bytes: Uint8List.fromList([0xFF, 0xD8, 0xFF]),
          observacionId: 'obs-con-foto',
          tipo: TipoMedio.foto,
        );
        await almacenador.guardarBytes(
          bytes: Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]),
          observacionId: 'obs-con-foto',
          tipo: TipoMedio.dibujo,
        );
      });
      try {
        await repositorio.guardarObservacion(Observacion(
          id: 'obs-con-foto',
          cuandoCreada: DateTime(2026, 4, 30),
          cuandoOcurrio: DateTime(2026, 4, 30),
          dondeNombre: 'parque',
          queVio: 'pájaro',
          confianza: NivelConfianza.hipotesisActiva,
          fotoRutaLocal: 'medios/obs-con-foto_foto.jpg',
        ));
        final dirMedios = Directory('${dirRaiz.path}/medios');

        await bombear(tester, almacenadorMedios: almacenador);
        await tester.tap(find.text('Borrar mi cuaderno'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Seguir'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'borrar');
        await tester.pump();
        await tester.tap(find.widgetWithText(TextButton, 'Borrar todo'));
        // Borrar implica I/O real de filesystem — pumpAndSettle en el
        // fake-async no avanza el await del _borrar. runAsync devuelve
        // control al loop de eventos real para que las awaits del flujo
        // (borrarTodoLoLocal + borrarTodo + showSnackBar) se resuelvan.
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        });
        await tester.pump();

        // El subdirectorio de medios desaparece.
        late bool existeMedios;
        await tester.runAsync(() async {
          existeMedios = await dirMedios.exists();
        });
        expect(existeMedios, isFalse);
        // El repositorio queda vacío.
        expect(await repositorio.obtenerObservaciones(), isEmpty);
      } finally {
        await tester.runAsync(() async {
          if (await dirRaiz.exists()) {
            await dirRaiz.delete(recursive: true);
          }
        });
      }
    },
  );

  testWidgets('cancelar el primer dialog NO borra nada', (tester) async {
    await repositorio.guardarObservacion(Observacion(
      id: 'obs-1',
      cuandoCreada: DateTime(2026, 4, 30),
      cuandoOcurrio: DateTime(2026, 4, 30),
      dondeNombre: 'parque',
      queVio: 'cosa',
      confianza: NivelConfianza.hipotesisActiva,
    ));
    await bombear(tester);
    await tester.tap(find.text('Borrar mi cuaderno'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(await repositorio.obtenerObservaciones(), hasLength(1));
  });

  testWidgets(
    'sin sit spots jubilados: el bloque "Sit spots de antes" no aparece',
    (tester) async {
      await bombear(tester);
      expect(find.text('Sit spots de antes'), findsNothing);
    },
  );

  testWidgets(
    'con un sit spot jubilado: el bloque aparece y abre la pantalla',
    (tester) async {
      // Establecer un sit spot activo y luego jubilarlo (mismo flujo
      // que en producción: copyWith con retiradoEn poblado).
      final activo = SitSpot(
        id: 'sit-old',
        nombre: 'mi banco viejo',
        dondeNombre: '',
        creadoEn: DateTime.utc(2026, 1, 15),
      );
      await repositorio.establecerSitSpot(activo);
      await repositorio.establecerSitSpot(
        activo.copyWith(retiradoEn: DateTime.utc(2026, 4, 30)),
      );

      await bombear(tester);
      expect(find.text('Sit spots de antes'), findsOneWidget);

      await tester.tap(find.text('Sit spots de antes'));
      await tester.pumpAndSettle();

      expect(find.byType(PantallaSitSpotsJubilados), findsOneWidget);
      expect(find.text('mi banco viejo'), findsOneWidget);
      expect(
        find.text('Estuvo activo del 15/01/2026 al 30/04/2026.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'borrar mi cuaderno también purga la presentación pedagógica del sit spot',
    (tester) async {
      final repoPresentacion = RepositorioPresentacionSitSpot(
        prefs: SharedPreferences.getInstance,
      );
      await repoPresentacion.marcar();
      var resetCalled = 0;

      await bombear(
        tester,
        repoPresentacionSitSpot: repoPresentacion,
        alResetearPresentacionSitSpot: () => resetCalled++,
      );

      await tester.tap(find.text('Borrar mi cuaderno'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Seguir'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'borrar');
      await tester.pump();
      await tester.tap(find.widgetWithText(TextButton, 'Borrar todo'));
      await tester.pumpAndSettle();

      expect(await repoPresentacion.cargar(), isFalse);
      expect(resetCalled, 1);
    },
  );

  testWidgets(
    'borrar mi cuaderno también purga el opt-in del mapa online',
    (tester) async {
      final repoMapa = RepositorioMapaOnlineOptIn(
        prefs: SharedPreferences.getInstance,
      );
      await repoMapa.activar();
      expect(await repoMapa.cargar(), isTrue);

      await bombear(tester, repoMapaOnlineOptIn: repoMapa);

      await tester.tap(find.text('Borrar mi cuaderno'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Seguir'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'borrar');
      await tester.pump();
      await tester.tap(find.widgetWithText(TextButton, 'Borrar todo'));
      await tester.pumpAndSettle();

      expect(
        await repoMapa.cargar(),
        isFalse,
        reason: 'el opt-in vuelve a OFF, como en una instalación nueva',
      );
    },
  );
}
