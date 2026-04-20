# Uno Roto — Arquitectura Técnica

> Documento técnico.
> Versión 0.1 — MVP Era 2.
> Complementa la biblia (doc 1) y el mapa de habilidades (doc 2).
> Escrito para que Claude Code pueda implementarlo sin ambigüedades.

---

## 1. Propósito y alcance

Define stack, arquitectura, modelo de datos, contratos entre componentes, estrategia offline-first, integración con tutor IA y convenciones de código. Cuando dice "se exige" es obligatorio; "se recomienda" admite desviación razonada.

## 2. Decisiones cerradas

1. **Cliente**: Flutter + Flame.
2. **Backend**: WordPress + plugin custom `uno-roto-core`.
3. **BD**: tablas MySQL custom (no CPTs).
4. **Offline-first** estricto.
5. **Privacidad por diseño**: sin tracking, sin anuncios, GDPR/COPPA/LOPD.
6. **Multiidioma** desde el día cero (es, eu, ca).
7. **Licencias**: código AGPL-3.0, contenido CC-BY-SA 4.0.
8. **Tutor IA vía Claude API** en momentos concretos.

## 3. Arquitectura de alto nivel

```
Flutter App (Flame)
  → Motor adaptativo local
  → Isar / SQLite
  → Cola sync
  → Cliente API
        ↓ HTTPS
WordPress + Plugin uno-roto-core
  → Endpoints /wp-json/uno-roto/v1/*
  → JWT propios
  → Tablas custom
  → Panel admin
        ↓
Anthropic API (tutor IA)
  → Cache agresivo
```

El cliente manda. Toda la lógica de juego vive en el cliente. Backend es buzón + proxy hacia Claude.

## 4-20. Especificación completa

Contenido canónico adoptado sin cambios de la v0.1 proporcionada por el equipo de diseño. Incluye: paquetes Flutter (§4), estructura de carpetas (§4.2), Isar schemas (§5), plugin WP (§6), REST API (§7), motor adaptativo (§8), Flame (§9), tutor IA con cache (§10), privacidad (§11), i18n (§12), accesibilidad (§13), despliegue (§14), testing (§15), licencias (§16), git conventions (§17), **hoja de ruta por fases (§18)** y riesgos (§19).

La fase 0 arranca con monorepo, la fase 1 con Isar + MasteryEngine, la fase 3 con Flame y familias A-B, la fase 7 con backend y sync, la fase 9 con tutor IA. Ver §18 para el checklist ordenado.
