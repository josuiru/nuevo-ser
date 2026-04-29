# nuevo_ser_core

Plataforma compartida de la **Colección Nuevo Ser Kids**.

## Estado de la extracción

Avance acumulado desde el Chunk 5 — el paquete re-exporta vía `package:nuevo_ser_core/nuevo_ser_core.dart`:

```
lib/src/
├── mastery/
│   ├── habilidad.dart                  ← Habilidad, NivelMaestria, IntentoHabilidad, EstadoHabilidad
│   ├── mastery_engine.dart             ← motor adaptativo Strategy (C6)
│   ├── mastery_profile.dart            ← contrato MasteryProfile + SessionPayload (C6)
│   ├── perfiles/p1_precision.dart      ← P1 funcional (C6)
│   ├── perfiles/p2_detection.dart      ← stub (C6)
│   ├── perfiles/p3_construction.dart   ← stub (C6)
│   ├── perfiles/p4_calibration.dart    ← stub (C6)
│   └── selector_habilidades.dart       ← selector adaptativo genérico
├── storage/
│   └── gestor_perfiles.dart            ← multi-perfil sobre SharedPreferences + PerfilInfo
└── sync/cliente_api.dart               ← ClienteApi, ExcepcionApi (REST con plugin WP)
```

Los demás submódulos previstos (`account/`, `i18n/`, `audio/`, `narrative/`) siguen vacíos a la espera de la próxima ronda de extracción.

## Deuda de extracción pendiente

| Pieza candidata | Por qué se queda en `apps/uno-roto/` | Plan |
|---|---|---|
| Resto de `repositorio_progreso.dart` (~620 LOC) | El núcleo de gestión de perfiles ya vive aquí; lo que queda mezcla persistencia genérica de habilidades/tutor con conceptos específicos del juego (arco, rango, ritmo, distrito, esquirlas). | Extraer en sucesivos slices la persistencia de `EstadoHabilidad` y `EstadoTutorHabilidad`; dejar en uno-roto solo lo específico (rango, esquirlas, flags…). |
| `escena_cinematica.dart`, `plano_escena.dart` | Dependen de `voz_personaje` y `ambiente_cielo` (modelos de Uno Roto). | Definir modelos abstractos en `narrative/` y dejar la capa específica en la app. |
| `servicio_sonoro.dart`, `catalogo_sonidos.dart` y resto de `lib/sonido/` | `servicio_sonoro` depende de `repositorio_progreso`; los catálogos son del juego concreto. | Salen detrás de `repositorio_progreso`. |
| `descargador_audio.dart`, `localizador_audio.dart` | Dependen del catálogo del juego para mapear ids a rutas. | Mismo tren que `servicio_sonoro`. |

`motor_maestria.dart`, `selector_habilidades.dart` y la gestión multi-perfil ya tienen su núcleo aquí; lo que queda en `apps/uno-roto/` son facades/wrappers finos que inyectan los acoplamientos juego-específicos (catálogo, distritos, conjunto de habilidades con puzzle implementado, claves globales del juego concreto) y delegan en la plataforma.

Mantener la separación cuesta menos que extraer y luego revertir: el principio aquí es "mover solo lo genuinamente reutilizable hoy".

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
