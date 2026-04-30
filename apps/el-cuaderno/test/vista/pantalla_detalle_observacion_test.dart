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

  Future<void> bombear(WidgetTester tester, Observacion obs) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(MaterialApp(
      theme: TemaCuaderno.claro(),
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      locale: const Locale('es'),
      home: PantallaDetalleObservacion(
        repositorio: repositorio,
        observacion: obs,
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
}
