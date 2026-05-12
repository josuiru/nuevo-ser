class ConfiguracionFiscal {
  final int? id;
  final String regimenIva; // reagp / general
  final String regimenIrpf; // estimacion_directa_simplificada / estimacion_directa_normal / modulos
  final bool compensacionReagp; // true = aplica compensación REAGP 12%

  ConfiguracionFiscal({
    this.id,
    this.regimenIva = 'reagp',
    this.regimenIrpf = 'estimacion_directa_simplificada',
    this.compensacionReagp = true,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'regimen_iva': regimenIva,
        'regimen_irpf': regimenIrpf,
        'compensacion_reagp': compensacionReagp ? 1 : 0,
      };

  factory ConfiguracionFiscal.fromMap(Map<String, Object?> mapa) =>
      ConfiguracionFiscal(
        id: mapa['id'] as int?,
        regimenIva: (mapa['regimen_iva'] as String?) ?? 'reagp',
        regimenIrpf: (mapa['regimen_irpf'] as String?) ?? 'estimacion_directa_simplificada',
        compensacionReagp: (mapa['compensacion_reagp'] as int?) == 1,
      );
}
