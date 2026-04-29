import 'mosaico.dart';

/// Resultado de `GET /companion/mosaicos`.
///
/// Misma envoltura que [ListadoEntradasCuaderno]: el cliente trabaja con
/// una sola forma de paginación para todos los listados de companion.
class ListadoMosaicos {
  final List<Mosaico> mosaicos;
  final int total;
  final int limit;
  final int offset;

  const ListadoMosaicos({
    required this.mosaicos,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory ListadoMosaicos.desdeJson(Map<String, dynamic> json) {
    final crudas = json['entries'];
    final List<Mosaico> mosaicos;
    if (crudas is List) {
      mosaicos = crudas
          .whereType<Map>()
          .map((m) => Mosaico.desdeJsonListado(
                m.map((k, v) => MapEntry(k.toString(), v)),
              ))
          .toList(growable: false);
    } else {
      mosaicos = const [];
    }
    return ListadoMosaicos(
      mosaicos: mosaicos,
      total: (json['total'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
    );
  }
}
