import 'package:flutter/material.dart';

/// Categoría gruesa de un cultivo. Sirve para agrupar visualmente en el
/// mapa, el quiz, los reportes y los catálogos curados de plagas
/// (compartidos por categoría cuando tienen sentido — p. ej. el
/// monilia afecta a todos los frutales de hueso).
enum CategoriaCultivo {
  micorricicoTrufa,
  forestal,
  frutalPepita,
  frutalHueso,
  frutoSeco,
  oleoso,
  vid,
  otro,
}

extension CategoriaCultivoTextos on CategoriaCultivo {
  String get nombreVisible {
    switch (this) {
      case CategoriaCultivo.micorricicoTrufa:
        return 'Truficultura';
      case CategoriaCultivo.forestal:
        return 'Forestal / dehesa';
      case CategoriaCultivo.frutalPepita:
        return 'Frutal de pepita';
      case CategoriaCultivo.frutalHueso:
        return 'Frutal de hueso';
      case CategoriaCultivo.frutoSeco:
        return 'Fruto seco';
      case CategoriaCultivo.oleoso:
        return 'Cultivo oleoso';
      case CategoriaCultivo.vid:
        return 'Vid';
      case CategoriaCultivo.otro:
        return 'Otro';
    }
  }
}

/// Definición de un cultivo. Datos genéricos que el usuario ve en el
/// alta de planta (qué variedades sugerir, qué patrón típico) y en el
/// mapa (icono, color marcador).
///
/// Las variedades sugeridas son una **lista no exhaustiva**: el usuario
/// siempre puede teclear una variedad libre. La idea es agilizar el
/// caso típico, no encerrar la opción.
class Cultivo {
  final String id;
  final String nombreVisible;
  final String nombreCientifico;
  final CategoriaCultivo categoria;
  final IconData icono;
  final Color color;
  final List<String> variedadesSugeridas;
  final List<String> patronesSugeridos;

  /// Sólo aplicable a cultivos micorrícicos (trufas). Lista de ids de
  /// cultivos en este mismo catálogo que son árboles hospederos
  /// habituales de la trufa: encina, roble, avellano, etc. Permite
  /// que la guía enlace cruzadamente "trufa → hospedero" y "hospedero
  /// → trufas que puede albergar".
  final List<String> hospederosCultivoIds;

  /// Sólo aplicable a árboles forestales que pueden actuar como
  /// hospederos truferos. Lista de ids de cultivos micorrícicos cuya
  /// micorrización admite este árbol. Inverso de `hospederosCultivoIds`.
  final List<String> trufasHospedables;

  const Cultivo({
    required this.id,
    required this.nombreVisible,
    required this.nombreCientifico,
    required this.categoria,
    required this.icono,
    required this.color,
    this.variedadesSugeridas = const [],
    this.patronesSugeridos = const [],
    this.hospederosCultivoIds = const [],
    this.trufasHospedables = const [],
  });
}

/// Catálogo inicial v1. Suficiente para los cultivos prioritarios
/// (trufa + frutales + pistacho + olivo) y mainstream del entorno
/// peninsular. El catálogo crece añadiendo entradas — los datos
/// guardados sólo guardan `cultivoId`, así que ampliar es no-breaking.
const List<Cultivo> catalogoCultivos = [
  // ─── Truficultura ──────────────────────────────────────
  Cultivo(
    id: 'tuber-melanosporum',
    nombreVisible: 'Trufa negra (Tuber melanosporum)',
    nombreCientifico: 'Tuber melanosporum',
    categoria: CategoriaCultivo.micorricicoTrufa,
    icono: Icons.spa,
    color: Color(0xFF3E2723),
    patronesSugeridos: ['Encina (Quercus ilex)', 'Roble carrasqueño (Quercus faginea)', 'Avellano (Corylus avellana)', 'Coscoja (Quercus coccifera)'],
    hospederosCultivoIds: ['encina', 'roble-carrasqueno', 'coscoja', 'avellano'],
  ),
  Cultivo(
    id: 'tuber-aestivum',
    nombreVisible: 'Trufa de verano (Tuber aestivum)',
    nombreCientifico: 'Tuber aestivum',
    categoria: CategoriaCultivo.micorricicoTrufa,
    icono: Icons.spa,
    color: Color(0xFF5D4037),
    patronesSugeridos: ['Encina', 'Roble carrasqueño', 'Avellano', 'Tilo'],
    hospederosCultivoIds: ['encina', 'roble-carrasqueno', 'avellano', 'tilo'],
  ),
  Cultivo(
    id: 'tuber-brumale',
    nombreVisible: 'Trufa de invierno (Tuber brumale)',
    nombreCientifico: 'Tuber brumale',
    categoria: CategoriaCultivo.micorricicoTrufa,
    icono: Icons.spa,
    color: Color(0xFF4E342E),
    patronesSugeridos: ['Encina', 'Roble carrasqueño', 'Avellano'],
    hospederosCultivoIds: ['encina', 'roble-carrasqueno', 'avellano'],
  ),

  // ─── Forestal / dehesa ─────────────────────────────────
  Cultivo(
    id: 'encina',
    nombreVisible: 'Encina',
    nombreCientifico: 'Quercus ilex',
    categoria: CategoriaCultivo.forestal,
    icono: Icons.park,
    color: Color(0xFF33691E),
    variedadesSugeridas: ['Subsp. ballota (carrasca, dehesa)', 'Subsp. ilex (encina típica mediterránea)'],
    trufasHospedables: ['tuber-melanosporum', 'tuber-aestivum', 'tuber-brumale'],
  ),
  Cultivo(
    id: 'roble-carrasqueno',
    nombreVisible: 'Roble carrasqueño',
    nombreCientifico: 'Quercus faginea',
    categoria: CategoriaCultivo.forestal,
    icono: Icons.park,
    color: Color(0xFF558B2F),
    trufasHospedables: ['tuber-melanosporum', 'tuber-aestivum', 'tuber-brumale'],
  ),
  Cultivo(
    id: 'coscoja',
    nombreVisible: 'Coscoja',
    nombreCientifico: 'Quercus coccifera',
    categoria: CategoriaCultivo.forestal,
    icono: Icons.local_florist,
    color: Color(0xFF689F38),
    trufasHospedables: ['tuber-melanosporum'],
  ),
  Cultivo(
    id: 'alcornoque',
    nombreVisible: 'Alcornoque',
    nombreCientifico: 'Quercus suber',
    categoria: CategoriaCultivo.forestal,
    icono: Icons.park,
    color: Color(0xFF6D4C41),
  ),
  Cultivo(
    id: 'tilo',
    nombreVisible: 'Tilo',
    nombreCientifico: 'Tilia spp.',
    categoria: CategoriaCultivo.forestal,
    icono: Icons.park,
    color: Color(0xFF388E3C),
    trufasHospedables: ['tuber-aestivum'],
  ),
  Cultivo(
    id: 'pino-pinonero',
    nombreVisible: 'Pino piñonero',
    nombreCientifico: 'Pinus pinea',
    categoria: CategoriaCultivo.forestal,
    icono: Icons.park,
    color: Color(0xFF1B5E20),
  ),
  Cultivo(
    id: 'chopo',
    nombreVisible: 'Chopo',
    nombreCientifico: 'Populus spp.',
    categoria: CategoriaCultivo.forestal,
    icono: Icons.park,
    color: Color(0xFF2E7D32),
    variedadesSugeridas: ['I-214', 'MC', 'Boelare', 'Triplo'],
  ),
  Cultivo(
    id: 'sauce',
    nombreVisible: 'Sauce',
    nombreCientifico: 'Salix spp.',
    categoria: CategoriaCultivo.forestal,
    icono: Icons.park,
    color: Color(0xFF388E3C),
  ),

  // ─── Frutales de pepita ────────────────────────────────
  Cultivo(
    id: 'manzano',
    nombreVisible: 'Manzano',
    nombreCientifico: 'Malus domestica',
    categoria: CategoriaCultivo.frutalPepita,
    icono: Icons.eco,
    color: Color(0xFFD32F2F),
    variedadesSugeridas: ['Reineta', 'Golden Delicious', 'Royal Gala', 'Fuji', 'Granny Smith', 'Verde Doncella', 'Pero de Oza'],
    patronesSugeridos: ['MM106', 'M9', 'M26', 'Franco'],
  ),
  Cultivo(
    id: 'peral',
    nombreVisible: 'Peral',
    nombreCientifico: 'Pyrus communis',
    categoria: CategoriaCultivo.frutalPepita,
    icono: Icons.eco,
    color: Color(0xFF8BC34A),
    variedadesSugeridas: ['Conference', 'Blanquilla', 'Limonera', 'Williams', 'Ercolini', 'Comice'],
    patronesSugeridos: ['Membrillero MA', 'Membrillero BA29', 'Franco peral'],
  ),
  Cultivo(
    id: 'membrillero',
    nombreVisible: 'Membrillero',
    nombreCientifico: 'Cydonia oblonga',
    categoria: CategoriaCultivo.frutalPepita,
    icono: Icons.eco,
    color: Color(0xFFFFB300),
    variedadesSugeridas: ['Vranja', 'Gigante de Vranja', 'Pineapple'],
  ),

  // ─── Frutales de hueso ─────────────────────────────────
  Cultivo(
    id: 'cerezo',
    nombreVisible: 'Cerezo',
    nombreCientifico: 'Prunus avium',
    categoria: CategoriaCultivo.frutalHueso,
    icono: Icons.local_florist,
    color: Color(0xFFAD1457),
    variedadesSugeridas: ['Burlat', 'Picota', 'Sweetheart', 'Lapins', 'Van', 'Ambrunés', 'Skeena'],
    patronesSugeridos: ['Santa Lucía SL64', 'Mahaleb', 'Gisela 5', 'Gisela 6'],
  ),
  Cultivo(
    id: 'ciruelo',
    nombreVisible: 'Ciruelo',
    nombreCientifico: 'Prunus domestica',
    categoria: CategoriaCultivo.frutalHueso,
    icono: Icons.local_florist,
    color: Color(0xFF6A1B9A),
    variedadesSugeridas: ['Claudia Reina', 'Santa Rosa', 'Golden Japan', 'President', 'Friar', 'Black Diamond'],
  ),
  Cultivo(
    id: 'melocotonero',
    nombreVisible: 'Melocotonero',
    nombreCientifico: 'Prunus persica',
    categoria: CategoriaCultivo.frutalHueso,
    icono: Icons.local_florist,
    color: Color(0xFFFF6F00),
    variedadesSugeridas: ['Calanda', 'Royal Glory', 'Sudanell', 'Maycrest', 'Catherina'],
    patronesSugeridos: ['GF677', 'Garnem', 'Adesoto'],
  ),
  Cultivo(
    id: 'albaricoquero',
    nombreVisible: 'Albaricoquero',
    nombreCientifico: 'Prunus armeniaca',
    categoria: CategoriaCultivo.frutalHueso,
    icono: Icons.local_florist,
    color: Color(0xFFFFA726),
    variedadesSugeridas: ['Búlida', 'Moniqui', 'Goldrich', 'Currot', 'Pepito', 'Real Fino'],
  ),
  Cultivo(
    id: 'nectarino',
    nombreVisible: 'Nectarino',
    nombreCientifico: 'Prunus persica var. nucipersica',
    categoria: CategoriaCultivo.frutalHueso,
    icono: Icons.local_florist,
    color: Color(0xFFEF5350),
  ),

  // ─── Frutos secos ──────────────────────────────────────
  Cultivo(
    id: 'almendro',
    nombreVisible: 'Almendro',
    nombreCientifico: 'Prunus dulcis',
    categoria: CategoriaCultivo.frutoSeco,
    icono: Icons.grain,
    color: Color(0xFFEEDC82),
    variedadesSugeridas: ['Marcona', 'Largueta', 'Guara', 'Soleta', 'Ferragnès', 'Lauranne', 'Vairo', 'Penta'],
    patronesSugeridos: ['GF677', 'Garnem', 'Rootpac', 'INRA'],
  ),
  Cultivo(
    id: 'pistacho',
    nombreVisible: 'Pistacho',
    nombreCientifico: 'Pistacia vera',
    categoria: CategoriaCultivo.frutoSeco,
    icono: Icons.grain,
    color: Color(0xFF689F38),
    variedadesSugeridas: ['Kerman', 'Sirora', 'Larnaka', 'Avdat', 'Mateur', 'Aegina'],
    patronesSugeridos: ['UCB-1', 'Pistacia atlantica', 'Pistacia terebinthus', 'Pistacia integerrima'],
  ),
  Cultivo(
    id: 'nogal',
    nombreVisible: 'Nogal',
    nombreCientifico: 'Juglans regia',
    categoria: CategoriaCultivo.frutoSeco,
    icono: Icons.park,
    color: Color(0xFF6D4C41),
    variedadesSugeridas: ['Chandler', 'Howard', 'Franquette', 'Lara', 'Tulare'],
    patronesSugeridos: ['Juglans regia', 'Paradox', 'Juglans nigra'],
  ),
  Cultivo(
    id: 'avellano',
    nombreVisible: 'Avellano',
    nombreCientifico: 'Corylus avellana',
    categoria: CategoriaCultivo.frutoSeco,
    icono: Icons.park,
    color: Color(0xFF795548),
    variedadesSugeridas: ['Negret', 'Pauetet', 'Tonda di Giffoni', 'Tonda Romana', 'Culplà'],
  ),
  Cultivo(
    id: 'castano',
    nombreVisible: 'Castaño',
    nombreCientifico: 'Castanea sativa',
    categoria: CategoriaCultivo.frutoSeco,
    icono: Icons.park,
    color: Color(0xFF4E342E),
    variedadesSugeridas: ['Marrón Sostera', 'Pelona', 'Negra', 'Bouche de Bétizac', 'Marigoule'],
  ),

  // ─── Cultivos oleosos ──────────────────────────────────
  Cultivo(
    id: 'olivo',
    nombreVisible: 'Olivo',
    nombreCientifico: 'Olea europaea',
    categoria: CategoriaCultivo.oleoso,
    icono: Icons.park,
    color: Color(0xFF558B2F),
    variedadesSugeridas: ['Picual', 'Arbequina', 'Hojiblanca', 'Cornicabra', 'Manzanilla', 'Empeltre', 'Picudo', 'Lechín', 'Verdial', 'Frantoio', 'Arbosana', 'Koroneiki'],
    patronesSugeridos: ['Franco', 'Estaca enraizada'],
  ),

  // ─── Vid ───────────────────────────────────────────────
  Cultivo(
    id: 'vid',
    nombreVisible: 'Vid',
    nombreCientifico: 'Vitis vinifera',
    categoria: CategoriaCultivo.vid,
    icono: Icons.wine_bar,
    color: Color(0xFF6A1B9A),
    variedadesSugeridas: ['Tempranillo', 'Garnacha', 'Mazuelo', 'Graciano', 'Albariño', 'Verdejo', 'Cabernet Sauvignon', 'Merlot', 'Syrah', 'Chardonnay', 'Sauvignon Blanc', 'Monastrell', 'Bobal', 'Mencía'],
    patronesSugeridos: ['110-Richter', '140-Ruggeri', '41B', '161-49', 'SO4', '420A'],
  ),

  // ─── Otros ─────────────────────────────────────────────
  Cultivo(
    id: 'higuera',
    nombreVisible: 'Higuera',
    nombreCientifico: 'Ficus carica',
    categoria: CategoriaCultivo.otro,
    icono: Icons.park,
    color: Color(0xFF7CB342),
    variedadesSugeridas: ['Cuello de Dama', 'Calabacita', 'Brown Turkey', 'Verdal', 'Negra'],
  ),
  Cultivo(
    id: 'granado',
    nombreVisible: 'Granado',
    nombreCientifico: 'Punica granatum',
    categoria: CategoriaCultivo.otro,
    icono: Icons.local_florist,
    color: Color(0xFFC62828),
    variedadesSugeridas: ['Mollar de Elche', 'Wonderful', 'Acco', 'Valenciana'],
  ),
  Cultivo(
    id: 'kiwi',
    nombreVisible: 'Kiwi',
    nombreCientifico: 'Actinidia deliciosa',
    categoria: CategoriaCultivo.otro,
    icono: Icons.eco,
    color: Color(0xFF558B2F),
    variedadesSugeridas: ['Hayward', 'Bruno', 'Tomuri (polinizador)'],
  ),
  Cultivo(
    id: 'caqui',
    nombreVisible: 'Caqui (palosanto)',
    nombreCientifico: 'Diospyros kaki',
    categoria: CategoriaCultivo.otro,
    icono: Icons.local_florist,
    color: Color(0xFFEF6C00),
    variedadesSugeridas: ['Rojo Brillante', 'Triumph', 'Sharon', 'Hachiya'],
  ),
  Cultivo(
    id: 'aguacate',
    nombreVisible: 'Aguacate',
    nombreCientifico: 'Persea americana',
    categoria: CategoriaCultivo.otro,
    icono: Icons.eco,
    color: Color(0xFF33691E),
    variedadesSugeridas: ['Hass', 'Bacon', 'Fuerte', 'Pinkerton', 'Lamb Hass', 'Reed'],
  ),
  Cultivo(
    id: 'citrico-naranjo',
    nombreVisible: 'Naranjo',
    nombreCientifico: 'Citrus sinensis',
    categoria: CategoriaCultivo.otro,
    icono: Icons.circle,
    color: Color(0xFFFF6F00),
    variedadesSugeridas: ['Navelina', 'Navel Lane Late', 'Salustiana', 'Valencia Late', 'Sanguinelli'],
    patronesSugeridos: ['Citrange Carrizo', 'Citrumelo', 'Mandarino Cleopatra'],
  ),
  Cultivo(
    id: 'citrico-mandarino',
    nombreVisible: 'Mandarino',
    nombreCientifico: 'Citrus reticulata',
    categoria: CategoriaCultivo.otro,
    icono: Icons.circle,
    color: Color(0xFFFFB300),
    variedadesSugeridas: ['Clementina', 'Clemenules', 'Hernandina', 'Satsuma Owari', 'Tango', 'Nadorcott'],
  ),
  Cultivo(
    id: 'citrico-limonero',
    nombreVisible: 'Limonero',
    nombreCientifico: 'Citrus limon',
    categoria: CategoriaCultivo.otro,
    icono: Icons.circle,
    color: Color(0xFFFFEB3B),
    variedadesSugeridas: ['Verna', 'Fino', 'Eureka', 'Lisbon'],
  ),
  Cultivo(
    id: 'generico',
    nombreVisible: 'Otro / no especificado',
    nombreCientifico: '',
    categoria: CategoriaCultivo.otro,
    icono: Icons.help_outline,
    color: Color(0xFF9E9E9E),
  ),
];

/// Devuelve el cultivo por id; nunca nulo (cae a 'generico' si el id
/// guardado en BD no existe ya en el catálogo, p. ej. después de
/// retirar un cultivo en una versión futura).
Cultivo cultivoPorId(String id) {
  for (final c in catalogoCultivos) {
    if (c.id == id) return c;
  }
  return catalogoCultivos.lastWhere((c) => c.id == 'generico');
}
