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

  // Dos Misterios literales del catálogo seminal (`docs/el-cuaderno/
  // catalogo-seminal-misterios.md`). Los códigos siguen el patrón
  // del catálogo para que cuando llegue Sprint 2 la sincronización
  // del backend pueda emparejar por código si los reusa.
  final misterioGolondrinas = Misterio(
    id: 'seed-misterio-golondrinas',
    pregunta: '¿Cuándo se van las golondrinas de tu barrio?',
    descripcionCorta:
        'Cada año las golondrinas vuelan al sur en otoño. La fecha cambia '
        'según el lugar y el año. ¿Las has visto este verano cerca de tu '
        'casa? ¿Cuándo dejaste de verlas?',
    estado: NivelConfianza.hipotesisActiva,
    abierto: true,
  );
  final misterioLluvia = Misterio(
    id: 'seed-misterio-lluvia',
    pregunta:
        'Después de llover, ¿qué seres vivos aparecen que no estaban antes?',
    descripcionCorta:
        'Después de una lluvia buena, salen seres que no estaban antes. '
        'Sal a tu sit spot o a un parque cuando pare de llover y mira. '
        '¿Qué encuentras? ¿Por qué crees que salen ahora y no antes?',
    estado: NivelConfianza.hipotesisActiva,
    abierto: true,
  );
  await _guardarMisterio(repositorio, misterioGolondrinas);
  await _guardarMisterio(repositorio, misterioLluvia);

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
