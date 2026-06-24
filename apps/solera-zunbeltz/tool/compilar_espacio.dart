// Compilador del espacio (fincas + puntos de infraestructura) de CSV a Dart.
//
// Lee content/espacio/fincas.csv y content/espacio/puntos.csv y genera
// lib/datos/espacio_generado.dart, que la app usa como seed real del Espacio
// Test. Cuando Zunbeltz entregue (o se capturen en campo) los puntos reales,
// se rellenan los CSV y se ejecuta:
//
//   dart run tool/compilar_espacio.dart
//
// Mismo patrón que los catálogos del resto de la suite Solera.

import 'dart:io';

const _delim = ';';

void main() {
  final raiz = Directory.current.path;
  final fincas = _leerCsv('$raiz/content/espacio/fincas.csv');
  final puntos = _leerCsv('$raiz/content/espacio/puntos.csv');

  final buffer = StringBuffer()
    ..writeln('// GENERADO por tool/compilar_espacio.dart — NO editar a mano.')
    ..writeln('// Fuente: content/espacio/fincas.csv y content/espacio/puntos.csv')
    ..writeln()
    ..writeln('class FincaSeed {')
    ..writeln('  const FincaSeed(this.nombre, this.latitud, this.longitud,')
    ..writeln('      this.superficieHa, this.recintosSigpac, this.notas);')
    ..writeln('  final String nombre;')
    ..writeln('  final double? latitud;')
    ..writeln('  final double? longitud;')
    ..writeln('  final double superficieHa;')
    ..writeln('  final String recintosSigpac;')
    ..writeln('  final String notas;')
    ..writeln('}')
    ..writeln()
    ..writeln('class PuntoSeed {')
    ..writeln('  const PuntoSeed(this.finca, this.tipo, this.nombre,')
    ..writeln('      this.latitud, this.longitud, this.estado, this.notas);')
    ..writeln('  final String finca;')
    ..writeln('  final String tipo;')
    ..writeln('  final String nombre;')
    ..writeln('  final double? latitud;')
    ..writeln('  final double? longitud;')
    ..writeln('  final String estado;')
    ..writeln('  final String notas;')
    ..writeln('}')
    ..writeln()
    ..writeln('const List<FincaSeed> fincasEspacio = [');
  for (final f in fincas) {
    buffer.writeln('  FincaSeed(${_s(f['nombre'])}, ${_d(f['latitud'])}, '
        '${_d(f['longitud'])}, ${_num(f['superficie_ha'])}, '
        '${_s(f['recintos_sigpac'])}, ${_s(f['notas'])}),');
  }
  buffer
    ..writeln('];')
    ..writeln()
    ..writeln('const List<PuntoSeed> puntosEspacio = [');
  for (final p in puntos) {
    buffer.writeln('  PuntoSeed(${_s(p['finca'])}, ${_s(p['tipo'])}, '
        '${_s(p['nombre'])}, ${_d(p['latitud'])}, ${_d(p['longitud'])}, '
        '${_s(p['estado'], def: 'operativo')}, ${_s(p['notas'])}),');
  }
  buffer.writeln('];');

  final destino = File('$raiz/lib/datos/espacio_generado.dart');
  destino.writeAsStringSync(buffer.toString());
  stdout.writeln('Generado lib/datos/espacio_generado.dart '
      '(${fincas.length} fincas, ${puntos.length} puntos).');
}

/// Lee un CSV `;`, ignorando comentarios (#) y líneas vacías. Devuelve filas
/// como mapas columna→valor según la cabecera.
List<Map<String, String>> _leerCsv(String ruta) {
  final fichero = File(ruta);
  if (!fichero.existsSync()) return const [];
  final lineas = fichero
      .readAsLinesSync()
      .where((l) => l.trim().isNotEmpty && !l.trimLeft().startsWith('#'))
      .toList();
  if (lineas.isEmpty) return const [];
  final cabecera = lineas.first.split(_delim).map((c) => c.trim()).toList();
  final filas = <Map<String, String>>[];
  for (final linea in lineas.skip(1)) {
    final campos = linea.split(_delim);
    final fila = <String, String>{};
    for (var i = 0; i < cabecera.length; i++) {
      fila[cabecera[i]] = i < campos.length ? campos[i].trim() : '';
    }
    filas.add(fila);
  }
  return filas;
}

/// Literal de String Dart, escapando comillas y barras.
String _s(String? v, {String def = ''}) {
  final texto = (v == null || v.isEmpty) ? def : v;
  final escapado = texto.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
  return "'$escapado'";
}

/// Literal de double? (null si vacío).
String _d(String? v) {
  if (v == null || v.trim().isEmpty) return 'null';
  return (double.tryParse(v.replaceAll(',', '.')) ?? 0).toString();
}

/// Literal de double (0 si vacío).
String _num(String? v) {
  if (v == null || v.trim().isEmpty) return '0';
  return (double.tryParse(v.replaceAll(',', '.')) ?? 0).toString();
}
