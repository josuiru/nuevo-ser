/// Configuración fiscal del titular (almazara o agricultor). Single-row
/// en la tabla `configuracion_fiscal`. Es **global** del titular:
/// cambia qué columnas pide el extracto y si los apuntes de venta de
/// aceituna o aceite llevan IVA repercutido (régimen general) o
/// compensación REAGP del 12% (REAGP).
///
/// **v1 PROVISIONAL hasta asesor fiscal**. Las reglas de tipos
/// implícitos se basan en la interpretación habitual del olivar, pero
/// la casuística entre venta de aceituna, aceite a granel a otro
/// envasador y aceite envasado al consumidor final es compleja —
/// registrado en BLOQUEOS-PENDIENTES.md (F1-A9). Mientras tanto, el
/// usuario puede sobrescribir el IVA en cada apunte.
///
/// **Regímenes soportados v1**:
///   - IRPF: estimación directa simplificada (la más común si hay
///     contabilidad mínima al día) o estimación directa normal.
///   - IVA: REAGP (régimen especial agricultura, ganadería y pesca,
///     con compensación del 12%) o régimen general.
///
/// Módulos NO está soportado en v1.
///
/// **Diferencia clave vs viticultura**:
///   - El **aceite** NO es bebida alcohólica (no aplica 21%). El
///     aceite virgen extra y virgen son alimentos básicos al 4% IVA
///     reducido. El aceite a granel entre operadores tiene matices
///     que el asesor fiscal debe confirmar.
///   - La **aceituna** vendida a almazara es producto agrícola REAGP-
///     elegible al 12% de compensación (igual que la uva a bodega).
class ConfiguracionFiscal {
  final int? id;

  /// 'estimacion_directa_simplificada' | 'estimacion_directa_normal'
  /// | 'sin_elegir'
  final String regimenIrpf;

  /// 'reagp' | 'general' | 'sin_elegir'
  final String regimenIva;

  /// Año fiscal en uso por defecto cuando se abre el libro económico.
  /// 0 = sin elegir → la pantalla usa el año actual.
  final int anyoFiscalActivo;

  ConfiguracionFiscal({
    this.id,
    this.regimenIrpf = 'sin_elegir',
    this.regimenIva = 'sin_elegir',
    this.anyoFiscalActivo = 0,
  });

  bool get estaConfigurado =>
      regimenIrpf != 'sin_elegir' && regimenIva != 'sin_elegir';

  bool get tieneCompensacionReagp => regimenIva == 'reagp';

  /// Tipo de IVA repercutido en venta de **aceituna** en régimen
  /// general: 4% reducido (producto agrícola básico). En REAGP no se
  /// repercute IVA — el comprador paga compensación REAGP en su lugar.
  double get tipoIvaVentaAceituna => regimenIva == 'general' ? 0.04 : 0.0;

  /// Compensación REAGP que el comprador paga al titular cuando éste
  /// está en REAGP y la operación es venta de aceituna: 12% sobre la
  /// base imponible (Ley 37/1992 LIVA art. 130). NO aplica al aceite
  /// envasado por el propio titular — el aceite es producto
  /// transformado y la almazara queda fuera del REAGP en esa venta.
  /// Cero si el titular no está en REAGP.
  double get tipoCompensacionReagpAceituna =>
      regimenIva == 'reagp' ? 0.12 : 0.0;

  /// Tipo de IVA repercutido en venta de **aceite virgen extra /
  /// virgen / lampante** envasado al consumidor final: 4% reducido
  /// (alimento de primera necesidad). Aplica esté el titular en
  /// REAGP o en general — el aceite envasado al consumidor está
  /// fuera del REAGP. ⚠ Si la regulación cambia (revisiones UE
  /// periódicas), sobrescribir en el apunte.
  double get tipoIvaVentaAceiteEnvasado => 0.04;

  /// Tipo de IVA repercutido en venta de aceite a granel a otro
  /// **envasador o refinador** (no consumidor final): tratamiento
  /// reducido al 4% por seguir siendo alimento, sujeto a confirmación
  /// del asesor fiscal — algunos asesores asumen 10% por ser
  /// operación entre operadores, otros mantienen 4% por la
  /// categorización del producto. ⚠ El usuario sobrescribe en el
  /// apunte hasta que entre F1-A10 con el asesor real.
  double get tipoIvaVentaAceiteGranel => 0.04;

  /// IVA del alquiler de terreno con uso agrícola: exento (Ley
  /// 37/1992 LIVA art. 20.1.23). Si el alquiler es para uso no
  /// agrícola tributa al 21% — el usuario sobrescribe en el formulario.
  double get tipoIvaAlquilerTerreno => 0.0;

  Map<String, Object?> toMap() => {
        'id': id,
        'regimen_irpf': regimenIrpf,
        'regimen_iva': regimenIva,
        'anyo_fiscal_activo': anyoFiscalActivo,
      };

  factory ConfiguracionFiscal.fromMap(Map<String, Object?> mapa) =>
      ConfiguracionFiscal(
        id: mapa['id'] as int?,
        regimenIrpf: (mapa['regimen_irpf'] as String?) ?? 'sin_elegir',
        regimenIva: (mapa['regimen_iva'] as String?) ?? 'sin_elegir',
        anyoFiscalActivo: (mapa['anyo_fiscal_activo'] as int?) ?? 0,
      );
}
