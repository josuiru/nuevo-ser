// Tests de la PantallaCuaderno.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:el_descifrador/dominio/estado_sesion.dart';
import 'package:el_descifrador/dominio/familiaridad_remitente.dart';
import 'package:el_descifrador/dominio/pieza_corpus.dart';
import 'package:el_descifrador/dominio/voz_remitente.dart';
import 'package:el_descifrador/l10n/app_localizations.dart';
import 'package:el_descifrador/vista/pantalla_cuaderno.dart';

void main() {
  Widget _envolver({
    required EstadoSesion estado,
    required FamiliaridadRemitente familiaridad,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      home: PantallaCuaderno(
        estadoSesion: estado,
        familiaridad: familiaridad,
      ),
    );
  }

  PiezaCorpus _piezaEjemplo({
    required String id,
    required VozRemitente? remitente,
  }) {
    return PiezaCorpus.desdeMapa({
      'id': id,
      'tipo': 'carta',
      'remitente': remitente?.identificadorTecnico ?? 'voz-puntual',
      'destinatario': 'oficina',
      'lengua_principal': 'pt',
      'lenguas_infiltradas': <String>['es'],
      'ocasion': 'Test',
      'habilidades_atomicas': <String>['B6'],
      'operacion_central': 'proponer',
      'dificultad': 2,
      'decisiones_validas': <String>['archivar'],
      'soporte': <String, dynamic>{},
      'cruces_con_corpus': <String>[],
      'texto_documento': 'Texto de prueba.',
      'estado_validacion': 'borrador',
    });
  }

  testWidgets('Cuaderno vacío muestra mensajes apropiados', (tester) async {
    final estado = EstadoSesion.inicial(const []);
    final familiaridad = FamiliaridadRemitente.inicial();

    await tester.pumpWidget(
      _envolver(estado: estado, familiaridad: familiaridad),
    );
    await tester.pump();

    expect(find.text('Tu cuaderno'), findsOneWidget);
    expect(find.text('Lenguas'), findsOneWidget);
    expect(find.text('Personajes'), findsOneWidget);
    expect(find.text('Documentos resueltos'), findsOneWidget);
    expect(
      find.textContaining('Aún no has visto ninguna lengua'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Aún no conoces a nadie'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Aún no has decidido sobre ninguna pieza'),
      findsOneWidget,
    );
  });

  testWidgets('Cuaderno con piezas resueltas muestra lenguas y personajes', (
    tester,
  ) async {
    // Construir estado con dos piezas, ambas resueltas.
    final ines = _piezaEjemplo(
      id: 'p1',
      remitente: VozRemitente.inesCocineraLisboa,
    );
    final mansfield = _piezaEjemplo(
      id: 'p2',
      remitente: VozRemitente.mansfieldMedicoBristol,
    );

    var estado = EstadoSesion.inicial([ines, mansfield]);
    estado = estado.conPiezaResuelta('p1');
    estado = estado.conPiezaResuelta('p2');

    // Familiaridad: una pieza con Inês (saludando), tres con Mansfield
    // (conocido).
    var familiaridad = FamiliaridadRemitente.inicial();
    familiaridad = familiaridad.conPiezaTrabajadaCon(
      VozRemitente.inesCocineraLisboa,
    );
    for (var i = 0; i < 3; i++) {
      familiaridad = familiaridad.conPiezaTrabajadaCon(
        VozRemitente.mansfieldMedicoBristol,
      );
    }

    await tester.pumpWidget(
      _envolver(estado: estado, familiaridad: familiaridad),
    );
    await tester.pump();

    // Sección Personajes muestra los dos.
    expect(find.text('Inês'), findsOneWidget);
    expect(find.text('Dr. Mansfield'), findsOneWidget);
    // Niveles correctos.
    expect(find.text('Saludando'), findsOneWidget);
    expect(find.text('Conocido'), findsOneWidget);
  });
}
