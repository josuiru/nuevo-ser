/// Configuración fiscal del titular (bodega o viticultor). Single-row
/// en la tabla `configuraciones_fiscales`. Es **global** del titular:
/// cambia qué columnas pide el extracto y si los apuntes de venta de
/// uva o vino llevan IVA repercutido (régimen general) o
/// compensación REAGP del 12% (REAGP).
///
/// **v1 provisional** soporta los dos regímenes dominantes en
/// bodega pequeña/mediana:
///  - IRPF: estimación directa simplificada (la más común si hay
///    contabilidad mínima al día) o estimación directa normal.
///  - IVA: REAGP (régimen especial agricultura, ganadería y pesca,
///    con compensación del 12%) o régimen general.
///
/// Módulos NO está soportado en v1 — el asesor fiscal debe pedirlo
/// y validar el formato del extracto antes de añadirlo. Registrado
/// en BLOQUEOS-PENDIENTES.md (F1-12).
///
/// Diferencia clave vs agro: la **uva** tributa al 4% (alimento de
/// primera necesidad si se vende para consumo, aunque la mayoría va
/// a vinificación). El **vino** tributa al 21% general (bebida
/// alcohólica). El usuario sobrescribe en cada apunte cuando difiera.
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

  /// Tipo de IVA repercutido en venta de uva en régimen general:
  /// 4% reducido (producto agrícola). En REAGP no se repercute IVA.
  double get tipoIvaVentaUva => regimenIva == 'general' ? 0.04 : 0.0;

  /// Tipo de IVA en venta de vino: 21% general — el vino es bebida
  /// alcohólica y NO entra en el 4% reducido. Aplica tanto a botella
  /// como a granel, con o sin DOP/IGP.
  double get tipoIvaVentaVino => 0.21;

  /// Compensación REAGP que el comprador paga al viticultor cuando
  /// éste está en REAGP: 12% sobre la base imponible (Ley 37/1992
  /// LIVA art. 130). Aplica a la **uva** vendida (producto agrícola
  /// estricto). NO aplica al vino — el vino ya es producto
  /// transformado por la bodega y queda fuera del REAGP. Cero si el
  /// titular no está en REAGP.
  double get tipoCompensacionReagpUva => regimenIva == 'reagp' ? 0.12 : 0.0;

  /// IVA del alquiler de terreno con uso agrícola: exento (Ley
  /// 37/1992 LIVA art. 20.1.23). Si el alquiler es para uso no
  /// agrícola tributa al 21% — el usuario sobrescribe en el
  /// formulario.
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
