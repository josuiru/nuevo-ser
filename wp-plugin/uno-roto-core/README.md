# Uno Roto Core (plugin WordPress)

Backend de sync, autenticación y (próximamente) tutor IA para la app Uno Roto.

## Estado

v0.1 — esqueleto funcional sin probar en WordPress real. Requiere verificación manual en una instalación WP + MySQL antes de producción.

## Instalación

1. Copia el directorio `uno-roto-core/` a `wp-content/plugins/` de tu WordPress.
2. En `wp-config.php`, define el secreto de JWT antes de activar:
   ```php
   define( 'UROTO_JWT_SECRET', 'cadena-aleatoria-64-chars-o-más' );
   ```
   Generar: `openssl rand -hex 32`.
3. Activa desde el panel. Las 4 tablas se crean en la activación (idempotente vía `dbDelta`).
4. Verifica endpoints: `curl https://tu-wp.example.org/wp-json/uno-roto/v1/login -I`.

## Tablas creadas

Todas con prefijo `{$wpdb->prefix}uroto_`:

- `uroto_usuarios` — tutor legal (email, password_hash, nombre, locale).
- `uroto_ninos` — perfiles de niño vinculados a un tutor.
- `uroto_progreso` — estado global del niño (esquirlas, rango, nombre_jugador, flags JSON, arco_actual).
- `uroto_estado_habilidades` — fila por (niño, habilidad) con nivel, precisión, tiempo_mediano, etc.

## Endpoints REST

Todos bajo `/wp-json/uno-roto/v1/`.

### Públicos

**POST `/register`**
```json
{ "email": "padre@example.org", "password": "minimo8chars",
  "nombre_tutor": "Josu", "nombre_nino": "Leo", "locale": "es" }
```
→ 201 `{ "token": "...", "nino_id": 42, "usuario_id": 7 }`

**POST `/login`**
```json
{ "email": "padre@example.org", "password": "minimo8chars" }
```
→ 200 `{ "token": "...", "nino_id": 42 }`

### Protegidos (header `Authorization: Bearer <token>`)

**GET `/progress`**
→ 200 `{ "progreso": {...}, "habilidades": [...] }`

**POST `/sync/progress`**
```json
{
  "progreso": { "nombre_jugador": "Leo", "esquirlas_total": 30,
                "rango": 1, "arco_actual": 1, "flags": {...},
                "actualizado_en": "2026-04-21 14:23:00" },
  "habilidades": [ { "id_habilidad": "FR.01", "nivel": 3, ... } ]
}
```
→ 200 con el estado final tras el merge LWW por registro.

**DELETE `/account`**
Borra todos los datos (niño, progreso, habilidades, usuario) asociados al JWT.
→ 200 `{ "ok": true }`

## Privacidad

- Sin tracking. Sin analytics.
- Passwords con `password_hash` (bcrypt por defecto en PHP ≥ 7.4).
- JWT HS256 con secreto en `UROTO_JWT_SECRET`.
- HTTPS obligatorio — configuración de hosting, no se valida en código.
- Borrado GDPR completo vía `DELETE /account`.

## Licencia

GPL-2.0-or-later (compatible con AGPL-3.0 del repo).
