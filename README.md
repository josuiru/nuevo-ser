# Uno Roto

Juego educativo de matemáticas para niños y niñas de 9 a 12 años.
Estado: pre-MVP. Diseño + prototipo del combate funcionando en Android.

## Estructura del repositorio

```
uno-roto/
├── docs/                        # Documentación de diseño
│   ├── 01-biblia.md             # Biblia maestra (cabecera)
│   ├── 02-mapa-habilidades-atomicas.md   # 52 habilidades pedagógicas
│   ├── 03-arquitectura-tecnica.md        # Flutter + WordPress headless
│   ├── 04-biblia-personajes.md           # Sora, Kai, 6 maestros
│   └── 05-biblia-worldbuilding.md        # Ciudad, distritos, Sociedad
│
└── app/                         # Prototipo del combate (Flutter)
    ├── lib/
    │   ├── dominio/             # Lógica pura Dart
    │   ├── vista/               # Widgets y CustomPainter
    │   └── nucleo/              # Paleta y tema
    ├── test/
    └── README.md                # Uso del prototipo y criterios de test
```

## Estado del prototipo

Cubre **solo** la Familia B (Fragmentos Unitarios: 1/2, 1/3, 1/4, 1/5).

Mecánica:

- El jugador desliza desde el centro hacia fuera para trazar un **radio**.
- Tras completar los radios necesarios, pulsa **Cortar** para evaluar.
- Los errores no castigan: puedes **Deshacer** trazos individuales o
  **Empezar de nuevo** sin perder el Fragmento.
- Al acertar: aura verde + háptica fuerte + reset automático.
- Al fallar: aura rosa, los trazos **se conservan** para ajustarlos.

Ver `app/README.md` para el protocolo de test con niños.

## Filosofía

Código abierto (AGPL-3.0), sin anuncios, sin compras internas, sin
tracking. Ver biblia §Anexo A.
