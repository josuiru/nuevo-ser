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
    ),
  ];
}

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
