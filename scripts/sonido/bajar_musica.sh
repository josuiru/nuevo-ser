#!/usr/bin/env bash
# Descarga las 12 piezas musicales de la capa 2 (capa compositiva)
# desde fuentes externas, verifica licencia compatible, convierte a
# OGG y deja todo en apps/uno-roto/assets/sonido/musica/ con su atribución
# anotada en CREDITOS.md.
#
# Cómo se usa:
#   1. Para cada slot, navega a la fuente recomendada en el navegador
#      (FMA, Musopen, archive.org…). Confirma con tus ojos:
#        a) que la pieza encaja con el mood del slot,
#        b) que la licencia es CC0, CC-BY 4.0, CC-BY-SA 4.0 o
#           dominio público.
#      ⚠ NUNCA aceptes CC-BY-NC (no comercial) ni CC-BY-ND (sin
#      derivadas) — son incompatibles con AGPL/CC-BY-SA.
#
#   2. Pega la URL DIRECTA del archivo (mp3/flac/ogg) en la variable
#      URL_<slot> de abajo y descomenta la línea de descarga.
#
#   3. Lanza:  bash scripts/sonido/bajar_musica.sh
#      Verifica licencia (best-effort) y convierte a OGG q=3 stereo.
#
#   4. Anota la atribución en apps/uno-roto/assets/sonido/CREDITOS.md.
#
# Mientras los slots no estén rellenados, los placeholders sintéticos
# de generar_placeholders_musica.sh siguen presentes y la app respira.

set -uo pipefail

DESTINO="$(dirname "$0")/../../apps/uno-roto/assets/sonido/musica"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$DESTINO"

# Detecta licencias incompatibles en URL o metadata HTTP. Devuelve 0
# si parece compatible, !=0 si detecta NC/ND o nada útil.
comprobar_licencia() {
  local url="$1"
  local lic_url="${2:-}"
  if [[ -n "$lic_url" ]]; then
    if [[ "$lic_url" =~ (^|/)by-nc(/|$|-) ]] || [[ "$lic_url" =~ (^|/)by-nd(/|$|-) ]]; then
      echo "  ✗ Licencia INCOMPATIBLE: $lic_url"
      return 1
    fi
    if [[ "$lic_url" =~ (^|/)by(/|$) ]] || [[ "$lic_url" =~ by-sa ]] || [[ "$lic_url" =~ publicdomain ]] || [[ "$lic_url" =~ zero ]]; then
      echo "  ✓ Licencia compatible: $lic_url"
      return 0
    fi
  fi
  if [[ "$url" =~ /by-nc/ ]] || [[ "$url" =~ /by-nd/ ]]; then
    echo "  ✗ URL contiene marca NC/ND: $url"
    return 1
  fi
  echo "  ⚠ Licencia no detectada automáticamente — VERIFICA A OJO antes de seguir."
  return 0
}

# Baja una URL y la convierte a OGG q=3 stereo en $DESTINO/$slot.ogg.
# Args: slot, url, autor, licencia_humana, fuente_url
descargar_y_convertir() {
  local slot="$1" url="$2" autor="$3" licencia="$4" fuente="$5"
  echo "▶ $slot — $autor — $licencia"
  if ! comprobar_licencia "$url" "$licencia"; then
    echo "  ⏭  saltado por licencia."
    return 1
  fi
  local ext="${url##*.}"
  ext="${ext%%\?*}"
  local origen="$TMP/${slot}.${ext}"
  if ! curl -fsSL -A "Mozilla/5.0" --max-time 60 -o "$origen" "$url"; then
    echo "  ✗ Descarga falló: $url"
    return 1
  fi
  ffmpeg -y -loglevel error -i "$origen" -ac 2 -ar 44100 -c:a libvorbis -q:a 3 \
    "$DESTINO/$slot.ogg"
  local tam
  tam=$(stat -c%s "$DESTINO/$slot.ogg" 2>/dev/null || stat -f%z "$DESTINO/$slot.ogg")
  echo "  ✓ $DESTINO/$slot.ogg ($((tam/1024)) KB)"
  echo "  → recuerda anotar atribución en assets/sonido/CREDITOS.md:"
  echo "    - $slot · $autor · $fuente · $licencia"
}

# ─── Slots musicales ────────────────────────────────────────────
# Para activar un slot: rellena URL_<slot>, AUTOR_<slot>,
# LICENCIA_<slot>, FUENTE_<slot> y descomenta la línea de llamada.
# Las recomendaciones de mood vienen del doc 12; las propuestas de
# autor del CREDITOS.md original. Verifica licencia siempre.

# musica_tejados — cálido ámbar, melancolía contenida
# Recomendación: pieza de piano lenta en menor con sustain.
URL_tejados=""           # ej: https://files.freemusicarchive.org/...
AUTOR_tejados=""         # ej: Lee Rosevere
LICENCIA_tejados=""      # ej: https://creativecommons.org/licenses/by/4.0/
FUENTE_tejados=""        # URL de la página del artista o pieza
[[ -n "$URL_tejados" ]] && descargar_y_convertir tejados "$URL_tejados" "$AUTOR_tejados" "$LICENCIA_tejados" "$FUENTE_tejados"

# musica_canales — agua, reflejos, nocturno
# Recomendación: ambient con texturas de agua o piano flotante.
URL_canales=""
AUTOR_canales=""
LICENCIA_canales=""
FUENTE_canales=""
[[ -n "$URL_canales" ]] && descargar_y_convertir canales "$URL_canales" "$AUTOR_canales" "$LICENCIA_canales" "$FUENTE_canales"

# musica_mercado — vivo, cálido, voces lejanas
# Recomendación: pieza folk/acústica suave con percusión ligera.
URL_mercado=""
AUTOR_mercado=""
LICENCIA_mercado=""
FUENTE_mercado=""
[[ -n "$URL_mercado" ]] && descargar_y_convertir mercado "$URL_mercado" "$AUTOR_mercado" "$LICENCIA_mercado" "$FUENTE_mercado"

# musica_industria — frío, máquina, ritmo de fábrica
# Recomendación: ambient industrial o synth lento sin calidez.
URL_industria=""
AUTOR_industria=""
LICENCIA_industria=""
FUENTE_industria=""
[[ -n "$URL_industria" ]] && descargar_y_convertir industria "$URL_industria" "$AUTOR_industria" "$LICENCIA_industria" "$FUENTE_industria"

# musica_puerto — niebla, vacío, agua profunda
# Recomendación: drone con sub bajo y reverb amplio.
URL_puerto=""
AUTOR_puerto=""
LICENCIA_puerto=""
FUENTE_puerto=""
[[ -n "$URL_puerto" ]] && descargar_y_convertir puerto "$URL_puerto" "$AUTOR_puerto" "$LICENCIA_puerto" "$FUENTE_puerto"

# musica_afueras — tranquilo, nocturno, abierto
# Recomendación: cuerda suave o guitarra acústica espaciosa.
URL_afueras=""
AUTOR_afueras=""
LICENCIA_afueras=""
FUENTE_afueras=""
[[ -n "$URL_afueras" ]] && descargar_y_convertir afueras "$URL_afueras" "$AUTOR_afueras" "$LICENCIA_afueras" "$FUENTE_afueras"

# musica_combate_cotidiano — neutral con pulso 90 BPM
# Recomendación: lo-fi ambient con base rítmica suave.
URL_combate_cotidiano=""
AUTOR_combate_cotidiano=""
LICENCIA_combate_cotidiano=""
FUENTE_combate_cotidiano=""
[[ -n "$URL_combate_cotidiano" ]] && descargar_y_convertir combate_cotidiano "$URL_combate_cotidiano" "$AUTOR_combate_cotidiano" "$LICENCIA_combate_cotidiano" "$FUENTE_combate_cotidiano"

# musica_combate_kurz — inquieto, primer combate, menor
# Recomendación: piano modal con tempo 110 BPM.
URL_combate_kurz=""
AUTOR_combate_kurz=""
LICENCIA_combate_kurz=""
FUENTE_combate_kurz=""
[[ -n "$URL_combate_kurz" ]] && descargar_y_convertir combate_kurz "$URL_combate_kurz" "$AUTOR_combate_kurz" "$LICENCIA_combate_kurz" "$FUENTE_combate_kurz"

# musica_combate_zafran — tenso, disonante, oscuro
# Recomendación: cuerda con tritono sostenido o ambient tenso.
URL_combate_zafran=""
AUTOR_combate_zafran=""
LICENCIA_combate_zafran=""
FUENTE_combate_zafran=""
[[ -n "$URL_combate_zafran" ]] && descargar_y_convertir combate_zafran "$URL_combate_zafran" "$AUTOR_combate_zafran" "$LICENCIA_combate_zafran" "$FUENTE_combate_zafran"

# musica_combate_vorax — modal final, drama, do# frigio o similar
URL_combate_vorax=""
AUTOR_combate_vorax=""
LICENCIA_combate_vorax=""
FUENTE_combate_vorax=""
[[ -n "$URL_combate_vorax" ]] && descargar_y_convertir combate_vorax "$URL_combate_vorax" "$AUTOR_combate_vorax" "$LICENCIA_combate_vorax" "$FUENTE_combate_vorax"

# musica_ceremonia — solemne, lento, tipo Satie
# Recomendación: una de las Gnossiennes en grabación PD (Musopen).
URL_ceremonia=""
AUTOR_ceremonia=""        # ej: Erik Satie (intérprete: ...)
LICENCIA_ceremonia=""     # ej: Public Domain
FUENTE_ceremonia=""
[[ -n "$URL_ceremonia" ]] && descargar_y_convertir ceremonia "$URL_ceremonia" "$AUTOR_ceremonia" "$LICENCIA_ceremonia" "$FUENTE_ceremonia"

# musica_amanecer_final — luz, ascenso, do mayor
# Recomendación: pieza acústica que abra hacia arriba.
URL_amanecer_final=""
AUTOR_amanecer_final=""
LICENCIA_amanecer_final=""
FUENTE_amanecer_final=""
[[ -n "$URL_amanecer_final" ]] && descargar_y_convertir amanecer_final "$URL_amanecer_final" "$AUTOR_amanecer_final" "$LICENCIA_amanecer_final" "$FUENTE_amanecer_final"

echo
echo "Final. Recuerda actualizar apps/uno-roto/assets/sonido/CREDITOS.md con cada"
echo "atribución que hayas confirmado."
