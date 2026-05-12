// GENERADO AUTOMÁTICAMENTE — NO EDITAR A MANO.
//
// Fuente: content/aceitera/fitosanitarios_olivar.csv
// Generado: 2026-05-12
// Filas: 20 (0 revisadas, 20 pendientes de revisión)
//
// ⚠ DATOS PROVISIONALES SIN VALIDAR AGRONÓMICAMENTE.
// La app muestra un banner mientras este flag siga activo.
// Para regenerar: cd apps/solera-aceitera && dart run tool/compilar_catalogos.dart

class FitosanitarioOlivar {
  final String id;
  final String nombreCanonico;
  /// IDs de plagas_olivo para las que está autorizada.
  final List<String> plagasObjetivo;
  /// insecticida / fungicida / acaricida / herbicida / biorracional.
  final String tipoAccion;
  /// Plazo de seguridad orientativo en días.
  /// ⚠ Verificar etiqueta del producto comercial vigente.
  final int plazoSeguridadOrientativoDias;
  final bool autorizadaEcologico;
  final String notas;

  const FitosanitarioOlivar({
    required this.id,
    required this.nombreCanonico,
    required this.plagasObjetivo,
    required this.tipoAccion,
    required this.plazoSeguridadOrientativoDias,
    required this.autorizadaEcologico,
    this.notas = '',
  });
}

const List<FitosanitarioOlivar> catalogoFitosanitariosOlivar = [
  FitosanitarioOlivar(
    id: 'spinosad',
    nombreCanonico: 'Spinosad',
    plagasObjetivo: ['mosca_olivo', 'prays_olivo'],
    tipoAccion: 'insecticida',
    plazoSeguridadOrientativoDias: 7,
    autorizadaEcologico: true,
    notas: 'Toxina natural fermentada; uso muy extendido contra mosca con cebos.',
  ),
  FitosanitarioOlivar(
    id: 'deltametrina',
    nombreCanonico: 'Deltametrina',
    plagasObjetivo: ['mosca_olivo', 'cochinilla_tizne'],
    tipoAccion: 'insecticida',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: false,
    notas: 'Piretroide de uso clásico; revisar restricciones por DOP y residuos.',
  ),
  FitosanitarioOlivar(
    id: 'caolin',
    nombreCanonico: 'Caolín en polvo',
    plagasObjetivo: ['mosca_olivo'],
    tipoAccion: 'insecticida',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: true,
    notas: 'Barrera mineral física; reduce oviposición sin afectar fauna auxiliar.',
  ),
  FitosanitarioOlivar(
    id: 'proteina_hidrolizada',
    nombreCanonico: 'Proteína hidrolizada',
    plagasObjetivo: ['mosca_olivo'],
    tipoAccion: 'biorracional',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: true,
    notas: 'Cebo atrayente combinado con insecticidas en parcheo de pulverización.',
  ),
  FitosanitarioOlivar(
    id: 'oxicloruro_cobre',
    nombreCanonico: 'Oxicloruro de cobre',
    plagasObjetivo: ['repilo', 'emplomado', 'tuberculosis_olivo'],
    tipoAccion: 'fungicida',
    plazoSeguridadOrientativoDias: 15,
    autorizadaEcologico: true,
    notas: 'Cúpricos de uso histórico; regulación Cu por hectárea/año en producción ecológica.',
  ),
  FitosanitarioOlivar(
    id: 'hidroxido_cobre',
    nombreCanonico: 'Hidróxido de cobre',
    plagasObjetivo: ['repilo', 'emplomado'],
    tipoAccion: 'fungicida',
    plazoSeguridadOrientativoDias: 15,
    autorizadaEcologico: true,
    notas: 'Cúprico alternativo al oxicloruro; mismo límite Cu/ha.',
  ),
  FitosanitarioOlivar(
    id: 'sulfato_cobre',
    nombreCanonico: 'Sulfato de cobre',
    plagasObjetivo: ['repilo', 'emplomado'],
    tipoAccion: 'fungicida',
    plazoSeguridadOrientativoDias: 15,
    autorizadaEcologico: true,
    notas: 'Otro cúprico clásico; precaución por fitotoxicidad en hojas jóvenes.',
  ),
  FitosanitarioOlivar(
    id: 'dodina',
    nombreCanonico: 'Dodina',
    plagasObjetivo: ['repilo', 'emplomado'],
    tipoAccion: 'fungicida',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: false,
    notas: 'Curativo y preventivo. Posibles restricciones de dosis revisadas por MAPA.',
  ),
  FitosanitarioOlivar(
    id: 'mancozeb',
    nombreCanonico: 'Mancozeb',
    plagasObjetivo: ['repilo', 'emplomado'],
    tipoAccion: 'fungicida',
    plazoSeguridadOrientativoDias: 28,
    autorizadaEcologico: false,
    notas: 'Multisitio. Verificar autorización vigente — ha tenido revisiones UE.',
  ),
  FitosanitarioOlivar(
    id: 'azufre_micronizado',
    nombreCanonico: 'Azufre micronizado',
    plagasObjetivo: ['arañuela_amarilla', 'cochinilla_tizne'],
    tipoAccion: 'fungicida',
    plazoSeguridadOrientativoDias: 5,
    autorizadaEcologico: true,
    notas: 'Acaricida y fungicida físico; precaución con temperaturas altas.',
  ),
  FitosanitarioOlivar(
    id: 'piretrinas_naturales',
    nombreCanonico: 'Piretrinas naturales',
    plagasObjetivo: ['prays_olivo', 'cochinilla_tizne'],
    tipoAccion: 'insecticida',
    plazoSeguridadOrientativoDias: 3,
    autorizadaEcologico: true,
    notas: 'Origen vegetal (Chrysanthemum); fotodegradación rápida — aplicar al atardecer.',
  ),
  FitosanitarioOlivar(
    id: 'azadiractina',
    nombreCanonico: 'Azadiractina (neem)',
    plagasObjetivo: ['prays_olivo', 'glifodes', 'algodoncillo'],
    tipoAccion: 'biorracional',
    plazoSeguridadOrientativoDias: 7,
    autorizadaEcologico: true,
    notas: 'Inhibe crecimiento de larvas; compatible con producción ecológica.',
  ),
  FitosanitarioOlivar(
    id: 'bacillus_thuringiensis',
    nombreCanonico: 'Bacillus thuringiensis',
    plagasObjetivo: ['prays_olivo', 'glifodes'],
    tipoAccion: 'biorracional',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: true,
    notas: 'Bioinsecticida específico contra orugas; sin efecto sobre fauna auxiliar.',
  ),
  FitosanitarioOlivar(
    id: 'beauveria_bassiana',
    nombreCanonico: 'Beauveria bassiana',
    plagasObjetivo: ['mosca_olivo', 'cochinilla_tizne'],
    tipoAccion: 'biorracional',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: true,
    notas: 'Hongo entomopatógeno; eficacia dependiente de humedad.',
  ),
  FitosanitarioOlivar(
    id: 'glifosato',
    nombreCanonico: 'Glifosato',
    plagasObjetivo: [],
    tipoAccion: 'herbicida',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: false,
    notas: 'Herbicida sistémico para calle/ruedo. Restringido en cubiertas vegetales activas.',
  ),
  FitosanitarioOlivar(
    id: 'oxifluorfen',
    nombreCanonico: 'Oxifluorfen',
    plagasObjetivo: [],
    tipoAccion: 'herbicida',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: false,
    notas: 'Herbicida residual de pre-emergencia. Verificar autorización en olivar adulto.',
  ),
  FitosanitarioOlivar(
    id: 'mcpa',
    nombreCanonico: 'MCPA',
    plagasObjetivo: [],
    tipoAccion: 'herbicida',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: false,
    notas: 'Herbicida hormonal para dicotiledóneas; usar fuera de viento.',
  ),
  FitosanitarioOlivar(
    id: 'acido_pelargonico',
    nombreCanonico: 'Ácido pelargónico',
    plagasObjetivo: [],
    tipoAccion: 'herbicida',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: true,
    notas: 'Herbicida de contacto natural; alternativa al glifosato en cubiertas controladas.',
  ),
  FitosanitarioOlivar(
    id: 'aceite_invierno',
    nombreCanonico: 'Aceite parafínico de invierno',
    plagasObjetivo: ['cochinilla_tizne', 'ceratoceria'],
    tipoAccion: 'insecticida',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: true,
    notas: 'Asfixia mecánica de cochinillas; aplicar en parada vegetativa.',
  ),
  FitosanitarioOlivar(
    id: 'fosfonato_potasico',
    nombreCanonico: 'Fosfonato potásico',
    plagasObjetivo: ['repilo'],
    tipoAccion: 'fungicida',
    plazoSeguridadOrientativoDias: 7,
    autorizadaEcologico: true,
    notas: 'Inductor de defensas; complemento a cúpricos en estrategias preventivas.',
  ),
];

FitosanitarioOlivar? fitosanitarioOlivarPorId(String id) {
  for (final f in catalogoFitosanitariosOlivar) {
    if (f.id == id) return f;
  }
  return null;
}

/// Filtra sustancias activas autorizadas para una plaga concreta.
List<FitosanitarioOlivar> fitosanitariosParaPlaga(String idPlaga) {
  return catalogoFitosanitariosOlivar
      .where((f) => f.plagasObjetivo.contains(idPlaga))
      .toList();
}

List<FitosanitarioOlivar> buscarFitosanitariosOlivar(String texto) {
  final q = _normalizar(texto);
  if (q.isEmpty) return const [];
  return catalogoFitosanitariosOlivar.where((f) {
    return _normalizar(f.nombreCanonico).contains(q) ||
        _normalizar(f.id).contains(q);
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

