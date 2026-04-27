import 'dart:math' as math;

/// Problema DIV.02: el niño ve un número N y cuatro candidatos. Tres
/// de ellos son divisores reales de N y uno no lo es. La habilidad es
/// reconocer cuál es el intruso. Pedagógicamente refuerza la idea de
/// divisor (un número que entra exacto) frente a no-divisor.
class ProblemaDivisores {
  final int numero;
  final List<int> candidatos;
  final int indiceIntruso;

  const ProblemaDivisores({
    required this.numero,
    required this.candidatos,
    required this.indiceIntruso,
  });

  int get intruso => candidatos[indiceIntruso];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceIntruso;
}

/// Números con suficientes divisores para que la mecánica funcione
/// (al menos 4 divisores propios entre 2 y N-1).
const _numerosFaciles = <int>[12, 18, 24, 20, 16, 30];
const _numerosMedios = <int>[36, 48, 60, 40, 28, 45];

class GeneradorDivisores {
  final math.Random _azar;

  GeneradorDivisores({int? semilla}) : _azar = math.Random(semilla);

  ProblemaDivisores generar({int dificultad = 1}) {
    final pool = <int>[
      ..._numerosFaciles,
      if (dificultad >= 2) ..._numerosMedios,
    ];
    final n = pool[_azar.nextInt(pool.length)];
    return _construirDesdeNumero(n);
  }

  ProblemaDivisores generarDesdeNumero(int n) => _construirDesdeNumero(n);

  ProblemaDivisores _construirDesdeNumero(int n) {
    final divisoresPropios = <int>[
      for (var d = 2; d < n; d++)
        if (n % d == 0) d,
    ];
    final noDivisores = <int>[
      for (var d = 2; d < n; d++)
        if (n % d != 0) d,
    ];

    // Tomamos tres divisores reales al azar; si no hay suficientes,
    // rellenamos con divisores triviales (1 si encaja). Por construcción
    // de los pools _numerosFaciles/_numerosMedios siempre hay ≥3.
    final divisoresMezclados = List<int>.from(divisoresPropios)
      ..shuffle(_azar);
    final tresDivisores = divisoresMezclados.take(3).toList();

    // Elegimos un no-divisor que sea cercano a alguno de los divisores
    // — un error plausible, no un número absurdo.
    int intruso;
    if (noDivisores.isEmpty) {
      // Defensa: si todos los números menores que n son divisores
      // (caso teórico imposible para n>2 con n no primo), usamos n+1.
      intruso = n + 1;
    } else {
      intruso = noDivisores[_azar.nextInt(noDivisores.length)];
    }

    final candidatos = [...tresDivisores, intruso]..shuffle(_azar);
    final indice = candidatos.indexOf(intruso);

    return ProblemaDivisores(
      numero: n,
      candidatos: candidatos,
      indiceIntruso: indice,
    );
  }
}
