// Tests del RepositorioSesion.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/repositorio_sesion.dart';
import 'package:el_descifrador/dominio/decision_documento.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('perfil nuevo: cargar devuelve sesión vacía', () async {
    final repo = RepositorioSesion(idPerfil: 'test-1');
    final sesion = await repo.cargar();
    expect(sesion.vacia, true);
    expect(sesion.decisionesPorPieza, isEmpty);
  });

  test('registrar pieza resuelta persiste decisión', () async {
    final repo = RepositorioSesion(idPerfil: 'test-2');
    await repo.registrarPiezaResuelta(
      'carta-ines-bacalao-001',
      DecisionDocumento.archivar,
    );

    final reabierto = RepositorioSesion(idPerfil: 'test-2');
    final sesion = await reabierto.cargar();

    expect(sesion.decisionesPorPieza['carta-ines-bacalao-001'],
        DecisionDocumento.archivar);
  });

  test('varias decisiones se acumulan', () async {
    final repo = RepositorioSesion(idPerfil: 'test-3');
    await repo.registrarPiezaResuelta(
      'pieza-a',
      DecisionDocumento.archivar,
    );
    await repo.registrarPiezaResuelta(
      'pieza-b',
      DecisionDocumento.publicarEnBoletin,
    );
    await repo.registrarPiezaResuelta(
      'pieza-c',
      DecisionDocumento.entregarAlDestinatario,
    );

    final sesion = await repo.cargar();
    expect(sesion.decisionesPorPieza.length, 3);
    expect(sesion.decisionesPorPieza['pieza-b'],
        DecisionDocumento.publicarEnBoletin);
  });

  test('perfiles distintos no se contaminan', () async {
    final ana = RepositorioSesion(idPerfil: 'ana');
    final luis = RepositorioSesion(idPerfil: 'luis');

    await ana.registrarPiezaResuelta('pieza-1', DecisionDocumento.archivar);
    await luis.registrarPiezaResuelta(
      'pieza-2',
      DecisionDocumento.publicarEnBoletin,
    );

    final sesionAna = await ana.cargar();
    final sesionLuis = await luis.cargar();

    expect(sesionAna.decisionesPorPieza.length, 1);
    expect(sesionAna.decisionesPorPieza['pieza-1'],
        DecisionDocumento.archivar);
    expect(sesionLuis.decisionesPorPieza.length, 1);
    expect(sesionLuis.decisionesPorPieza['pieza-2'],
        DecisionDocumento.publicarEnBoletin);
  });

  test('borrar deja perfil a estado inicial', () async {
    final repo = RepositorioSesion(idPerfil: 'test-borrar');
    await repo.registrarPiezaResuelta('p', DecisionDocumento.archivar);
    await repo.borrar();

    final sesion = await repo.cargar();
    expect(sesion.vacia, true);
  });

  test('JSON corrupto se trata como sesión vacía', () async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.descifrador.perfil.test-corrupto.sesion': 'no es JSON válido',
    });
    final repo = RepositorioSesion(idPerfil: 'test-corrupto');
    final sesion = await repo.cargar();
    expect(sesion.vacia, true);
  });
}
