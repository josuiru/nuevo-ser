#!/usr/bin/env bash
# Sirve la presentación de Solera·Zunbeltz y, opcionalmente, crea un enlace
# público temporal para compartirla online (sin cuenta, vía localhost.run).
#
# Uso:
#   bash servir.sh                  # solo local  -> http://localhost:8787/index.html
#   bash servir.sh --publico        # local + enlace público temporal (https://....lhr.life)
#   bash servir.sh --publico 9123   # idem en el puerto 9123
#
# El enlace público vive mientras este script esté en marcha. Ctrl+C para parar.

set -uo pipefail

PUBLICO=0
PUERTO=8787   # 8000 suele estar ocupado por otros servicios -> evitamos colisión
for arg in "$@"; do
  case "$arg" in
    --publico|-p) PUBLICO=1 ;;
    ''|*[!0-9]*)  : ;;            # ignora flags no numéricos
    *)            PUERTO="$arg" ;;
  esac
done

DIR="$(cd "$(dirname "$0")" && pwd)"

# 1) ¿El puerto está libre?
if ss -ltn 2>/dev/null | grep -q ":${PUERTO}\b"; then
  echo "✗ El puerto ${PUERTO} ya está ocupado por otro servicio."
  echo "  Prueba con otro:  bash servir.sh --publico 9123"
  exit 1
fi

echo "▸ Sirviendo  $DIR"
echo "▸ Local:     http://localhost:${PUERTO}/index.html"

# 2) Servidor estático en segundo plano
python3 -m http.server "$PUERTO" --directory "$DIR" >/tmp/zunbeltz-web.log 2>&1 &
SRV=$!
trap 'kill "$SRV" 2>/dev/null || true' EXIT
sleep 1

# 3) Verificar que de verdad servimos NUESTRA página (no otra cosa)
if ! curl -s --max-time 5 "http://127.0.0.1:${PUERTO}/index.html" | grep -q "Espacio Test Agrario"; then
  echo "✗ El servidor arrancó pero no devuelve la presentación de Zunbeltz."
  echo "  Revisa /tmp/zunbeltz-web.log"
  exit 1
fi
echo "✓ Verificado: la página de Zunbeltz se sirve correctamente."

if [ "$PUBLICO" -eq 0 ]; then
  echo "▸ (Para un enlace público temporal: bash servir.sh --publico)"
  echo "▸ Ctrl+C para parar."
  wait "$SRV"
else
  echo "▸ Creando enlace público temporal con localhost.run …"
  echo "  Busca abajo una línea  https://XXXX.lhr.life  -> ESA es la que compartes."
  echo "  (sin cuenta; el enlace dura lo que dure este proceso; Ctrl+C para parar)"
  echo
  ssh -o StrictHostKeyChecking=accept-new \
      -o ServerAliveInterval=60 \
      -R 80:localhost:"${PUERTO}" \
      nokey@localhost.run
fi
