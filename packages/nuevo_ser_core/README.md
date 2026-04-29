# nuevo_ser_core

Plataforma compartida de la **Colección Nuevo Ser Kids**.

## Estado tras Chunk 5

Primera extracción real desde `apps/uno-roto/`. El paquete consume las siguientes piezas y las re-exporta vía `package:nuevo_ser_core/nuevo_ser_core.dart`:

```
lib/src/
├── mastery/habilidad.dart   ← Habilidad, NivelHabilidad, IntentoHabilidad
└── sync/cliente_api.dart    ← ClienteApi, ExcepcionApi (REST con plugin WP)
```

Los demás submódulos previstos (`account/`, `storage/`, `i18n/`, `audio/`, `narrative/`) siguen vacíos a la espera del Chunk 6 (motor adaptativo) y siguientes.

## Lo que NO se ha movido en C5 (deuda asumida hasta C6+)

| Pieza candidata | Por qué se queda en `apps/uno-roto/` | Plan |
|---|---|---|
| `motor_maestria.dart` | Importa `catalogo_habilidades.dart` (lista del juego concreto). | Refactor en C6 con `MasteryProfile` parametrizable. |
| `selector_habilidades.dart` | Importa `distrito` y `mapeo_habilidades_puzzle` (Uno Roto-específicos). | C6: separar selector genérico + adaptación por juego. |
| `repositorio_progreso.dart` (786 LOC) | Mezcla persistencia genérica con conceptos del juego (arco, rango, ritmo) e importa `disparador_tutor`. | C6: dividir en `KeyValueStore` core + `RepositorioUnoRoto` específico. |
| `escena_cinematica.dart`, `plano_escena.dart` | Dependen de `voz_personaje` y `ambiente_cielo` (modelos de Uno Roto). | C6/C7: definir modelos abstractos en `narrative/` y dejar la capa específica en la app. |
| `servicio_sonoro.dart`, `catalogo_sonidos.dart` y resto de `lib/sonido/` | `servicio_sonoro` depende de `repositorio_progreso`; los catálogos son del juego concreto. | C6 (cuando `repositorio_progreso` esté escindido) o C7. |
| `descargador_audio.dart`, `localizador_audio.dart` | Dependen del catálogo del juego para mapear ids a rutas. | Mismo tren que `servicio_sonoro`. |

Mantener la separación cuesta menos que extraer y luego revertir: el principio aquí es "mover solo lo genuinamente reutilizable hoy". Los siguientes chunks (especialmente C6) hacen el refactor estructural que habilita el resto.

## Submódulos previstos

```
lib/src/
├── account/    autenticación, perfiles
├── sync/       cliente HTTP, last-write-wins, cola offline      ← parcial
├── mastery/    motor adaptativo, selector de habilidades        ← parcial
├── storage/    persistencia
├── i18n/       utilidades de localización
├── audio/      capa sonora, descargador de paquetes
└── narrative/  sistema de cinemáticas genérico
```

## Deuda técnica explícita

- **Persistencia**: Uno Roto sigue usando `shared_preferences` con whitelist global y prefijos por perfil (`uroto.perfil.<id>.<sufijo>`). El doc de arquitectura prescribe Isar (`coleccion-nuevo-ser/plataforma/nuevo-ser-core-arquitectura.md` §3.1). **Migración a Isar diferida a v1.5** — no entra en este refactor para no inflar el alcance ni romper la promesa "tests existentes pasan idénticos" del Chunk 8.
- **Claves de persistencia**: el prefijo `uroto.*` se mantiene para Uno Roto. Juegos nuevos (Las Versiones, El Cuaderno) usarán `nuevoser.<juego>.*`. Renombrado uniforme diferido a v1.5.

## Licencia

AGPL-3.0 — coherente con el resto de la Colección Nuevo Ser.
