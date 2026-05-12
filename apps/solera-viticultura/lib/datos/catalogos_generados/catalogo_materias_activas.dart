// GENERADO AUTOMÁTICAMENTE — NO EDITAR A MANO.
//
// Fuente: content/viticultura/materias_activas.csv
// Generado: 2026-05-11
// Filas: 19 (19 revisadas, 0 pendientes de revisión)
// Estado: ✅ todas las filas revisadas por: Registro Fitosanitario MAPA 2026

class MateriaActiva {
  final String id;
  final String nombreCanonico;
  /// IDs de plagas en `catalogo_plagas_vid.dart` para las que está autorizada.
  final List<String> plagasObjetivo;
  final String tipoAccion;
  /// Plazo de seguridad orientativo en días. ⚠ Verificar etiqueta del producto.
  final int plazoSeguridadOrientativoDias;
  final bool autorizadaEcologico;
  final String notas;

  const MateriaActiva({
    required this.id,
    required this.nombreCanonico,
    required this.plagasObjetivo,
    required this.tipoAccion,
    required this.plazoSeguridadOrientativoDias,
    required this.autorizadaEcologico,
    this.notas = '',
  });
}

const List<MateriaActiva> catalogoMateriasActivas = [
  MateriaActiva(
    id: 'azufre',
    nombreCanonico: 'Azufre',
    plagasObjetivo: ['oidio'],
    tipoAccion: 'contacto',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: true,
    notas: 'Mojable o espolvoreo. No aplicar con T>28°C (riesgo fototoxicidad).',
  ),
  MateriaActiva(
    id: 'sulfato_cobre',
    nombreCanonico: 'Sulfato de cobre (caldo bordelés)',
    plagasObjetivo: ['mildiu'],
    tipoAccion: 'contacto',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: true,
    notas: 'Limite UE: 4 kg Cu/ha/año (media móvil 7 años).',
  ),
  MateriaActiva(
    id: 'hidroxido_cobre',
    nombreCanonico: 'Hidróxido de cobre',
    plagasObjetivo: ['mildiu'],
    tipoAccion: 'contacto',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: true,
    notas: 'Sustituye al sulfato en muchas formulaciones modernas. Mismo límite UE de Cu.',
  ),
  MateriaActiva(
    id: 'oxicloruro_cobre',
    nombreCanonico: 'Oxicloruro de cobre',
    plagasObjetivo: ['mildiu'],
    tipoAccion: 'contacto',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: true,
    notas: 'Alternativa cúprica. Mismo límite UE de Cu.',
  ),
  MateriaActiva(
    id: 'folpet',
    nombreCanonico: 'Folpet',
    plagasObjetivo: ['mildiu', 'black_rot'],
    tipoAccion: 'contacto',
    plazoSeguridadOrientativoDias: 28,
    autorizadaEcologico: false,
    notas: 'Preventivo de amplio espectro. Vigilar plazo seguridad.',
  ),
  MateriaActiva(
    id: 'fosetil_aluminio',
    nombreCanonico: 'Fosetil-aluminio',
    plagasObjetivo: ['mildiu'],
    tipoAccion: 'sistemico',
    plazoSeguridadOrientativoDias: 28,
    autorizadaEcologico: false,
    notas: 'Sistémico ascendente y descendente. Buena penetración.',
  ),
  MateriaActiva(
    id: 'dimetomorfo',
    nombreCanonico: 'Dimetomorfo',
    plagasObjetivo: ['mildiu'],
    tipoAccion: 'translaminar',
    plazoSeguridadOrientativoDias: 28,
    autorizadaEcologico: false,
    notas: 'Antiesporulante. Se mezcla con cúpricos para preventivo+curativo.',
  ),
  MateriaActiva(
    id: 'azoxistrobin',
    nombreCanonico: 'Azoxistrobin',
    plagasObjetivo: ['mildiu', 'oidio'],
    tipoAccion: 'sistemico',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: false,
    notas: 'Estrobilurina. Resistencia cruzada — alternar con otros modos de acción.',
  ),
  MateriaActiva(
    id: 'miclobutanil',
    nombreCanonico: 'Miclobutanil',
    plagasObjetivo: ['oidio'],
    tipoAccion: 'sistemico',
    plazoSeguridadOrientativoDias: 14,
    autorizadaEcologico: false,
    notas: 'Triazol. Curativo de oídio.',
  ),
  MateriaActiva(
    id: 'tebuconazol',
    nombreCanonico: 'Tebuconazol',
    plagasObjetivo: ['oidio'],
    tipoAccion: 'sistemico',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: false,
    notas: 'Triazol. Atención: bajo revisión UE.',
  ),
  MateriaActiva(
    id: 'penconazol',
    nombreCanonico: 'Penconazol',
    plagasObjetivo: ['oidio'],
    tipoAccion: 'sistemico',
    plazoSeguridadOrientativoDias: 28,
    autorizadaEcologico: false,
    notas: 'Triazol clásico para oídio.',
  ),
  MateriaActiva(
    id: 'boscalid',
    nombreCanonico: 'Boscalid',
    plagasObjetivo: ['botritis'],
    tipoAccion: 'translaminar',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: false,
    notas: 'SDHI. Se mezcla con piraclostrobin habitualmente.',
  ),
  MateriaActiva(
    id: 'fluopiram',
    nombreCanonico: 'Fluopiram',
    plagasObjetivo: ['botritis', 'oidio'],
    tipoAccion: 'translaminar',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: false,
    notas: 'SDHI. Bajo riesgo de resistencia si se rota.',
  ),
  MateriaActiva(
    id: 'pirimetanil',
    nombreCanonico: 'Pirimetanil',
    plagasObjetivo: ['botritis'],
    tipoAccion: 'sistemico',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: false,
    notas: 'Anilinopirimidina. Buena curativo de botritis.',
  ),
  MateriaActiva(
    id: 'ciprodinil',
    nombreCanonico: 'Ciprodinil',
    plagasObjetivo: ['botritis'],
    tipoAccion: 'sistemico',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: false,
    notas: 'Anilinopirimidina. Alternativa o mezcla con pirimetanil.',
  ),
  MateriaActiva(
    id: 'fludioxonil',
    nombreCanonico: 'Fludioxonil',
    plagasObjetivo: ['botritis'],
    tipoAccion: 'contacto',
    plazoSeguridadOrientativoDias: 21,
    autorizadaEcologico: false,
    notas: 'Habitual en mezcla con ciprodinil.',
  ),
  MateriaActiva(
    id: 'bacillus_thuringiensis_kurstaki',
    nombreCanonico: 'Bacillus thuringiensis kurstaki',
    plagasObjetivo: ['polilla_racimo'],
    tipoAccion: 'biologico',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: true,
    notas: 'Solo eficaz contra larvas pequeñas. Sin plazo seguridad.',
  ),
  MateriaActiva(
    id: 'spinosad',
    nombreCanonico: 'Spinosad',
    plagasObjetivo: ['polilla_racimo'],
    tipoAccion: 'contacto',
    plazoSeguridadOrientativoDias: 14,
    autorizadaEcologico: true,
    notas: 'Origen biológico. Autorizado en ecológico con condiciones (toxicidad para abejas).',
  ),
  MateriaActiva(
    id: 'aceite_parafinico',
    nombreCanonico: 'Aceite parafínico',
    plagasObjetivo: ['acaros_eriofidos'],
    tipoAccion: 'fisico',
    plazoSeguridadOrientativoDias: 0,
    autorizadaEcologico: true,
    notas: 'Acción física. Buen perfil ecológico. Aplicar fuera del periodo de floración.',
  ),
];

MateriaActiva? materiaActivaPorId(String id) {
  for (final m in catalogoMateriasActivas) {
    if (m.id == id) return m;
  }
  return null;
}

/// Filtra materias activas por plaga objetivo. Útil cuando el viticultor
/// abre un tratamiento desde una incidencia concreta y quiere ver qué
/// materias están autorizadas para esa plaga.
List<MateriaActiva> materiasParaPlaga(String idPlaga) {
  return catalogoMateriasActivas
      .where((m) => m.plagasObjetivo.contains(idPlaga))
      .toList();
}
