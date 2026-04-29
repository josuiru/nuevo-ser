# Uno Roto — Prototipo del combate

Prototipo mínimo de la mecánica de cortar Fragmentos Unitarios (Familia B).
Cubre solo los denominadores **1/2, 1/3, 1/4 y 1/5**. Sin narrativa, sin
sincronización, sin backend. Un único objetivo:

> Responder a la pregunta más peligrosa del proyecto:
> **¿el gesto de cortar se siente como jugar o como examen?**

## Qué hay y qué no hay

Incluido:

- Pantalla única con selector de Fragmento (2, 3, 4, 5).
- Fragmento dibujado con aura neón y latido suave (biblia §3.2 — azul-violeta).
- Gesto de cortar: deslizar desde el centro hacia el borde crea un radio.
- Evaluación tolerante: el jugador completa el objetivo si traza tantos radios
  como el denominador, distribuidos de forma aproximadamente uniforme
  (tolerancia actual: ±12° por sector).
- Feedback visual inmediato: aura verde suave (éxito), rosa (no cuadra).
- Mensaje amable bajo el Fragmento (nunca "¡incorrecto!").
- Reintento automático tras 1,5 segundos.

No incluido (a propósito):

- Progresión, rangos, cuenta, sincronización.
- Otras familias de Fragmentos.
- Narrativa, Sora, diálogos, misiones.
- Sonido.
- Animaciones de combate avanzadas.

## Cómo arrancar

Requiere Flutter ≥ 3.24 en el sistema.

```bash
cd app
flutter pub get
flutter analyze    # debe salir sin issues
flutter test       # debe pasar 7/7
flutter run        # lanza en el dispositivo/emulador activo
```

Si no hay dispositivo Android/iOS conectado, se puede ejecutar en Linux:

```bash
flutter run -d linux
```

## Estructura

```
lib/
├── main.dart                       # entry point, MaterialApp
├── nucleo/
│   └── paleta.dart                 # tema y paleta neón
├── dominio/                        # lógica pura Dart, sin Flutter
│   ├── fragmento.dart              # FragmentoUnitario y RadioTrazado
│   └── resolucion_corte.dart       # EvaluadorCorte y ResultadoIntento
└── vista/
    ├── pantalla_combate.dart       # pantalla y selector
    ├── lienzo_combate.dart         # GestureDetector y ciclo del intento
    └── pintor_fragmento.dart       # CustomPainter del Fragmento
test/
├── evaluador_corte_test.dart       # 6 tests de lógica pura
└── widget_test.dart                # smoke test de arranque
```

## Test de validación con niños

**Qué hay que responder con este prototipo** — ordenado por importancia:

1. ¿El niño **entiende** solo, sin instrucciones, cómo se corta?
   *Si no, el gesto está mal elegido y hay que rediseñarlo.*
2. ¿**Sonríe** cuando acierta?
   *Si no, falta algo en el feedback. La matemática no basta por sí sola.*
3. ¿**Quiere probar otro denominador** por curiosidad, o se aburre?
   *Si se aburre con 1/2, 1/3, 1/4, 1/5 el juego completo no funcionará.*
4. ¿Cuando falla, **se rinde** o **reintenta**?
   *Si se rinde, el fallo está mal presentado. El mensaje amable no basta —
   la estética también debe acompañar.*
5. ¿Hace una **estrategia distinta** con 1/5 que con 1/2?
   *Si no, no está aprendiendo — está pulsando. Revisar.*

### Protocolo sugerido

- 5-10 niños de 9 a 12 años.
- Sesiones individuales de 15 minutos máximo.
- No enseñar a usarlo — entregar el móvil y observar.
- Permitido: preguntarles al final qué esperaban que pasara.
- **Prohibido**: animar o felicitar durante la sesión (distorsiona).

### Criterios de éxito del prototipo

- ≥ 80% de los niños descubren el gesto en menos de 30 segundos.
- ≥ 70% **sonríen** espontáneamente al menos una vez.
- ≥ 60% prueban con un denominador mayor sin invitación.
- Ningún niño se frustra visiblemente (llanto, silencio largo, dejar el móvil).

Si se cumplen, se sigue al siguiente prototipo (Familia C o narrativa).
Si no se cumplen, se rediseña el gesto antes de construir nada encima.

## Licencia

AGPL-3.0 (decisión en `docs/03-arquitectura-tecnica.md` §13).
