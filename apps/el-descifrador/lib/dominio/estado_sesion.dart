// Estado en memoria de una sesión de El Descifrador.
//
// Gestiona las tres bandejas de la mesa (entrada / en curso / resuelto)
// según composición del doc 11 §5.1.
//
// En v0.3.0 no persiste — al cerrar la app el estado se pierde y al
// reabrir, el corpus completo vuelve a estar en la bandeja de entrada.
// La persistencia llega cuando se implemente el cuaderno completo
// (siguiente sprint).

import 'pieza_corpus.dart';

/// Bandeja a la que pertenece una pieza dentro de la sesión actual.
enum Bandeja {
  /// Documentos que han llegado pero el niño aún no ha trabajado.
  entrada,

  /// Documentos que el niño está trabajando ahora. (Aún no implementado
  /// en v0.3.0 — el niño abre, decide y archiva en un solo flujo.)
  enCurso,

  /// Documentos cerrados con decisión. Quedan en archivo de la oficina.
  resuelto,
}

/// Estado completo de la sesión actual. Inmutable — las operaciones
/// devuelven nueva instancia para permitir setState() trivial en el
/// widget que la consume.
class EstadoSesion {
  EstadoSesion._(this._bandejaPorPieza, this._piezas);

  /// Estado inicial: todas las piezas en bandeja de entrada.
  factory EstadoSesion.inicial(List<PiezaCorpus> piezasDelCorpus) {
    final bandejas = <String, Bandeja>{};
    for (final pieza in piezasDelCorpus) {
      bandejas[pieza.id] = Bandeja.entrada;
    }
    return EstadoSesion._(
      Map.unmodifiable(bandejas),
      Map.unmodifiable({for (final pieza in piezasDelCorpus) pieza.id: pieza}),
    );
  }

  final Map<String, Bandeja> _bandejaPorPieza;
  final Map<String, PiezaCorpus> _piezas;

  /// Piezas en bandeja de entrada — las que el niño ve en la mesa al
  /// abrir el juego.
  List<PiezaCorpus> piezasEnBandejaDeEntrada() {
    return _piezasEnBandeja(Bandeja.entrada);
  }

  /// Piezas resueltas — visibles en la esquina resuelto de la mesa
  /// y consultables desde el archivo del cuaderno.
  List<PiezaCorpus> piezasResueltas() {
    return _piezasEnBandeja(Bandeja.resuelto);
  }

  List<PiezaCorpus> _piezasEnBandeja(Bandeja bandeja) {
    return _bandejaPorPieza.entries
        .where((entrada) => entrada.value == bandeja)
        .map((entrada) => _piezas[entrada.key]!)
        .toList();
  }

  /// Pieza concreta por ID. Lanza si no existe — debe existir si llegó
  /// desde la UI.
  PiezaCorpus piezaPorId(String id) {
    final pieza = _piezas[id];
    if (pieza == null) {
      throw StateError('Pieza desconocida: $id');
    }
    return pieza;
  }

  /// Bandeja en la que está una pieza concreta.
  Bandeja bandejaDe(String idPieza) {
    return _bandejaPorPieza[idPieza] ?? Bandeja.entrada;
  }

  /// Mueve una pieza a bandeja resuelto. Devuelve nueva instancia.
  /// La decisión concreta tomada se procesa fuera (registrar
  /// familiaridad, abrir consecuencias narrativas).
  EstadoSesion conPiezaResuelta(String idPieza) {
    final nuevasBandejas = Map<String, Bandeja>.from(_bandejaPorPieza);
    nuevasBandejas[idPieza] = Bandeja.resuelto;
    return EstadoSesion._(Map.unmodifiable(nuevasBandejas), _piezas);
  }

  /// True si no queda nada por trabajar. La mesa queda con la frase
  /// sobria del maestro: "El correo de hoy está hecho."
  bool get bandejaDeEntradaVacia => piezasEnBandejaDeEntrada().isEmpty;

  /// Número total de piezas que el niño ha resuelto hoy. Para
  /// indicador discreto en la esquina resuelto.
  int get cantidadResueltas => piezasResueltas().length;
}
