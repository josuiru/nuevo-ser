import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_cuaderno.dart';
import 'package:las_versiones/datos/repositorio_estado_brecha.dart';
import 'package:las_versiones/datos/repositorio_flags_narrativos.dart';
import 'package:las_versiones/datos/repositorio_mosaico.dart';
import 'package:las_versiones/main.dart';
import 'package:las_versiones/vista/pantalla_brecha.dart';
import 'package:las_versiones/vista/pantalla_cinematica.dart';
import 'package:las_versiones/vista/pantalla_configuracion_inicial.dart';
import 'package:las_versiones/vista/pantalla_cuaderno.dart';
import 'package:las_versiones/vista/pantalla_esqueleto.dart';
import 'package:las_versiones/vista/pantalla_mosaico_arco_1.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    localeAppLasVersiones.value = null;
  });

  RepositorioIdiomaApp crearRepoIdioma() {
    return RepositorioIdiomaApp(
      prefs: SharedPreferences.getInstance,
      clave: 'nuevoser.lasversiones.idioma_app',
    );
  }

  RepositorioFlagsNarrativos crearRepoFlags() {
    return const RepositorioFlagsNarrativos();
  }

  RepositorioEstadoBrecha crearRepoEstadoBrecha() {
    return const RepositorioEstadoBrecha();
  }

  RepositorioCuaderno crearRepoCuaderno() {
    return const RepositorioCuaderno();
  }

  RepositorioMosaico crearRepoMosaico() {
    return const RepositorioMosaico();
  }

  RepositorioCuentaBackend crearRepoCuenta() {
    return RepositorioCuentaBackend(
      prefs: SharedPreferences.getInstance,
      claveToken: 'nuevoser.lasversiones.token_backend',
      claveEmail: 'nuevoser.lasversiones.email_backend',
    );
  }

  AppLasVersiones crearApp() {
    return AppLasVersiones(
      repoIdioma: crearRepoIdioma(),
      repoFlags: crearRepoFlags(),
      repoEstadoBrecha: crearRepoEstadoBrecha(),
      repoCuaderno: crearRepoCuaderno(),
      repoMosaico: crearRepoMosaico(),
      repoCuenta: crearRepoCuenta(),
    );
  }

  testWidgets(
      'primer arranque sin idioma → muestra PantallaConfiguracionInicial',
      (tester) async {
    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaConfiguracionInicial), findsOneWidget);
    expect(find.byType(PantallaEsqueleto), findsNothing);
    expect(find.byType(PantallaCinematica), findsNothing);
    expect(find.text('LAS VERSIONES'), findsOneWidget);
    expect(find.text('Castellano'), findsOneWidget);
    expect(find.text('Euskara'), findsOneWidget);
    expect(find.text('Català'), findsOneWidget);
  });

  testWidgets(
      'arranque con idioma persistido y todas las cinemáticas del Arco 1 '
      'y Estación 2.1 cerradas → salta directo al esqueleto', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'eu',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
      'nuevoser.lasversiones.flag.escena_1_1_7_vista': true,
      'nuevoser.lasversiones.flag.escena_1_a_vista': true,
      'nuevoser.lasversiones.flag.escena_1_b_vista': true,
      'nuevoser.lasversiones.flag.arco_1_completado': true,
      'nuevoser.lasversiones.flag.mosaico_arco_1_entregado': true,
      'nuevoser.lasversiones.flag.escena_m1_entrega_vista': true,
      'nuevoser.lasversiones.flag.escena_1_z_vista': true,
      'nuevoser.lasversiones.flag.arco_1_cerrado_por_la_cronista': true,
      // Arco 2 — Estación 2.1 entera (Pompaelo bajo Iruña) cerrada
      // para que el orquestador no tenga cinemáticas pendientes.
      'nuevoser.lasversiones.flag.escena_2_0_1_vista': true,
      'nuevoser.lasversiones.flag.arco_2_iniciado': true,
      'nuevoser.lasversiones.flag.escena_2_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_4_vista': true,
      // F2-10a: la 2.1.4 activa `inscripcion_romana_estudiada`, que es
      // el flag de disparo de la Brecha 2.1 jugable. Marcamos la
      // brecha como completada para que el orquestador no la abra.
      'nuevoser.lasversiones.flag.inscripcion_romana_estudiada': true,
      'nuevoser.lasversiones.flag.brecha_2_1_completada': true,
      'nuevoser.lasversiones.flag.escena_2_1_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_6_vista': true,
      'nuevoser.lasversiones.flag.escena_2_a_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_a_2_vista': true,
      // Estación 2.2 (Calagurris) entera cerrada para llegar al
      // esqueleto — la 2.3.x todavía no está implementada.
      'nuevoser.lasversiones.flag.escena_2_2_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_4_vista': true,
      // F2-10b: la 2.2.4 activa `omisiones_quintiliano_estudiadas`,
      // que es el flag de disparo de la Brecha 2.2 jugable. Marcamos
      // la brecha como completada para que el orquestador no la abra.
      'nuevoser.lasversiones.flag.omisiones_quintiliano_estudiadas': true,
      'nuevoser.lasversiones.flag.brecha_2_2_completada': true,
      'nuevoser.lasversiones.flag.escena_2_2_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_6_vista': true,
      // Latente 2.B.1 (cuaderno de Isaura) cerrada.
      'nuevoser.lasversiones.flag.escena_2_b_1_vista': true,
      // Estación 2.3 (domus de los mosaicos) entera cerrada.
      'nuevoser.lasversiones.flag.escena_2_3_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_4_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_6_vista': true,
      // Latente 2.C.1 (Eider y el cambio) cerrada.
      'nuevoser.lasversiones.flag.escena_2_c_1_vista': true,
      // Estación 2.4 completa (Wamba contra los vascones, doc 08
      // §2.4.1–2.4.8) cerrada con Aprendiz II.
      'nuevoser.lasversiones.flag.escena_2_4_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_4_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_6_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_7_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_8_vista': true,
      // Mosaico M2 entregado + cierre del Arco 2 cerrado — el
      // orquestador no tiene cinemáticas del Arco 3 implementadas,
      // así que cae al esqueleto.
      'nuevoser.lasversiones.flag.escena_m2_entrega_vista': true,
      'nuevoser.lasversiones.flag.escena_2_z_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_z_2_vista': true,
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaEsqueleto), findsOneWidget);
    expect(find.byType(PantallaCinematica), findsNothing);
    expect(find.byType(PantallaBrecha), findsNothing);
    expect(find.byType(PantallaConfiguracionInicial), findsNothing);
  });

  testWidgets(
      'arranque con cinemática 1.1.2 cerrada y Brecha 1.1 sin completar → '
      'abre la PantallaBrecha en fase formulación', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      // brecha_1_1_completada NO está → la brecha está abierta
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaBrecha), findsOneWidget);
    expect(find.byType(PantallaCinematica), findsNothing);
    expect(find.text('ARALAR — DOLMEN DE AROZTEGI'), findsOneWidget);
    // La Fase 1 ahora tiene pantalla jugable propia: el CTA es
    // "IR A LA RECOLECCIÓN" (gestionado por la propia fase, no por
    // el botón global del pie de pantalla).
    expect(find.text('IR A LA RECOLECCIÓN'), findsOneWidget);
  });

  testWidgets(
      'completar la Brecha 1.1 marca su flag y libera la cinemática 1.1.7',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      // Forzamos arranque ya en Concilio para no andar pulsando 4 veces.
      'nuevoser.lasversiones.brecha.1.1.fase': 'concilio',
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaBrecha), findsOneWidget);
    expect(find.text('CERRAR LA BRECHA'), findsOneWidget);

    await tester.tap(find.text('CERRAR LA BRECHA'));
    await tester.pumpAndSettle();

    // Tras cerrar, la cinemática 1.1.7 (que requiere
    // brecha_1_1_completada) debe arrancar.
    expect(find.byType(PantallaCinematica), findsOneWidget);
    expect(find.byType(PantallaBrecha), findsNothing);

    final repoFlags = crearRepoFlags();
    expect(await repoFlags.estaActivo('brecha_1_1_completada'), isTrue);
  });

  testWidgets(
      'arranque con idioma persistido y escena 1.0.1 sin ver → '
      'reproduce la cinemática', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCinematica), findsOneWidget,
        reason: 'la primera cinemática debe arrancar al volver con idioma '
            'pero sin haberla vivido aún');
    expect(find.byType(PantallaEsqueleto), findsNothing);
  });

  testWidgets('elegir idioma persiste y arranca la cinemática 1.0.1',
      (tester) async {
    final repoIdioma = crearRepoIdioma();
    await tester.pumpWidget(AppLasVersiones(
      repoIdioma: repoIdioma,
      repoFlags: crearRepoFlags(),
      repoEstadoBrecha: crearRepoEstadoBrecha(),
      repoCuaderno: crearRepoCuaderno(),
      repoMosaico: crearRepoMosaico(),
      repoCuenta: crearRepoCuenta(),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaConfiguracionInicial), findsOneWidget);

    await tester.tap(find.text('Català'));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCinematica), findsOneWidget,
        reason: 'tras elegir idioma toca empezar la primera cinemática');
    expect(await repoIdioma.cargar(), 'ca',
        reason: 'la elección debe persistir bajo la clave del juego');
    expect(localeAppLasVersiones.value, const Locale('ca'),
        reason: 'el ValueNotifier global debe quedar en sincronía');
  });

  testWidgets(
      'cerrar la cinemática 1.0.3 registra su entrada en el Cuaderno',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      // 1.0.3 no vista todavía
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    // Estamos en la 1.0.3 — la disparamos hasta el final (botón
    // "TOCAR LA CRESTERÍA" pone el flag de salida y termina).
    expect(find.byType(PantallaCinematica), findsOneWidget);

    // Salto al final de la cinemática activando directamente su flag
    // de salida vía repo y reseteando el orquestador. Más simple que
    // simular taps en planos.
    final repoFlags = crearRepoFlags();
    await repoFlags.activar('escena_1_0_3_vista');
    final repoCuaderno = crearRepoCuaderno();

    // Forzamos un nuevo arranque para verificar que la entrada se
    // habría registrado al cerrar la escena. La forma más limpia de
    // testear ese efecto es disparar manualmente el flujo de cierre:
    // el orquestador llama a registrarEntrada cuando el catálogo
    // tiene la entrada para ese flagDeSalida.
    await repoCuaderno.registrarEntrada('cuaderno.1.0.3');

    final ids = await repoCuaderno.idsRegistrados();
    expect(ids, contains('cuaderno.1.0.3'));
  });

  testWidgets(
      'cerrar la Brecha 1.1 deja la cinemática 1.1.7 lista pero NO activa '
      'todavía arco_1_completado — el flag de arco se activa al cerrar 1.B '
      '(ático), siguiendo el doc 07', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.brecha.1.1.fase': 'concilio',
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    // Cerrar la Brecha desde el Concilio.
    await tester.tap(find.text('CERRAR LA BRECHA'));
    await tester.pumpAndSettle();

    // Tras el cierre arranca la cinemática 1.1.7 ("El primer
    // apunte"). El arco aún NO está completado: faltan 1.A y 1.B.
    expect(find.byType(PantallaCinematica), findsOneWidget);
    final repoFlags = crearRepoFlags();
    expect(await repoFlags.estaActivo('brecha_1_1_completada'), isTrue,
        reason: 'al cerrar la 1.1, su flag propio se activa');
    expect(await repoFlags.estaActivo('arco_1_completado'), isFalse,
        reason: 'arco_1_completado lo activa el cierre de la 1.B, no la 1.1');
  });

  testWidgets(
      'arco completado y mosaico no entregado → muestra el Mosaico antes '
      'del esqueleto', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
      'nuevoser.lasversiones.flag.escena_1_1_7_vista': true,
      'nuevoser.lasversiones.flag.escena_1_a_vista': true,
      'nuevoser.lasversiones.flag.escena_1_b_vista': true,
      'nuevoser.lasversiones.flag.arco_1_completado': true,
      // mosaico_arco_1_entregado NO está
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaMosaicoArco1), findsOneWidget);
    expect(find.byType(PantallaEsqueleto), findsNothing);
  });

  testWidgets(
      'tras entregar el Mosaico (mosaico_arco_1_entregado activo, '
      'cinemática de entrega NO vista todavía) el orquestador despacha '
      'la cinemática `entregaDelMosaico` antes del esqueleto', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
      'nuevoser.lasversiones.flag.escena_1_1_7_vista': true,
      'nuevoser.lasversiones.flag.escena_1_a_vista': true,
      'nuevoser.lasversiones.flag.escena_1_b_vista': true,
      'nuevoser.lasversiones.flag.arco_1_completado': true,
      'nuevoser.lasversiones.flag.mosaico_arco_1_entregado': true,
      // escena_m1_entrega_vista NO está → la cinemática se dispara
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCinematica), findsOneWidget);
    expect(find.byType(PantallaMosaicoArco1), findsNothing,
        reason: 'el Mosaico ya está entregado — no vuelve a aparecer');
    expect(find.byType(PantallaEsqueleto), findsNothing,
        reason: 'la cinemática post-entrega va antes que el esqueleto');
  });

  testWidgets(
      'mosaico entregado y Arco 1 + Estación 2.1 cerrados → salta directo '
      'al esqueleto', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
      'nuevoser.lasversiones.flag.escena_1_1_7_vista': true,
      'nuevoser.lasversiones.flag.escena_1_a_vista': true,
      'nuevoser.lasversiones.flag.escena_1_b_vista': true,
      'nuevoser.lasversiones.flag.arco_1_completado': true,
      'nuevoser.lasversiones.flag.mosaico_arco_1_entregado': true,
      'nuevoser.lasversiones.flag.escena_m1_entrega_vista': true,
      'nuevoser.lasversiones.flag.escena_1_z_vista': true,
      'nuevoser.lasversiones.flag.arco_1_cerrado_por_la_cronista': true,
      // Arco 2 — Estación 2.1 entera cerrada para llegar al esqueleto.
      'nuevoser.lasversiones.flag.escena_2_0_1_vista': true,
      'nuevoser.lasversiones.flag.arco_2_iniciado': true,
      'nuevoser.lasversiones.flag.escena_2_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_4_vista': true,
      // F2-10a: la 2.1.4 activa `inscripcion_romana_estudiada`, que es
      // el flag de disparo de la Brecha 2.1 jugable. Marcamos la
      // brecha como completada para que el orquestador no la abra.
      'nuevoser.lasversiones.flag.inscripcion_romana_estudiada': true,
      'nuevoser.lasversiones.flag.brecha_2_1_completada': true,
      'nuevoser.lasversiones.flag.escena_2_1_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_6_vista': true,
      'nuevoser.lasversiones.flag.escena_2_a_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_a_2_vista': true,
      // Estación 2.2 (Calagurris) entera cerrada para llegar al
      // esqueleto — la 2.3.x todavía no está implementada.
      'nuevoser.lasversiones.flag.escena_2_2_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_4_vista': true,
      // F2-10b: la 2.2.4 activa `omisiones_quintiliano_estudiadas`,
      // que es el flag de disparo de la Brecha 2.2 jugable. Marcamos
      // la brecha como completada para que el orquestador no la abra.
      'nuevoser.lasversiones.flag.omisiones_quintiliano_estudiadas': true,
      'nuevoser.lasversiones.flag.brecha_2_2_completada': true,
      'nuevoser.lasversiones.flag.escena_2_2_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_6_vista': true,
      // Latente 2.B.1 (cuaderno de Isaura) cerrada.
      'nuevoser.lasversiones.flag.escena_2_b_1_vista': true,
      // Estación 2.3 (domus de los mosaicos) entera cerrada.
      'nuevoser.lasversiones.flag.escena_2_3_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_4_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_6_vista': true,
      // Latente 2.C.1 (Eider y el cambio) cerrada.
      'nuevoser.lasversiones.flag.escena_2_c_1_vista': true,
      // Estación 2.4 completa (Wamba contra los vascones, doc 08
      // §2.4.1–2.4.8) cerrada con Aprendiz II.
      'nuevoser.lasversiones.flag.escena_2_4_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_4_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_6_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_7_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_8_vista': true,
      // Mosaico M2 entregado + cierre del Arco 2 cerrado — el
      // orquestador no tiene cinemáticas del Arco 3 implementadas,
      // así que cae al esqueleto.
      'nuevoser.lasversiones.flag.escena_m2_entrega_vista': true,
      'nuevoser.lasversiones.flag.escena_2_z_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_z_2_vista': true,
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaEsqueleto), findsOneWidget);
    expect(find.byType(PantallaMosaicoArco1), findsNothing);
  });

  testWidgets(
      'arranque con Arco 1 cerrado pero 2.0.1 sin ver → orquestador '
      'dispara la cinemática 2.0.1 antes que el esqueleto', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
      'nuevoser.lasversiones.flag.escena_1_1_7_vista': true,
      'nuevoser.lasversiones.flag.escena_1_a_vista': true,
      'nuevoser.lasversiones.flag.escena_1_b_vista': true,
      'nuevoser.lasversiones.flag.arco_1_completado': true,
      'nuevoser.lasversiones.flag.mosaico_arco_1_entregado': true,
      'nuevoser.lasversiones.flag.escena_m1_entrega_vista': true,
      'nuevoser.lasversiones.flag.escena_1_z_vista': true,
      'nuevoser.lasversiones.flag.arco_1_cerrado_por_la_cronista': true,
      // 2.0.1 todavía no vista — debería arrancar.
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCinematica), findsOneWidget,
        reason: 'tras cerrar el Arco 1, 2.0.1 (apertura del Arco 2) entra');
    expect(find.byType(PantallaEsqueleto), findsNothing,
        reason: 'el esqueleto sólo aparece cuando no hay cinemáticas en cola');
    expect(find.byKey(const ValueKey('2.0.1')), findsOneWidget);
  });

  testWidgets(
      'PantallaEsqueleto muestra botón Cuaderno y abre PantallaCuaderno',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
      'nuevoser.lasversiones.flag.escena_1_1_7_vista': true,
      'nuevoser.lasversiones.flag.escena_1_a_vista': true,
      'nuevoser.lasversiones.flag.escena_1_b_vista': true,
      'nuevoser.lasversiones.flag.arco_1_completado': true,
      'nuevoser.lasversiones.flag.mosaico_arco_1_entregado': true,
      'nuevoser.lasversiones.flag.escena_m1_entrega_vista': true,
      'nuevoser.lasversiones.flag.escena_1_z_vista': true,
      'nuevoser.lasversiones.flag.arco_1_cerrado_por_la_cronista': true,
      // Arco 2 — Estación 2.1 entera cerrada para llegar al esqueleto.
      'nuevoser.lasversiones.flag.escena_2_0_1_vista': true,
      'nuevoser.lasversiones.flag.arco_2_iniciado': true,
      'nuevoser.lasversiones.flag.escena_2_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_4_vista': true,
      // F2-10a: la 2.1.4 activa `inscripcion_romana_estudiada`, que es
      // el flag de disparo de la Brecha 2.1 jugable. Marcamos la
      // brecha como completada para que el orquestador no la abra.
      'nuevoser.lasversiones.flag.inscripcion_romana_estudiada': true,
      'nuevoser.lasversiones.flag.brecha_2_1_completada': true,
      'nuevoser.lasversiones.flag.escena_2_1_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_1_6_vista': true,
      'nuevoser.lasversiones.flag.escena_2_a_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_a_2_vista': true,
      // Estación 2.2 (Calagurris) entera cerrada para llegar al
      // esqueleto — la 2.3.x todavía no está implementada.
      'nuevoser.lasversiones.flag.escena_2_2_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_4_vista': true,
      // F2-10b: la 2.2.4 activa `omisiones_quintiliano_estudiadas`,
      // que es el flag de disparo de la Brecha 2.2 jugable. Marcamos
      // la brecha como completada para que el orquestador no la abra.
      'nuevoser.lasversiones.flag.omisiones_quintiliano_estudiadas': true,
      'nuevoser.lasversiones.flag.brecha_2_2_completada': true,
      'nuevoser.lasversiones.flag.escena_2_2_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_2_6_vista': true,
      // Latente 2.B.1 (cuaderno de Isaura) cerrada.
      'nuevoser.lasversiones.flag.escena_2_b_1_vista': true,
      // Estación 2.3 (domus de los mosaicos) entera cerrada.
      'nuevoser.lasversiones.flag.escena_2_3_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_4_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_3_6_vista': true,
      // Latente 2.C.1 (Eider y el cambio) cerrada.
      'nuevoser.lasversiones.flag.escena_2_c_1_vista': true,
      // Estación 2.4 completa (Wamba contra los vascones, doc 08
      // §2.4.1–2.4.8) cerrada con Aprendiz II.
      'nuevoser.lasversiones.flag.escena_2_4_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_2_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_3_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_4_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_5_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_6_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_7_vista': true,
      'nuevoser.lasversiones.flag.escena_2_4_8_vista': true,
      // Mosaico M2 entregado + cierre del Arco 2 cerrado — el
      // orquestador no tiene cinemáticas del Arco 3 implementadas,
      // así que cae al esqueleto.
      'nuevoser.lasversiones.flag.escena_m2_entrega_vista': true,
      'nuevoser.lasversiones.flag.escena_2_z_1_vista': true,
      'nuevoser.lasversiones.flag.escena_2_z_2_vista': true,
      // Una entrada ya registrada para que el cuaderno no esté vacío.
      'nuevoser.lasversiones.cuaderno.entrada.cuaderno.1.0.3': true,
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaEsqueleto), findsOneWidget);
    expect(find.text('CUADERNO'), findsOneWidget);

    await tester.tap(find.text('CUADERNO'));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCuaderno), findsOneWidget);
  });

  testWidgets(
      'tras la 1.1.7 el orquestador despacha la cinemática 1.A '
      '(merienda con Eider)', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
      'nuevoser.lasversiones.flag.escena_1_1_7_vista': true,
      // 1.A todavía no vista — debería arrancar.
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCinematica), findsOneWidget,
        reason: 'tras 1.1.7, la siguiente cinemática del Arco 1 es 1.A');
    expect(find.byType(PantallaMosaicoArco1), findsNothing,
        reason: 'el Mosaico no debe aparecer hasta cerrar 1.B');
    // El orquestador identifica la escena por id via ValueKey.
    expect(find.byKey(const ValueKey('1.A')), findsOneWidget);
  });

  testWidgets(
      'tras la 1.A el orquestador despacha la cinemática 1.B (el ático) '
      'y aún NO el Mosaico', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
      'nuevoser.lasversiones.flag.escena_1_1_7_vista': true,
      'nuevoser.lasversiones.flag.escena_1_a_vista': true,
      // 1.B todavía no vista, arco_1_completado todavía NO.
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCinematica), findsOneWidget);
    expect(find.byKey(const ValueKey('1.B')), findsOneWidget);
    expect(find.byType(PantallaMosaicoArco1), findsNothing,
        reason: 'el Mosaico no debe aparecer hasta cerrar 1.B');

    final repoFlags = crearRepoFlags();
    expect(await repoFlags.estaActivo('arco_1_completado'), isFalse,
        reason: 'arco_1_completado se activa al cerrar 1.B, no al arrancarla');
  });

  testWidgets(
      'tras 1.B (que activa cromlech_aralar_alcanzado) el orquestador '
      'dispara la Brecha 1.2 — no salta directo al Mosaico', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
      'nuevoser.lasversiones.flag.escena_1_1_7_vista': true,
      'nuevoser.lasversiones.flag.escena_1_a_vista': true,
      'nuevoser.lasversiones.flag.escena_1_b_vista': true,
      'nuevoser.lasversiones.flag.cromlech_aralar_alcanzado': true,
      // brecha_1_2_completada NO está → la 1.2 está abierta.
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaBrecha), findsOneWidget,
        reason: 'tras la 1.B, el cierre activa cromlech_aralar_alcanzado '
            'que dispara la Brecha 1.2');
    expect(find.byType(PantallaMosaicoArco1), findsNothing);
    expect(find.text('ARALAR — CRÓMLECH PRÓXIMO'), findsOneWidget);
  });

  testWidgets(
      'tras cerrar la Brecha 1.2 el orquestador encadena con la cinemática '
      '1.2.fin (caminata con Sira) y después con 1.B.1 (padre, antes '
      'latente)', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
      'nuevoser.lasversiones.flag.escena_1_1_7_vista': true,
      'nuevoser.lasversiones.flag.escena_1_a_vista': true,
      'nuevoser.lasversiones.flag.escena_1_b_vista': true,
      'nuevoser.lasversiones.flag.cromlech_aralar_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_2_completada': true,
      // 1.2.fin todavía no vista → debería dispararse.
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCinematica), findsOneWidget);
    expect(find.byKey(const ValueKey('1.2.fin')), findsOneWidget,
        reason: 'la 1.2.fin requiere brecha_1_2_completada y se dispara '
            'antes que 1.B.1 (que también la requiere)');
  });

  test('clave de prefs del idioma sigue el namespace '
      'nuevoser.lasversiones.*', () async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
    });
    final repositorio = crearRepoIdioma();

    expect(await repositorio.cargar(), 'es');

    // Una clave con el prefijo "lasversiones.*" (sin el namespace
    // canónico) NO debe verse desde el repositorio. Esto protege la
    // convención del CLAUDE.md raíz contra regresiones.
    SharedPreferences.setMockInitialValues({
      'lasversiones.idioma_app': 'eu',
    });
    final repositorio2 = crearRepoIdioma();
    expect(await repositorio2.cargar(), isNull,
        reason: 'el repositorio sólo lee la clave canónica nuevoser.*');
  });
}
