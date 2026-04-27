# Uno Roto — CLAUDE.md

Cerebro persistente del proyecto. Se lee al inicio de cada sesión. Se mantiene corto. Para detalle: `docs/`.

## Qué es Uno Roto

Juego educativo de matemáticas (fracciones, decimales, proporciones) para niños 9-12 años. MVP en Era 2. Narrativa-mecánica fusionada: las matemáticas **son** el gameplay, no su excusa.

Stack objetivo (doc 03):
- **Cliente**: Flutter + Flame, offline-first, Isar local, Android APK.
- **Backend**: WordPress plugin `uno-roto-core` (independiente de Flavor Platform), MySQL, REST API, JWT propio.
- **IA tutor**: Claude API en servidor, solo en momentos concretos, caché agresivo, SafetyFilter.
- **Idiomas**: castellano, euskera, catalán desde día cero.

Licencia: código AGPL-3.0, contenido CC-BY-SA 4.0.

## Principios innegociables (doc 01)

1. **El niño es la medida.** No el mercado, no la moda, no la métrica.
2. Las matemáticas son el mundo, no un peaje.
3. La mesura es el sabor. Nada de euforia ni sonidos de castigo.
4. Open source de verdad, no de marketing.
5. Privacidad por diseño. Sin tracking, sin ads, sin monetización.

## Documentos de diseño

En `docs/`. Al empezar tarea → solo los relevantes (contexto limitado):

- `01-biblia.md` — espíritu del juego
- `02-mapa-habilidades-atomicas.md` — 66 habilidades del MVP
- `03-arquitectura-tecnica.md` — stack, esquemas, API, roadmap 11 fases
- `04-biblia-personajes.md` — voces y arcos
- `05-biblia-worldbuilding.md` — lore profundo
- `06-biblia-narrativa.md` — estructura narrativa global
- `07-guion-arco-1.md` → `10-guion-arco-4.md` — 62 escenas
- `11-guia-visual.md` — paleta, tipografía, formas
- `12-guia-sonora.md` — capas, motivos, efectos
- `13-storyboards.md` — 10 momentos clave plano a plano
- `14-prompt-maestro.md` — este prompt operativo, 11 fases de desarrollo

## Estado actual

Repo existente con estructura real:
```
uno-roto/
├── app/                   # Flutter (prototipo funcional, no vacío)
│   ├── lib/
│   │   ├── datos/         # RepositorioProgreso, CatalogoHabilidades
│   │   ├── dominio/       # Fragmentos, distritos, motor maestría, selector
│   │   ├── nucleo/        # paleta
│   │   └── vista/         # pantallas + CustomPainters
│   ├── assets/data/skills.json
│   └── test/
└── docs/                  # 14 docs canónicos
```

**Ya implementado (pre-canon)**:
- 6 distritos con posiciones, colores, saludos.
- 66 habilidades cargadas, 39 con puzzle implementado.
- Motor de maestría (5 niveles, precisión ponderada, tiempo mediano, decaimiento 21d/14d).
- Selector adaptativo con pesos por nivel + decay + distrito + anti-repetición.
- Familias de puzzle: unitario, espejo, decimal (**DEC.08 fracción → decimal**: muestra una fracción y candidatos decimales — dirección correcta del catálogo), porcentaje, impropio, proporcional, dual (**FR.16 suma / FR.17 resta / FR.18 × natural / FR.19 × fracción / FR.20 ÷ natural / FR.21 ÷ fracción**: las "× natural" / "÷ natural" se distinguen porque el generador fija denB=1 y la pantalla muestra el segundo operando sin barra; idHabilidadPrincipal lee denB para devolver la skill correcta), operación decimal (**DEC.04 ± / DEC.05 × natural / DEC.06 × decimal / DEC.07 ÷**: pares curados separados para que DEC.05 use siempre un segundo factor entero), **comparación** (FR.05 mismo denominador / FR.06 mismo numerador — dos fracciones, tocar la mayor; el modo lo fija la skill y el generador produce fracciones propias con el ganador claro), **simplificar** (FR.10 — fracción reducible con cuatro candidatos; el ganador es único, la forma mínima. Distractores: el propio objetivo sin simplificar, otra amplificación, y una fracción cercana no equivalente), **amplificar** (FR.11 — ecuación "3/4 = ?/12" con cuatro numeradores candidatos; primera mecánica de "rellenar el hueco". Distractores: el numerador base sin amplificar, el factor confundido con numerador, y errores de ±1/±2), **divisibilidad** (DIV.03 con criterios básicos {2,3,5,10} y DIV.04 con criterios avanzados {4,6,9} — comparten pantalla y motor, el set de divisores se elige por skill vía `divisoresParaSkillId`. `idHabilidadPrincipal` distingue de vuelta cuál ejercita cada Fragmento según el divisor que cargue; DIV.04 pesa un escalón más en dificultad), **comparación decimal** (DEC.02 — dos decimales lado a lado, tocar el mayor. Generador sesgado a casos donde el decimal con más dígitos NO es el mayor (0,35 vs 0,4) — es justo el error sistemático que la habilidad pretende corregir; pista textual "lee las cifras, no las cuentes"), **lectura decimal** (DEC.01 — texto en castellano "veinticinco centésimas" + cuatro etiquetas numéricas. Mecánica nueva texto→número. Lista curada de 10 formas con distractores específicos por trampa de valor de posición; dificultad 1 evita milésimas y mixtos), **múltiplos** (DIV.01 — comparte pantalla y motor con divisibilidad pero usa fraseado inverso "¿N es múltiplo de M?". `ModoFraseoDivisibilidad.multiplo` cambia título y pregunta; el set de divisores es {2..10} en lugar de los criterios memorizados), **comparación con la unidad** (FR.04 — una fracción + tres botones (<1, =1, >1). Primera mecánica de tres opciones en Uno Roto, después de tantas binarias. Generador con reparto 45 % propias / 45 % impropias / 10 % iguales — el caso n/n se incluye explícitamente porque suele pasarse por alto), **lectura de fracción** (FR.02 — texto en castellano "tres quintos" + cuatro fracciones candidatas. Simétrico a DEC.01 pero con trampas propias del idioma de fracciones: invertir num/den (5/3), duplicar cifras (5/5 = 1, no 3/5), confundir ordinales con cardinales. 15 formas curadas; dificultad 1 evita denominadores > 5), **mixto a impropio** (FR.13 — número mixto "2 y 3/4" + cuatro fracciones impropias candidatas. Inverso pedagógico de FR.12. Distractores curados a los errores reales: suma errónea (e+n)/d, ignora el entero (n/d), producto sin sumar (e×n)/d, vecinos ±1 si hay colisión), **redondeo decimal** (DEC.09 — decimal con dos cifras "2,37" + cuatro candidatos a su redondeo a la décima. Distractores curados a los errores reales: truncar (2,3), redondear-pero-rellenar (2,40), truncar-y-rellenar (2,30), redondear de más cuando no hace falta. Generador con sesgo a centésimas en zona de duda 3..7), **comparación de fracciones distintas** (FR.07 — dos fracciones sin nada en común, tocar la mayor. Siguiente escalón sobre FR.05/FR.06: la intuición simple ya no basta, hay que comparar el valor (multiplicación cruzada o cálculo). El generador sesga ≥60% a casos contraintuitivos: la mayor por valor tiene num y den ambos menores que la otra, p. ej. 3/4 vs 5/7), **primos** (DIV.05 — mecánica binaria sí/no "¿es primo?". Pools curados por categoría pedagógica: confusos no-primos (1, 9, 15, 21, 25, 27, 33, 35), especiales (1 que no es primo, 2 único par primo), primos claros como contraste, pares obvios. Reparto 40/30/15/15 — el grueso son los casos donde el niño se equivoca de verdad), **regla de tres directa** (PROP.03 — proporción "a → b · c → ?" + cuatro candidatos. Mecánica del producto cruzado dividido entre el primer término: `? = b·c/a`. Triplas curadas (a,b,c) con resultado entero y c≠a para evitar trivialidad. Distractores curados a los errores reales: relación invertida (b·a/c en lugar de b·c/a), suma de los tres, ignorar la proporción y elegir solo b, suma parcial b+c), **ordenar decimales** (DEC.03 — tres decimales presentados sin orden + cuatro candidatos con permutaciones; el niño elige la que va de menor a mayor. Trios curados sesgados al error "más cifras = mayor": 0,5/0,35/0,8 (donde 0,35 tiene más cifras pero es el menor). Distractores: orden por número de cifras decimales, orden invertido, orden por la primera cifra solo), **MCM y MCD** (DIV.06 MCD / DIV.07 MCM — comparten pantalla y motor con `ModoMcmMcd`. Dos números + cuatro candidatos. Distractores curados a errores reales: confundir MCM↔MCD (el contrario), producto de los dos, suma, uno de los dos números), **jerarquía de operaciones** (OP.01 — expresión "a op b op c" sin paréntesis + cuatro candidatos. Casos curados con resultado entero garantizado y donde el cálculo izquierda-a-derecha siempre da un valor distinto del correcto. Distractor estrella: el cálculo izquierda-a-derecha sin respetar prioridad de × y ÷), **comparar con 1/2** (FR.03 — una fracción + tres botones (<1/2, =1/2, >1/2) con un rectángulo de referencia mostrando la mitad coloreada. La habilidad es interiorizar la heurística "doble del numerador frente al denominador": si 2·n < d → menor, 2·n = d → igual, 2·n > d → mayor. Generador con casos curados contraintuitivos: 5/9 > 1/2, 4/9 < 1/2, 3/6 = 1/2 (la equivalencia que se pasa por alto). Reparto 40/40/20), **porcentaje de cantidad** (PROP.04 — "el 25 % de 80 = ?" + cuatro candidatos. Cálculo directo % × cantidad / 100. Pares curados con resultado entero garantizado. Distractores: el % literal (25), multiplicar sin dividir entre 100 (2000), confundir con resta (cantidad − resultado)).
- Pantalla caza con spawn timer, combate enfoque sin dictado, pantalla habilidades debug.
- Persistencia shared_preferences con keys `uroto.*`.
- Ciudad con restauración progresiva según esquirlas.
- **Tipografía Cormorant Garamond** en `app/assets/fonts/` (variable + variable italic, OFL desde google/fonts). Registrada en pubspec como familia `CormorantGaramond`. Usada por `VozPersonaje.estiloTextoCuerpo()` para voces de Fragmentos nombrados — la serif que distingue visualmente a Kurz/Eco/Zafrán/Vorax del habla humana (doc 11 §5).
- **Sistema de cinemáticas v0.5** (dominio/): `VozPersonaje`, `PlanoEscena` sealed (PlanoAmbiente + PlanoDialogo + PlanoEleccion + PlanoInteractivo + PlanoCierreAmable), `OpcionEleccion` con flags, `EscenaCinematica` con flagsRequeridos + esCierreAmable. Player con reveal letra-a-letra, opciones con respuesta, widget tutorial jugable, botón de cierre "HASTA MAÑANA", callback alEstablecerFlag, fade 300ms, botón saltar. **Sustitución `{nombre}`** vía `aplicarTokens(texto, nombre)`.
- **Sistema de nombre del jugador**: `PantallaNombre` con TextField + botón continuar. Persistido como `uroto.nombre_jugador`. Token `{nombre}` en escenas se sustituye automáticamente.
- Escenas del Arco 1 implementadas y encadenadas:
  - **1.1 El tejado** (completa, incluye bloque Montaña + elección + `{nombre}, ¿verdad?`).
  - **1.2 La primera ventana** — tutorial FR.01: Sora guía a dividir un Pleno y desfragmentar las mitades con gestos reales.
  - **1.3 El callejón** — mujer desorientada, 4 opciones.
  - **1.4 Irune** — las tres reglas, dirigidas a `{nombre}`.
  - **1.5 Kurz aparece** — primer Fragmento nombrado con voz en itálica (Cormorant pendiente). Cinemática-puente: el combate real está calibrado a derrota pero aún no implementado jugable.
  - **1.6 La derrota** — cierre emocional tras el combate jugable de Kurz. Requiere `combate_kurz_1_completado`.
  - **1.7 Kai visto de lejos** — pausa en punto elevado, Sora presenta a Kai ("va dos rangos por delante"). `esCierreAmable: true`. Se dispara al siguiente login.
  - **1.9 Los Plenos** — latente en catálogo. Requiere `fr_05_competente` (flag que activará el motor de maestría cuando el niño domine FR.05). Intro de Impropios.
  Cadena: 1.1 → 1.2 → 1.3 → 1.4 → 1.5 → 1.6 (cierre) → 1.7 (cierre) → [latente: 1.9 cuando FR.05 competente].
- **Escenas pendientes** (requieren combate jugable o sistema de rangos): 1.8 (variantes entrenamiento), 1.10 (2ª derrota Kurz), 1.11 (cena silenciosa), 1.12 (Kurz vencido), 1.13 (ceremonia Aprendiz II), 1.14 (Canales desde arriba).
- **Arco 2 (doc 08) — completo end-to-end**: 16 escenas implementadas (algunas latentes por maestría FR.09/FR.16). Voces nuevas: Rexán (ámbar #E8B85C), Ari (verde), Zafrán (Dual, no habla — Sora guía en su combate). Cadena: 2.1 Bajar solo → 2.2 Rexán → 2.3 Espejo → 2.4 variantes (rotan como 1.8, 4 versiones) → 2.5 pintada → 2.6 Zafrán mencionado (FR.09 competente) → 2.7 Dual+MCM (FR.16 introducida) → 2.8 Rexán+agua → 2.9 Ari → 2.10 silbido (FR.16 competente) → 2.11 Sora baja → 2.12 noche Zafrán → **combate zafran (jugable)** → 2.13 Zafrán escapa → 2.14 después → 2.15 Rexán espera → 2.16 cierre con HASTA MAÑANA.
- **Combate Zafrán**: `DesafioKurz` refactorizado con campos `nombreFragmento`, `vozQueHabla`, `mostrarOjos`. `DesafioKurz.zafran` usa Sora como vocero (no el propio Fragmento — Zafrán no habla), sin ojos, halo rojo oxidado `PaletaNeon.rojoOxidado`. Preguntas sobre MCM(7,11)=77 + amplificación 5/7→55/77, 3/11→21/77, suma 76/77. ki=5, 10s/pregunta, calibrado a victoria narrativa (Zafrán escapa debilitado).
- **Arco 3 (doc 09) — COMPLETO**: 17 escenas de 18 implementadas (falta 3.7 variantes máquinas). Voces nuevas: Vadic (gris metal). Cadena completa con duelo Kai jugable, Eco como escena clave (Cormorant italic, no combate), santuario Coleccionistas, Brina (17% trimestral), Montaña nombrada (Algebrista).
- **Arco 4 (doc 10) — COMPLETO, cierre del MVP**: 14 escenas todas implementadas. 4.1 Oryn tutorial multiplicación → 4.2 El agua recuerda → 4.3 La bolsa (concha) → 4.4 Tercera pintada Opaca (tachada con respuesta) → 4.5 Eco casi (silencio, no aparece) → 4.6 Irune invitación → 4.7 Las tres pruebas (elección persistida) → 4.8 Sora antes (3 variantes: Fuego/Sendero/Espejo) → **4.9 Prueba (3 ramas: combate Vorax jugable / Sendero narrado / Espejo con Niko)** → 4.10 Ceremonia (5 maestros, 5 "Bien", 2 "Gracias" de Sora) → 4.11 Rexán té → 4.12 Kai enhorabuena → 4.13 Sora revela Kir → 4.14 La Montaña con HASTA ENTONCES.
- **Combate Vorax** (`DesafioKurz.vorax`): vocero narrador (silencio absoluto en combate), halo verde, sin ojos. 5 preguntas sobre conversión Impropio→Mixto y descomposición en cuartos (11/4 → 2 y 3/4 → eliminar enteros → cuartos).
- **HUD** soporta 4 arcos: `ProgresoArco.arco1/2/3/4` con 14/16/18/14 escenas; `arcoActual` prioriza 4 > 3 > 2 > 1.
- **HUD del mapa** ahora elige el arco actual dinámicamente: `ProgresoArco.arcoActual(flagActivo)` — si hay progreso en Arco 2, muestra Arco 2; si no, Arco 1.
- **Conexión motor → flags narrativos**: `MotorMaestria.alSubirNivel` callback se invoca cuando una habilidad sube de nivel estricto. `MotorMaestria.flagDeMaestria(id, nivel)` produce flags estables tipo `fr_05_competente`. `pantalla_caza.dart` engancha el callback al repositorio. La escena 1.9 se desbloquea automáticamente cuando el niño domina FR.05.
- **Combate jugable de Kurz v0.2** (`dominio/desafio_kurz.dart` + `vista/pantalla_combate_kurz.dart`): Fragmento nombrado pintado con esfera radial violeta + ojos, valor flotante grande, frases de Kurz reactivas. Tres desafíos calibrados:
  - **kurz_1**: 3 preguntas, ki=2, 4s/pregunta. Calibrado a derrota (1.5).
  - **kurz_2**: 5 preguntas, ki=3, 6s/pregunta. Probable derrota, posible victoria (1.10).
  - **kurz_3**: 4 preguntas, ki=4, 8s/pregunta. Calibrado a victoria (1.12).
  El orquestador detecta combate pendiente vía `_combateKurzPendiente()` antes de buscar siguiente cinemática. Tras combate marca `combate_<id>_completado` + `victoria_<id>`/`derrota_<id>`.
- **Sistema de rangos** (`dominio/rango_narrativo.dart`): enum RangoNarrativo (Aprendiz I/II/III/Iniciado), cada uno con `flagAlcanzado` estable (`rango_aprendiz_ii_alcanzado`...). Persistencia en repositorio. Dos disparadores:
  - **Por esquirlas**: umbrales 0/30/100/250 — proxy. `pantalla_caza` verifica subida tras cada esquirla ganada.
  - **Narrativos**: `repositorio.forzarRangoMinimo(rango)` sube si el actual es menor y activa flag. Usado tras kurz_3 victoria → garantiza Aprendiz II → desbloquea 1.13 ceremonia.
- **HUD del mapa**: rango visible en el header del mapa, debajo de "UNO ROTO", seguido del progreso del arco ("Arco I · X/14") en tamaño pequeño y tenue.
- **ProgresoArco** (`dominio/progreso_arco.dart`): mapeo de las 14 escenas oficiales del Arco 1 a sus flags equivalentes (1.10 y 1.12 agrupan sus ramas, 1.8 agrupa variantes). `contarVistas(flagActivo)` devuelve cuántas están completas — se muestra en el HUD para que el niño vea dónde está.
- **Variantes de entrenamiento (1.8)** (`dominio/variantes_entrenamiento.dart`): 5 mini-cinemáticas recurrentes (noche despejada, niebla, lluvia ligera, pregunta sobre la Montaña con 4 opciones, buen entrenamiento). Se disparan antes de ir al mapa cuando la 1.7 está vista y el Arco 1 aún no cerró (1.14 no vista). `VariantesEntrenamiento.elegirSiguiente(Set)` devuelve la primera no usada, o null si el pool se agotó (el orquestador resetea y reelige). Persistido en repositorio como `uroto.variantes_entrenamiento_usadas`. Una variante por transición (flag `_varianteYaDisparadaEnEstaTransicion`) para no encadenar.
- Escenas adicionales del Arco 1:
  - **1.11 La cena que no se ve** (cierre amable, requiere 1.7).
  - **1.10pre Kurz vuelve** + **combate kurz_2** + **1.10derrota/1.10victoria** — bloque del 2º combate. Ambas cierres marcan `escena_1_10_resuelta` para encadenar la 1.12.
  - **1.12pre Hoy** + **combate kurz_3** + **1.12victoria/1.12derrota** — bloque del 3er combate. La victoria activa `escena_1_12_vista` que abre la 1.13.
  - **1.13 Las palabras de Irune** (sigue latente porque también requiere `rango_aprendiz_ii_alcanzado`). Termina con `PlanoCierreAmable`.
  - **1.14 Los Canales desde arriba** (latente, requiere 1.13). Cierre del Arco I con HASTA MAÑANA explícito.
- Flags narrativos persistidos como `uroto.flag.<nombre>`.
- Orquestador `main.dart` elige la siguiente escena cuyos `flagsRequeridos` estén activos.
- Widget `WidgetFragmentoTutorial` renderiza un Pleno con pulso lento (esfera radial blanco-azul), dos mitades con CustomPaint de semicírculo, dispara callback al completar la acción.
- **Sistema de perfiles** (`datos/repositorio_progreso.dart` + `vista/pantalla_perfiles.dart`): cada perfil guarda su progreso bajo `uroto.perfil.<id>.<sufijo>`. Al arrancar con claves heredadas `uroto.*`, se migran una vez al perfil `principal`. `listarPerfiles`, `crearPerfil(nombre)` (slug con sufijo numérico si colisiona), `cambiarAPerfil`, `borrarPerfil`. Con >1 perfil, la app arranca en el selector; con uno solo sigue el flujo normal. Desde `pantalla_habilidades` hay botón de cambio de perfil que al volver reinicia el orquestador (callback `alReiniciarConPerfilActivo`). `reiniciar()` borra solo el perfil activo preservando su nombre.
- **Capa sonora v0.1** (doc 12): `sonido/servicio_sonoro.dart` es un singleton con 4 capas (ambient / música / efectos / narrativos — enum `CapaAudio`) y un AudioPlayer por capa (plugin `audioplayers`). Fades crossing, ducking cuando entra un narrativo. `CatalogoSonidos` mapea identificadores lógicos (`ambient_canales`, `musica_combate_zafran`, `motivo_sora`, `narrativo_silbido_zafran`…) a rutas WAV bajo `assets/sonido/{ambient,musica,efectos,narrativos}/`. **Tolera assets ausentes y plugin no registrado** (tests, headless): cualquier llamada falla en silencio, la app nunca deja de funcionar por no poder sonar. Preferencias de volumen por capa + modo silencio persisten **por perfil** (`audio.modo_silencio`, `audio.volumen.<capa>`). Pantalla `PantallaAjustesSonido` (accesible desde habilidades) con 4 sliders + switch. Cableado: `EscenaCinematica.sonidoDeEntrada/loopDeFondo` con motivos anotados en escenas clave (Sora/Kai/Montaña/ceremonia/silbido), música dedicada por Fragmento en `pantalla_combate_kurz`, ambient+música de distrito en `pantalla_caza` con fades largos. **Assets WAV aún no existen** — la arquitectura está lista para recibirlos.

**Gap frente a doc 03 / prompt maestro**:
- Backend WordPress `wp-plugin/uno-roto-core/` v0.1 escrito pero sin probar en WP real (plugin standalone, no integrado con el cliente todavía).
- Sin integración cliente-backend aún: falta wire de HTTP en Flutter.
- Sin Isar (usamos shared_preferences).
- Sin Flame (CustomPainter puro).
- Sin Riverpod.
- Sin sistema de cinemáticas (bloqueante para guiones 07-10 y storyboards 13).
- 18/66 habilidades con puzzle concreto.
- Sin tutor IA.
- Sin arte/música final (todo programático/placeholder).

**Fase actual**: ~4-6 del roadmap del doc 03/14 — primer Fragmento jugable + motor + primer distrito funcionales pero sin narrativa scriptada ni sync.

## Backlog priorizado

1. ~~Sistema de cinemáticas~~ ✅
2. ~~Fragmentos nombrados~~ ✅ (Kurz×3 + Zafrán + Vorax + Eco + Duel Kai)
3. ~~Rangos~~ ✅
4. ~~Cormorant Garamond~~ ✅
5. ~~Capa sonora doc 12~~ ✅ **v0.1 arquitectura completa**. Pendiente: grabar/componer los WAV reales y sustituir los placeholders.
6. ~~Pruebas de Ascenso~~ ✅ (las tres implementadas)
7. ~~Backend WordPress~~ ✅ **v0.1 escrito**. Pendiente: probarlo en WP real + wire del cliente Flutter a HTTP.
8. **Migración a Flame + Isar** según se necesite, no antes.
9. **Tutor IA Claude API** (doc 03 §9, fase 9).
10. **Assets reales** (arte + música), sustituyendo placeholders programáticos.

## Comandos habituales

```bash
# Desde /home/josu/Projects/uno-roto/app/
flutter analyze
flutter test
flutter run -d linux        # desktop debug
flutter build apk --release  # APK Android

# Flutter path (no está en PATH del sistema):
export PATH="$HOME/flutter/bin:$PATH"

# Build Android requiere Java 17 (forzado en app/android/gradle.properties):
# org.gradle.java.home=/usr/lib/jvm/java-17-openjdk-amd64
```

## Decisiones técnicas tomadas

- **Flutter 3.24, Dart 3.5** sin Flame ni Riverpod (prototipo con CustomPainter + StatefulWidget). Migrar cuando haya razón real.
- **shared_preferences 2.2.2** como persistencia inicial. Migrar a Isar en fase de sync.
- **Gradle 8.5 + AGP 8.1 + Kotlin 1.9.20 + Java 17** para compilar en Ubuntu 24.
- **Nombres descriptivos en castellano** para variables/clases/archivos (regla usuario). Técnicos en original (widget, builder, etc).
- **Esquirlas como contador crudo** — temporal. Se sustituye por rangos narrativos.
- **Idiomas**: solo castellano en prototipo. eu/ca cuando haya infraestructura `intl`.

## Reglas de interacción (doc 14)

- **Commits pequeños**: <10 archivos salvo setup inicial.
- **Tests antes del código no visual**: motor adaptativo, sync, API, persistencia.
- **Documentar mientras**: actualizar CLAUDE.md al terminar tarea compleja.
- **Verificar antes de inventar**: APIs Flame/WordPress confirmadas o preguntadas.
- **Respetar tono**: si algo choca con doc 01 → señalar antes de implementar.
- **Nunca cargar los 14 docs a la vez** — solo los de la fase.

## Cosas que NO hacer

- No añadir librerías sin registrarlas en "Decisiones técnicas".
- No generar código que viole AGPL.
- No romper barrera cliente/backend (se comunican solo vía API).
- No meter claves, secrets, endpoints producción en commits.
- No hacer "mejoras" de tono sin justificación contra docs.
- No reemplazar código funcional por abstracciones sin razón.
- No usar `withValues(alpha:)` — la versión de Flutter pide `withOpacity()`.
- No crear agujeros de gamificación (puntos, premios, combos) — doc 01 principio 3.

## Incidentes conocidos (para no repetir)

- **MIUI INSTALL_FAILED_USER_RESTRICTED**: aceptar popup manualmente en Redmi Note 8.
- **shared_preferences_android jlink error**: requiere forzar Java 17 en gradle.properties.
- **Niños testers dicen "es para clase"**: el pivote fue quitar sesiones dictadas y abrir cazadero libre. No volver al modelo "ejercicio-por-ejercicio".
- **pumpAndSettle timeout en tests**: usar `pump(duration)` discretos.
