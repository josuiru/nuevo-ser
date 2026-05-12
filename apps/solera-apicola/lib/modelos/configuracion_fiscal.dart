/// Configuración fiscal del titular. Single-row en la tabla
/// `configuraciones_fiscales` (la BD no debe tener más de una en
/// v0.1). Es **global** del titular, no por-apiario — el régimen
/// IRPF y la forma de IVA se eligen para toda la actividad apícola.
///
/// **v1 provisional** soporta los dos regímenes dominantes en
/// apicultura mediana (20-200 colmenas):
///  - IRPF: estimación directa simplificada (la más común si hay
///    contabilidad mínima al día) o estimación directa normal.
///  - IVA: REAGP (régimen especial agricultura, ganadería y pesca,
///    con compensación del 12%) o régimen general.
///
/// Módulos NO está soportado en v1 — el asesor fiscal debe pedirlo
/// y validar el formato del extracto antes de añadirlo. Registrado
/// en BLOQUEOS-PENDIENTES.md (F1A-10).
class ConfiguracionFiscal {
  final int? id;

  /// 'estimacion_directa_simplificada' | 'estimacion_directa_normal'
  /// | 'sin_elegir'
  final String regimenIrpf;

  /// 'reagp' | 'general' | 'sin_elegir'
  final String regimenIva;

  /// Año fiscal en uso por defecto cuando se abre el libro
  /// económico. 0 = sin elegir → la pantalla usa el año actual.
  final int anoFiscalActivo;

  ConfiguracionFiscal({
    this.id,
    this.regimenIrpf = 'sin_elegir',
    this.regimenIva = 'sin_elegir',
    this.anoFiscalActivo = 0,
  });

  bool get estaConfigurado =>
      regimenIrpf != 'sin_elegir' && regimenIva != 'sin_elegir';

  bool get tieneCompensacionReagp => regimenIva == 'reagp';

  /// Tipo de IVA repercutido en venta de productos apícolas en
  /// régimen general. Miel y derivados tributan al 4% como alimento
  /// de primera necesidad (Ley 37/1992 LIVA art. 91.1.1.1.º). En
  /// REAGP no se repercute IVA — el comprador paga compensación 12%.
  double get tipoIvaVentaProducto => regimenIva == 'general' ? 0.04 : 0.0;

  /// Compensación REAGP que el comprador paga al apicultor cuando
  /// éste está en REAGP: 12% sobre la base imponible (Ley 37/1992
  /// LIVA art. 130). Cero si el titular NO está en REAGP.
  double get tipoCompensacionReagp => regimenIva == 'reagp' ? 0.12 : 0.0;

  /// IVA del servicio de polinización (alquiler de colmenas).
  /// Tributa al 21% general — caveat documentado en
  /// BLOQUEOS-PENDIENTES.md: el asesor fiscal puede determinar si
  /// procede el reducido del 10% o si encaja como REAGP en algunos
  /// casos. v1 aplica el más conservador: general 21%.
  double get tipoIvaPolinizacion => 0.21;

  Map<String, Object?> toMap() => {
        'id': id,
        'regimen_irpf': regimenIrpf,
        'regimen_iva': regimenIva,
        'ano_fiscal_activo': anoFiscalActivo,
      };

  factory ConfiguracionFiscal.fromMap(Map<String, Object?> mapa) =>
      ConfiguracionFiscal(
        id: mapa['id'] as int?,
        regimenIrpf: (mapa['regimen_irpf'] as String?) ?? 'sin_elegir',
        regimenIva: (mapa['regimen_iva'] as String?) ?? 'sin_elegir',
        anoFiscalActivo: (mapa['ano_fiscal_activo'] as int?) ?? 0,
      );
}
