import 'package:flutter/foundation.dart';

import '../dominio/misterio.dart';
import '../dominio/nivel_confianza.dart';
import '../dominio/observacion.dart';
import '../dominio/repositorio_local.dart';
import '../dominio/sit_spot.dart';
import '../infraestructura/isar/repositorio_isar.dart';
import '../infraestructura/memoria/repositorio_memoria.dart';
import 'cargador_misterios_seminal.dart';

/// Función `kDebugMode`-only que pobla el repositorio con datos
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
  // `docs/el-cuaderno/catalogo-seminal-misterios.md`) desde el asset
  // JSON auditable por el comité científico (ítem #6 de
  // decisiones-provisionales.md). Cinco quedan marcados `abierto: true`
  // en el propio asset para que el home muestre el rango 3–5 que
  // prescribe la biblia §5.3.
  final misteriosCatalogo = await cargarCatalogoSeminal();
  for (final misterio in misteriosCatalogo) {
    await _guardarMisterio(repositorio, misterio);
  }

  // El Misterio 8 (lluvia) sirve de ancla para una de las
  // observaciones de ejemplo — lo recuperamos por id para evitar
  // depender del orden del catálogo.
  final misterioLluvia = misteriosCatalogo.firstWhere(
    (misterio) => misterio.id == 'seed-misterio-lluvia',
  );

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
