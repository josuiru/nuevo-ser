# Uno Roto — Prompt Maestro para Claude Code

> Documento operativo (no creativo). v0.1 MVP Era 2.
> Contiene el mensaje de apertura literal + guías para mantener Claude Code productivo durante meses.

---

## 1. Estructura del documento

Tres partes:
- **A** — Preparación del entorno (repo, CLAUDE.md raíz, .gitignore).
- **B** — Prompt de apertura literal.
- **C** — 11 prompts de fase, uno por fase del roadmap del doc 03.

Idea: sesión continua de meses. CLAUDE.md = cerebro persistente. Prompts = empujones de cambio de fase.

## 2. Siete principios de interacción

| # | Principio | Resumen |
|---|---|---|
| 2.1 | Espíritu > código | Si Claude propone "optimizaciones" que sacrifican tono → recordar doc 1 principio 1 ("el niño es la medida") |
| 2.2 | Commits pequeños | Ningún commit toca >10 archivos salvo setup inicial |
| 2.3 | Test-first no visual | Motor adaptativo, sync, API, persistencia: test antes del código |
| 2.4 | No alucinar stack | Verificar APIs Flame/WordPress antes de codificar. Si no seguro → ejecutar o preguntar |
| 2.5 | Documentar mientras, no después | Actualizar CLAUDE.md/README al terminar tarea compleja |
| 2.6 | Respetar contexto | 12 docs = ~540 KB. **Nunca cargar todos a la vez**. Solo los relevantes de la fase |
| 2.7 | Iterar en grises | Cuando algo no queda → feedback concreto, no reinicio |

---

## PARTE A — Preparación

### 3. Estructura de repo (propuesta original)

```
uno-roto/
├── docs/                  # 12 docs de diseño
├── flutter-app/           # cliente Flutter+Flame
├── wp-plugin/             # plugin WordPress backend
├── content/               # JSONs exportables
├── tests/                 # tests cross-stack
├── .gitignore
├── LICENSE                # AGPL-3.0
├── README.md
└── CLAUDE.md              # cerebro persistente
```

> **Nota**: nuestro repo actual tiene `app/` (Flutter) en vez de `flutter-app/` + `wp-plugin/`. El backend WordPress no se ha iniciado. La estructura propuesta es para arranque limpio; el estado real es post-fase 4 aproximadamente.

### 4. Plantilla inicial de CLAUDE.md

Ver `/CLAUDE.md` en la raíz — aplicado adaptado al estado real del proyecto.

### 5. .gitignore base

Flutter (`.dart_tool/`, `build/`, `.gradle/`, `local.properties`), WordPress (`vendor/`, `node_modules/`, `.env`), IDE (`.vscode/`, `.idea/`), OS (`.DS_Store`), secrets (`*.pem`, `*.key`, `*.env.production`), logs.

---

## PARTE B — Prompt literal de apertura

```
Hola Claude. Eres el desarrollador principal de Uno Roto. Vamos a trabajar
juntos durante meses. Empezamos hoy.

Antes de escribir una sola línea de código, lee en este orden:
1. CLAUDE.md (raíz)
2. docs/01-biblia-del-juego.md (ENTERO)
3. docs/03-arquitectura-tecnica.md (ENTERO, secciones 1-6)

No leas otros docs aún. Los irás leyendo por fase.

Responde al checkpoint:
- Dos frases: qué es Uno Roto.
- Dos frases: principios innegociables (los más críticos y por qué).
- Tres frases: stack técnico y elementos más arriesgados.

Contexto: desarrollador web, experiencia WordPress senior, Flutter novato.
Proyecto como BIEN COMÚN DIGITAL, no startup. Solicitud a NLnet NGI0.
AGPL-3.0 código, CC-BY-SA 4.0 contenido. Sin dependencias propietarias
cuando haya alternativa abierta. Sin tracking, sin ads.

MVP cubre Era 2 (9-12 años) — fracciones, decimales, proporciones.
66 habilidades (doc 2), 62 escenas (docs 6-9), arquitectura (doc 3).
Tenemos más material del que necesitamos. Lo que falta es construirlo.

Reglas:
1. Commits pequeños.
2. Tests antes del código no visual.
3. Documentación mientras, no después.
4. Verificar APIs antes de inventar.
5. Respeto al tono (si pido algo que choca con doc 1, señalarlo).
6. El espíritu precede a la optimización.

Empezamos. Lee los tres archivos y responde al checkpoint.
```

---

## PARTE C — Prompts por fase (11 fases)

**Uso**: un prompt por fase, cuando toca. Commit cerrando fase anterior ("Fin de fase N: ...") antes del siguiente prompt.

### Fase 0 — Setup inicial
**Docs**: 03 §§2, 11, 13. **Entregable**: repo estructurado, CLAUDE.md poblado, CI/CD básico.

Tareas: crear estructura de carpetas (solo `.gitkeep`), `flutter-app/pubspec.yaml` con deps justificadas, `wp-plugin/uno-roto-core.php` con header GPL-2.0+, `README.md` (<200 líneas), workflow GitHub Actions (`flutter analyze` + PHPUnit). **No** código de gameplay.

### Fase 1 — Modelo de datos
**Docs**: 02 apéndice A, 03 §§3, 4. **Entregable**: modelos Isar, tablas MySQL, seed de habilidades.

5 colecciones Isar, 5 tablas MySQL idempotentes (`dbDelta()`), `content/skills/skills-mvp.json` con las 66 skills. Tests de serialización, validación JSON y migraciones. Comando `seed.dart`.

### Fase 2 — Bootstrap app Flutter
**Docs**: 03 §§5, 6; 10 §§4, 5, 9. **Entregable**: app arranca, splash, pantalla inicio, navegación placeholder.

Tema oscuro con paleta doc 10. Inter + Cinzel como assets locales (no Google Fonts online). `intl` con es/eu/ca (es completo, eu/ca placeholder). Reglas: mínimo 30% negativo, no negro absoluto, esquinas 8-12px, fade-in 300ms.

### Fase 3 — Motor adaptativo
**Docs**: 02 §§5, 6; 03 §7. **Entregable**: motor de selección en Flutter + PHP idénticos. Test-first sin excepción.

Precisión ponderada, decaimiento 21d/14d, selección combinando nivel + deps + decay + arco. Tests de 4 arquetipos (principiante, master, gaps, 30d sin jugar). **Duplicar en PHP** — frontend y backend devuelven misma recomendación. Test de integración cross-stack.

### Fase 4 — Primer Fragmento jugable
**Docs**: 01 §§6, 7; 10 §6; 11 §8. **Entregable**: familia A (Plenos) y B (Unitarios) jugables.

Clase base `Fragment`, subclases Pleno/Unitario. Escena Flame minimalista: tap desfragmenta, swipe divide. Halo pulsante (doc 10 §6.1). Sonidos placeholder. UI: solo barra de Ki. Sin Sora, sin diálogo.

### Fase 5 — Auth y sync
**Docs**: 03 §§5, 8; 01 §9. **Entregable**: login email/pass, JWT, sync LWW por campo.

Endpoints `/register`, `/login`, `/sync/progress`, `/progress`. JWT en `flutter_secure_storage`. Sync offline-first. **LWW por campo** (no por registro) — cada campo con timestamp propio. HTTPS obligatorio. Sin analytics, sin Google Play Services si se puede evitar. "Exportar datos" y "eliminar cuenta" desde día cero.

### Fase 6 — Primer distrito + Arco 1 (escenas 1.1-1.4)
**Docs**: 06 entero; 05 secciones Sora + Irune; 10 §8.1; 11 §5.1. **Entregable**: azotea jugable, sistema narrativo, escenas 1.1-1.4.

Motor de diálogo cargando escenas desde JSON, aparición letra por letra, flags narrativos (`met_sora`, `seen_rooftops`, `met_irune`), silencios escritos respetados. Escena 1.1 completa (10 planos storyboard 1). Escenas 1.2-1.4 encadenadas.

### Fase 7 — Cierre Arco 1 + Fragmentos nombrados
**Docs**: 06 escenas 1.5-1.14; 01 §7 familia J; 11 §9.2. **Entregable**: Arco 1 completo hasta rango Aprendiz II.

Familia C (Compuestos). **Kurz** como Fragmento nombrado familia J — voz en Cormorant Garamond (crítico), se retira al ser derrotado. 5 variantes de entrenamiento (selección por sesión). Primer combate pensado para perder. Ceremonia Aprendiz II. Botón "HASTA MAÑANA". **Gestión de ritmo**: tras 1.6, 1.13, 1.14 sugerir descanso con gap de N horas — discutir antes de implementar.

**Al terminar fase 7 → probar con niño real.**

### Fase 8 — Arcos 2, 3, 4 (partir en 8a, 8b, 8c)
**Docs**: 07, 08, 09; 10 §8 resto distritos; 11 §5 música por distrito.

Por subfase: leer guion + guía visual distrito + guía sonora + biblia personajes nuevos. Fragmentos:
- **8a (Arco 2)**: familias D (Espejo) + F (Duales). **Zafrán**.
- **8b (Arco 3)**: G (Decimales) + H (Porcentuales) + I (Proporcionales). **Eco** con "mundo baja volumen".
- **8c (Arco 4)**: E (Impropios). **Vorax** para Prueba de Fuego. Pruebas de Ascenso: Fuego, Sendero, **Espejo** (aprendiz Niko generado con Claude API — prompt seguro, gesto del pelo 2× exactas).

Probar con niño al final de cada subfase.

### Fase 9 — Tutor IA Claude API
**Docs**: 03 §9. **Entregable**: tutor IA limitado, cache agresivo, SafetyFilter, fallback estático.

Cliente Claude API **en servidor** (clave nunca toca dispositivo). Endpoint `/ai/hint`. SafetyFilter: validación previa + posterior, rechaza si voces no respetadas o contenido inapropiado → fallback. Caché 30d por hash de contexto. Límite N intervenciones/niño/semana. Fallback estático pre-escrito en es/eu/ca para cada activador.

### Fase 10 — Pulido audiovisual
**Docs**: 10 entera, 11 entera, 12 entera. **Entregable**: arte real, música real, animaciones pulidas.

Desarrollo con Claude Code se pausa parcialmente. Humanos hacen arte/música. Claude ayuda con briefings, integración de assets, iteración de animaciones, implementación plano a plano del doc 12. Balance volumen capas 1-4. Tests rendimiento gama baja.

### Fase 11 — Publicación
**Docs**: 01 §§9, 10; 03 §§11, 14. **Entregable**: APK distribuible, backend en producción, canal feedback.

Build producción, deploy Dinahosting o equivalente. GDPR/normativa niños España+UE. Formulario feedback + email — **sin telemetría automática**. Página pública (qué es, licencias, contribuir, descargar, privacidad real, contacto). Plan mantenimiento 6 meses. Informe NLnet.

---

## PARTE D — Guías transversales

### 19. Pedir cambios que funcionen

- Identifica **qué principio** no se respeta (doc 1, 4, etc).
- Cítalo literalmente: *"Esto choca con principio 3 doc 1: la mesura es el sabor."*
- Propón alternativa concreta o pide 2-3.

**No funciona**: "Esto no me gusta", "Hazlo mejor", "Cambia todo".

### 20. Gestión de contexto en sesiones largas

1. CLAUDE.md siempre actualizado.
2. Cada sesión: *"Lee CLAUDE.md y continuamos con fase X tarea Y."*
3. Si sesión se alarga → cortar, commit, nueva sesión.
4. Nunca pegar los 12 docs — referenciar paths.

### 21. Revisión mensual de calidad

Sesión dedicada: *"Diagnostica deuda técnica, lee CLAUDE.md, dime qué partes están más descuidadas."* → priorizar 2-3 áreas → issues → atacar prioritarias.

### 22. Manejo de bloqueos

Si Claude no avanza (soluciones que no funcionan, código que revierte):
1. Parar.
2. *"Describe qué intentas, con qué restricciones, qué obstáculos ves."*
3. Leer → aclarar suposición mala.
4. Tras 2 resets → decisión humana.

### 23. Cuándo consultar humanos externos

NO decidir solo Claude Code + tú:
- Arquitectura fuera del doc 03.
- Privacidad infantil fuera del doc 01 §9.
- Narrativa que invalide docs 04-09.
- Licencias.
- Financieras.

→ Comunidad open source, NLnet, consultoría legal.

### 24. Feedback de niños (sagrado)

1. Cada mes, 2-3 niños edad objetivo.
2. Observar sin intervenir.
3. Preguntas abiertas post-sesión: *"¿Qué te gustó? ¿Qué te aburrió? ¿Qué no entendiste?"*
4. Notas tras cada sesión.
5. A 5-10 sesiones → patrones.
6. *"4 de 5 se perdieron en escena X. Revisemos ritmo."*

**Nunca ignorar feedback de niño porque no encaje con docs. Los niños son la verdad.**

---

## 25. Cierre

> *"¿Respetaría esto a un niño de 10 años que lo juega por primera vez?"*
> Si sí → sigue. Si no → no lo hagas aunque sea más rápido.

---

*Fin prompt maestro v0.1. Fin documentación inicial Uno Roto MVP Era 2. Siguiente: ejecución.*
