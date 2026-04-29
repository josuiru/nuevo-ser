#!/usr/bin/env bash
# Integra el pack OwlishMedia ya descargado en los slots que la app espera.
# Reproducible: tras `bajar_sonidos.sh`, ejecutar este para que todos los
# slots cubiertos por el pack queden en su sitio. Idempotente (sobrescribe).
#
# Convierte a OGG Vorbis al vuelo (5-8× más pequeño que WAV, calidad
# equivalente para nuestro uso). audioplayers reproduce OGG nativamente
# en Android, iOS, Linux y Web.
#
# Uso:
#   bash scripts/sonido/integrar_pack.sh
#
# Requiere: ffmpeg con libvorbis.

set -euo pipefail

DIR_RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DIR_SONIDO="$DIR_RAIZ/app/assets/sonido"
DIR_PACK="$DIR_SONIDO/_pack_owlishmedia"

if [[ ! -d "$DIR_PACK" ]]; then
  echo "ERROR: $DIR_PACK no existe." >&2
  echo "Ejecuta primero: bash scripts/sonido/bajar_sonidos.sh" >&2
  exit 1
fi

cd "$DIR_SONIDO"

# Limpia versiones previas de los slots que vamos a (re)generar, en
# cualquier formato.
for slot in tap acierto error whoosh fusion ki_subiendo fragmento_disuelto; do
  rm -f "efectos/${slot}.wav" "efectos/${slot}.ogg" "efectos/${slot}.mp3"
done
for slot in tejados canales industria afueras; do
  rm -f "ambient/${slot}.wav" "ambient/${slot}.ogg" "ambient/${slot}.mp3"
done

# Codifica un origen WAV a OGG en la ruta destino con calidad apropiada.
codificar_a_ogg() {
  local entrada="$1" salida="$2" calidad="$3"
  ffmpeg -hide_banner -loglevel error -y \
    -i "$entrada" \
    -c:a libvorbis -q:a "$calidad" \
    "$salida"
}

echo "==> Codificando efectos cortos a OGG (capa 3)..."
codificar_a_ogg "_pack_owlishmedia/Impacts/hit.wav"     "efectos/tap.ogg"               5
codificar_a_ogg "_pack_owlishmedia/UI/UI_025.wav"       "efectos/acierto.ogg"           5
codificar_a_ogg "_pack_owlishmedia/UI/UI_034.wav"       "efectos/error.ogg"             5
codificar_a_ogg "_pack_owlishmedia/Impacts/scrape1.wav" "efectos/whoosh.ogg"            5
codificar_a_ogg "_pack_owlishmedia/UI/UI_011.wav"       "efectos/fusion.ogg"            5
codificar_a_ogg "_pack_owlishmedia/UI/UI_018.wav"       "efectos/ki_subiendo.ogg"       5
codificar_a_ogg "_pack_owlishmedia/UI/UI_017.wav"       "efectos/fragmento_disuelto.ogg" 5

echo "==> Construyendo ambient loops y codificando a OGG (capa 1)..."
# afueras: el sample original ya dura 82 s, no hace falta loop
codificar_a_ogg \
  "_pack_owlishmedia/Ambience/night-crickets-ambience-on-rural-property.wav" \
  "ambient/afueras.ogg" 4

# Loops cortos: extender por concatenación (stream_loop) y codificar OGG
# en una sola pasada (a WAV intermedio en /tmp y luego a OGG).
extender_y_codificar() {
  local entrada="$1" salida_ogg="$2" repeticiones="$3" calidad="$4"
  local tmp_wav
  tmp_wav="$(mktemp --suffix=.wav)"
  ffmpeg -hide_banner -loglevel error -y \
    -stream_loop "$repeticiones" -i "$entrada" -c copy "$tmp_wav"
  ffmpeg -hide_banner -loglevel error -y \
    -i "$tmp_wav" -c:a libvorbis -q:a "$calidad" "$salida_ogg"
  rm -f "$tmp_wav"
}

extender_y_codificar \
  "_pack_owlishmedia/Ambience/loopable-ticking-clock.wav" \
  "ambient/industria.ogg" 12 4

extender_y_codificar \
  "_pack_owlishmedia/Technology/record_player_loop.wav" \
  "ambient/tejados.ogg" 8 4

extender_y_codificar \
  "_pack_owlishmedia/Water/tap-water-1.wav" \
  "ambient/canales.ogg" 4 4

echo
echo "==> Hecho. Slots cubiertos (en formato OGG, ~3.5 MB total):"
echo "    efectos/{tap,acierto,error,whoosh,fusion,ki_subiendo,fragmento_disuelto}.ogg"
echo "    ambient/{tejados,canales,industria,afueras}.ogg"
echo
echo "==> Slots PENDIENTES (no hay match en el pack OwlishMedia):"
echo "    ambient/{mercado,puerto}.ogg  → Freesound CC0 manual"
echo "    musica/*.ogg                  → Free Music Archive (ver CREDITOS.md)"
echo "    narrativos/*.ogg              → derivados de musica/* (ver PLAN_AUDIO.md)"
