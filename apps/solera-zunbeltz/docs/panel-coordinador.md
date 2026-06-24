# Solera Zunbeltz — Panel del coordinador (repositorio de informes) · propuesta técnica

> Estado: **propuesta** (opción C de la consulta del 2026-06-24). Requiere decisión humana de **stack/hosting/RGPD** (es la decisión de backend bloqueada, ver `BLOQUEOS-PENDIENTES.md` C.14-15 y F4 de agro). No desplegado. Pensado como **fase posterior a la Fase 1**, financiable por su propia línea (innovación / grupo operativo).

## Objetivo

Que **Zunbeltz Elkartea** (coordinador) **gestione y consulte de forma centralizada** los informes (PDF) y, opcionalmente, los datos de seguimiento de **todas las personas tester**, sin depender de que cada una le mande los ficheros a mano.

Dos alcances posibles:
- **C1 · Repositorio de informes** (recomendado como MVP): los testadores **suben sus PDF/CSV**; el coordinador entra con login y **lista/descarga** los de cada proyecto. Gestión documental, no sincroniza datos.
- **C2 · Panel con datos** (evolución, = Capa B / FZ-10): además de los documentos, sincroniza los **datos** y el coordinador ve **indicadores, rentabilidad y la comparativa** de todos los testers en vivo.

## Arquitectura — opciones de stack

| Opción | Qué es | Pros | Contras |
|---|---|---|---|
| **a) Reutilizar el plugin WordPress del monorepo** (`wp-plugin/nuevo-ser-core/`) | Endpoints REST + almacenamiento + auth ya existentes (NS_Auth, NS_Esquema), como el Companion | Infra y auth ya montadas; coherente con el repo; coste bajo | Acoplado a WordPress; subir/servir binarios (PDF) en WP requiere cuidado |
| **b) Servicio backend Solera independiente** | API propia (la decisión F4 de agro) + storage de objetos | Limpio, escalable, multi-tenant (red de ETAs) | Nuevo stack a decidir y mantener; más coste |
| **c) Carpeta cloud gestionada (Drive/Nextcloud) + subida automática** | La app sube a una carpeta compartida vía API/WebDAV | Casi sin backend propio; rápido | Sin login por rol fino; gestión = navegar carpetas |

**Recomendación**: **C1 sobre la opción (a)** — un repositorio de informes montado sobre el plugin WordPress existente, que es lo más rápido y barato y resuelve "gestión y consulta de PDFs". Dejar **C2/(b)** para cuando se aborde el backend Solera completo.

## MVP (C1) — repositorio de informes sobre WordPress

**Modelo de datos** (tablas `wp_ns_*` con `game_id`, convención del repo):
- `informe`: id, proyecto_ref, tester_ref (o nombre), tipo (informe/comparativa/csv), fichero (ruta/adjunto), fecha_subida, tamaño, subido_por.
- Roles: **testador** (sube los suyos), **coordinador** (lista/descarga todos), **mentor** (sus testadores) — reutiliza el esquema de roles del Companion (que ya tiene el bloqueo de auth profesor/cuidador pendiente).

**Endpoints** (`/nuevo-ser/v1/zunbeltz/...`):
- `POST /informes` (auth testador) — sube un PDF/CSV con metadatos del proyecto.
- `GET /informes` (auth coordinador/mentor) — lista filtrable por tester/proyecto/fecha.
- `GET /informes/{id}` — descarga.
- `DELETE /informes/{id}` — borra (permisos).

**App (cliente)**:
- En `ProyectoDetalle`, junto a "Enviar al coordinador" (ya existe como compartir), añadir **"Subir al panel"** que hace el `POST` autenticado.
- Necesita: configurar la URL del panel + credenciales del testador en Ajustes.

**Panel del coordinador**: vista web (página del plugin o app aparte) con login que lista los informes por tester/proyecto y permite descargar. C2 añadiría aquí indicadores/comparativa en vivo.

## RGPD (load-bearing)

Los informes llevan **datos económicos y personales** del testador (rentabilidad, ventas, evaluación). Centralizarlos exige, **antes de implementar**:
- Definir **quién ve qué** (coordinador sí; ¿mentor solo los suyos?; el resto de testers nunca).
- **Base legal y consentimiento** del testador para que Zunbeltz custodie sus datos.
- **Responsable del tratamiento** = Zunbeltz Elkartea; registro de actividades; cifrado en tránsito (HTTPS) y control de acceso.

## Coste

- **Recurrente**: hosting + dominio (si servicio propio) o el alojamiento WordPress existente; SSL gratis (Let's Encrypt); mantenimiento.
- **Desarrollo**: C1 (repositorio) es acotado; C2 (datos en vivo) es el backend completo (mayor).

## Encaje y financiación

- Es **fase posterior** a la Fase 1 (que es single-device). Encaja como **proyecto de innovación / grupo operativo** o ampliación, no en la convocatoria de comercialización actual.
- Comparte la **decisión de stack** con F4 de agro y el **auth multi-rol** del Companion (ambos bloqueados). Resolverlos aquí sirve a toda la Suite Solera y a la red de ETAs.

## Mientras tanto (sin backend)

La app ya cubre el puente con **"Enviar al coordinador"** (compartir el informe PDF al correo del coordinador configurado en Ajustes) y **exportar CSV**. Combinado con una **carpeta compartida** (Drive/Nextcloud) da una gestión documental básica con coste cero hasta decidir C.
