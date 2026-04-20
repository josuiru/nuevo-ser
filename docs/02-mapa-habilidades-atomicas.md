# Uno Roto — Mapa de Habilidades Atómicas

> Documento pedagógico-técnico.
> Versión 0.1 — MVP Era 2.
> Complemento obligatorio de `01-biblia-del-juego.md`.

---

## 0. Qué es este documento

Este es el **mapa de habilidades matemáticas** que el juego enseña, mide y certifica. Es el puente entre la biblia narrativa (que describe **qué pasa**) y el código del motor adaptativo (que decide **qué ejercicio darle al niño ahora mismo**).

Cada habilidad aquí descrita:

1. Es **atómica** — no se subdivide más. O la tienes o no la tienes.
2. Es **medible** — tiene criterios numéricos de dominio.
3. Está **conectada** — sabe qué otras habilidades son su prerrequisito y cuáles dependen de ella.
4. Está **encarnada** en el juego — uno o más tipos de Fragmento la entrenan.
5. Está **alineada con el currículum** escolar de 5º y 6º de primaria (España), con correspondencias generales aplicables a otros currículos hispanohablantes.

Sirve como:

- Especificación para el **motor adaptativo** (qué practicar, cuándo, cómo medir).
- Guía para el **dashboard de padres y maestros** (qué muestra, cómo lo explica).
- Criterio de **desbloqueo de rangos** (ver sección 18).
- Base para **evaluación pedagógica** rigurosa (comparar contra niños reales).

## 1. Principios de medición

### 1.1 Niveles de dominio

Cada habilidad de cada niño se mantiene en un valor continuo entre 0 y 1, clasificado en cuatro niveles:

- **Ausente** (0 – 0,25) — nunca o casi nunca se ha practicado con éxito.
- **Emergente** (0,25 – 0,6) — aciertos ocasionales, inconsistente, lento.
- **Consolidado** (0,6 – 0,85) — acierta la mayoría de las veces, velocidad razonable.
- **Dominado** (0,85 – 1) — acierta casi siempre, con fluidez, sin esfuerzo aparente.

Una habilidad se considera **dominada** cuando su valor supera 0,85 de forma **estable** durante al menos **3 sesiones distintas** separadas en el tiempo. No basta un día bueno.

### 1.2 Componentes del dominio

El valor de dominio se calcula combinando:

- **Precisión** (% de aciertos en los últimos N intentos, ponderado por dificultad).
- **Velocidad** (tiempo medio de respuesta comparado con la media del niño).
- **Consistencia** (estabilidad entre sesiones — no valen rachas aisladas).
- **Transferencia** (capacidad de aplicar en contexto nuevo, no solo en el contexto de entrenamiento).

La fórmula exacta se define en el documento de arquitectura técnica. Aquí basta saber que los cuatro componentes se pesan y combinan de forma continua.

### 1.3 Olvido

El valor de dominio **decae** con el tiempo si no se practica. Modelo inspirado en la curva de olvido de Ebbinghaus:

- Tras **7 días** sin práctica: pequeño decaimiento (−0,03 aprox).
- Tras **30 días** sin práctica: decaimiento notable (−0,1 aprox).
- Tras **90 días** sin práctica: decaimiento fuerte (−0,25 aprox).
- El decaimiento es **menor** cuanto mayor haya sido el dominio previo (memoria robusta).

Cuando una habilidad decae por debajo del umbral, el sistema propone una **sesión de refresco** la próxima vez que el niño juegue. No se le bajan los rangos — pero se le invita a repasar antes de avanzar.

### 1.4 Transferencia

Además de practicar cada habilidad en su contexto de Fragmento natural, el sistema introduce esa habilidad en **contextos inesperados** (misiones narrativas, puzles de distrito, pruebas de espejo). Solo se considera **dominada** si el niño la aplica correctamente también fuera del contexto de entrenamiento directo.

Esto es crítico pedagógicamente: evita que el niño aprenda "el truco del juego" sin aprender matemáticas reales.

## 2. Plantilla de cada habilidad

Cada habilidad en este documento sigue esta plantilla:

```
H-XXX · Nombre de la habilidad
───────────────────────────────
ID          : identificador técnico (usado en código)
Dominio     : rama matemática a la que pertenece
Currículum  : correspondencia con currículum escolar
Rango       : rango mínimo al que se introduce
Prerrequisitos : habilidades que deben estar al menos consolidadas antes
Descripción : qué sabe hacer exactamente un niño que la domina
Criterio de dominio : condiciones numéricas concretas
Fragmentos  : qué tipos de Fragmento la entrenan
Técnica asociada : técnica del juego que la encarna (si existe)
Ejemplo     : caso concreto
Errores típicos : errores más frecuentes del niño, útil para feedback
```

## 3. Dominios de habilidad del MVP

Las habilidades del MVP se organizan en nueve dominios:

- **F** — Fracciones (fundamentos).
- **E** — Equivalencia y simplificación.
- **O** — Operaciones con fracciones.
- **D** — Decimales.
- **C** — Conversión entre representaciones.
- **P** — Proporcionalidad y porcentajes.
- **M** — Medidas y geometría aplicada.
- **S** — Estadística y probabilidad básica.
- **N** — Sentido numérico y estimación (transversal).

Cada dominio contiene entre 4 y 10 habilidades atómicas. Total del MVP: **52 habilidades**.

---

## 4. Dominio F — Fracciones (fundamentos)

### H-F01 · Fracción como parte de un todo

```
ID          : H-F01
Dominio     : F
Currículum  : 5º primaria — introducción a fracciones
Rango       : Aprendiz I
Prerrequisitos : ninguna
Descripción : Reconoce que una fracción representa una parte de un todo dividido
              en partes iguales. Identifica visualmente fracciones representadas
              en figuras (círculos, rectángulos) y las escribe como a/b.
Criterio de dominio :
  - Precisión ≥ 85% en 20 intentos recientes.
  - Tiempo medio de respuesta ≤ 5 segundos.
  - Dominio ≥ 0,85 durante 3 sesiones separadas.
Fragmentos  : A1 (Pleno), A2 (Pleno Doble).
Técnica asociada : ninguna todavía — esto es la base.
Ejemplo     : Fragmento Pleno dividido en 4 partes, 1 iluminada. El niño toca
              la representación "1/4" entre varias opciones.
Errores típicos :
  - Confundir a/b con b/a.
  - No entender que las partes deben ser iguales.
```

### H-F02 · Numerador y denominador

```
ID          : H-F02
Dominio     : F
Currículum  : 5º primaria
Rango       : Aprendiz I
Prerrequisitos : H-F01.
Descripción : Distingue numerador (partes tomadas) y denominador (partes totales).
              Usa correctamente la terminología.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 4s, 3 sesiones.
Fragmentos  : B2–B12 en modo introducción (cuando se muestra la fracción expandida).
Técnica asociada : identificación en combate — antes de atacar, el niño ve a/b y decide.
Ejemplo     : Fragmento 3/7. Pregunta emergente: "¿Cuántas partes totales tiene?"
              Respuesta correcta: 7.
Errores típicos :
  - Invertir los roles.
```

### H-F03 · Fracciones unitarias hasta 1/5

```
ID          : H-F03
Dominio     : F
Currículum  : 5º primaria
Rango       : Aprendiz I
Prerrequisitos : H-F01, H-F02.
Descripción : Reconoce, dibuja y manipula fracciones unitarias (1/n) con n entre 2 y 5.
              Sabe que cuanto mayor es n, más pequeña es la fracción.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 4s, 3 sesiones, transferencia verificada.
Fragmentos  : B2, B3, B4, B5.
Técnica asociada : Cuchilla del Medio (cuando n=2).
Ejemplo     : Cortar un Fragmento Pleno en cinco partes exactas. El gesto del niño
              debe dividir la figura en quintos iguales.
Errores típicos :
  - Creer que 1/5 > 1/2 (confundir con números naturales).
```

### H-F04 · Fracciones unitarias hasta 1/12

```
ID          : H-F04
Dominio     : F
Currículum  : 5º primaria avanzado
Rango       : Aprendiz II
Prerrequisitos : H-F03.
Descripción : Extiende H-F03 a denominadores hasta 12. Incluye reconocimiento
              de denominadores "incómodos" (7, 11) sin que el niño sepa todavía
              que son primos.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 5s, 3 sesiones.
Fragmentos  : B6–B12.
Técnica asociada : técnicas de maestro (ver biblia §7.4).
Ejemplo     : Cortar Fragmento B7 en siete partes exactas. Visualmente exigente.
Errores típicos :
  - Imprecisión en cortes impares.
  - Confundir séptimos con octavos.
```

### H-F05 · Fracción como división

```
ID          : H-F05
Dominio     : F
Currículum  : 5º primaria
Rango       : Aprendiz II
Prerrequisitos : H-F02.
Descripción : Entiende que a/b equivale a a ÷ b y sabe usar esta equivalencia.
Criterio de dominio : precisión ≥ 85% en problemas de reparto.
Fragmentos  : Fragmentos con narrativa de reparto ("reparte 3 panes entre 4 personas").
Técnica asociada : no aún.
Ejemplo     : Sora dice "Reparte 3 trozos de pan entre 4 personas, ¿cuánto le toca
              a cada una?" Respuesta: 3/4.
Errores típicos :
  - Confundir dividendo y divisor.
  - No ver la fracción como resultado de una división.
```

### H-F06 · Fracción mayor, menor o igual a la unidad

```
ID          : H-F06
Dominio     : F
Currículum  : 5º primaria
Rango       : Aprendiz II
Prerrequisitos : H-F02.
Descripción : Clasifica una fracción como menor, igual o mayor que 1 comparando
              numerador y denominador.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 3s, 3 sesiones.
Fragmentos  : todos; pregunta emerge antes de atacar.
Técnica asociada : detección de Fragmentos Impropios (familia E).
Ejemplo     : Fragmento 7/4. ¿Mayor o menor que 1? Mayor.
Errores típicos :
  - Decidir por tamaño del numerador solo.
```

### H-F07 · Comparación con 1/2 como referencia

```
ID          : H-F07
Dominio     : F
Currículum  : 5º primaria
Rango       : Aprendiz II
Prerrequisitos : H-F03, H-F06.
Descripción : Decide rápidamente si una fracción es mayor, menor o igual a 1/2
              sin calcular explícitamente. Clave para estimación.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 2,5s, 3 sesiones.
Fragmentos  : todos; mecánica de "golpear solo si > 1/2" de los primeros minutos.
Técnica asociada : primera técnica enseñada por Sora.
Ejemplo     : 3/7 — ¿mayor que 1/2? (Como 3,5 sería la mitad de 7, y 3 < 3,5, es menor.)
Errores típicos :
  - Calcular explícitamente en vez de usar la heurística.
  - Fallar con fracciones cercanas a 1/2 (3/7, 5/9).
```

### H-F08 · Comparación de fracciones con mismo denominador

```
ID          : H-F08
Dominio     : F
Currículum  : 5º primaria
Rango       : Aprendiz III
Prerrequisitos : H-F02.
Descripción : Compara dos fracciones con igual denominador. La mayor es la de
              mayor numerador.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 3s.
Fragmentos  : Fragmentos pareados del mismo tipo (dos B5, dos B7, etc.).
Técnica asociada : no aún.
Ejemplo     : 3/8 vs 5/8 — mayor es 5/8.
Errores típicos :
  - Confundirlo con H-F09.
```

### H-F09 · Comparación de fracciones con mismo numerador

```
ID          : H-F09
Dominio     : F
Currículum  : 5º primaria
Rango       : Aprendiz III
Prerrequisitos : H-F03.
Descripción : Compara dos fracciones con igual numerador. La mayor es la de
              menor denominador.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 3s.
Fragmentos  : Fragmentos pareados con mismo numerador, distinto denominador.
Técnica asociada : no aún.
Ejemplo     : 3/5 vs 3/8 — mayor es 3/5.
Errores típicos :
  - Elegir la de mayor denominador (error por inercia con números naturales).
```

---

## 5. Dominio E — Equivalencia y simplificación

### H-E01 · Fracciones equivalentes por observación visual

```
ID          : H-E01
Dominio     : E
Currículum  : 5º primaria
Rango       : Aprendiz III
Prerrequisitos : H-F01, H-F02.
Descripción : Reconoce visualmente que 1/2 = 2/4 = 3/6 etc., viendo dos
              representaciones y juzgando si representan la misma cantidad.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 4s.
Fragmentos  : Familia D (Espejo).
Técnica asociada : Balanza Áurea (parcial).
Ejemplo     : Dos Fragmentos, uno 2/4 y otro 1/2 — el niño reconoce su equivalencia.
Errores típicos :
  - Confundir equivalencia con igualdad de partes (sí es igualdad de valor).
```

### H-E02 · Fracciones equivalentes por cálculo

```
ID          : H-E02
Dominio     : E
Currículum  : 5º primaria
Rango       : Aprendiz III
Prerrequisitos : H-E01.
Descripción : Genera fracciones equivalentes multiplicando o dividiendo numerador
              y denominador por el mismo número.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 6s.
Fragmentos  : Familia D combinada con ejercicios explícitos.
Técnica asociada : Balanza Áurea.
Ejemplo     : ¿Es 3/4 equivalente a 9/12? Sí (×3 arriba y abajo).
Errores típicos :
  - Multiplicar solo el numerador.
  - Sumar en vez de multiplicar.
```

### H-E03 · Simplificación de fracciones

```
ID          : H-E03
Dominio     : E
Currículum  : 6º primaria
Rango       : Iniciado I
Prerrequisitos : H-E02, H-N03 (factores comunes).
Descripción : Simplifica una fracción dividiendo numerador y denominador por un
              factor común (no necesariamente el máximo). Reconoce una fracción
              irreducible.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 8s.
Fragmentos  : Familia D avanzada, preparando familias F y G.
Técnica asociada : Balanza Áurea.
Ejemplo     : Simplificar 6/8 → 3/4.
Errores típicos :
  - No reconocer cuándo está ya simplificada.
  - Dividir solo el numerador.
```

### H-E04 · Fracción irreducible

```
ID          : H-E04
Dominio     : E
Currículum  : 6º primaria
Rango       : Iniciado I
Prerrequisitos : H-E03.
Descripción : Identifica si una fracción está en su forma irreducible. Relacionado
              con el concepto de MCD.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 5s.
Fragmentos  : Familia D tipo "jefe".
Técnica asociada : no aún.
Ejemplo     : ¿Es 7/11 irreducible? Sí.
Errores típicos :
  - Detener la simplificación antes de tiempo.
```

### H-E05 · Convertir a denominador común

```
ID          : H-E05
Dominio     : E
Currículum  : 6º primaria
Rango       : Iniciado I
Prerrequisitos : H-E02, H-N04 (múltiplos comunes).
Descripción : Dados dos denominadores, encuentra un denominador común y transforma
              ambas fracciones a esa representación. No necesariamente el mcm; cualquier
              común vale al principio.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 10s.
Fragmentos  : Familia F (Duales) fase previa a fusión.
Técnica asociada : Puente de Denominadores.
Ejemplo     : 1/3 y 1/4 → 4/12 y 3/12.
Errores típicos :
  - Multiplicar solo un numerador.
  - Usar suma de denominadores en vez de producto o mcm.
```

---

## 6. Dominio O — Operaciones con fracciones

### H-O01 · Suma de fracciones con mismo denominador

```
ID          : H-O01
Dominio     : O
Currículum  : 5º primaria avanzado
Rango       : Aprendiz III
Prerrequisitos : H-F02, H-F08.
Descripción : Suma fracciones con mismo denominador conservando el denominador
              y sumando numeradores.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 6s.
Fragmentos  : Fragmentos C (compuestos), dos B del mismo tipo.
Técnica asociada : combos en ataque.
Ejemplo     : 2/7 + 3/7 = 5/7.
Errores típicos :
  - Sumar también denominadores (error clásico).
```

### H-O02 · Resta de fracciones con mismo denominador

```
ID          : H-O02
Dominio     : O
Currículum  : 5º primaria avanzado
Rango       : Aprendiz III
Prerrequisitos : H-O01.
Descripción : Resta fracciones con mismo denominador.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 6s.
Fragmentos  : Fragmentos con narrativa de sustracción (otro Fraccionista se lleva parte).
Técnica asociada : defensa.
Ejemplo     : 5/8 − 2/8 = 3/8.
Errores típicos :
  - Restar denominadores.
```

### H-O03 · Suma de fracciones con distinto denominador

```
ID          : H-O03
Dominio     : O
Currículum  : 6º primaria
Rango       : Iniciado I
Prerrequisitos : H-O01, H-E05.
Descripción : Suma fracciones con distintos denominadores llevándolas primero a
              un denominador común.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 15s.
Fragmentos  : Familia F (Duales) — núcleo de su mecánica.
Técnica asociada : Puente de Denominadores.
Ejemplo     : 1/3 + 1/4 = 4/12 + 3/12 = 7/12.
Errores típicos :
  - Sumar numeradores y denominadores directamente (error crítico).
  - Olvidar simplificar.
```

### H-O04 · Resta de fracciones con distinto denominador

```
ID          : H-O04
Dominio     : O
Currículum  : 6º primaria
Rango       : Iniciado I
Prerrequisitos : H-O03.
Descripción : Resta fracciones con distintos denominadores.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 15s.
Fragmentos  : Familia F con variante resta.
Técnica asociada : Puente de Denominadores.
Ejemplo     : 3/4 − 1/3 = 9/12 − 4/12 = 5/12.
Errores típicos :
  - Restar numeradores sin unificar denominadores.
```

### H-O05 · Multiplicación de fracción por número natural

```
ID          : H-O05
Dominio     : O
Currículum  : 6º primaria
Rango       : Iniciado I
Prerrequisitos : H-F02, H-O01.
Descripción : Multiplica una fracción por un número natural.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 8s.
Fragmentos  : Fragmentos que aparecen en grupo (3 × 1/4).
Técnica asociada : combos multiplicativos.
Ejemplo     : 3 × 1/4 = 3/4.
Errores típicos :
  - Multiplicar también el denominador.
```

### H-O06 · Multiplicación de fracciones

```
ID          : H-O06
Dominio     : O
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-O05.
Descripción : Multiplica fracciones entre sí multiplicando numerador con numerador
              y denominador con denominador.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 10s.
Fragmentos  : Combates del Puerto.
Técnica asociada : técnica del Maestro del Puerto.
Ejemplo     : 2/3 × 3/5 = 6/15 = 2/5.
Errores típicos :
  - Hallar denominador común (no hace falta para multiplicar).
  - Olvidar simplificar resultado.
```

### H-O07 · Inversa de una fracción

```
ID          : H-O07
Dominio     : O
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-F02.
Descripción : Calcula la inversa (recíproca) de una fracción intercambiando
              numerador y denominador.
Criterio de dominio : precisión ≥ 95%, velocidad ≤ 3s.
Fragmentos  : familia especial "Espejo Invertido" en el Puerto.
Técnica asociada : prerequisito de la técnica del Puerto.
Ejemplo     : inversa de 3/5 = 5/3.
Errores típicos :
  - Cambiar el signo en vez de invertir.
```

### H-O08 · División de fracciones

```
ID          : H-O08
Dominio     : O
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-O06, H-O07.
Descripción : Divide fracciones multiplicando por la inversa de la segunda.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 12s.
Fragmentos  : Puerto avanzado.
Técnica asociada : técnica del Maestro del Puerto.
Ejemplo     : 2/3 ÷ 3/4 = 2/3 × 4/3 = 8/9.
Errores típicos :
  - Invertir la primera en vez de la segunda.
  - Dividir numerador con numerador y denominador con denominador.
```

### H-O09 · Conversión entre fracción impropia y mixta

```
ID          : H-O09
Dominio     : O
Currículum  : 6º primaria
Rango       : Iniciado I
Prerrequisitos : H-F05, H-F06.
Descripción : Convierte 7/4 en 1 + 3/4 y viceversa.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 8s.
Fragmentos  : Familia E.
Técnica asociada : mecánica de estabilización de Fragmentos Impropios.
Ejemplo     : 11/3 = 3 y 2/3.
Errores típicos :
  - Confundir cociente con resto.
```

---

## 7. Dominio D — Decimales

### H-D01 · Lectura y escritura de decimales hasta centésimas

```
ID          : H-D01
Dominio     : D
Currículum  : 5º primaria
Rango       : Iniciado I
Prerrequisitos : H-F01.
Descripción : Lee y escribe números decimales hasta las centésimas.
              Identifica partes entera y decimal.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 4s.
Fragmentos  : familia G.
Técnica asociada : no aún.
Ejemplo     : Escribir "tres y veinticinco centésimas" → 3,25.
Errores típicos :
  - Confusión con la coma / punto decimal.
```

### H-D02 · Decimales hasta milésimas

```
ID          : H-D02
Dominio     : D
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-D01.
Descripción : Extiende H-D01 a milésimas.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 5s.
Fragmentos  : familia G avanzada.
Técnica asociada : técnica del Maestro de la Industria.
Ejemplo     : 0,725 — setecientas veinticinco milésimas.
Errores típicos :
  - Confundir posiciones tras la coma.
```

### H-D03 · Comparación de decimales

```
ID          : H-D03
Dominio     : D
Currículum  : 5º–6º primaria
Rango       : Iniciado I
Prerrequisitos : H-D01.
Descripción : Compara dos decimales usando la lectura posicional.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 5s.
Fragmentos  : familia G pareada.
Técnica asociada : no aún.
Ejemplo     : 0,25 vs 0,3 — mayor es 0,3 (porque 0,30 > 0,25).
Errores típicos :
  - Comparar por cantidad de cifras.
```

### H-D04 · Suma y resta de decimales

```
ID          : H-D04
Dominio     : D
Currículum  : 5º–6º primaria
Rango       : Iniciado II
Prerrequisitos : H-D01.
Descripción : Suma y resta decimales alineando por la coma.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 10s.
Fragmentos  : familia G, combates de Industria.
Técnica asociada : Escala Rota (componente).
Ejemplo     : 3,25 + 0,7 = 3,95.
Errores típicos :
  - No alinear por coma.
```

### H-D05 · Multiplicación de decimales

```
ID          : H-D05
Dominio     : D
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-D04.
Descripción : Multiplica decimales y coloca correctamente la coma en el resultado.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 15s.
Fragmentos  : combates de Industria avanzados.
Técnica asociada : Escala Rota.
Ejemplo     : 0,3 × 0,4 = 0,12.
Errores típicos :
  - Colocar mal la coma (confundir número de decimales).
```

### H-D06 · División de decimales entre naturales

```
ID          : H-D06
Dominio     : D
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-D04.
Descripción : Divide un decimal entre un número natural.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 15s.
Fragmentos  : Industria.
Técnica asociada : Escala Rota.
Ejemplo     : 4,5 ÷ 3 = 1,5.
Errores típicos :
  - Perder la coma en el cociente.
```

---

## 8. Dominio C — Conversión entre representaciones

### H-C01 · Fracción decimal ↔ decimal

```
ID          : H-C01
Dominio     : C
Currículum  : 5º primaria
Rango       : Iniciado I
Prerrequisitos : H-F02, H-D01.
Descripción : Convierte fracciones decimales (denominador 10, 100, 1000) en decimales
              y viceversa.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 5s.
Fragmentos  : familia G en transición con B.
Técnica asociada : Escala Rota inicial.
Ejemplo     : 25/100 = 0,25.
Errores típicos :
  - Posicionar mal la coma.
```

### H-C02 · Fracción cualquiera → decimal

```
ID          : H-C02
Dominio     : C
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-C01, H-F05.
Descripción : Convierte cualquier fracción en su representación decimal (exacta o periódica
              básica).
Criterio de dominio : precisión ≥ 80%, velocidad ≤ 20s.
Fragmentos  : puentes entre distritos.
Técnica asociada : técnica del Maestro de Industria avanzada.
Ejemplo     : 3/4 = 0,75 ; 1/3 = 0,333…
Errores típicos :
  - Pánico ante decimales periódicos.
```

### H-C03 · Fracción ↔ porcentaje

```
ID          : H-C03
Dominio     : C
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-C01.
Descripción : Convierte entre fracción y porcentaje en casos estándar (1/2=50%,
              1/4=25%, 1/5=20%, 3/4=75%, etc.).
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 5s.
Fragmentos  : familia H (Porcentuales), en el Mercado.
Técnica asociada : Balanza Áurea.
Ejemplo     : 3/5 = 60%.
Errores típicos :
  - Olvidar el %.
```

### H-C04 · Decimal ↔ porcentaje

```
ID          : H-C04
Dominio     : C
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-D01.
Descripción : Convierte entre decimal y porcentaje (0,25 = 25%).
Criterio de dominio : precisión ≥ 95%, velocidad ≤ 3s.
Fragmentos  : familia H.
Técnica asociada : Balanza Áurea.
Ejemplo     : 0,6 = 60%.
Errores típicos :
  - Multiplicar por 10 en vez de 100.
```

---

## 9. Dominio P — Proporcionalidad y porcentajes

### H-P01 · Concepto de razón

```
ID          : H-P01
Dominio     : P
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-F05.
Descripción : Entiende una razón como comparación multiplicativa entre dos cantidades.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 8s.
Fragmentos  : familia I (Proporcionales), en el Mercado.
Técnica asociada : técnica del Maestro del Mercado.
Ejemplo     : "Por cada 3 manzanas hay 5 peras — razón manzanas:peras = 3:5".
Errores típicos :
  - Confundir razón con diferencia.
```

### H-P02 · Magnitudes directamente proporcionales

```
ID          : H-P02
Dominio     : P
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-P01, H-O05.
Descripción : Reconoce cuándo dos magnitudes varían en proporción directa (al multiplicar
              una por k, la otra también). Completa tablas de proporcionalidad directa.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 10s.
Fragmentos  : familia I — Fragmentos proporcionales que aparecen a escala 2/3 → 4/6 → 6/9.
Técnica asociada : técnica del Maestro del Mercado (versión inicial).
Ejemplo     : Si 3 kg de manzanas cuestan 6 €, ¿cuánto cuestan 6 kg? Respuesta: 12 €.
Errores típicos :
  - Sumar en vez de multiplicar (error de razonamiento aditivo).
  - Confundir proporción directa con inversa.
```

### H-P03 · Regla de tres simple directa

```
ID          : H-P03
Dominio     : P
Currículum  : 6º primaria
Rango       : Iniciado III
Prerrequisitos : H-P02, H-O06.
Descripción : Aplica la regla de tres simple directa para hallar un cuarto valor
              en una proporción directa.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 20s, con transferencia a contextos
              narrativos (misiones del Mercado).
Fragmentos  : familia I en su forma "pide cuarto valor".
Técnica asociada : técnica del Maestro del Mercado (completa).
Ejemplo     : Si 4 fraccionistas recogen 12 Fragmentos en una hora, ¿cuántos recogerán
              7 fraccionistas en una hora? Respuesta: 21.
Errores típicos :
  - Colocar mal los valores en la cruz.
  - Confundir con inversa y dividir donde debería multiplicar.
```

### H-P04 · Porcentaje de una cantidad

```
ID          : H-P04
Dominio     : P
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-C04, H-O05.
Descripción : Calcula el X% de una cantidad. Domina los porcentajes "amables" de
              memoria (10%, 25%, 50%, 75%) y el general por cálculo.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 8s para amables, ≤ 15s en general.
Fragmentos  : familia H en el Mercado.
Técnica asociada : Balanza Áurea avanzada.
Ejemplo     : 25% de 80 = 20. 15% de 60 = 9.
Errores típicos :
  - Dividir por el porcentaje en vez de aplicar la proporción.
  - Olvidar convertir el porcentaje a decimal antes de multiplicar.
```

### H-P05 · Aumentos y descuentos porcentuales

```
ID          : H-P05
Dominio     : P
Currículum  : 6º primaria avanzado
Rango       : Iniciado III
Prerrequisitos : H-P04.
Descripción : Aplica un aumento del X% (×(1 + X/100)) y un descuento del X%
              (×(1 − X/100)) a una cantidad.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 15s.
Fragmentos  : familia H en contexto de "intercambio" del Mercado.
Técnica asociada : Balanza Áurea avanzada.
Ejemplo     : Un Fragmento vale 40 créditos. Con un 20% de descuento, vale 32.
Errores típicos :
  - Restar el X en vez del X% (restar 20 en lugar de 8).
  - Aplicar el descuento dos veces.
```

### H-P06 · Magnitudes inversamente proporcionales y regla de tres inversa

```
ID          : H-P06
Dominio     : P
Currículum  : 6º primaria avanzado
Rango       : Fraccionista
Prerrequisitos : H-P03.
Descripción : Reconoce proporción inversa (al multiplicar una magnitud por k, la otra
              se divide por k) y aplica la regla de tres inversa.
Criterio de dominio : precisión ≥ 80%, velocidad ≤ 25s, con transferencia verificada.
Fragmentos  : familia I variante "inversa" (aparece en Afueras y Mercado).
Técnica asociada : técnica del Maestro del Mercado en modo inverso.
Ejemplo     : Si 4 fraccionistas tardan 6 horas en limpiar un distrito, ¿cuánto tardan 8?
              Respuesta: 3 horas (inverso).
Errores típicos :
  - Aplicar regla directa por inercia.
  - Dividir en el paso equivocado.
```

### H-P07 · Escala (mapas y planos)

```
ID          : H-P07
Dominio     : P
Currículum  : 6º primaria
Rango       : Iniciado III
Prerrequisitos : H-P03.
Descripción : Interpreta y aplica escalas en representaciones (1:100, 1:50000) para
              pasar entre distancia real y distancia en el mapa.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 20s.
Fragmentos  : mini-juego del mapa del distrito (Industria, Afueras).
Técnica asociada : no específica, uso cruzado.
Ejemplo     : En un mapa a escala 1:100, 5 cm representan 500 cm = 5 m reales.
Errores típicos :
  - Confundir las dos direcciones de la conversión.
  - No cambiar de unidades al final.
```

---

## 10. Dominio M — Medidas y geometría aplicada

### H-M01 · Conversión de unidades de longitud

```
ID          : H-M01
Dominio     : M
Currículum  : 5º–6º primaria
Rango       : Iniciado I
Prerrequisitos : H-D01, H-D03.
Descripción : Convierte entre km, m, cm y mm multiplicando o dividiendo por potencias de 10.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 8s.
Fragmentos  : familia G en contexto Industria (medidas "reales" del mundo).
Técnica asociada : Escala Rota (componente).
Ejemplo     : 3,5 m = 350 cm = 3500 mm.
Errores típicos :
  - Multiplicar cuando toca dividir (y viceversa).
  - Perder la coma en la conversión.
```

### H-M02 · Conversión de unidades de masa y capacidad

```
ID          : H-M02
Dominio     : M
Currículum  : 5º–6º primaria
Rango       : Iniciado I
Prerrequisitos : H-M01.
Descripción : Convierte entre kg, g y mg, y entre l, cl y ml. Comparte estructura
              decimal con H-M01; se introduce tras dominarla.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 8s.
Fragmentos  : puestos del Mercado, tuberías de la Industria.
Técnica asociada : Escala Rota.
Ejemplo     : 2,5 l = 250 cl = 2500 ml.
Errores típicos :
  - Transferir mal la tabla de longitud a masa/capacidad (el esqueleto es el mismo).
```

### H-M03 · Operaciones con unidades de tiempo

```
ID          : H-M03
Dominio     : M
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-O01, H-N02.
Descripción : Suma y resta horas, minutos y segundos reconociendo la base 60 (no decimal).
              Convierte entre horas, minutos y segundos.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 15s.
Fragmentos  : mecánica del cronómetro en combates, jefe Vorax (biblia §5.2 J).
Técnica asociada : Cronómetro Estable (técnica ambiental, no de un maestro).
Ejemplo     : 2 h 45 min + 1 h 30 min = 4 h 15 min (no 3 h 75 min).
Errores típicos :
  - Operar en base 10 (sumar 45 + 30 = 75 y dejarlo así).
  - Olvidar llevarse una hora al pasar de 60 minutos.
```

### H-M04 · Perímetro de polígonos

```
ID          : H-M04
Dominio     : M
Currículum  : 5º–6º primaria
Rango       : Iniciado I
Prerrequisitos : H-D04.
Descripción : Calcula el perímetro sumando los lados de polígonos regulares e irregulares.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 10s.
Fragmentos  : mini-puzles del distrito Industrial (delimitar zonas).
Técnica asociada : no específica.
Ejemplo     : Rectángulo de 3 cm × 5 cm → perímetro = 2·3 + 2·5 = 16 cm.
Errores típicos :
  - Sumar solo dos lados en el rectángulo.
  - Confundir perímetro con área.
```

### H-M05 · Área de figuras básicas

```
ID          : H-M05
Dominio     : M
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-M04, H-D05.
Descripción : Calcula el área de cuadrados y rectángulos (base × altura) y de
              triángulos (base × altura / 2).
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 12s.
Fragmentos  : puzles geométricos del distrito Industrial.
Técnica asociada : técnica del Maestro de Industria (componente geométrico).
Ejemplo     : Triángulo de base 6 cm y altura 4 cm → área = 6·4/2 = 12 cm².
Errores típicos :
  - Olvidar dividir por 2 en el triángulo.
  - Confundir unidades (cm vs cm²).
```

---

## 11. Dominio S — Estadística y probabilidad básica

### H-S01 · Lectura de tablas y gráficos de barras

```
ID          : H-S01
Dominio     : S
Currículum  : 5º–6º primaria
Rango       : Iniciado I
Prerrequisitos : ninguna.
Descripción : Extrae información de tablas y gráficos de barras: lee valores, compara
              categorías, identifica máximo y mínimo.
Criterio de dominio : precisión ≥ 90%, velocidad ≤ 6s.
Fragmentos  : panel de datos del distrito de Afueras (biblia §3.3).
Técnica asociada : no específica.
Ejemplo     : Gráfico de Fragmentos cazados por semana — identifica la semana récord.
Errores típicos :
  - Leer en la escala equivocada.
```

### H-S02 · Lectura de gráficos circulares como fracciones

```
ID          : H-S02
Dominio     : S
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-F01, H-C03.
Descripción : Interpreta sectores de un gráfico circular como fracciones o porcentajes del
              total. Estima a ojo (un sector que ocupa un cuarto = 25%).
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 8s.
Fragmentos  : panel de datos del distrito de Afueras; Fragmentos espejo visualizados como
              sectores.
Técnica asociada : Balanza Áurea (por la equivalencia visual).
Ejemplo     : Un sector que ocupa justo la mitad → 1/2 → 50%.
Errores típicos :
  - Confundir un sector grande con un valor pequeño.
```

### H-S03 · Media aritmética

```
ID          : H-S03
Dominio     : S
Currículum  : 6º primaria
Rango       : Iniciado II
Prerrequisitos : H-O05, H-D06.
Descripción : Calcula la media aritmética sumando valores y dividiendo entre su cantidad.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 15s.
Fragmentos  : misiones del distrito de Afueras.
Técnica asociada : no específica.
Ejemplo     : Fragmentos cazados en 5 días: 3, 4, 2, 5, 6 → media = 20/5 = 4.
Errores típicos :
  - Dividir entre la suma de los valores en lugar de entre la cantidad.
  - Olvidar incluir un dato.
```

### H-S04 · Probabilidad elemental

```
ID          : H-S04
Dominio     : S
Currículum  : 6º primaria
Rango       : Iniciado III
Prerrequisitos : H-F01, H-C03.
Descripción : Calcula la probabilidad de un suceso como cociente entre casos favorables y
              casos posibles. Expresa el resultado como fracción, decimal o porcentaje.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 15s.
Fragmentos  : misiones del distrito de Afueras con dados, bolsas y giros.
Técnica asociada : ligada a la Balanza Áurea para expresar como %.
Ejemplo     : Probabilidad de sacar un número par en un dado estándar = 3/6 = 1/2 = 50%.
Errores típicos :
  - Contar mal casos favorables o totales.
  - No simplificar.
```

---

## 12. Dominio N — Sentido numérico y estimación (transversal)

Habilidades que atraviesan todos los dominios. No se enseñan aisladamente sino que se entrenan como parte de otras misiones.

### H-N01 · Cálculo mental ágil (sumas y restas hasta 100)

```
ID          : H-N01
Dominio     : N
Currículum  : 4º–5º primaria (repaso).
Rango       : Aprendiz I (prerequisito de entrada).
Prerrequisitos : ninguna (se da por asumida al inicio y se afina).
Descripción : Suma y resta mentalmente con números hasta 100, con descomposición y compensación.
Criterio de dominio : precisión ≥ 95%, velocidad ≤ 3s.
Fragmentos  : todos — es base del combate.
Técnica asociada : tempo del combate.
Ejemplo     : 47 + 28 mentalmente (como 47 + 30 − 2 = 75).
Errores típicos :
  - Calcular por algoritmo escrito mental (lento).
```

### H-N02 · Tablas de multiplicar hasta 12

```
ID          : H-N02
Dominio     : N
Currículum  : 3º–4º primaria (repaso).
Rango       : Aprendiz I (prerequisito de entrada).
Prerrequisitos : ninguna.
Descripción : Recupera los productos de tablas del 1 al 12 con fluidez.
Criterio de dominio : precisión ≥ 95%, velocidad ≤ 2s.
Fragmentos  : todos los que implican multiplicación; indispensable para H-E02, H-O06.
Técnica asociada : todas las de cálculo rápido.
Ejemplo     : 7 × 8 = 56, 9 × 12 = 108.
Errores típicos :
  - Lagunas en tablas del 7, 8 y 12 (las más olvidadas).
```

### H-N03 · Factores y divisores comunes

```
ID          : H-N03
Dominio     : N
Currículum  : 6º primaria
Rango       : Aprendiz III
Prerrequisitos : H-N02.
Descripción : Encuentra factores de un número y divisores comunes de dos números.
              No exige máximo común divisor todavía — basta con cualquiera.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 10s.
Fragmentos  : Familia D en fase de simplificación; prerequisito de H-E03.
Técnica asociada : Balanza Áurea.
Ejemplo     : Divisores comunes de 12 y 18: 1, 2, 3, 6.
Errores típicos :
  - Listar solo los primeros divisores y no llegar al común.
```

### H-N04 · Múltiplos y mínimo común múltiplo

```
ID          : H-N04
Dominio     : N
Currículum  : 6º primaria
Rango       : Iniciado I
Prerrequisitos : H-N02.
Descripción : Lista múltiplos de un número y encuentra el mcm de dos números pequeños
              (denominadores ≤ 12). Entiende por qué el mcm sirve como denominador común.
Criterio de dominio : precisión ≥ 85%, velocidad ≤ 12s.
Fragmentos  : Familia F (Duales); prerequisito de H-E05 y H-O03.
Técnica asociada : Puente de Denominadores.
Ejemplo     : mcm(4, 6) = 12.
Errores típicos :
  - Usar el producto (4·6 = 24) en lugar del mcm (12) — funciona pero es ineficiente.
  - Usar la suma por confusión.
```

---

## 13. Grafo de prerrequisitos (resumen)

Capas de aprendizaje, de base a punta. Cada habilidad depende de las de capas inferiores.

```
Capa 0 (entrada asumida):
    H-N01 · H-N02

Capa 1 (fundamentos):
    H-F01 → H-F02, H-F05, H-F06
    H-F02 → H-F03, H-F08

Capa 2 (fracciones básicas):
    H-F03 → H-F04, H-F07, H-F09
    H-F06 → H-F07, H-O09
    H-F08 → H-O01
    H-F09 (comparación)

Capa 3 (operaciones y equivalencias iniciales):
    H-O01 → H-O02, H-O05
    H-E01 → H-E02
    H-N03 → H-E03
    H-N04 → H-E05, H-O03

Capa 4 (operaciones avanzadas):
    H-E02 → H-E03 → H-E04, H-E05
    H-E05 → H-O03 → H-O04
    H-O05 → H-O06 → H-O08
    H-O07 → H-O08
    H-O09 (impropia/mixta)

Capa 5 (decimales y conversión):
    H-F01 → H-D01 → H-D02, H-D03, H-D04 → H-D05, H-D06
    H-D01 → H-C01 → H-C02, H-C03, H-C04
    H-C01 → H-M01 → H-M02

Capa 6 (proporcionalidad y aplicación):
    H-P01 → H-P02 → H-P03 → H-P05, H-P07
    H-P03 → H-P06
    H-P04 (desde H-C04)
    H-M04 → H-M05
    H-M03 (tiempo)

Capa 7 (estadística y probabilidad):
    H-S01 → H-S03
    H-S02 (desde H-F01, H-C03)
    H-S04 (desde H-F01, H-C03)
```

El motor adaptativo (ver documento 03) usa este grafo para elegir qué habilidad introducir a continuación: solo abre las que tienen todos sus prerrequisitos al menos **consolidados** (≥ 0,6).

---

## 14. Correspondencia con currículo oficial

Resumen de encaje con el **currículo LOMLOE** de matemáticas de 5º y 6º de primaria (España). Correspondencias análogas se elaborarán por separado para Heziberri (País Vasco), competències bàsiques (Cataluña) y otros currículos hispanohablantes en v1.5.

| Bloque curricular | Habilidades cubiertas |
|-------------------|----------------------|
| Sentido numérico — naturales | H-N01, H-N02, H-N03, H-N04 |
| Sentido numérico — fracciones | H-F01–H-F09, H-E01–H-E05, H-O01–H-O09 |
| Sentido numérico — decimales | H-D01–H-D06 |
| Sentido numérico — porcentaje | H-C03, H-C04, H-P04, H-P05 |
| Sentido de la medida | H-M01, H-M02, H-M03, H-M04, H-M05 |
| Sentido espacial | H-M04, H-M05, H-P07 |
| Razonamiento proporcional | H-P01–H-P07 |
| Sentido estocástico | H-S01, H-S02, H-S03, H-S04 |
| Conexiones y representaciones | H-C01–H-C04 (transversal) |

El mapa cubre ≥ 90% del bloque de sentido numérico y razonamiento proporcional de 5º–6º. Geometría y medida quedan parcialmente cubiertas en el MVP — ampliación prevista en v1.5 con volumen, circunferencia y ángulos.

---

## 15. Índice inverso — Fragmento → habilidades

Para diseñar contenido del juego es útil saber qué habilidades entrena cada familia.

| Familia Fragmento | Habilidades entrenadas |
|-------------------|-----------------------|
| A — Enteros | H-F01, H-N01, H-N02 |
| B — Unitarios | H-F02, H-F03, H-F04, H-F07, H-F09, H-N02 |
| C — Compuestos | H-F08, H-O01, H-O02 |
| D — Espejo | H-E01, H-E02, H-E03, H-E04, H-N03 |
| E — Impropios | H-F06, H-O09, H-F05 |
| F — Duales | H-E05, H-O03, H-O04, H-N04 |
| G — Decimales | H-D01–H-D06, H-C01, H-C02, H-M01, H-M02 |
| H — Porcentuales | H-C03, H-C04, H-P04, H-P05 |
| I — Proporcionales | H-P01, H-P02, H-P03, H-P06, H-P07 |
| J — Jefes nombrados | Integración — múltiples habilidades en combinación |

Y al revés, qué técnicas (biblia §7.4) encarnan qué habilidades:

| Técnica | Habilidades encarnadas |
|---------|------------------------|
| Cuchilla del Medio | H-F03 (caso n=2), H-F07 |
| Puente de Denominadores | H-E05, H-N04, H-O03, H-O04 |
| Balanza Áurea | H-E01, H-E02, H-E03, H-C03, H-C04, H-S02 |
| Escala Rota | H-C01, H-D04, H-D05, H-M01, H-M02 |
| Técnica del Maestro del Puerto | H-O06, H-O07, H-O08 |
| Técnica del Maestro del Mercado | H-P01, H-P02, H-P03, H-P06 |
| Técnica del Maestro de la Industria | H-D02, H-M05 |

---

## 16. Directrices para el motor adaptativo

Criterios que el motor usa para decidir **qué habilidad tocar** en cada combate (especificación viva; la implementación concreta está en `03-arquitectura-tecnica.md` §6):

1. **No ofrecer una habilidad cuyos prerrequisitos no estén consolidados** (≥ 0,6). La frustración de chocarse con algo imposible rompe el principio biblia §2.3.
2. **Priorizar habilidades en zona de desarrollo próximo**: dominio entre 0,3 y 0,8. Ahí es donde se aprende.
3. **Intercalar refresco**: habilidades que hayan decaído por debajo del umbral reciben cupo garantizado antes de introducir nuevas.
4. **Evitar fatiga por repetición**: no repetir la misma habilidad más de 3 combates seguidos salvo que el niño esté claramente atascado y respondiendo.
5. **Transferir a contextos narrativos**: cada cierto tiempo, sacar la habilidad de su distrito habitual y meterla en una misión de otro distrito para verificar transferencia.
6. **Respetar el ritmo del niño**: si los tiempos de respuesta se disparan, reducir la dificultad o proponer cerrar sesión (biblia §8.1).

## 17. Integración con el dashboard

Qué información de este mapa se muestra a padres, maestros y al propio niño.

**Para el niño (dentro del juego)**:
- Un "mapa de constelación" visual donde cada habilidad es una estrella. Las estrellas se encienden a medida que el dominio sube. Estética coherente con biblia §3.2 (neón, lo-fi).
- **Nunca números crudos**. Nunca "has fallado el 40% de H-O03". Lenguaje narrativo: "Aún no domino la fusión de fracciones con denominadores distintos".
- Siempre **hacia adelante**: qué ha crecido, qué se está trabajando.

**Para padres**:
- Resumen semanal: rangos alcanzados, habilidades consolidadas, habilidades en curso.
- Identificación honesta de atascos con sugerencias de conversación o apoyo fuera del juego (biblia §15.2).
- Comparativa **consigo mismo**, nunca con otros niños.

**Para maestros (licencia institucional)**:
- Vista agregada por clase: distribución de dominio por habilidad.
- Detección de huecos transversales ("el 70% de la clase tiene H-O03 por debajo de 0,4 — merece ejercitarlo en clase").
- Sugerencias de ejercicios presenciales alineados con lo que la clase está viviendo.

---

## 18. Desbloqueo de rangos

Criterio **numérico** para pasar de un rango al siguiente. Se aplica el siguiente principio general: un rango se desbloquea cuando el niño ha **dominado** (≥ 0,85 estable) todas las habilidades de su lista **obligatoria**, y tiene al menos **consolidadas** (≥ 0,6) las de la lista de **acompañamiento**. Margen de tolerancia: se permite que hasta 2 habilidades obligatorias estén en ≥ 0,7 (en vez de 0,85) si el resto está sólido.

| Rango objetivo | Habilidades obligatorias para ascender | Habilidades de acompañamiento |
|----------------|----------------------------------------|-------------------------------|
| **Aprendiz II** | H-F01, H-F02, H-F03, H-N01, H-N02 | H-F05, H-F06 |
| **Aprendiz III** | H-F04, H-F05, H-F06, H-F07 | H-F08, H-F09, H-N03 |
| **Iniciado I** | H-F08, H-F09, H-O01, H-O02, H-E01, H-E02, H-N03 | H-E03, H-O09, H-N04 |
| **Iniciado II** | H-E03, H-E04, H-E05, H-O03, H-O04, H-O05, H-O09, H-N04, H-D01, H-D03, H-C01, H-M01, H-M04, H-S01 | H-D04, H-C04, H-P01 |
| **Iniciado III** | H-D02, H-D04, H-D05, H-D06, H-C02, H-C03, H-C04, H-O06, H-O07, H-P01, H-P02, H-P04, H-M02, H-M03, H-M05, H-S02, H-S03 | H-O08, H-P03, H-P05, H-P07 |
| **Fraccionista** | H-O08, H-P03, H-P05, H-P07, H-S04 | H-P06 |
| **Fraccionista Mayor** | H-P06 + **retención ≥ 0,8 en todas las habilidades del MVP durante 30 días** | — |

El rango de **Fraccionista Mayor** es el único que exige retención a largo plazo: no basta con haber dominado las habilidades una vez; hay que mantener el dominio mientras se progresa. Esto refleja la diferencia entre "he aprobado el examen" y "sé matemáticas".

Tiempos orientativos (nunca comunicados al niño, biblia §6.2):

| De → a | Tiempo típico (10 años bien acompañado) |
|--------|----------------------------------------|
| Aprendiz I → II | 1–2 semanas |
| Aprendiz II → III | 3–5 semanas |
| Aprendiz III → Iniciado I | 5–8 semanas |
| Iniciado I → II | 8–12 semanas |
| Iniciado II → III | 10–16 semanas |
| Iniciado III → Fraccionista | 8–12 semanas |
| Fraccionista → Fraccionista Mayor | 3–6 meses de consolidación |

Total de extremo a extremo: **12–18 meses**. Perfectamente coherente con la biblia §6.2. Niños de 12 que ya saben la materia pueden acelerarlo a 3–5 meses; el sistema detecta el dominio rápido y agiliza la introducción de siguientes habilidades sin rebajar criterios.

---

## 19. Qué queda fuera de este documento

- **Algoritmos exactos** del motor adaptativo y de cómputo de dominio → documento 03 (arquitectura técnica).
- **Guiones y diálogos** específicos de misiones que entrenan cada habilidad → documento de contenido narrativo.
- **Calibración fina de los umbrales** por edad y perfil → se ajusta con datos reales de pruebas pedagógicas (documento de evaluación).
- **Correspondencia con currículos no españoles** → documento de localización pedagógica.

Este mapa es un **esqueleto vivo**. Cambios requieren actualizar la versión y justificar el motivo. Cada revisión se compara contra los principios de la biblia §2.

*Fin del mapa v0.1 — 52 habilidades definidas.*
