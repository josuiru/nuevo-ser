# nuevo_ser_tutor

Cliente del Tutor IA — proxy a Claude API con caché LRU + TTL, doble capa de filtros (cliente/servidor) y disparador adaptativo.

## Estado tras Chunk 5

Extracción inicial desde `apps/uno-roto/`. El paquete re-exporta vía `package:nuevo_ser_tutor/nuevo_ser_tutor.dart`:

```
lib/src/
├── cache_tutor.dart        ← LRU 200 + TTL 30d sobre SharedPreferences
├── cliente_tutor.dart      ← POST /tutor/explicar (depende de ExcepcionApi del core)
├── filtro_seguridad.dart   ← contrato canónico de seguridad (Dart) — espejo en PHP
└── disparador_tutor.dart   ← heurística "ofrecer tutor" (umbral fallos + cooldown)
```

## Lo que NO se ha movido en C5

| Pieza | Por qué se queda en `apps/uno-roto/` |
|---|---|
| `servicio_tutor.dart` | Importa `RepositorioProgreso`, que todavía mezcla persistencia genérica con conceptos de Uno Roto (arco, rango, ritmo). Se moverá cuando C6 escinda el repositorio. |
| `cliente_tutor_panel.dart` | Cliente del panel admin del tutor — específico del flujo de Uno Roto, no se considera plataforma reusable hoy. |

## Dependencias

- `nuevo_ser_core` — para `ExcepcionApi` (cliente HTTP base).
- `http` — POST a `/wp-json/nuevo-ser/v1/tutor/explicar` (canónico desde C3).
- `shared_preferences` — persistencia de la caché LRU.

## Filtros: contrato Dart como canónico

`filtro_seguridad.dart` es la fuente de verdad. El plugin WordPress (`includes/class-ns-filtro-tutor.php`) replica las mismas 7 reglas; cualquier cambio aquí debe espejarse allí. La doble capa garantiza que un cliente comprometido no puede filtrar.

## Licencia

AGPL-3.0.
