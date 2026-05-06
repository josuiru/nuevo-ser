import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/vista/pantalla_perfiles.dart';

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
    required GestorPerfiles gestor,
    required Future<void> Function(String) alCambiarAPerfil,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PantallaPerfiles(
          gestor: gestor,
          alCambiarAPerfil: alCambiarAPerfil,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
      'arranque sin perfiles previos: muestra el perfil principal único '
      'marcado como ACTIVO', (tester) async {
    final gestor = _gestorDePrueba();
    await bombear(tester, gestor: gestor, alCambiarAPerfil: (_) async {});
    expect(find.text('principal'), findsOneWidget);
    expect(find.text('ACTIVO'), findsOneWidget);
    expect(find.text('Pulsa para activar'), findsNothing);
  });

  testWidgets(
      'crear un nuevo perfil añade fila — y el creado aparece como '
      'no-activo (el activo sigue siendo el principal)', (tester) async {
    final gestor = _gestorDePrueba();
    await bombear(tester, gestor: gestor, alCambiarAPerfil: (_) async {});

    await tester.tap(find.text('Nueva Cronista'));
    await tester.pumpAndSettle();
    expect(find.text('Nombre de la Cronista — para distinguirla de otras '
            'del mismo dispositivo.'),
        findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Maren');
    await tester.tap(find.text('CREAR'));
    await tester.pumpAndSettle();

    expect(find.text('Maren'), findsOneWidget);
    expect(find.text('principal'), findsOneWidget);
    expect(find.text('ACTIVO'), findsOneWidget);
    expect(find.text('Pulsa para activar'), findsOneWidget);
  });

  testWidgets(
      'tap sobre un perfil no-activo invoca alCambiarAPerfil con su id',
      (tester) async {
    final gestor = _gestorDePrueba();
    await gestor.crearPerfil('Ander');

    String? idCambiado;
    await bombear(
      tester,
      gestor: gestor,
      alCambiarAPerfil: (id) async {
        idCambiado = id;
      },
    );

    await tester.tap(find.text('Ander'));
    await tester.pumpAndSettle();
    expect(idCambiado, 'ander');
  });

  testWidgets(
      'borrar un perfil no-activo lo quita de la lista y conserva el '
      'activo intacto', (tester) async {
    final gestor = _gestorDePrueba();
    await gestor.crearPerfil('Ander');
    await bombear(tester, gestor: gestor, alCambiarAPerfil: (_) async {});

    // Tap en la papelera de Ander (la segunda — la primera es la del
    // perfil principal, que tiene papelera porque hay >1 perfil pero
    // que no queremos borrar en este test).
    await tester.tap(find.byTooltip('Borrar perfil').last);
    await tester.pumpAndSettle();
    expect(find.text('¿Borrar este perfil?'), findsOneWidget);
    await tester.tap(find.text('SÍ, BORRAR'));
    await tester.pumpAndSettle();

    expect(find.text('Ander'), findsNothing);
    expect(find.text('principal'), findsOneWidget);
  });

  testWidgets('cuando sólo queda un perfil, el icono de borrar no aparece '
      '— evita dejar la app sin perfil activo', (tester) async {
    final gestor = _gestorDePrueba();
    await bombear(tester, gestor: gestor, alCambiarAPerfil: (_) async {});
    expect(find.byTooltip('Borrar perfil'), findsNothing);
  });
}
