// GENERADO AUTOMÁTICAMENTE — NO EDITAR A MANO.
//
// Fuente: content/apicola/sustancias_varroa.csv
// Generado: 2026-05-08
// Filas: 9 (9 revisadas, 0 pendientes de revisión)
// Estado: ✅ todas las filas revisadas por: AEMPS CIMA Vet + RD 1132/2010

/// Familia química de la sustancia activa.
enum FamiliaSustanciaVarroa { organica, sintetica, naturalAceiteEsencial }

/// Vehículo de aplicación principal. Cada uno requiere material distinto.
enum VehiculoSustanciaVarroa { sublimacion, goteo, sandwich, tiraPolimero, nebulizacion }

/// Eficacia orientativa contra varroa en condiciones ideales.
/// ⚠ La eficacia real depende de temperatura, humedad y carga de cría.
enum EficaciaSustanciaVarroa { baja, media, alta, muyAlta }

/// Ventana óptima de aplicación durante el ciclo apícola.
enum VentanaAplicacionVarroa { invernada, primavera, otono, sinPostura, conPostura }

class SustanciaVarroa {
  final String id;
  final String nombreCanonico;
  final FamiliaSustanciaVarroa familia;
  final VehiculoSustanciaVarroa vehiculoPrincipal;
  final EficaciaSustanciaVarroa eficaciaOrientativa;
  /// Plazo de seguridad orientativo en días. ⚠ Verificar etiqueta del producto.
  final int plazoSeguridadDias;
  final bool autorizadaEcologico;
  final VentanaAplicacionVarroa ventanaAplicacion;
  final String notas;

  const SustanciaVarroa({
    required this.id,
    required this.nombreCanonico,
    required this.familia,
    required this.vehiculoPrincipal,
    required this.eficaciaOrientativa,
    required this.plazoSeguridadDias,
    required this.autorizadaEcologico,
    required this.ventanaAplicacion,
    this.notas = '',
  });
}

const List<SustanciaVarroa> catalogoSustanciasVarroa = [
  SustanciaVarroa(
    id: 'acido_oxalico',
    nombreCanonico: 'Ácido oxálico',
    familia: FamiliaSustanciaVarroa.organica,
    vehiculoPrincipal: VehiculoSustanciaVarroa.sublimacion,
    eficaciaOrientativa: EficaciaSustanciaVarroa.muyAlta,
    plazoSeguridadDias: 0,
    autorizadaEcologico: true,
    ventanaAplicacion: VentanaAplicacionVarroa.sinPostura,
    notas: 'Muy eficaz en ausencia de cría operculada — invernada o tras enjambrazón. Mejor vehículo: sublimación con vaporizador',
  ),
  SustanciaVarroa(
    id: 'acido_oxalico_goteo',
    nombreCanonico: 'Ácido oxálico (goteo)',
    familia: FamiliaSustanciaVarroa.organica,
    vehiculoPrincipal: VehiculoSustanciaVarroa.goteo,
    eficaciaOrientativa: EficaciaSustanciaVarroa.alta,
    plazoSeguridadDias: 0,
    autorizadaEcologico: true,
    ventanaAplicacion: VentanaAplicacionVarroa.sinPostura,
    notas: 'Mismo principio activo en jarabe — más manual y agresivo para abejas que la sublimación',
  ),
  SustanciaVarroa(
    id: 'acido_formico',
    nombreCanonico: 'Ácido fórmico',
    familia: FamiliaSustanciaVarroa.organica,
    vehiculoPrincipal: VehiculoSustanciaVarroa.nebulizacion,
    eficaciaOrientativa: EficaciaSustanciaVarroa.alta,
    plazoSeguridadDias: 0,
    autorizadaEcologico: true,
    ventanaAplicacion: VentanaAplicacionVarroa.conPostura,
    notas: 'Penetra en la cría operculada — útil con cría presente. Cuidado: tóxico para abejas adultas en dosis alta',
  ),
  SustanciaVarroa(
    id: 'timol',
    nombreCanonico: 'Timol',
    familia: FamiliaSustanciaVarroa.naturalAceiteEsencial,
    vehiculoPrincipal: VehiculoSustanciaVarroa.tiraPolimero,
    eficaciaOrientativa: EficaciaSustanciaVarroa.media,
    plazoSeguridadDias: 0,
    autorizadaEcologico: true,
    ventanaAplicacion: VentanaAplicacionVarroa.otono,
    notas: 'Aceite esencial del tomillo. Eficacia variable con la temperatura ambiente. Plazo retirada antes de cosecha',
  ),
  SustanciaVarroa(
    id: 'amitraz',
    nombreCanonico: 'Amitraz',
    familia: FamiliaSustanciaVarroa.sintetica,
    vehiculoPrincipal: VehiculoSustanciaVarroa.tiraPolimero,
    eficaciaOrientativa: EficaciaSustanciaVarroa.muyAlta,
    plazoSeguridadDias: 30,
    autorizadaEcologico: false,
    ventanaAplicacion: VentanaAplicacionVarroa.otono,
    notas: 'Acaricida sintético. Riesgo de residuos en cera. Sospecha de resistencias documentadas en Europa',
  ),
  SustanciaVarroa(
    id: 'flumetrina',
    nombreCanonico: 'Flumetrina',
    familia: FamiliaSustanciaVarroa.sintetica,
    vehiculoPrincipal: VehiculoSustanciaVarroa.tiraPolimero,
    eficaciaOrientativa: EficaciaSustanciaVarroa.alta,
    plazoSeguridadDias: 30,
    autorizadaEcologico: false,
    ventanaAplicacion: VentanaAplicacionVarroa.otono,
    notas: 'Piretroide sintético. Resistencias documentadas — alternar con familias distintas',
  ),
  SustanciaVarroa(
    id: 'fluvalinato',
    nombreCanonico: 'Tau-fluvalinato',
    familia: FamiliaSustanciaVarroa.sintetica,
    vehiculoPrincipal: VehiculoSustanciaVarroa.tiraPolimero,
    eficaciaOrientativa: EficaciaSustanciaVarroa.alta,
    plazoSeguridadDias: 30,
    autorizadaEcologico: false,
    ventanaAplicacion: VentanaAplicacionVarroa.otono,
    notas: 'Piretroide sintético. Resistencias documentadas — usar con prudencia',
  ),
  SustanciaVarroa(
    id: 'acido_lactico',
    nombreCanonico: 'Ácido láctico',
    familia: FamiliaSustanciaVarroa.organica,
    vehiculoPrincipal: VehiculoSustanciaVarroa.nebulizacion,
    eficaciaOrientativa: EficaciaSustanciaVarroa.media,
    plazoSeguridadDias: 0,
    autorizadaEcologico: true,
    ventanaAplicacion: VentanaAplicacionVarroa.sinPostura,
    notas: 'Tradicional — eficaz solo sobre varroa forética. Operativamente muy laborioso',
  ),
  SustanciaVarroa(
    id: 'mezcla_oxalico_glicerol',
    nombreCanonico: 'Ácido oxálico + glicerol (tiras)',
    familia: FamiliaSustanciaVarroa.organica,
    vehiculoPrincipal: VehiculoSustanciaVarroa.tiraPolimero,
    eficaciaOrientativa: EficaciaSustanciaVarroa.alta,
    plazoSeguridadDias: 0,
    autorizadaEcologico: true,
    ventanaAplicacion: VentanaAplicacionVarroa.otono,
    notas: 'Tira de carton impregnada — efecto prolongado. Confirmar autorización vigente',
  ),
];

SustanciaVarroa? sustanciaVarroaPorId(String id) {
  for (final s in catalogoSustanciasVarroa) {
    if (s.id == id) return s;
  }
  return null;
}

/// Filtra sustancias por ventana de aplicación. Útil cuando el apicultor
/// abre el formulario en pleno otoño y quiere ver qué sustancias proceden.
List<SustanciaVarroa> sustanciasParaVentana(VentanaAplicacionVarroa ventana) {
  return catalogoSustanciasVarroa
      .where((s) => s.ventanaAplicacion == ventana)
      .toList();
}

/// Sólo sustancias autorizadas en producción ecológica.
List<SustanciaVarroa> sustanciasEcologico() {
  return catalogoSustanciasVarroa.where((s) => s.autorizadaEcologico).toList();
}

List<SustanciaVarroa> buscarSustanciasVarroa(String texto) {
  final consultaNormalizada = _normalizar(texto);
  if (consultaNormalizada.isEmpty) return const [];
  return catalogoSustanciasVarroa.where((s) {
    return _normalizar(s.id).contains(consultaNormalizada) ||
        _normalizar(s.nombreCanonico).contains(consultaNormalizada);
  }).toList();
}

String _normalizar(String texto) {
  return texto
      .toLowerCase()
      .replaceAll(RegExp(r'[áàä]'), 'a')
      .replaceAll(RegExp(r'[éèë]'), 'e')
      .replaceAll(RegExp(r'[íìï]'), 'i')
      .replaceAll(RegExp(r'[óòö]'), 'o')
      .replaceAll(RegExp(r'[úùü]'), 'u')
      .replaceAll('ñ', 'n')
      .trim();
}

