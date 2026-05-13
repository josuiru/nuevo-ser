// Localizaciones del puerto de La Estafeta. Doc 02 §1 (la ciudad) +
// pivot de v0.13.0 hacia mundo explorable.
//
// El aprendiz se mueve por cinco lugares conectados según el mapa:
//
//                       ┌──────────┐
//                       │  Boletín │
//                       └────┬─────┘
//                            │
//                            ▼
//   ┌─────────┐          ┌──────────┐         ┌──────────┐
//   │Despacho │◀────────│Calle Mayor│────────▶│  Muelle  │
//   │ Maestro │          └────┬─────┘         └──────────┘
//   └─────────┘               │
//                             ▼
//                       ┌──────────┐
//                       │ Oficina  │ (default al arrancar)
//                       └──────────┘

enum Localizacion {
  oficina('oficina', 'La oficina', 'Tu mesa en La Estafeta'),
  calleMayor('calle_mayor', 'Calle Mayor', 'El centro del puerto'),
  despachoMaestro(
    'despacho_maestro',
    'Despacho del maestro',
    'Antón te espera',
  ),
  muelle('muelle', 'El muelle', 'Donde llegan los barcos'),
  boletin('boletin', 'El Boletín', 'El periódico de la ciudad');

  const Localizacion(
    this.identificadorTecnico,
    this.nombreCanonico,
    this.descripcionBreve,
  );

  final String identificadorTecnico;
  final String nombreCanonico;
  final String descripcionBreve;

  /// Ruta al render de fondo. La convención: assets/escenarios/<id>.png.
  String get rutaFondo => 'assets/escenarios/$identificadorTecnico.png';

  static Localizacion desdeIdentificador(String identificador) {
    for (final loc in Localizacion.values) {
      if (loc.identificadorTecnico == identificador) return loc;
    }
    throw ArgumentError('Localización desconocida: "$identificador"');
  }
}

/// Conexiones del mapa: desde una localización, a cuáles se puede ir
/// directamente. El grafo no es completo — la geografía importa.
const Map<Localizacion, Set<Localizacion>> conexionesPuerto = {
  Localizacion.oficina: {Localizacion.calleMayor},
  Localizacion.calleMayor: {
    Localizacion.oficina,
    Localizacion.despachoMaestro,
    Localizacion.muelle,
    Localizacion.boletin,
  },
  Localizacion.despachoMaestro: {Localizacion.calleMayor},
  Localizacion.muelle: {Localizacion.calleMayor},
  Localizacion.boletin: {Localizacion.calleMayor},
};

/// Localizaciones alcanzables desde aquí (vacío si la actual es null).
Set<Localizacion> destinosDesde(Localizacion actual) {
  return conexionesPuerto[actual] ?? const {};
}
