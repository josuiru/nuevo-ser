import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Caracteriza el algoritmo del [SelectorHabilidades] extraído de Uno
/// Roto. Estos tests son red de seguridad de la extracción C5/C6:
/// cualquier cambio aquí cambia la pedagogía adaptativa de los juegos
/// que usan la plataforma.
void main() {
  Habilidad construirHabilidad({
    required String id,
    String dominio = 'FR',
    List<String> dependencias = const [],
    List<String> distritos = const ['tejados'],
  }) {
    return Habilidad(
      identificador: id,
      nombre: id,
      dominio: dominio,
      dependencias: dependencias,
      familiasFragmento: const [],
      distritos: distritos,
      rangoIntroduccion: 'aprendiz_i',
      rangoExigido: 'aprendiz_i',
      umbralPrecision: 0.75,
      tiempoMedianoMinSeg: 4,
      tiempoMedianoMaxSeg: 8,
    );
  }

  EstadoHabilidad estadoCon({
    required String id,
    NivelMaestria nivel = NivelMaestria.inexplorada,
    int totalExposiciones = 0,
    DateTime? ultimaPractica,
  }) {
    return EstadoHabilidad(
      identificadorHabilidad: id,
      nivel: nivel,
      precision: 0,
      tiempoMedianoSeg: 0,
      ultimaPractica: ultimaPractica ?? DateTime.fromMillisecondsSinceEpoch(0),
      sesionesConsecutivasBuenas: 0,
      totalExposiciones: totalExposiciones,
      intentosRecientes: const [],
    );
  }

  /// Cuenta cómo se reparte el muestreo del selector sobre 2000 tiradas
  /// con dos candidatas. Devuelve la fracción que cae en [idObjetivo].
  Future<double> fraccionElecciones({
    required String idObjetivo,
    required List<Habilidad> candidatas,
    required Map<String, EstadoHabilidad> estados,
    String? contextoBonusId,
    bool aplicarBonusContexto = true,
    int tiradas = 2000,
  }) async {
    var aciertos = 0;
    for (var semilla = 0; semilla < tiradas; semilla++) {
      final selector = SelectorHabilidades(
        cargarEstado: (id) async => estados[id],
        semilla: semilla,
      );
      final elegida = await selector.elegirSiguienteHabilidad(
        candidatas: candidatas,
        contextoBonusId: contextoBonusId,
        aplicarBonusContexto: aplicarBonusContexto,
      );
      if (elegida == idObjetivo) aciertos++;
    }
    return aciertos / tiradas;
  }

  test('candidatas vacías → null', () async {
    final selector = SelectorHabilidades(
      cargarEstado: (_) async => null,
      semilla: 0,
    );
    final elegida = await selector.elegirSiguienteHabilidad(
      candidatas: const [],
    );
    expect(elegida, isNull);
  });

  test('una sola candidata sin estado previo → la elige', () async {
    final habilidad = construirHabilidad(id: 'FR.01');
    final selector = SelectorHabilidades(
      cargarEstado: (_) async => null,
      semilla: 0,
    );
    final elegida = await selector.elegirSiguienteHabilidad(
      candidatas: [habilidad],
    );
    expect(elegida, 'FR.01');
  });

  test('inexplorada (peso 10) prevalece sobre maestría (peso 1)', () async {
    // Sin decay (ultimaPractica reciente) para aislar el efecto de los
    // pesos por nivel: 10 vs 1 → 10/11 ≈ 0.91 esperado.
    final inexplorada = construirHabilidad(id: 'FR.01');
    final dominada = construirHabilidad(id: 'FR.02');
    final fraccion = await fraccionElecciones(
      idObjetivo: 'FR.01',
      candidatas: [inexplorada, dominada],
      estados: {
        'FR.02': estadoCon(
          id: 'FR.02',
          nivel: NivelMaestria.maestria,
          totalExposiciones: 20,
          ultimaPractica: DateTime.now(),
        ),
      },
    );
    expect(fraccion, greaterThan(0.85));
  });

  test('bonus de contexto: pertenecer al contexto sube ~2 puntos', () async {
    // Dos habilidades en nivel competente (peso 3). Una pertenece a
    // tejados, la otra no. Con bonus contexto activo: 5 vs 3 → ~62% al
    // contexto. Sin bonus: 50/50.
    final delContexto = construirHabilidad(id: 'FR.01', distritos: ['tejados']);
    final fueraContexto =
        construirHabilidad(id: 'FR.02', distritos: ['canales']);
    final estados = {
      'FR.01': estadoCon(id: 'FR.01', nivel: NivelMaestria.competente),
      'FR.02': estadoCon(id: 'FR.02', nivel: NivelMaestria.competente),
    };

    final conBonus = await fraccionElecciones(
      idObjetivo: 'FR.01',
      candidatas: [delContexto, fueraContexto],
      estados: estados,
      contextoBonusId: 'tejados',
    );
    expect(conBonus, greaterThan(0.55), reason: '5/8 esperado');
    expect(conBonus, lessThan(0.70));

    final sinBonus = await fraccionElecciones(
      idObjetivo: 'FR.01',
      candidatas: [delContexto, fueraContexto],
      estados: estados,
      contextoBonusId: 'tejados',
      aplicarBonusContexto: false,
    );
    expect(sinBonus, greaterThan(0.40));
    expect(sinBonus, lessThan(0.60));
  });

  test('bonus contexto inerte si contextoBonusId es null', () async {
    final a = construirHabilidad(id: 'FR.01', distritos: ['tejados']);
    final b = construirHabilidad(id: 'FR.02', distritos: ['tejados']);
    final estados = {
      'FR.01': estadoCon(id: 'FR.01', nivel: NivelMaestria.competente),
      'FR.02': estadoCon(id: 'FR.02', nivel: NivelMaestria.competente),
    };
    final fraccion = await fraccionElecciones(
      idObjetivo: 'FR.01',
      candidatas: [a, b],
      estados: estados,
      contextoBonusId: null,
    );
    expect(fraccion, greaterThan(0.40));
    expect(fraccion, lessThan(0.60));
  });

  test('decay: >10 días sin práctica añade puntos a la habilidad', () async {
    // Dos habilidades enDesarrollo (peso 7). Una se practicó hace 30
    // días → 7 + min(5, 30*0.3=9) = 7+5 = 12. La otra hace 1 día → 7.
    // 12 / 19 ≈ 0.63.
    final hace30dias = DateTime.now().subtract(const Duration(days: 30));
    final hace1dia = DateTime.now().subtract(const Duration(days: 1));
    final reciente = construirHabilidad(id: 'FR.01');
    final olvidada = construirHabilidad(id: 'FR.02');

    final fraccion = await fraccionElecciones(
      idObjetivo: 'FR.02',
      candidatas: [reciente, olvidada],
      estados: {
        'FR.01': estadoCon(
          id: 'FR.01',
          nivel: NivelMaestria.enDesarrollo,
          totalExposiciones: 5,
          ultimaPractica: hace1dia,
        ),
        'FR.02': estadoCon(
          id: 'FR.02',
          nivel: NivelMaestria.enDesarrollo,
          totalExposiciones: 5,
          ultimaPractica: hace30dias,
        ),
      },
    );
    expect(fraccion, greaterThan(0.55));
  });

  test('decay no aplica si totalExposiciones == 0', () async {
    // ultimaPractica antigua pero sin exposiciones → sin bonus de decay.
    // Ambas inexploradas: 10 vs 10 → 50/50.
    final hace30dias = DateTime.now().subtract(const Duration(days: 30));
    final a = construirHabilidad(id: 'FR.01');
    final b = construirHabilidad(id: 'FR.02');
    final fraccion = await fraccionElecciones(
      idObjetivo: 'FR.01',
      candidatas: [a, b],
      estados: {
        'FR.01': estadoCon(
          id: 'FR.01',
          totalExposiciones: 0,
          ultimaPractica: hace30dias,
        ),
        'FR.02': estadoCon(id: 'FR.02', totalExposiciones: 0),
      },
    );
    expect(fraccion, greaterThan(0.40));
    expect(fraccion, lessThan(0.60));
  });

  test('anti-repetición: la última elegida pierde 70% de su peso', () async {
    // Misma semilla, dos llamadas seguidas, dos candidatas idénticas.
    // En la 2ª llamada la primera pierde 70% → la otra debería ganar
    // casi siempre.
    final a = construirHabilidad(id: 'FR.01');
    final b = construirHabilidad(id: 'FR.02');
    final estados = {
      'FR.01': estadoCon(id: 'FR.01', nivel: NivelMaestria.enDesarrollo),
      'FR.02': estadoCon(id: 'FR.02', nivel: NivelMaestria.enDesarrollo),
    };
    var bSegundaVez = 0;
    const tiradas = 1000;
    for (var semilla = 0; semilla < tiradas; semilla++) {
      final selector = SelectorHabilidades(
        cargarEstado: (id) async => estados[id],
        semilla: semilla,
      );
      final primera = await selector.elegirSiguienteHabilidad(
        candidatas: [a, b],
      );
      final segunda = await selector.elegirSiguienteHabilidad(
        candidatas: [a, b],
      );
      if (primera != segunda) bSegundaVez++;
    }
    // Si penalizamos *0.3 a la última, la otra tiene 7 vs 2.1 → ~77%
    // de cambiar.
    expect(bSegundaVez / tiradas, greaterThan(0.65));
  });

  test('dependencias bloquean si dep está bajo competente', () async {
    final dep = construirHabilidad(id: 'FR.01');
    final dependiente =
        construirHabilidad(id: 'FR.05', dependencias: ['FR.01']);
    final selector = SelectorHabilidades(
      cargarEstado: (id) async => id == 'FR.01'
          ? estadoCon(id: 'FR.01', nivel: NivelMaestria.enDesarrollo)
          : null,
      semilla: 0,
    );
    final elegida = await selector.elegirSiguienteHabilidad(
      candidatas: [dep, dependiente],
    );
    // FR.05 está bloqueada (FR.01 < competente). FR.01 está disponible.
    expect(elegida, 'FR.01');
  });

  test('dependencias listas si la propia ya está enDesarrollo+', () async {
    // Aunque la dep no esté competente, si la propia habilidad ya se
    // está practicando (≥enDesarrollo) no se bloquea.
    final dep = construirHabilidad(id: 'FR.01');
    final dependiente =
        construirHabilidad(id: 'FR.05', dependencias: ['FR.01']);
    final selector = SelectorHabilidades(
      cargarEstado: (id) async {
        if (id == 'FR.01') {
          return estadoCon(id: 'FR.01', nivel: NivelMaestria.introducida);
        }
        if (id == 'FR.05') {
          return estadoCon(id: 'FR.05', nivel: NivelMaestria.enDesarrollo);
        }
        return null;
      },
      semilla: 0,
    );
    final elegida = await selector.elegirSiguienteHabilidad(
      candidatas: [dep, dependiente],
    );
    // Ambas elegibles. No comprobamos cuál sale, sólo que no es null.
    expect(elegida, isNotNull);
  });

  test('dependencias ausentes del mapa de estados no bloquean', () async {
    // Dep = "DIV.01" no está entre las candidatas y nunca se ha tocado.
    // El selector la trata como prerrequisito externo y no bloquea.
    final dependiente =
        construirHabilidad(id: 'FR.05', dependencias: ['DIV.01']);
    final selector = SelectorHabilidades(
      cargarEstado: (_) async => null,
      semilla: 0,
    );
    final elegida = await selector.elegirSiguienteHabilidad(
      candidatas: [dependiente],
    );
    expect(elegida, 'FR.05');
  });

  test('determinismo: misma semilla + mismas entradas → misma elección',
      () async {
    final a = construirHabilidad(id: 'FR.01');
    final b = construirHabilidad(id: 'FR.02');
    final estados = {
      'FR.01': estadoCon(id: 'FR.01', nivel: NivelMaestria.enDesarrollo),
      'FR.02': estadoCon(id: 'FR.02', nivel: NivelMaestria.competente),
    };
    final s1 = SelectorHabilidades(
      cargarEstado: (id) async => estados[id],
      semilla: 42,
    );
    final s2 = SelectorHabilidades(
      cargarEstado: (id) async => estados[id],
      semilla: 42,
    );
    final r1 = await s1.elegirSiguienteHabilidad(candidatas: [a, b]);
    final r2 = await s2.elegirSiguienteHabilidad(candidatas: [a, b]);
    expect(r1, r2);
  });
}
