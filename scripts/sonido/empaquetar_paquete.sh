#!/usr/bin/env bash
# Empaqueta el paquete sonoro descargable.
#
# Construye dist/audio_v<N>.zip a partir de los OGG en
# app/assets/sonido/{efectos,ambient,musica,narrativos}/, calcula sha256
# y produce un manifest.json listo para servir.
#
# Uso:
#   bash scripts/sonido/empaquetar_paquete.sh <version>
#
# Ejemplo:
#   bash scripts/sonido/empaquetar_paquete.sh 1
#
# Salida:
#   dist/audio_v1.zip
#   dist/audio_v1.manifest.json   # {version, url, sha256, tamano_bytes}
#
# Despliegue manual del manifest+zip en WP:
#   1. Subir audio_vN.zip a wp-content/uploads/uno-roto/audio/
#   2. El plugin uno-roto-core lee la última versión del directorio y
#      la sirve en GET /uno-roto/v1/audio/manifest.

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Uso: $0 <version>" >&2
  echo "Ej:   $0 1" >&2
  exit 1
fi

VERSION="$1"

if ! [[ "$VERSION" =~ ^[0-9]+$ ]]; then
  echo "ERROR: la versión debe ser un entero positivo (recibido: $VERSION)" >&2
  exit 1
fi

DIR_RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DIR_FUENTE="$DIR_RAIZ/app/assets/sonido"
DIR_DIST="$DIR_RAIZ/dist"

mkdir -p "$DIR_DIST"

NOMBRE_ZIP="audio_v${VERSION}.zip"
RUTA_ZIP="$DIR_DIST/$NOMBRE_ZIP"
RUTA_MANIFEST="$DIR_DIST/audio_v${VERSION}.manifest.json"

# Limpia salidas previas de esta versión.
rm -f "$RUTA_ZIP" "$RUTA_MANIFEST"

# Recorre los 4 subdirectorios y mete sus *.ogg en el zip preservando
# rutas relativas. Excluye archivos vacíos y placeholders.
echo "==> Empaquetando OGG en $RUTA_ZIP ..."
cd "$DIR_FUENTE"
ARCHIVOS=()
for sub in efectos ambient musica narrativos; do
  if [[ -d "$sub" ]]; then
    while IFS= read -r -d '' archivo; do
      # Saltar archivos de tamaño 0.
      if [[ -s "$archivo" ]]; then
        ARCHIVOS+=("$archivo")
      fi
    done < <(find "$sub" -name '*.ogg' -type f -print0)
  fi
done

if [[ ${#ARCHIVOS[@]} -eq 0 ]]; then
  echo "ERROR: no se encontraron archivos .ogg para empaquetar." >&2
  echo "Asegúrate de tener los assets en app/assets/sonido/{efectos,ambient,musica,narrativos}/" >&2
  exit 1
fi

zip --quiet -r "$RUTA_ZIP" "${ARCHIVOS[@]}"

# sha256 y tamaño.
SHA256=$(sha256sum "$RUTA_ZIP" | awk '{print $1}')
TAMANO=$(stat -c '%s' "$RUTA_ZIP")

# Sidecar .sha256 hermano del zip — el endpoint WP lo lee directamente
# para no recalcular el hash en cada petición.
RUTA_SHA="$DIR_DIST/audio_v${VERSION}.sha256"
echo "$SHA256  $NOMBRE_ZIP" > "$RUTA_SHA"

# Manifest. La URL es un placeholder — el plugin WP construye la URL
# real al servir el endpoint, pero la dejamos aquí para que el script
# de despliegue futuro pueda copiarla.
URL_PLACEHOLDER="https://CAMBIAR_DOMINIO/wp-content/uploads/uno-roto/audio/$NOMBRE_ZIP"

cat > "$RUTA_MANIFEST" <<EOF
{
  "version": $VERSION,
  "url": "$URL_PLACEHOLDER",
  "sha256": "$SHA256",
  "tamano_bytes": $TAMANO,
  "archivos": ${#ARCHIVOS[@]}
}
EOF

echo "==> Hecho:"
echo "    Zip:       $RUTA_ZIP"
echo "    Tamaño:    $(numfmt --to=iec-i --suffix=B "$TAMANO")"
echo "    Archivos:  ${#ARCHIVOS[@]}"
echo "    SHA256:    $SHA256"
echo "    Manifest:  $RUTA_MANIFEST"
echo
echo "==> Despliegue:"
echo "    1) Subir $NOMBRE_ZIP y audio_v${VERSION}.sha256 al servidor:"
echo "       wp-content/uploads/uno-roto/audio/"
echo "    2) Permisos: chmod 644 en ambos archivos."
echo "    3) Verificar el endpoint:"
echo "       curl https://<dominio>/wp-json/uno-roto/v1/audio/manifest"
echo "    4) El cliente verá la nueva versión en su próxima visita a"
echo "       Ajustes de sonido → Comprobar actualizaciones."
