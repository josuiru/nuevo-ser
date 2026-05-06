import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/vista/pantalla_ajustes_audio.dart';

GestorPerfiles _gestorDePrueba() => GestorPerfiles(
      namespace: 'nuevoser.lasversiones',
      sufijoNombreVisible: 'nombre_jugador',
      clavesGlobalesNoMigrables: const {
        'nuevoser.lasversiones.idioma_app',
        'nuevoser.lasversiones.token_backend',
        'nuevoser.lasversiones.email_backend',
      },
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> bombear(
    WidgetTester tester, {
    required RepositorioPreferenciasAudio repo,
  }) async {
    await tester.pumpWidget(
      MaterialApp(home: PantallaAjustesAudio(repoAudio: repo)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
      'arranque sin valores guardados muestra los defaults del enum CapaAudio',
      (tester) async {
    final repo = RepositorioPreferenciasAudio(gestor: _gestorDePrueba());
    await bombear(tester, repo: repo);

    // Las cuatro filas con sus nombreVisible visibles.
    expect(find.text('Ambiente'), findsOneWidget);
    expect(find.text('Música'), findsOneWidget);
    expect(find.text('Efectos'), findsOneWidget);
    expect(find.text('Narrativos'), findsOneWidget);

    // Los valores por defecto deben aparecer junto a cada fila —
    // 45 / 70 / 80 / 85 según `CapaAudio.values`.
    expect(find.text('45'), findsOneWidget);
    expect(find.text('70'), findsOneWidget);
    expect(find.text('80'), findsOneWidget);
    expect(find.text('85'), findsOneWidget);
  });

  testWidgets('toggle del modo silencio persiste y deshabilita los sliders',
      (tester) async {
    final repo = RepositorioPreferenciasAudio(gestor: _gestorDePrueba());
    await bombear(tester, repo: repo);

    expect(find.text('Sonido activado'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.text('Silencio activado'), findsOneWidget);

    expect(await repo.cargarModoSilencio(), isTrue);

    final slidersDeshabilitados = tester
        .widgetList<Slider>(find.byType(Slider))
        .where((s) => s.onChanged == null);
    expect(slidersDeshabilitados.length, 4,
        reason:
            'al silenciar, los 4 sliders se deshabilitan para indicar '
            'que no afectan al sonido');
  });

  testWidgets('mover un slider persiste el valor por capa', (tester) async {
    final repo = RepositorioPreferenciasAudio(gestor: _gestorDePrueba());
    await bombear(tester, repo: repo);

    // Mueve el primer slider (Ambiente) al extremo derecho.
    final primerSlider = find.byType(Slider).first;
    final caja = tester.getRect(primerSlider);
    await tester.dragFrom(
      Offset(caja.left + 4, caja.center.dy),
      Offset(caja.width, 0),
    );
    await tester.pumpAndSettle();

    final guardado = await repo.cargarVolumenCapa(
      CapaAudio.ambient.clave,
      predeterminado: CapaAudio.ambient.volumenPredeterminado,
    );
    expect(guardado, greaterThan(CapaAudio.ambient.volumenPredeterminado),
        reason:
            'arrastrar a la derecha aumenta el valor respecto al default');
  });

  testWidgets(
      'valores guardados previamente reaparecen al abrir — aislamiento por '
      'perfil cubierto por el GestorPerfiles', (tester) async {
    final gestor = _gestorDePrueba();
    final repo = RepositorioPreferenciasAudio(gestor: gestor);
    await repo.guardarModoSilencio(true);
    await repo.guardarVolumenCapa(CapaAudio.musica.clave, 30);

    await bombear(tester, repo: repo);

    expect(find.text('Silencio activado'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
  });
}
