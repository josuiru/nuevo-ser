import 'package:flutter/foundation.dart';

import '../dominio/misterio.dart';
import '../dominio/nivel_confianza.dart';
import '../dominio/observacion.dart';
import '../dominio/repositorio_local.dart';
import '../dominio/sit_spot.dart';
import '../infraestructura/isar/repositorio_isar.dart';
import '../infraestructura/memoria/repositorio_memoria.dart';

/// Función `kDebugMode`-only que poblara el repositorio con datos
/// suficientes para que la pantalla principal del cuaderno muestre
/// todos los estados (sit spot configurado con visita reciente,
/// Misterios abiertos, última página).
///
/// Idempotente: comprueba si ya hay sit spot antes de hacer nada. Si
/// ya está sembrada, sale sin tocar.
///
/// **No invocar en builds de release**: el dispatcher de `main.dart`
/// solo la llama cuando `kDebugMode` es true. Aquí dentro hacemos un
/// `assert(kDebugMode)` defensivo por si alguien la llamara
/// directamente.
Future<void> sembrarDatosDesarrollo(RepositorioLocal repositorio) async {
  assert(
    kDebugMode,
    'sembrarDatosDesarrollo solo debe llamarse en builds debug',
  );
  if (!kDebugMode) return;

  final sitSpotExistente = await repositorio.obtenerSitSpot();
  if (sitSpotExistente != null) {
    // Ya hay datos sembrados — mantener idempotencia.
    return;
  }

  final ahora = DateTime.now();
  final hace4Dias = ahora.subtract(const Duration(days: 4));
  final hace2Dias = ahora.subtract(const Duration(days: 2));
  final hace7Dias = ahora.subtract(const Duration(days: 7));
  final hace12Dias = ahora.subtract(const Duration(days: 12));

  final sitSpot = SitSpot(
    id: 'seed-sitspot-roble-grande',
    nombre: 'El Roble Grande',
    dondeNombre: 'al final del parque, junto al pino más alto',
    creadoEn: hace12Dias,
    ultimaVisita: hace4Dias,
  );
  await repositorio.establecerSitSpot(sitSpot);

  // Carga el catálogo seminal completo (los 19 del documento
  // `docs/el-cuaderno/catalogo-seminal-misterios.md`). Cinco quedan
  // marcados como `abierto: true` para que el home muestre el rango
  // 3–5 que prescribe la biblia §5.3; los demás están en el catálogo
  // pero no aparecen al niño hasta que el sistema los abra. La
  // selección de los 5 abiertos cubre las seis categorías del
  // catálogo (fenológico, sistémico, identificación, paciencia) y
  // los tipos de lugar más probables del piloto (parque/borde
  // urbano-rural).
  final misteriosCatalogo = _construirCatalogoSeminal();
  for (final misterio in misteriosCatalogo) {
    await _guardarMisterio(repositorio, misterio);
  }

  // El Misterio 8 (lluvia) sirve de ancla para una de las
  // observaciones de ejemplo — lo recuperamos por id para evitar
  // depender del orden del catálogo.
  final misterioLluvia = misteriosCatalogo.firstWhere(
    (misterio) => misterio.id == 'seed-misterio-lluvia',
  );

  // Tres observaciones de ejemplo. La primera (más reciente) alimenta
  // la sección "última página" del home; las otras dos enriquecen la
  // historia del sit spot y del Misterio de la lluvia.
  final observacionReciente = Observacion(
    id: 'seed-obs-reciente',
    cuandoCreada: hace2Dias,
    cuandoOcurrio: hace2Dias,
    dondeNombre: 'El Roble Grande',
    sitSpotId: sitSpot.id,
    queVio:
        'Tres pájaros pequeños marrones saltando entre las hojas caídas '
        'del roble. Cola corta. No me dio tiempo a ver el pecho.',
    creesQueEs: 'petirrojos jóvenes',
    confianza: NivelConfianza.hipotesisActiva,
  );
  final observacionLluvia = Observacion(
    id: 'seed-obs-lluvia',
    cuandoCreada: hace7Dias,
    cuandoOcurrio: hace7Dias,
    dondeNombre: 'El Roble Grande',
    sitSpotId: sitSpot.id,
    misterioId: misterioLluvia.id,
    queVio:
        'Después de la lluvia de anoche, dos caracoles grandes en el '
        'tronco del roble y un montón de hojas amarillas pegadas a la '
        'corteza húmeda.',
    creesQueEs: 'caracol común',
    confianza: NivelConfianza.noSegura,
  );
  final observacionAntigua = Observacion(
    id: 'seed-obs-antigua',
    cuandoCreada: hace12Dias,
    cuandoOcurrio: hace12Dias,
    dondeNombre: 'El Roble Grande',
    sitSpotId: sitSpot.id,
    queVio:
        'El roble todavía tiene hojas verdes pero algunas empiezan a '
        'amarillear por los bordes. Hace fresco al amanecer.',
    confianza: NivelConfianza.hipotesisActiva,
  );

  await repositorio.guardarObservacion(observacionReciente);
  await repositorio.guardarObservacion(observacionLluvia);
  await repositorio.guardarObservacion(observacionAntigua);
}

/// Devuelve los 19 Misterios del catálogo seminal v0.1 (`docs/
/// el-cuaderno/catalogo-seminal-misterios.md`) en el orden del
/// documento. Texto de pregunta y bajada copiados literales del
/// catálogo (validados por la voz del Cuaderno, doc 04 §2). Cinco
/// marcados como `abierto: true` para que la primera carga del home
/// tenga el rango 3–5 prescrito por la biblia §5.3.
///
/// El estado `mixto` del catálogo (consenso parcial + hipótesis
/// activa restante) se mapea a `NivelConfianza.hipotesisActiva`
/// porque el modelo del juego solo distingue `consenso` /
/// `hipotesisActiva` para Misterios; la matización fina queda en el
/// campo `descripcionCorta`.
List<Misterio> _construirCatalogoSeminal() {
  // Aplicamos las traducciones provisionales eu/ca a cada Misterio
  // del catálogo seminal vía copyWith. Mantener las declaraciones
  // originales en castellano y la tabla de traducciones aparte hace
  // que el catálogo siga legible y que añadir/cerrar idiomas sea
  // mecánico cuando lleguen las traducciones nativas (ítem #7 de
  // decisiones-provisionales.md).
  return _construirCatalogoCastellano()
      .map((misterio) => misterio.copyWith(
            traducciones: _traduccionesProvisionales[misterio.id],
          ))
      .toList(growable: false);
}

List<Misterio> _construirCatalogoCastellano() {
  return [
    Misterio(
      id: 'seed-misterio-golondrinas',
      pregunta: '¿Cuándo se fueron las golondrinas de tu barrio?',
      descripcionCorta:
          'Cada año las golondrinas vuelan al sur en otoño. Se sabe que '
          'se van. La fecha exacta cambia según el lugar y el año, y los '
          'científicos no están seguros del todo de cómo deciden cuándo '
          'irse. ¿Las has visto este verano cerca de tu casa? ¿Cuándo '
          'dejaste de verlas?',
      estado: NivelConfianza.hipotesisActiva,
      abierto: true,
      seasons: const ['verano', 'otono'],
    ),
    Misterio(
      id: 'seed-misterio-primera-hoja',
      pregunta: '¿Cuándo cae la primera hoja del árbol de tu calle?',
      descripcionCorta:
          'Los árboles que pierden la hoja en otoño no la pierden todos '
          'a la vez. Algunos años las hojas caen pronto, otros más tarde. '
          'Cada árbol tiene su ritmo. Mira el árbol de tu calle un poco '
          'cada día. ¿Qué hoja se va primero? ¿Qué pasa con el árbol '
          'cuando empieza?',
      estado: NivelConfianza.consenso,
      abierto: false,
      seasons: const ['otono'],
    ),
    Misterio(
      id: 'seed-misterio-primera-flor',
      pregunta: '¿Cuál es la primera flor del año cerca de tu casa?',
      descripcionCorta:
          'Aunque parezca que en invierno no hay flores, casi siempre hay '
          'alguna. Una almendro temprano. Una mimosa. Una hierba pequeña '
          'entre el cemento. Mira en cualquier rincón verde cerca de ti. '
          '¿Cuál es la primera que ves florecer este año?',
      estado: NivelConfianza.hipotesisActiva,
      abierto: false,
      seasons: const ['invierno', 'primavera'],
    ),
    Misterio(
      id: 'seed-misterio-cigarras-fin',
      pregunta: '¿Cuándo dejaron de cantar las cigarras este verano?',
      descripcionCorta:
          'Las cigarras cantan los días calurosos del verano. Su canto es '
          'uno de los sonidos del verano. Después de un tiempo, dejan de '
          'cantar. ¿Cuándo dejaste de oírlas este año? Si nunca las '
          'oíste, ¿sabes si en tu zona hay cigarras?',
      estado: NivelConfianza.hipotesisActiva,
      abierto: false,
      seasons: const ['verano'],
      regions: const [
        'ES-AN',
        'ES-EX',
        'ES-MD',
        'ES-CM',
        'ES-CL',
        'ES-CT',
        'ES-VC',
        'ES-MU',
        'ES-AR',
      ],
    ),
    Misterio(
      id: 'seed-misterio-petirrojo',
      pregunta: '¿Cuándo viste el primer petirrojo este otoño?',
      descripcionCorta:
          'Los petirrojos viven en parques, jardines y bordes de bosque. '
          'En invierno llegan más petirrojos del norte de Europa a pasar '
          'el frío en la península. Se ven más en otoño y en invierno. '
          '¿Cuándo viste el primero este año?',
      estado: NivelConfianza.consenso,
      abierto: false,
      seasons: const ['otono', 'invierno'],
    ),
    Misterio(
      id: 'seed-misterio-polinizadores',
      pregunta: '¿Qué insectos visitan las flores de tu calle?',
      descripcionCorta:
          'Aunque sea una calle urbana, en primavera y verano hay flores: '
          'en macetas, en jardincillos, entre el cemento. Esas flores '
          'reciben visitas. Mira durante 10 minutos una flor cualquiera. '
          '¿Quién viene? ¿Cuántos tipos distintos cuentas?',
      estado: NivelConfianza.hipotesisActiva,
      abierto: false,
      seasons: const ['primavera', 'verano', 'otono'],
    ),
    Misterio(
      id: 'seed-misterio-liquenes',
      pregunta:
          '¿Por qué hay líquenes en este lado del muro y no en el otro?',
      descripcionCorta:
          'Los líquenes son manchas grises, amarillas o anaranjadas que '
          'crecen en muros, troncos y piedras. Si miras un muro o un '
          'tronco, suelen estar más en un lado que en otro. ¿Por qué? '
          'Mira a tu alrededor antes de proponer una hipótesis.',
      estado: NivelConfianza.consenso,
      abierto: true,
    ),
    Misterio(
      id: 'seed-misterio-lluvia',
      pregunta: 'Después de llover, ¿qué seres vivos aparecen?',
      descripcionCorta:
          'Después de una lluvia buena, salen seres vivos que no estaban '
          'antes. Caracoles, lombrices, ciertos hongos, ciertas plantas. '
          'Sal a tu sit spot o a un parque cuando pare de llover y mira. '
          '¿Qué encuentras? ¿Por qué crees que salen ahora y no antes?',
      estado: NivelConfianza.consenso,
      abierto: true,
      seasons: const ['primavera', 'otono'],
    ),
    Misterio(
      id: 'seed-misterio-hormigas-arbol',
      pregunta:
          '¿Por qué hay hormigas en este árbol y no en el de al lado?',
      descripcionCorta:
          'En tu calle o en tu parque, fíjate: dos árboles parecidos, uno '
          'tiene hormigas subiendo y bajando, el otro no. ¿Por qué? Mira '
          'la corteza, el suelo, las hojas. Compara los dos durante '
          'varios días. Propón hipótesis y vuelve a comprobar.',
      estado: NivelConfianza.hipotesisActiva,
      abierto: false,
      seasons: const ['primavera', 'verano', 'otono'],
    ),
    Misterio(
      id: 'seed-misterio-aves-suelo-ramas',
      pregunta: '¿Qué pájaros comen en el suelo y cuáles en las ramas?',
      descripcionCorta:
          'Los pájaros del parque no buscan comida en el mismo sitio. '
          'Algunos andan por el suelo, otros se mueven por las ramas, '
          'otros vuelan a buscar bichos. Mira durante un rato. ¿Quién '
          'come dónde? ¿Por qué crees que cada uno está en un sitio?',
      estado: NivelConfianza.consenso,
      abierto: false,
    ),
    Misterio(
      id: 'seed-misterio-dos-pequenos-marrones',
      pregunta:
          'Hay dos pájaros pequeños y marrones en tu sit spot. ¿Son la '
          'misma especie?',
      descripcionCorta:
          'Los pájaros pequeños y marrones son fáciles de confundir. ¿En '
          'qué te fijarías para saber si son la misma especie o son dos '
          'distintas? No te pedimos que los identifiques. Te pedimos que '
          'pienses en cómo lo sabrías.',
      estado: NivelConfianza.consenso,
      abierto: true,
    ),
    Misterio(
      id: 'seed-misterio-mariposas-blancas',
      pregunta:
          'Tres mariposas blancas pasan por tu jardín. ¿Cómo distinguirlas?',
      descripcionCorta:
          'En primavera y verano, varias mariposas blancas vuelan por '
          'jardines y prados. Parecen iguales a primera vista, pero no lo '
          'son. ¿En qué te fijarías para distinguirlas? Mira despacio, no '
          'las identifiques rápido.',
      estado: NivelConfianza.consenso,
      abierto: false,
      seasons: const ['primavera', 'verano'],
    ),
    Misterio(
      id: 'seed-misterio-platano',
      pregunta:
          'El árbol grande de tu calle: ¿es plátano o no es plátano?',
      descripcionCorta:
          'El plátano de sombra es uno de los árboles más comunes de las '
          'ciudades. Pero hay muchos árboles que se le parecen: arce, '
          'falso plátano, sicomoro. ¿En qué te fijarías para saber si tu '
          'árbol es plátano? Mira la corteza, las hojas, los frutos.',
      estado: NivelConfianza.consenso,
      abierto: false,
    ),
    Misterio(
      id: 'seed-misterio-pajaro-cola',
      pregunta:
          '¿Qué hace ese pájaro pequeño que mueve la cola arriba y abajo?',
      descripcionCorta:
          'Cerca del agua, en parques con fuentes, en bordes de río, hay '
          'un pájaro pequeño que anda por el suelo moviendo la cola '
          'arriba y abajo todo el rato. ¿Lo has visto? ¿Por qué crees '
          'que mueve la cola así? Si no lo has visto, mira la próxima '
          'vez que pases por agua.',
      estado: NivelConfianza.hipotesisActiva,
      abierto: false,
      seasons: const ['primavera', 'verano', 'otono'],
    ),
    Misterio(
      id: 'seed-misterio-flor-rara',
      pregunta:
          'Hay una flor que solo has visto una vez. ¿Qué pasa si la '
          'coges? ¿Y si no?',
      descripcionCorta:
          'En tu sit spot o cerca, ves una flor que no habías visto '
          'antes. Solo hay una, o muy pocas. Te llama la atención. '
          'Piensa: si la coges, ¿qué pasa con la flor? ¿Y con la próxima '
          'persona que pase por aquí? ¿Y si no la coges? No tiene una '
          'respuesta única.',
      estado: NivelConfianza.hipotesisActiva,
      abierto: false,
      seasons: const ['primavera', 'verano'],
    ),
    Misterio(
      id: 'seed-misterio-hormigas-sendero',
      pregunta:
          'Las hormigas tienen un nido en mitad del sendero. ¿Cómo pasas?',
      descripcionCorta:
          'Vas por un sendero o por la acera, y en mitad del camino las '
          'hormigas han hecho su nido. Hay un montículo y mucho '
          'movimiento. ¿Cómo pasas? ¿Qué pasa si pisas el nido? ¿Y si lo '
          'rodeas?',
      estado: NivelConfianza.consenso,
      abierto: false,
      regions: const [
        'ES-AN',
        'ES-EX',
        'ES-CL',
        'ES-CM',
        'ES-MD',
        'ES-VC',
        'ES-MU',
        'ES-AR',
        'ES-CT',
      ],
    ),
    Misterio(
      id: 'seed-misterio-encina-vieja',
      pregunta: 'La encina vieja del parque: ¿de qué año es?',
      descripcionCorta:
          'En muchos parques y campos hay una encina o un árbol grande '
          'que parece muy viejo. Lleva más años allí que tu abuelo. '
          '¿Cuántos? No es fácil saberlo. ¿Cómo lo averiguarías sin '
          'cortarlo?',
      estado: NivelConfianza.consenso,
      abierto: true,
    ),
    Misterio(
      id: 'seed-misterio-grito-raro',
      pregunta:
          'Algunas noches de otoño se oye un grito raro. ¿Qué animal es?',
      descripcionCorta:
          'Si vives donde no hay mucho ruido, algunas noches de otoño y '
          'de invierno oyes sonidos que no sabes qué son. Un canto, un '
          'grito, un ladrido raro. ¿Cómo lo describirías? ¿Cuándo lo '
          'oyes? ¿De dónde viene?',
      estado: NivelConfianza.consenso,
      abierto: false,
      seasons: const ['otono', 'invierno'],
    ),
    Misterio(
      id: 'seed-misterio-polillas-farolas',
      pregunta:
          '¿Hay menos polillas en las farolas de tu calle que hace dos '
          'meses?',
      descripcionCorta:
          'En verano y al principio del otoño, las polillas vuelan '
          'alrededor de las farolas de noche. Más adelante van quedando '
          'menos. ¿Cuándo dejaste de ver muchas? ¿Cómo lo sabrías sin '
          'contarlas exactamente?',
      estado: NivelConfianza.hipotesisActiva,
      abierto: false,
      seasons: const ['verano', 'otono'],
    ),
  ];
}

/// Tabla de traducciones provisionales eu/ca de los Misterios
/// seminales. Cada entrada es `{ 'eu': MisterioTexto, 'ca':
/// MisterioTexto }`. Si un id no está en el mapa, no se traduce y el
/// niño lo verá en castellano en cualquier locale.
///
/// **Calidad**: traducción del operador + Claude, NO nativa, marcada
/// en `decisiones-provisionales.md` ítem #7 como pendiente de
/// validación por hablantes nativos con criterio terminológico
/// naturalista (Elhuyar, Aranzadi, IEC). Mientras llega esa revisión
/// el niño bilingüe del piloto interno ve los Misterios en su idioma
/// con sintaxis razonable y un disclaimer que el operador entiende.
final Map<String, Map<String, MisterioTexto>> _traduccionesProvisionales = {
  'seed-misterio-golondrinas': {
    'eu': const MisterioTexto(
      pregunta: 'Noiz joan ziren enarak zure auzotik?',
      descripcionCorta:
          'Urtero udazkenean enarak hegoaldera hegaldatzen dira. Joaten '
          'direla badakigu. Zehatz-mehatz noiz joaten diren tokiaren eta '
          'urtearen arabera aldatzen da, eta zientzialariek ez dakite '
          'guztiz nola erabakitzen duten noiz alde egin. Aurten zure etxe '
          'inguruan ikusi al dituzu? Noiz utzi zenuen ikusteari?',
    ),
    'ca': const MisterioTexto(
      pregunta: 'Quan se\'n van anar les orenetes del teu barri?',
      descripcionCorta:
          'Cada any les orenetes volen al sud a la tardor. Sabem que '
          'se\'n van. La data exacta canvia segons el lloc i l\'any, i els '
          'científics no n\'estan del tot segurs de com decideixen quan '
          'marxar. Les has vist aquest estiu prop de casa teva? Quan vas '
          'deixar de veure-les?',
    ),
  },
  'seed-misterio-primera-hoja': {
    'eu': const MisterioTexto(
      pregunta: 'Noiz erortzen da zure kaleko zuhaitzaren lehen orria?',
      descripcionCorta:
          'Udazkenean orria galtzen duten zuhaitzek ez dute denak batera '
          'galtzen. Urte batzuetan goiz erortzen dira orriak, beste '
          'batzuetan beranduago. Zuhaitz bakoitzak bere erritmoa du. '
          'Begiratu zure kaleko zuhaitza pixka bat egunero. Zein orri '
          'doa lehenengo? Zer gertatzen da zuhaitzarekin hasten denean?',
    ),
    'ca': const MisterioTexto(
      pregunta: 'Quan cau la primera fulla de l\'arbre del teu carrer?',
      descripcionCorta:
          'Els arbres que perden la fulla a la tardor no la perden tots '
          'a la vegada. Alguns anys les fulles cauen aviat, d\'altres '
          'més tard. Cada arbre té el seu ritme. Mira l\'arbre del teu '
          'carrer una mica cada dia. Quina fulla se\'n va primer? Què '
          'passa amb l\'arbre quan comença?',
    ),
  },
  'seed-misterio-primera-flor': {
    'eu': const MisterioTexto(
      pregunta: 'Zein da zure etxe inguruko urteko lehen lorea?',
      descripcionCorta:
          'Neguan lorerik ez dagoela badirudi ere, ia beti dago bat. '
          'Almendra goiztiar bat. Mimosa bat. Belar txiki bat zementuaren '
          'artean. Begiratu zure inguruko edozein txoko berde. Aurten '
          'lehenengoa zein ikusten duzu loratzen?',
    ),
    'ca': const MisterioTexto(
      pregunta: 'Quina és la primera flor de l\'any prop de casa teva?',
      descripcionCorta:
          'Encara que sembli que a l\'hivern no hi ha flors, gairebé '
          'sempre n\'hi ha alguna. Un ametller primerenc. Una mimosa. '
          'Una herba petita entre el ciment. Mira en qualsevol racó verd '
          'a prop teu. Quina és la primera que veus florir aquest any?',
    ),
  },
  'seed-misterio-cigarras-fin': {
    'eu': const MisterioTexto(
      pregunta: 'Noiz utzi zioten kantatzeari kigalek aurtengo udan?',
      descripcionCorta:
          'Kigalek udako egun beroetan kantatzen dute. Haien kantua udako '
          'soinuetako bat da. Denbora baten ondoren, kantatzeari uzten '
          'diote. Aurten noiz utzi zenuen entzuteari? Inoiz entzun ez '
          'badituzu, badakizu zure inguruan kigalik dagoen?',
    ),
    'ca': const MisterioTexto(
      pregunta: 'Quan van deixar de cantar les cigales aquest estiu?',
      descripcionCorta:
          'Les cigales canten els dies calorosos de l\'estiu. El seu cant '
          'és un dels sons de l\'estiu. Després d\'un temps, deixen de '
          'cantar. Quan vas deixar de sentir-les aquest any? Si mai les '
          'has sentit, saps si a la teva zona hi ha cigales?',
    ),
  },
  'seed-misterio-petirrojo': {
    'eu': const MisterioTexto(
      pregunta: 'Noiz ikusi zenuen aurtengo udazkeneko lehen txantxangorria?',
      descripcionCorta:
          'Txantxangorriak parkeetan, lorategietan eta basoaren ertzetan '
          'bizi dira. Neguan Europako iparraldetik txantxangorri gehiago '
          'iristen dira penintsulara hotza pasatzera. Udazkenean eta '
          'neguan gehiago ikusten dira. Aurten lehena noiz ikusi zenuen?',
    ),
    'ca': const MisterioTexto(
      pregunta: 'Quan vas veure el primer pit-roig aquesta tardor?',
      descripcionCorta:
          'Els pit-rojos viuen en parcs, jardins i vores de bosc. A '
          'l\'hivern arriben més pit-rojos del nord d\'Europa per passar '
          'el fred a la península. Es veuen més a la tardor i a '
          'l\'hivern. Quan vas veure el primer aquest any?',
    ),
  },
  'seed-misterio-polinizadores': {
    'eu': const MisterioTexto(
      pregunta: 'Zer intsektuk bisitatzen dituzte zure kaleko loreak?',
      descripcionCorta:
          'Hiriko kalea izan arren, udaberrian eta udan loreak daude: '
          'lorontzietan, lorategi txikietan, zementuaren artean. Lore '
          'horiek bisitak jasotzen dituzte. Begiratu 10 minutuz edozein '
          'lore. Nor dator? Zenbat mota ezberdin zenbatzen dituzu?',
    ),
    'ca': const MisterioTexto(
      pregunta: 'Quins insectes visiten les flors del teu carrer?',
      descripcionCorta:
          'Encara que sigui un carrer urbà, a la primavera i a l\'estiu '
          'hi ha flors: en testos, en jardinets, entre el ciment. '
          'Aquestes flors reben visites. Mira durant 10 minuts una flor '
          'qualsevol. Qui ve? Quants tipus diferents en comptes?',
    ),
  },
  'seed-misterio-liquenes': {
    'eu': const MisterioTexto(
      pregunta:
          'Zergatik daude likenak hormaren alde honetan eta ez bestean?',
      descripcionCorta:
          'Likenak hormetan, enborretan eta harrietan hazten diren orban '
          'gris, hori edo laranjak dira. Horma edo enbor bat begiratzen '
          'baduzu, alde batean gehiago egoten dira beste aldean baino. '
          'Zergatik? Begiratu zure inguruan hipotesi bat proposatu '
          'aurretik.',
    ),
    'ca': const MisterioTexto(
      pregunta: 'Per què hi ha líquens en aquest costat del mur i no a l\'altre?',
      descripcionCorta:
          'Els líquens són taques grises, grogues o ataronjades que '
          'creixen en murs, troncs i pedres. Si mires un mur o un tronc, '
          'solen estar més en un costat que en l\'altre. Per què? Mira '
          'al teu voltant abans de proposar una hipòtesi.',
    ),
  },
  'seed-misterio-lluvia': {
    'eu': const MisterioTexto(
      pregunta: 'Euria egin ondoren, zer izaki bizidun agertzen dira?',
      descripcionCorta:
          'Euri on baten ondoren, lehen ez zeuden izaki bizidunak '
          'irteten dira. Barraskiloak, zizareak, zenbait onddo, zenbait '
          'landare. Joan zure sit spot-era edo parke batera euria '
          'gelditu eta gero, eta begiratu. Zer aurkitzen duzu? Zergatik '
          'uste duzu orain irteten direla eta lehen ez?',
    ),
    'ca': const MisterioTexto(
      pregunta: 'Després de ploure, quins éssers vius apareixen?',
      descripcionCorta:
          'Després d\'una bona pluja, surten éssers vius que abans no '
          'hi eren. Cargols, cucs de terra, certs fongs, certes plantes. '
          'Surt al teu sit spot o a un parc quan deixi de ploure i mira. '
          'Què trobes? Per què creus que surten ara i no abans?',
    ),
  },
  'seed-misterio-hormigas-arbol': {
    'eu': const MisterioTexto(
      pregunta:
          'Zergatik daude inurriak zuhaitz honetan eta ez ondokoan?',
      descripcionCorta:
          'Zure kalean edo parkean, erreparatu: bi zuhaitz antzeko, '
          'batean inurriak gora eta behera doaz, bestean ez. Zergatik? '
          'Begiratu azala, lurra, hostoak. Konparatu biak hainbat egunez. '
          'Hipotesiak proposatu eta berriz egiaztatu.',
    ),
    'ca': const MisterioTexto(
      pregunta:
          'Per què hi ha formigues en aquest arbre i no en el del costat?',
      descripcionCorta:
          'Al teu carrer o al teu parc, fixa\'t: dos arbres semblants, un '
          'té formigues pujant i baixant, l\'altre no. Per què? Mira '
          'l\'escorça, el terra, les fulles. Compara els dos durant '
          'diversos dies. Proposa hipòtesis i torna a comprovar.',
    ),
  },
  'seed-misterio-aves-suelo-ramas': {
    'eu': const MisterioTexto(
      pregunta: 'Zein txori jaten dute lurrean eta zein adarretan?',
      descripcionCorta:
          'Parkeko txoriek ez dute janaria leku berean bilatzen. Batzuk '
          'lurrean ibiltzen dira, beste batzuk adarren artean mugitzen '
          'dira, beste batzuk hegan egiten dute zomorroak harrapatzeko. '
          'Begiratu pixka batean. Nork jaten du non? Zergatik uste duzu '
          'bakoitza leku batean dagoela?',
    ),
    'ca': const MisterioTexto(
      pregunta: 'Quins ocells mengen a terra i quins a les branques?',
      descripcionCorta:
          'Els ocells del parc no busquen menjar al mateix lloc. Alguns '
          'caminen pel terra, altres es mouen per les branques, altres '
          'volen a buscar bestioles. Mira durant una estona. Qui menja '
          'on? Per què creus que cadascun és en un lloc?',
    ),
  },
  'seed-misterio-dos-pequenos-marrones': {
    'eu': const MisterioTexto(
      pregunta:
          'Bi txori txiki marroi daude zure sit spot-ean. Espezie berekoak al '
          'dira?',
      descripcionCorta:
          'Txori txiki marroiak erraz nahasten dira. Zertan begiratuko '
          'zenuke espezie berekoak diren ala bi ezberdin diren jakiteko? '
          'Ez dizugu eskatzen identifikatzeko. Pentsatzeko eskatzen '
          'dizugu nola jakingo zenukeen.',
    ),
    'ca': const MisterioTexto(
      pregunta:
          'Hi ha dos ocells petits i marrons al teu sit spot. Són la mateixa '
          'espècie?',
      descripcionCorta:
          'Els ocells petits i marrons són fàcils de confondre. En què '
          't\'hi fixaries per saber si són la mateixa espècie o són dues '
          'de diferents? No et demanem que els identifiquis. Et demanem '
          'que pensis com ho sabries.',
    ),
  },
  'seed-misterio-mariposas-blancas': {
    'eu': const MisterioTexto(
      pregunta:
          'Hiru tximeleta zuri pasatzen dira zure lorategitik. Nola bereiziko '
          'zenituzke?',
      descripcionCorta:
          'Udaberrian eta udan, hainbat tximeleta zuri hegan dabiltza '
          'lorategi eta belazeetan zehar. Lehen begiratuan berdinak '
          'dirudite, baina ez dira. Zertan begiratuko zenuke bereizteko? '
          'Begiratu poliki, ez identifikatu azkar.',
    ),
    'ca': const MisterioTexto(
      pregunta:
          'Tres papallones blanques passen pel teu jardí. Com les '
          'distingiries?',
      descripcionCorta:
          'A la primavera i a l\'estiu, diverses papallones blanques '
          'volen per jardins i prats. Semblen iguals a primer cop d\'ull, '
          'però no ho són. En què t\'hi fixaries per distingir-les? Mira '
          'a poc a poc, no les identifiquis ràpid.',
    ),
  },
  'seed-misterio-platano': {
    'eu': const MisterioTexto(
      pregunta:
          'Zure kaleko zuhaitz handia: platanoa al da edo ez da platanoa?',
      descripcionCorta:
          'Itzal-platanoa hirietako zuhaitz arruntenetakoa da. Baina '
          'antzeko zuhaitz asko daude: astigarra, sasi-platanoa, '
          'sikomoroa. Zertan begiratuko zenuke zure zuhaitza platanoa den '
          'jakiteko? Begiratu azala, hostoak, fruituak.',
    ),
    'ca': const MisterioTexto(
      pregunta:
          'L\'arbre gran del teu carrer: és plàtan o no és plàtan?',
      descripcionCorta:
          'El plàtan d\'ombra és un dels arbres més comuns de les '
          'ciutats. Però hi ha molts arbres que se li semblen: erable, '
          'fals plàtan, sicòmor. En què t\'hi fixaries per saber si el '
          'teu arbre és plàtan? Mira l\'escorça, les fulles, els fruits.',
    ),
  },
  'seed-misterio-pajaro-cola': {
    'eu': const MisterioTexto(
      pregunta:
          'Zer egiten du txori txiki horrek isatsa gora eta behera mugitzen '
          'duenean?',
      descripcionCorta:
          'Uretik gertu, iturridun parkeetan, ibai-ertzetan, lurrean '
          'ibiltzen den txori txiki bat dago, isatsa gora eta behera '
          'mugitzen duena etengabe. Ikusi al duzu? Zergatik uste duzu '
          'isatsa hala mugitzen duela? Ikusi ez baduzu, begiratu hurrengo '
          'aldian uretik pasatzen zarenean.',
    ),
    'ca': const MisterioTexto(
      pregunta:
          'Què fa aquell ocell petit que belluga la cua amunt i avall?',
      descripcionCorta:
          'Prop de l\'aigua, en parcs amb fonts, en vores de riu, hi ha '
          'un ocell petit que camina pel terra bellugant la cua amunt i '
          'avall tota l\'estona. L\'has vist? Per què creus que belluga '
          'la cua així? Si no l\'has vist, mira la propera vegada que '
          'passis prop d\'aigua.',
    ),
  },
  'seed-misterio-flor-rara': {
    'eu': const MisterioTexto(
      pregunta:
          'Behin bakarrik ikusi duzun lore bat dago. Zer gertatzen da hartzen '
          'baduzu? Eta ez baduzu?',
      descripcionCorta:
          'Zure sit spot-ean edo gertu, lehen ikusi ez zenuen lore bat '
          'ikusten duzu. Bakarra dago, edo gutxi batzuk. Begia jartzen '
          'dizu. Pentsatu: hartzen baduzu, zer gertatzen da lorearekin? '
          'Eta hemendik pasatzen den hurrengo pertsonarekin? Eta hartzen '
          'ez baduzu? Ez du erantzun bakarra.',
    ),
    'ca': const MisterioTexto(
      pregunta:
          'Hi ha una flor que només has vist una vegada. Què passa si la '
          'culls? I si no?',
      descripcionCorta:
          'Al teu sit spot o a prop, veus una flor que no havies vist '
          'abans. Només n\'hi ha una, o molt poques. Et crida l\'atenció. '
          'Pensa: si la culls, què passa amb la flor? I amb la propera '
          'persona que passi per aquí? I si no la culls? No té una sola '
          'resposta.',
    ),
  },
  'seed-misterio-hormigas-sendero': {
    'eu': const MisterioTexto(
      pregunta:
          'Inurriek habia bat dute bidexkaren erdian. Nola pasatzen zara?',
      descripcionCorta:
          'Bidexka edo espaloi batetik zoaz, eta bidearen erdian inurriek '
          'beren habia egin dute. Mendi txiki bat eta mugimendu asko '
          'dago. Nola pasatzen zara? Zer gertatzen da habia zapaltzen '
          'baduzu? Eta inguratzen baduzu?',
    ),
    'ca': const MisterioTexto(
      pregunta:
          'Les formigues tenen un niu al mig del camí. Com hi passes?',
      descripcionCorta:
          'Vas per un camí o per la vorera, i al mig del camí les '
          'formigues han fet el seu niu. Hi ha un munt i molt moviment. '
          'Com hi passes? Què passa si trepitges el niu? I si el voregis?',
    ),
  },
  'seed-misterio-encina-vieja': {
    'eu': const MisterioTexto(
      pregunta: 'Parkeko arte zaharra: zein urtetakoa da?',
      descripcionCorta:
          'Parke eta zelai askotan arte edo zuhaitz handi bat dago, oso '
          'zaharra dirudiena. Zure aitona baino urte gehiago daramatza '
          'han. Zenbat? Ez da erraza jakitea. Nola jakingo zenuke moztu '
          'gabe?',
    ),
    'ca': const MisterioTexto(
      pregunta: 'L\'alzina vella del parc: de quin any és?',
      descripcionCorta:
          'En molts parcs i camps hi ha una alzina o un arbre gran que '
          'sembla molt vell. Hi porta més anys que el teu avi. Quants? '
          'No és fàcil saber-ho. Com ho esbrinaries sense tallar-lo?',
    ),
  },
  'seed-misterio-grito-raro': {
    'eu': const MisterioTexto(
      pregunta:
          'Udazkeneko gau batzuetan oihu arraro bat entzuten da. Zer animalia '
          'da?',
      descripcionCorta:
          'Zaratarik gabeko leku batean bizi bazara, udazkeneko eta '
          'neguko gau batzuetan ezagutzen ez dituzun soinuak entzungo '
          'dituzu. Kantu bat, oihu bat, zaunka arraro bat. Nola '
          'deskribatuko zenuke? Noiz entzuten duzu? Nondik dator?',
    ),
    'ca': const MisterioTexto(
      pregunta:
          'Algunes nits de tardor se sent un crit estrany. Quin animal és?',
      descripcionCorta:
          'Si vius on no hi ha gaire soroll, algunes nits de tardor i '
          'd\'hivern sents sons que no saps què són. Un cant, un crit, '
          'un lladruc estrany. Com el descriuries? Quan el sents? D\'on '
          've?',
    ),
  },
  'seed-misterio-polillas-farolas': {
    'eu': const MisterioTexto(
      pregunta:
          'Zure kaleko farolatan duela bi hilabete baino sits gutxiago al daude?',
      descripcionCorta:
          'Udan eta udazken hasieran, sitsek farolatan inguruan hegan '
          'egiten dute gauez. Aurrerago gero eta gutxiago daude. Noiz '
          'utzi zenion asko ikusteari? Nola jakingo zenuke zehazki '
          'kontatu gabe?',
    ),
    'ca': const MisterioTexto(
      pregunta:
          'Hi ha menys arnes als fanals del teu carrer que fa dos mesos?',
      descripcionCorta:
          'A l\'estiu i al començament de la tardor, les arnes volen al '
          'voltant dels fanals de nit. Més endavant van quedant menys. '
          'Quan vas deixar de veure\'n moltes? Com ho sabries sense '
          'comptar-les exactament?',
    ),
  },
};

/// Despacho a la API privada del repositorio para guardar misterios.
/// La interfaz pública del [RepositorioLocal] no expone
/// `guardarMisterio` porque el niño no debería poder crear Misterios
/// — los trae el catálogo. El seed sí necesita poblarlos.
Future<void> _guardarMisterio(
  RepositorioLocal repositorio,
  Misterio misterio,
) async {
  if (repositorio is RepositorioIsar) {
    await repositorio.guardarMisterio(misterio);
    return;
  }
  if (repositorio is RepositorioMemoria) {
    await repositorio.guardarMisterio(misterio);
    return;
  }
  throw UnsupportedError(
    'sembrar Misterios necesita un RepositorioIsar o RepositorioMemoria',
  );
}
