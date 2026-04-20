# Uno Roto — Mapa de Habilidades Atómicas

> Documento pedagógico-técnico.
> Versión 0.1 — MVP Era 2 (9-12 años).
> Complementa la biblia del juego (documento 1).

---

## 1. Qué es este documento y para qué sirve

La **biblia** (documento 1) define cómo se siente Uno Roto. Este documento define **qué mide y qué enseña**.

Cada concepto matemático del currículum de 9-12 años se descompone aquí en **habilidades atómicas** — unidades pedagógicas suficientemente pequeñas como para medirse de forma fiable, suficientemente significativas como para tener sentido didáctico propio. El sistema de maestría del juego opera sobre estas habilidades: son las que suben y bajan, las que desbloquean rangos, las que el tutor IA trabaja cuando el niño se atasca.

En total, el MVP define **66 habilidades atómicas** organizadas en **8 dominios**. Cada una tiene un identificador único, criterios cuantificables de maestría, dependencias con otras habilidades, familia(s) de Fragmentos donde se ejercita y mapeo al currículum oficial (LOMLOE en el caso español).

El documento termina con un **apéndice JSON** que Claude Code puede consumir directamente para generar el modelo de datos del motor adaptativo.

## 2. Principios pedagógicos

### 2.1 Atomicidad real
Una habilidad atómica tiene **sentido por sí misma** y su dominio **no implica** el dominio automático de otra. "Sumar fracciones con mismo denominador" y "sumar fracciones con distinto denominador" son dos habilidades distintas.

### 2.2 Dependencias explícitas
Cada habilidad declara de qué **otras habilidades depende**. El sistema no presenta una habilidad al niño hasta que las dependencias estén al menos en nivel "Competente".

### 2.3 Maestría observable, no declarada
Se considera dominada cuando el niño **demuestra** el dominio reiteradamente. Medición por **precisión**, **velocidad relativa al propio niño**, **consistencia** y **retención**.

### 2.4 Comprensión por encima de ejecución
Las habilidades se miden siempre que sea posible en contextos que requieren **comprensión** y no solo cálculo mecánico. La Prueba de Espejo (biblia §6.3) está diseñada para distinguir estas dos cosas.

### 2.5 No linealidad controlada
Las habilidades forman un **grafo dirigido acíclico**, no una secuencia lineal. Hay múltiples caminos válidos.

## 3. Anatomía de una habilidad atómica

Cada habilidad declara: **id**, **nombre**, **dominio**, **descripción pedagógica**, **ejemplo**, **dependencias**, **familias_fragmento**, **distritos**, **rango_introducción**, **rango_exigido**, **criterios_maestría** (precisión, tiempo), **currículum_lomloe** y **notas_didácticas**.

## 4. Niveles de maestría

Cada habilidad tiene, para cada niño, un estado en uno de estos cinco niveles:

| Nivel | Nombre | Precisión | Velocidad | Consistencia |
|-------|--------|-----------|-----------|--------------|
| 0 | Inexplorada | N/A | N/A | N/A |
| 1 | Introducida | 0 — 0.50 | lenta | irregular |
| 2 | En desarrollo | 0.50 — 0.75 | variable | irregular |
| 3 | Competente | 0.75 — 0.90 | aceptable | 3+ sesiones |
| 4 | Maestría | ≥ 0.90 | fluida | 5+ sesiones + retención >2 semanas |

### 4.1 Decaimiento
- Maestría → Competente si no se practica en **21 días**.
- Competente → En desarrollo si pasan **14 días** sin ejercicio.
- Suelo: En desarrollo. No baja más.

### 4.2 Precisión ponderada
```
precisión = Σ (acierto_i · peso_dificultad_i) / Σ peso_dificultad_i
```
con `peso_dificultad_i ∈ [0.5, 2.0]`.

### 4.3 Velocidad
Tiempo mediano del niño para esa habilidad, comparado solo con su propio histórico y con el rango declarado por habilidad. **Nunca** con otros niños.

## 5. Los ocho dominios

1. **FR — Fracciones.** 22 habilidades. Corazón pedagógico del MVP.
2. **DEC — Decimales.** 9 habilidades.
3. **PROP — Proporcionalidad y porcentajes.** 7 habilidades.
4. **DIV — Divisibilidad y primos.** 7 habilidades.
5. **OP — Operaciones integradas.** 3 habilidades.
6. **MED — Medida.** 5 habilidades.
7. **GEO — Geometría.** 7 habilidades.
8. **EST — Estadística y probabilidad.** 6 habilidades.

**Total: 66 habilidades atómicas** (ajustado tras revisión del bestiario).

---

*(Secciones 6-13: fichas completas por habilidad; §14 mapeo a rangos; §15 mapeo LOMLOE; §16 modelo matemático de maestría; §17 tutor IA; Apéndice A JSON maestro; Apéndice B checklist de ejercicios. Contenido canónico adoptado sin cambios de la v0.1 proporcionada por el equipo de diseño.)*
