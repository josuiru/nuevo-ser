# Uno Roto — Juego de matemáticas narrativo

Juego educativo de matemáticas (fracciones, decimales, proporciones, geometría y estadística) para niños de 9 a 14 años. Las matemáticas **son** el gameplay, no su excusa.

Parte de la línea **Colección Nuevo Ser Kids**.

## Estado del proyecto

**MVP prácticamente completo (~95%)**. Catálogo de **76 habilidades** implementado en 11 dominios, 4 arcos narrativos con más de 60 escenas, combates jugables, motor adaptativo, backend WordPress y tutor IA.

## Lo que incluye

### 76 habilidades en 11 dominios
- **FR** (22) — Fracciones: unitario, comparación, simplificar, amplificar, mixto a impropio, equivalente, fracción de cantidad, ordenar, dual (suma, resta, multiplicación, división)
- **DEC** (9) — Decimales: lectura, comparación, ordenar, redondeo, operaciones, conversión fracción↔decimal
- **PROP** (7) — Proporcionalidad: razón, regla de tres, porcentajes, aumentos y descuentos, escala, proporcionalidad directa
- **DIV** (7) — Divisibilidad: múltiplos, divisores, criterios, primos, MCM y MCD
- **OP** (3) — Jerarquía de operaciones: básica y con fracciones, operación mixta decimal+fracción
- **MED** (5) — Medidas: longitud, masa y capacidad, tiempo sexagesimal, ángulos, superficie y áreas
- **GEO** (8) — Geometría: polígonos, perímetro, área de rectángulo y triángulo, círculo, volumen, simetría axial, ortoedro
- **EST** (6) — Estadística: gráfico de barras, gráfico circular, media, moda y mediana, probabilidad
- **ARI** (5) — Aritmética: suma, resta, multiplicación, división, operaciones combinadas
- **ALG** (3) — Álgebra: ecuaciones lineales, ecuaciones de ambos lados, valor absoluto
- **FUN** (1) — Funciones: relación lineal

### Narrativa — 4 arcos completos
- **Arco 1** (14 escenas): El encuentro con Sora, el primer Fragmento, la ciudad rota. Combates con Kurz.
- **Arco 2** (16 escenas): Mercado, Canales, los Fragmentos nombrados. Combate con Zafrán.
- **Arco 3** (18 escenas): Industria, Puerto, el duelo con Kai. Eco y la IA tutor.
- **Arco 4** (14 escenas): Afueras, la Montaña, el combate con Vorax, el cierre del viaje.

### Motor de juego
- Selector adaptativo de habilidades con pesos por nivel, decaimiento, distrito y anti-repetición
- Motor de maestría con 5 niveles por habilidad (precisión ponderada, tiempo mediano, decaimiento 21d/14d)
- Sistema de rangos narrativos (Aprendiz I→III, Iniciado) vinculados a esquirlas y progreso
- 6 distritos con atmósferas visuales diferenciadas (Tejados, Canales, Mercado, Industria, Puerto, Afueras)
- Puzzles con distractores curados a errores reales de niños

### Combates jugables
- **Kurz**: 3 combates calibrados (derrota → probable derrota → victoria)
- **Zafrán**: combate de MCM con preguntas de amplificación
- **Vorax**: combate de conversión impropio→mixto
- **Duelo Kai**: combate en Arco 3
- Fragmentos nombrados con voces, halos de color y personalidad propia

### Tutor IA v0.2
- Integración con Claude API (Anthropic) en servidor
- Filtro de seguridad en doble capa (cliente Dart + servidor PHP)
- Cache LRU con persistencia global y TTL de 30 días
- Cooldown de 10 minutos entre consultas
- Se ofrece tras un Fragmento que se escapa en el cazadero

### Extras
- **El Faro de Azula**: periódico semanal in-game con lore, 10 ediciones, acertijos
- **Capa sonora**: 4 capas (ambient, música, efectos, narrativos) con fades crossing y paquete descargable
- **Sistema de perfiles**: multi-niño en el mismo dispositivo
- **3 idiomas**: castellano, euskera, catalán desde el primer arranque
- **Modo entrenamiento**: práctica por dominio sin presión narrativa
- **Pista escalonada**: ayuda visual tras 2 fallos consecutivos
- **Micro-tutorial gestual**: la primera vez que se ve cada familia de puzzle

## Stack técnico

- **Cliente**: Flutter + Dart, CustomPainter, offline-first, shared_preferences
- **Backend**: WordPress plugin `nuevo-ser-core`, MySQL, REST API, JWT
- **IA tutor**: Claude API con cache LRU + filtros de seguridad
- **Idiomas**: `flutter_localizations` + `intl` (UI) y mapas runtime (narrativa)

## Requisitos

- Flutter ≥ 3.24
- Dart 3.5

## Cómo arrancar

```bash
cd apps/uno-roto
flutter pub get
flutter analyze
flutter test
flutter run -d linux        # escritorio
flutter build apk --release  # APK Android
```

> Nota: Flutter no está en PATH del sistema — exportar con `export PATH="$HOME/flutter/bin:$PATH"`.
> Build Android requiere Java 17.

## Licencia

Código: **AGPL-3.0**. Contenido: **CC-BY-SA 4.0**.
