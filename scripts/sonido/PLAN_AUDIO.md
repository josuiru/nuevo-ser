# Plan de descarga de audio — Uno Roto

Este documento es la guía operativa para llenar `apps/uno-roto/assets/sonido/`.
Se ejecuta **una vez al principio** y se actualiza cuando se cambian
piezas. Lectura recomendada antes: `apps/uno-roto/assets/sonido/CREDITOS.md`.

## Pasos

### 1. Efectos (capa 3) — automatizado

```bash
bash scripts/sonido/bajar_sonidos.sh
```

El script baja el pack OwlishMedia CC0 (~142 MB) y lo descomprime en
`apps/uno-roto/assets/sonido/_pack_owlishmedia/`. **Inspecciona** los nombres de
archivo del pack y copia los que mejor encajen al slot que toca:

```bash
cd apps/uno-roto/assets/sonido
# Ejemplos — los nombres exactos del pack los verás al descomprimir.
cp _pack_owlishmedia/UI/Confirm_001.wav      efectos/acierto.wav
cp _pack_owlishmedia/UI/Back_002.wav         efectos/error.wav
cp _pack_owlishmedia/Water/Drop_small_03.wav efectos/tap.wav
cp _pack_owlishmedia/Impact/Soft_05.wav      efectos/fusion.wav
cp _pack_owlishmedia/UI/Whoosh_01.wav        efectos/whoosh.wav
```

Criterios al elegir:
- `acierto`: corto (<400 ms), tono claro, NO triunfal.
- `error`: aún más corto y bajo que `acierto`. **Importante**: nunca
  estridente (doc 12 §Feedback acierto/error).
- `tap`: gota suave, <120 ms.
- `whoosh`: <500 ms, tela o aire. Para abrir/cerrar UI.
- `fusion`: dos sonidos que se acercan, ~600 ms.
- `ki_subiendo`: si el pack no tiene un riser, déjalo vacío (el motor
  silencia la llamada) o sintetízalo con ffmpeg.
- `fragmento_disuelto`: cristal/shimmer 0.8-1.2 s, ascendente.

### 2. Ambient por distrito (capa 1) — semiautomático

Algunos slots se cubren con el pack OwlishMedia (categoría
`ambient/`). Otros requieren búsqueda manual. Tabla:

| Slot | Acción |
|------|--------|
| `ambient_tejados` | Del pack: `ambient/Wind_*` o `Wind_night_loop.wav`. Si no convence, Freesound query: `wind night loop 30s` filtro CC0. |
| `ambient_canales` | Mezcla de viento + agua suave. Pack: `Water/`. Querría editar con Audacity para mezclar. |
| `ambient_mercado` | **Manual**: Freesound query `night market crowd ambience`. Login requerido. Filtro CC0. |
| `ambient_industria` | Pack: `Technology/Machine_loop_*`. |
| `ambient_puerto` | Mezcla: Pack `Water/Waves` + viento + gaviota. La gaviota se busca manualmente. |
| `ambient_afueras` | **Manual**: Freesound query `crickets countryside night loop`. CC0. |

Loops ambient: deben durar **2-4 minutos** y cerrar el bucle sin
click. Si el sample original es más corto, usar `audacity` o `ffmpeg`
para extender por concatenación con crossfade:

```bash
ffmpeg -i loop_corto.wav -filter_complex \
  "[0:a]aloop=loop=4:size=44100*30,afade=t=out:st=120:d=2" \
  loop_largo.wav
```

### 3. Música compositiva (capa 2) — manual

**Descargar desde el navegador**: Free Music Archive y MusOpen no
admiten curl estable porque sus URLs cambian periódicamente.

Por slot, ir a la URL indicada en `CREDITOS.md`, escuchar las pistas
del compositor, elegir la que más encaje con el mood del doc 12, y:

1. Pulsar el botón de descarga FMA (suele dar MP3 o FLAC).
2. Convertir a WAV 44.1 kHz 16-bit con:
   ```bash
   ffmpeg -i pista_descargada.mp3 -acodec pcm_s16le -ar 44100 \
     apps/uno-roto/assets/sonido/musica/<slot>.wav
   ```
3. Si la pieza dura más de 4 min, recortar la parte más representativa
   con `ffmpeg -ss [inicio] -t [duracion]`.
4. Anotar atribución en `CREDITOS.md`:
   `- musica_canales · Lee Rosevere — Featherlight · https://freemusicarchive.org/... · CC-BY 4.0`

**Verificar siempre la licencia** en la página de la pista. Si dice
`NC` o `ND` → descartar (incompatible con AGPL/CC-BY-SA).

### 4. Motivos cortos (motivos + narrativos) — derivados

Una vez tengas la música compositiva, los motivos se generan por
recorte:

```bash
cd apps/uno-roto/assets/sonido

# Motivo de Sora — primeros 8 segundos de musica_tejados con fade out
ffmpeg -i musica/tejados.wav -ss 0 -t 8 \
  -af "afade=t=out:st=6:d=2" \
  narrativos/motivo_sora.wav

# Motivo de Kai — un acorde tenso de musica_combate_kurz, 3 segundos
ffmpeg -i musica/combate_kurz.wav -ss 12 -t 3 \
  narrativos/motivo_kai.wav
```

**Motivo de la Montaña**: doc 12 §51 lo trata como la "semilla musical
más importante del proyecto". Para el MVP: composición manual o
sintética con ffmpeg, 6 segundos, fa mayor:

```bash
# Tres notas de cuerda apagada — placeholder muy crudo, sustituir
ffmpeg -f lavfi -i "sine=frequency=349.23:duration=2" \
       -f lavfi -i "sine=frequency=440:duration=2" \
       -f lavfi -i "sine=frequency=523.25:duration=2" \
       -filter_complex "[0:a][1:a][2:a]concat=n=3:v=0:a=1" \
       narrativos/motivo_montana.wav
```

**Silbido de Zafrán** (doc 12 §161): único en el MVP, 2.5 s, 180-220
Hz fundamental con sub-bass. Sintético hasta tener un compositor:

```bash
ffmpeg -f lavfi -i "sine=frequency=200:duration=2.5" \
  -af "afade=t=in:d=0.2,afade=t=out:st=2:d=0.5,asetrate=44100*0.7,aresample=44100" \
  narrativos/silbido_zafran.wav
```

(la última pasada baja el tono al 70 % para dar el efecto inhumano)

## Checklist final

Antes de dar por buena la integración:

- [ ] Todos los efectos (7 archivos) presentes en `efectos/`.
- [ ] Todos los ambient (6 archivos) presentes en `ambient/` y duran
  ≥ 30 s sin click en bucle.
- [ ] Todas las músicas (12 archivos) presentes en `musica/`.
- [ ] Los 6 motivos/narrativos presentes en `narrativos/`.
- [ ] `CREDITOS.md` lista la atribución de cada archivo CC-BY.
- [ ] No hay archivos `NC` o `ND` por error.
- [ ] La app arranca y suena algo en el cazadero (basta con que el
  ambient del distrito empiece).
- [ ] Las preferencias por capa funcionan: bajar `musica` a 0 deja
  oír solo `ambient` y `efectos`.

## Tamaño esperado del directorio

Estimación con WAV 44.1 kHz 16-bit:

- Efectos: 7 × 200 KB = ~1.5 MB
- Ambient: 6 × 30 MB (3 min loops) = ~180 MB
- Música: 12 × 25 MB (2-3 min) = ~300 MB
- Narrativos: 6 × 1 MB = ~6 MB

**Total**: ~500 MB. **Demasiado para commitear al repo**. Por eso el
`.gitignore` excluye los binarios y deja los archivos solo en el disco
del desarrollador. Para release/distribución del APK, los assets se
empaquetan automáticamente al hacer `flutter build apk`.

Si los WAV se sienten demasiado grandes, convertir música y ambient a
**OGG Vorbis** (5-8× más pequeño, calidad equivalente):

```bash
ffmpeg -i musica/tejados.wav -c:a libvorbis -q:a 5 musica/tejados.ogg
rm musica/tejados.wav
```

Y actualizar `lib/sonido/catalogo_sonidos.dart` para apuntar a `.ogg`
en lugar de `.wav` (audioplayers reproduce ambos sin distinción).
