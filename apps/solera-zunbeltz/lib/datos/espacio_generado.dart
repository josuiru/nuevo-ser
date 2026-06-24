// GENERADO por tool/compilar_espacio.dart — NO editar a mano.
// Fuente: content/espacio/fincas.csv y content/espacio/puntos.csv

class FincaSeed {
  const FincaSeed(this.nombre, this.latitud, this.longitud,
      this.superficieHa, this.recintosSigpac, this.notas);
  final String nombre;
  final double? latitud;
  final double? longitud;
  final double superficieHa;
  final String recintosSigpac;
  final String notas;
}

class PuntoSeed {
  const PuntoSeed(this.finca, this.tipo, this.nombre,
      this.latitud, this.longitud, this.estado, this.notas);
  final String finca;
  final String tipo;
  final String nombre;
  final double? latitud;
  final double? longitud;
  final String estado;
  final String notas;
}

const List<FincaSeed> fincasEspacio = [
  FincaSeed('Zunbeltz', 42.7872, -1.945, 231.0, '', 'PROVISIONAL · superficie publica, centroide aproximado — validar con Zunbeltz'),
  FincaSeed('La Planilla', 42.801, -1.972, 197.0, '', 'PROVISIONAL · superficie publica, centroide aproximado — validar con Zunbeltz'),
];

const List<PuntoSeed> puntosEspacio = [
];
