import 'entrada_cuaderno.dart';

/// Resultado de `GET /companion/cuaderno/entries`.
///
/// El backend pagina con `limit`/`offset` clásicos. [total] es el número
/// total de entradas que matchean el filtro (independiente de la página
/// actual) — útil para que la app decida si pedir más páginas.
class ListadoEntradasCuaderno {
  final List<EntradaCuaderno> entradas;
  final int total;
  final int limit;
  final int offset;

  const ListadoEntradasCuaderno({
    required this.entradas,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory ListadoEntradasCuaderno.desdeJson(Map<String, dynamic> json) {
    final crudas = json['entries'];
    final List<EntradaCuaderno> entradas;
    if (crudas is List) {
      entradas = crudas
          .whereType<Map>()
          .map((m) => EntradaCuaderno.desdeJsonListado(
                m.map((k, v) => MapEntry(k.toString(), v)),
              ))
          .toList(growable: false);
    } else {
      entradas = const [];
    }
    return ListadoEntradasCuaderno(
      entradas: entradas,
      total: (json['total'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
    );
  }
}
