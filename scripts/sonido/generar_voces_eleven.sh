#!/usr/bin/env bash
# Genera audio TTS para frases canónicas del juego usando la API de
# ElevenLabs. Lee la fuente de verdad de scripts/sonido/voces/*.tsv,
# llama a la API por cada línea, recibe MP3, lo recodifica a OGG q=3
# stereo, y lo coloca en apps/uno-roto/assets/sonido/voces/<personaje>/<slug>.ogg.
#
# Configuración (variables de entorno OBLIGATORIAS — nunca commit):
#   ELEVENLABS_API_KEY   tu API key de ElevenLabs
#   VOICE_SORA           voice_id (hash) para Sora
#   VOICE_FRAGMENTOKURZ  voice_id para Kurz
#   VOICE_FRAGMENTOECO   voice_id para Eco
#   (añade VOICE_<personaje_uppercase> conforme amplíes el lote)
#
# Modo dry-run (recomendado primero):
#   bash scripts/sonido/generar_voces_eleven.sh --dry-run
#   imprime cuántos caracteres se usarán y para qué slugs, sin llamar
#   a la API.
#
# Modo real:
#   export ELEVENLABS_API_KEY=...
#   export VOICE_SORA=...
#   export VOICE_FRAGMENTOKURZ=...
#   export VOICE_FRAGMENTOECO=...
#   bash scripts/sonido/generar_voces_eleven.sh
#
# Modo force (regenera aunque el OGG ya exista):
#   bash scripts/sonido/generar_voces_eleven.sh --force

set -uo pipefail

DRY_RUN=0
FORCE=0
TSV_DEFAULT="$(dirname "$0")/voces/lote_inicial.tsv"
TSVS=()

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --force)   FORCE=1 ;;
    --help|-h) sed -n '2,30p' "$0"; exit 0 ;;
    *)         TSVS+=("$arg") ;;
  esac
done
[[ ${#TSVS[@]} -eq 0 ]] && TSVS=("$TSV_DEFAULT")

DESTINO_BASE="$(dirname "$0")/../../apps/uno-roto/assets/sonido/voces"
mkdir -p "$DESTINO_BASE"

# Modelo TTS multilingüe (mejor para español que el default inglés).
MODELO_ID="${ELEVEN_MODEL_ID:-eleven_multilingual_v2}"

total_chars=0
total_pendientes=0
total_saltados=0
total_generados=0
total_fallidos=0

procesar_linea() {
  local personaje="$1" slug="$2" texto="$3"
  local destino_dir="$DESTINO_BASE/$personaje"
  local destino="$destino_dir/$slug.ogg"
  local nchars=${#texto}

  if [[ -f "$destino" && $FORCE -eq 0 ]]; then
    echo "  ⏭  $personaje/$slug.ogg ya existe ($nchars chars; salta)"
    total_saltados=$((total_saltados+1))
    return
  fi

  total_pendientes=$((total_pendientes+1))
  total_chars=$((total_chars+nchars))

  if [[ $DRY_RUN -eq 1 ]]; then
    echo "  → $personaje/$slug ($nchars chars): \"$texto\""
    return
  fi

  # Voz dinámica por personaje: VOICE_<MAYÚSCULAS>
  local var_voz="VOICE_${personaje^^}"
  local voice_id="${!var_voz:-}"
  if [[ -z "$voice_id" ]]; then
    echo "  ✗ $personaje: variable $var_voz no definida — saltando"
    total_fallidos=$((total_fallidos+1))
    return
  fi

  if [[ -z "${ELEVENLABS_API_KEY:-}" ]]; then
    echo "  ✗ ELEVENLABS_API_KEY no definida — saltando"
    total_fallidos=$((total_fallidos+1))
    return
  fi

  mkdir -p "$destino_dir"
  local tmp_mp3
  tmp_mp3=$(mktemp --suffix=.mp3)
  local payload
  payload=$(python3 -c "
import json,sys
print(json.dumps({
  'text': sys.argv[1],
  'model_id': sys.argv[2],
  'voice_settings': {'stability': 0.55, 'similarity_boost': 0.75}
}))" "$texto" "$MODELO_ID")

  local http_code
  http_code=$(curl -sS -o "$tmp_mp3" -w "%{http_code}" -X POST \
    "https://api.elevenlabs.io/v1/text-to-speech/$voice_id" \
    -H "xi-api-key: $ELEVENLABS_API_KEY" \
    -H "Content-Type: application/json" \
    -H "Accept: audio/mpeg" \
    -d "$payload" || echo "000")

  if [[ "$http_code" != "200" ]]; then
    echo "  ✗ $personaje/$slug HTTP $http_code:"
    head -c 400 "$tmp_mp3"; echo
    rm -f "$tmp_mp3"
    total_fallidos=$((total_fallidos+1))
    return
  fi

  ffmpeg -y -loglevel error -i "$tmp_mp3" \
    -ac 2 -ar 44100 -c:a libvorbis -q:a 3 \
    "$destino"
  rm -f "$tmp_mp3"
  local tam
  tam=$(stat -c%s "$destino" 2>/dev/null || stat -f%z "$destino")
  echo "  ✓ $personaje/$slug.ogg ($((tam/1024)) KB, $nchars chars)"
  total_generados=$((total_generados+1))
}

for tsv in "${TSVS[@]}"; do
  echo "═══ Procesando $tsv ═══"
  while IFS=$'\t' read -r personaje slug texto || [[ -n "$personaje" ]]; do
    [[ -z "$personaje" || "$personaje" =~ ^# ]] && continue
    procesar_linea "$personaje" "$slug" "$texto"
  done < "$tsv"
done

echo
echo "─────────────────────────────────────────────"
echo "  Pendientes detectados: $total_pendientes"
echo "  Caracteres a usar:     $total_chars"
echo "  Ya en disco (saltados): $total_saltados"
if [[ $DRY_RUN -eq 1 ]]; then
  echo "  Modo dry-run — sin llamadas a la API."
  echo
  echo "  Cuota Starter: 30 000 chars/mes"
  pct=$(python3 -c "print(round($total_chars*100/30000,2))")
  echo "  Este lote sería ${pct}% de la cuota."
else
  echo "  Generados:  $total_generados"
  echo "  Fallidos:   $total_fallidos"
fi
