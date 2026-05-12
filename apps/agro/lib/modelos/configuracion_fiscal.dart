/// Configuración fiscal del titular agrícola. Single-row en la tabla
/// `configuraciones_fiscales`. Es **global** del titular: cambia qué
/// columnas pide el extracto y si los apuntes de venta de cosecha
/// llevan IVA repercutido (régimen general) o compensación REAGP
/// del 12%.
///
/// **v1 provisional** soporta los dos regímenes dominantes en
/// agricultor pequeño/mediano (multi-cultivo en explotaciones
/// peninsulares):
///  - IRPF: estimación directa simplificada (la más común si hay
///    contabilidad mínima al día) o estimación directa normal.
///  - IVA: REAGP (régimen especial agricultura, ganadería y pesca,
///    con compensación del 12%) o régimen general.
///
/// Módulos NO está soportado en v1 — el asesor fiscal debe pedirlo
/// y validar el formato del extracto antes de añadirlo. Registrado
/// en BLOQUEOS-PENDIENTES.md (F3.5). Es importante señalar que en
/// agricultura módulos sigue siendo más usado que en apicultura, así
/// que es probable que el asesor lo pida.
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

  /// Tipo de IVA repercutido en venta de cosecha en régimen general.
  /// Asume 4% por defecto: aceite de oliva, frutas, hortalizas,
  /// cereales, vino sin DOP/IGP tributan al 4% como alimento de
  /// primera necesidad (Ley 37/1992 LIVA art. 91.1.1.1.º). El
  /// usuario sobrescribe cuando sea distinto (vino DOP/IGP 21%,
  /// trufa 10%, madera 21%). En REAGP no se repercute IVA.
  double get tipoIvaVentaCosecha => regimenIva == 'general' ? 0.04 : 0.0;

  /// Compensación REAGP que el comprador paga al agricultor cuando
  /// éste está en REAGP: 12% sobre la base imponible (Ley 37/1992
  /// LIVA art. 130). Cero si el titular NO está en REAGP.
  double get tipoCompensacionReagp => regimenIva == 'reagp' ? 0.12 : 0.0;

  /// IVA del alquiler de terreno con uso agrícola: exento (Ley
  /// 37/1992 LIVA art. 20.1.23). Si el alquiler es para uso no
  /// agrícola (cazadero, evento, almacén) tributa al 21% — el
  /// usuario sobrescribe en el formulario.
  double get tipoIvaAlquilerTerreno => 0.0;

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
