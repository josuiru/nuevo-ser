#!/usr/bin/env bash
# Abre el puente entre el móvil conectado por USB y el Local WP del PC.
#
# El cliente Flutter, cuando ConfigApi.usarProduccion = false, apunta a
# 127.0.0.1:10063. Desde el móvil, 127.0.0.1 es el propio móvil — no el PC.
# Con `adb reverse` el móvil ve el puerto 10063 del PC en su propio localhost.
#
# Requisitos:
#   - Local WP arrancado con el sitio "uno-roto" en puerto 10063.
#   - Móvil conectado por USB con depuración USB activada.
#
# Uso:
#   ./scripts/dev/abrir_puente_wp.sh
set -euo pipefail

PUERTO_LOCAL_WP=10063
HOST_LOCAL_WP="uno-roto.local"

if ! command -v adb >/dev/null 2>&1; then
  echo "ERROR: adb no está en el PATH. Instala platform-tools." >&2
  exit 1
fi

dispositivosConectados=$(adb devices | awk 'NR>1 && $2=="device" {print $1}')
if [[ -z "$dispositivosConectados" ]]; then
  echo "ERROR: ningún móvil conectado vía adb." >&2
  echo "Comprueba: USB conectado, depuración USB activa, popup aceptado." >&2
  exit 1
fi

echo "Móviles detectados:"
echo "$dispositivosConectados" | sed 's/^/  - /'

while read -r idDispositivo; do
  echo "Abriendo puente en $idDispositivo (puerto $PUERTO_LOCAL_WP) ..."
  adb -s "$idDispositivo" reverse "tcp:$PUERTO_LOCAL_WP" "tcp:$PUERTO_LOCAL_WP"
done <<<"$dispositivosConectados"

echo ""
echo "Probando manifest del paquete sonoro contra Local WP ..."
codigoHttp=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Host: $HOST_LOCAL_WP" \
  "http://127.0.0.1:$PUERTO_LOCAL_WP/wp-json/uno-roto/v1/audio/manifest" \
  --max-time 5 || echo "000")

if [[ "$codigoHttp" == "200" ]]; then
  echo "OK ($codigoHttp). El móvil ya puede llegar al Local WP."
else
  echo "AVISO: la prueba devolvió $codigoHttp."
  echo "Comprueba que Local WP está arrancado y el sitio uno-roto en :$PUERTO_LOCAL_WP."
  exit 2
fi
