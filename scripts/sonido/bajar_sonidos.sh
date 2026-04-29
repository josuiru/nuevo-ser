#!/usr/bin/env bash
# Descarga del primer lote de assets sonoros para Uno Roto.
#
# Estrategia v0.1:
#  1. Pack base de efectos: OwlishMedia (OpenGameArt, CC0). Cubre la
#     mayoría de slots de la capa 3 (efectos) y varios ambient.
#  2. La música compositiva por distrito y los motivos narrativos se
#     descargan **manualmente** desde el navegador (ver CREDITOS.md y
#     PLAN_AUDIO.md) — los enlaces de Free Music Archive no permiten
#     curl directo de forma estable.
#
# Idempotente: si el zip ya está descargado y descomprimido, el script
# no vuelve a hacerlo. Para forzar redescarga: borrar el directorio
# `_pack_owlishmedia/` y el zip.
#
# Uso:
#   bash scripts/sonido/bajar_sonidos.sh
#
# Requisitos: curl, unzip.

set -euo pipefail

DIR_RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DIR_SONIDO="$DIR_RAIZ/app/assets/sonido"
DIR_PACK="$DIR_SONIDO/_pack_owlishmedia"
RUTA_ZIP="$DIR_SONIDO/_owlishmedia.zip"

URL_PACK="https://opengameart.org/sites/default/files/Owlish%20Media%20Sound%20Effects.zip"

echo "==> Uno Roto · descarga de assets sonoros (v0.1)"
echo "    Destino: $DIR_SONIDO"

if [[ ! -d "$DIR_SONIDO" ]]; then
  echo "ERROR: no existe el directorio $DIR_SONIDO" >&2
  echo "Ejecuta este script desde la raíz del repo o ajusta la ruta." >&2
  exit 1
fi

mkdir -p "$DIR_SONIDO/ambient" "$DIR_SONIDO/musica" \
         "$DIR_SONIDO/efectos" "$DIR_SONIDO/narrativos"

# ---- Pack OwlishMedia (CC0) ---------------------------------------------

if [[ -d "$DIR_PACK" ]] && [[ -n "$(ls -A "$DIR_PACK" 2>/dev/null)" ]]; then
  echo "==> Pack OwlishMedia ya extraído en $DIR_PACK — saltando descarga."
else
  if [[ ! -f "$RUTA_ZIP" ]]; then
    echo "==> Bajando Owlish Media Sound Effects.zip (~142 MB) desde OpenGameArt..."
    curl --fail --location --output "$RUTA_ZIP" "$URL_PACK"
  else
    echo "==> Zip ya presente en $RUTA_ZIP — saltando descarga."
  fi

  echo "==> Extrayendo pack en $DIR_PACK ..."
  mkdir -p "$DIR_PACK"
  unzip -q -o "$RUTA_ZIP" -d "$DIR_PACK"
fi

echo
echo "==> Pack listo. Siguiente paso: examinar el contenido y copiar"
echo "    samples elegidos a los nombres que la app espera."
echo
echo "    Ver guía en app/assets/sonido/CREDITOS.md (§Cómo probar)."
echo
echo "    Ejemplo:"
echo "      cp $DIR_PACK/UI/<nombre>.wav $DIR_SONIDO/efectos/acierto.wav"
echo
echo "==> Para música compositiva (musica_*) y motivos: ver PLAN_AUDIO.md."
echo "==> Hecho."
