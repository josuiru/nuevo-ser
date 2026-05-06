import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'catalogo_brechas.dart';
import 'cuaderno.dart';
import 'escenas_arco_1.dart';
import 'escenas_arco_2.dart';
import 'escenas_arco_3.dart';

/// Estado agregado del progreso del juego para una Cronista. Lo
/// computa [calcularAvances] a partir del set de flags activos + la
/// cuenta de Mosaicos entregados, sin tocar persistencia.
///
/// Se utiliza en la `PantallaAvances` para que la Cronista (y el
/// adulto acompañante) vean dónde está el oficio sin tener que
/// recorrer el mapa narrativo entero.
class AvancesArchivo {
  final List<AvanceArco> arcos;
  final int brechasCompletadas;
  final int brechasTotal;
  final int entradasCuaderno;
  final int entradasCuadernoTotal;
  final int mosaicosEntregados;
  final int mosaicosTotal;

  const AvancesArchivo({
    required this.arcos,
    required this.brechasCompletadas,
    required this.brechasTotal,
    required this.entradasCuaderno,
    required this.entradasCuadernoTotal,
    required this.mosaicosEntregados,
    required this.mosaicosTotal,
  });
}

/// Avance de un arco concreto. `cinematicasVistas` cuenta cuántas
/// escenas del arco tienen su `flagDeSalida` activo; `total` es el
/// tamaño del catálogo. `cerrado` mira un flag específico de cierre
/// del arco.
class AvanceArco {
  final String id;
  final String titulo;
  final int cinematicasVistas;
  final int cinematicasTotal;
  final bool cerrado;

  const AvanceArco({
    required this.id,
    required this.titulo,
    required this.cinematicasVistas,
    required this.cinematicasTotal,
    required this.cerrado,
  });
}

/// Computa el estado agregado a partir del set de [flagsActivos],
/// los IDs del Cuaderno registrados y los flags
/// `mosaico_arco_*_entregado`. Función pura — toda la lógica de
/// fuente está aquí, los catálogos se leen como datos.
AvancesArchivo calcularAvances({
  required Set<String> flagsActivos,
  required Set<String> idsCuadernoRegistrados,
  required bool mosaicoArco1Entregado,
  required bool mosaicoArco2Entregado,
}) {
  int contarVistas(List<EscenaCinematica> escenas) {
    var vistas = 0;
    for (final escena in escenas) {
      if (flagsActivos.contains(escena.flagDeSalida)) vistas++;
    }
    return vistas;
  }

  final arcos = <AvanceArco>[
    AvanceArco(
      id: 'arco_1',
      titulo: 'Arco 1 — La voz que falta',
      cinematicasVistas: contarVistas(EscenasArco1.todas),
      cinematicasTotal: EscenasArco1.todas.length,
      cerrado: flagsActivos.contains('arco_1_cerrado_por_la_cronista'),
    ),
    AvanceArco(
      id: 'arco_2',
      titulo: 'Arco 2 — El oficio del silencio',
      cinematicasVistas: contarVistas(EscenasArco2.todas),
      cinematicasTotal: EscenasArco2.todas.length,
      cerrado: flagsActivos.contains('arco_2_cerrado_por_la_cronista'),
    ),
    AvanceArco(
      id: 'arco_3',
      titulo: 'Arco 3 — La forja del reino',
      cinematicasVistas: contarVistas(EscenasArco3.todas),
      cinematicasTotal: EscenasArco3.todas.length,
      cerrado: flagsActivos.contains('arco_3_cerrado_por_la_cronista'),
    ),
  ];

  final flagsCompletadoBrechas = CatalogoBrechas
      .brechaPorFlagDeDisparo.values
      .map((brecha) => brecha.flagDeCompletado)
      .toSet();
  final brechasCompletadas =
      flagsCompletadoBrechas.where(flagsActivos.contains).length;

  final entradasCuaderno = CatalogoCuaderno.todas
      .where((entrada) => idsCuadernoRegistrados.contains(entrada.id))
      .length;

  final mosaicosEntregados =
      (mosaicoArco1Entregado ? 1 : 0) + (mosaicoArco2Entregado ? 1 : 0);

  return AvancesArchivo(
    arcos: arcos,
    brechasCompletadas: brechasCompletadas,
    brechasTotal: flagsCompletadoBrechas.length,
    entradasCuaderno: entradasCuaderno,
    entradasCuadernoTotal: CatalogoCuaderno.todas.length,
    mosaicosEntregados: mosaicosEntregados,
    mosaicosTotal: 2,
  );
}
