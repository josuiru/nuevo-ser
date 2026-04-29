# nuevo_ser_companion

Acompañamiento (Cuaderno del niño, Mosaicos, dashboards de aula y cuidador) de la **Colección Nuevo Ser Kids**.

Cliente HTTP de los endpoints `/wp-json/nuevo-ser/v1/companion/*` del plugin `nuevo-ser-core`. Implementación incremental: cada ruta sale del estado 501 reservado (C7) cuando esta librería tiene un cliente capaz de invocarla y el plugin tiene un handler real registrado.

## Estado v0.1

| Ruta | Cliente Dart | Handler PHP |
|---|---|---|
| `POST /companion/cuaderno/entries` | `ClienteCompanion.crearEntradaCuaderno` | `NS_Companion_Cuaderno::crear_entrada` |
| `GET /companion/cuaderno/entries` | `ClienteCompanion.listarEntradasCuaderno` | `NS_Companion_Cuaderno::listar_entradas` |
| `POST /companion/mosaicos` | `ClienteCompanion.crearMosaico` | `NS_Companion_Mosaicos::crear_mosaico` |

## Pendiente (siguen 501 en el servidor)

| Ruta | Método | Notas |
|---|---|---|
| `/companion/aggregates/weekly` | POST | Anonimizado, alimenta "Esta semana". |
| `/classrooms` | POST | Profesor crea aula. |
| `/classrooms/{code}/join` | POST | Niño se une con código. |
| `/classrooms/{id}/aggregates` | GET | Profesor ve agregados. |
| `/caregivers/link/request` | POST | Solicitud de vínculo cuidador-niño. |
| `/caregivers/link/verify` | POST | Verificación con consentimiento parental. |
| `/caregivers/{caregiverId}/children/{childId}/summary` | GET | Resumen para cuidador. |

## Diseño

Mismo patrón que `ClienteApi` (core) y `ClienteTutor` (tutor): sin lógica de negocio, cliente HTTP inyectable para tests, errores tipados con `ExcepcionApi`. El backend valida formato y existencia de `game_id` contra `ns_games` — el mismo backend sirve a Uno Roto y a Las Versiones sin que un cliente pueda inventar un juego.

## Licencia

AGPL-3.0.
