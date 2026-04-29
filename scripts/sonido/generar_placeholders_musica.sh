#!/usr/bin/env bash
# Genera placeholders musicales sintéticos para los 12 slots de la
# capa 2 (musica_*). NO son las piezas finales — son drones armónicos
# con un mood diferenciado por distrito/combate, hechos con ffmpeg
# puro, para que la app respire mientras llega la música compositiva
# real (Kai Engel, Satie, etc., ver scripts/sonido/bajar_musica.sh).
#
# Salida: apps/uno-roto/assets/sonido/musica/<slot>.ogg
#
# Licencia: creación propia, CC-BY-SA 4.0 con el resto del contenido.
# No tiene problema de redistribución.

set -euo pipefail

# Trucos:
#   aevalsrc → sintetiza tonos sumando senos. Amplitud baja (≈0.15-0.25)
#     para que sumar varios no sature.
#   afftdn → denoise sutil que suaviza bordes digitales.
#   aecho → reverb barata (delay+decay).
#   lowpass/highpass → mood térmico (cálido = lowpass; frío = highpass).
#   afade → no terminar bruscamente.
#
# Las frecuencias son de la escala temperada (A=440Hz):
#   A2=110, A3=220, A4=440, A5=880
#   E3=164.81, E4=329.63
#   D3=146.83, D4=293.66
#   C4=261.63, F4=349.23, G4=392.00, B4=493.88
#   F#3=185.00, F#4=369.99, Bb3=233.08, Eb4=311.13

DESTINO="$(dirname "$0")/../../apps/uno-roto/assets/sonido/musica"
mkdir -p "$DESTINO"

generar() {
  local nombre="$1"
  local duracion="$2"
  local expresion_l="$3"
  local expresion_r="$4"
  local filtros="$5"
  local destino="$DESTINO/$nombre.ogg"
  echo "→ $nombre  (${duracion}s)"
  ffmpeg -y -loglevel error \
    -f lavfi -i "aevalsrc=${expresion_l}|${expresion_r}:d=${duracion}:s=44100" \
    -af "$filtros" \
    -c:a libvorbis -q:a 3 \
    "$destino"
}

# ─── Distritos ───────────────────────────────────────────────

# Tejados — cálido ámbar. La menor (A-C-E) con sub bajo.
generar "tejados" 24 \
  "0.18*sin(2*PI*110*t)+0.14*sin(2*PI*220*t)+0.10*sin(2*PI*329.63*t)" \
  "0.16*sin(2*PI*220*t)+0.10*sin(2*PI*329.63*t)+0.08*sin(2*PI*440*t)" \
  "lowpass=f=1400,aecho=0.7:0.6:800|1300:0.5|0.3,volume=1.6,afade=t=in:d=2,afade=t=out:st=20:d=4"

# Canales — agua, reflejos. Re menor (D-F-A) con leve modulación.
generar "canales" 28 \
  "0.16*sin(2*PI*146.83*t)+0.12*sin(2*PI*293.66*t)+0.08*sin(2*PI*440*t+sin(0.4*t))" \
  "0.14*sin(2*PI*293.66*t)+0.08*sin(2*PI*440*t)+0.06*sin(2*PI*587.33*t+sin(0.3*t))" \
  "lowpass=f=1800,aecho=0.6:0.7:1200|1900:0.4|0.3,volume=1.5,afade=t=in:d=3,afade=t=out:st=23:d=5"

# Mercado — vivo, cálido. Do mayor (C-E-G) pulsando.
generar "mercado" 22 \
  "(0.18+0.06*sin(0.7*t))*sin(2*PI*261.63*t)+0.10*sin(2*PI*329.63*t)+0.08*sin(2*PI*392.00*t)" \
  "(0.16+0.06*sin(0.7*t+1))*sin(2*PI*329.63*t)+0.10*sin(2*PI*392.00*t)+0.06*sin(2*PI*523.25*t)" \
  "lowpass=f=2200,aecho=0.5:0.5:600:0.3,volume=1.5,afade=t=in:d=2,afade=t=out:st=18:d=4"

# Industria — frío, máquina. Re menor sin armónicos cálidos, highpass.
generar "industria" 26 \
  "0.14*sin(2*PI*146.83*t)+0.10*sin(2*PI*220*t)+0.05*sin(2*PI*440*t)" \
  "0.10*sin(2*PI*220*t)+0.08*sin(2*PI*440*t+0.05*sin(2*t))" \
  "highpass=f=180,lowpass=f=2400,aecho=0.4:0.4:500:0.2,volume=1.5,afade=t=in:d=2,afade=t=out:st=22:d=4"

# Puerto — niebla, vacío. Sol menor sub + alto, hueco en medios.
generar "puerto" 30 \
  "0.18*sin(2*PI*98*t)+0.06*sin(2*PI*392.00*t)+0.04*sin(2*PI*587.33*t)" \
  "0.16*sin(2*PI*98*t+0.5)+0.05*sin(2*PI*440*t)+0.04*sin(2*PI*659.25*t)" \
  "aecho=0.7:0.8:1500|2400:0.5|0.4,volume=1.7,afade=t=in:d=4,afade=t=out:st=24:d=6"

# Afueras — tranquilo nocturno. La mayor pentatónica suave.
generar "afueras" 28 \
  "0.16*sin(2*PI*220*t)+0.10*sin(2*PI*329.63*t)+0.06*sin(2*PI*493.88*t)" \
  "0.12*sin(2*PI*277.18*t)+0.10*sin(2*PI*440*t)+0.05*sin(2*PI*659.25*t)" \
  "lowpass=f=1600,aecho=0.6:0.7:1100|1700:0.4|0.3,volume=1.5,afade=t=in:d=3,afade=t=out:st=23:d=5"

# ─── Combates ────────────────────────────────────────────────

# Combate cotidiano — neutral, oscilante. La menor con pulso 90 BPM.
generar "combate_cotidiano" 18 \
  "(0.18+0.10*sin(2*PI*1.5*t))*sin(2*PI*220*t)+0.10*sin(2*PI*329.63*t)" \
  "(0.16+0.10*sin(2*PI*1.5*t+1))*sin(2*PI*220*t)+0.08*sin(2*PI*440*t)" \
  "lowpass=f=2000,aecho=0.5:0.5:400:0.3,volume=1.6,afade=t=in:d=1,afade=t=out:st=15:d=3"

# Combate Kurz — inquieto. Mi menor, oscilación rápida.
generar "combate_kurz" 20 \
  "(0.16+0.12*sin(2*PI*2*t))*sin(2*PI*164.81*t)+0.08*sin(2*PI*246.94*t)+0.06*sin(2*PI*329.63*t)" \
  "(0.14+0.12*sin(2*PI*2*t+0.5))*sin(2*PI*246.94*t)+0.08*sin(2*PI*329.63*t)" \
  "lowpass=f=2200,aecho=0.5:0.5:350:0.3,volume=1.6,afade=t=in:d=1,afade=t=out:st=17:d=3"

# Combate Zafrán — tenso, disonante. Tritono Bb-E sostenido.
generar "combate_zafran" 22 \
  "0.16*sin(2*PI*116.54*t)+0.10*sin(2*PI*164.81*t)+0.08*sin(2*PI*233.08*t+0.1*sin(3*t))" \
  "0.12*sin(2*PI*164.81*t)+0.08*sin(2*PI*329.63*t+0.1*sin(3*t+1))" \
  "highpass=f=80,lowpass=f=2400,aecho=0.5:0.6:600|900:0.4|0.3,volume=1.7,afade=t=in:d=2,afade=t=out:st=18:d=4"

# Combate Vorax — modal final, drama. Modo frigio en Mi.
generar "combate_vorax" 24 \
  "0.18*sin(2*PI*82.41*t)+0.10*sin(2*PI*164.81*t)+0.06*sin(2*PI*246.94*t)+0.04*sin(2*PI*311.13*t)" \
  "0.14*sin(2*PI*164.81*t)+0.08*sin(2*PI*246.94*t)+0.05*sin(2*PI*329.63*t)" \
  "lowpass=f=2200,aecho=0.6:0.7:700|1100:0.5|0.4,volume=1.7,afade=t=in:d=2,afade=t=out:st=20:d=4"

# ─── Momentos únicos ─────────────────────────────────────────

# Ceremonia — solemne tipo Satie. La menor con quintas abiertas.
generar "ceremonia" 32 \
  "0.16*sin(2*PI*110*t)+0.10*sin(2*PI*164.81*t)+0.08*sin(2*PI*329.63*t)" \
  "0.14*sin(2*PI*220*t)+0.08*sin(2*PI*329.63*t)+0.06*sin(2*PI*440*t)" \
  "lowpass=f=1500,aecho=0.7:0.7:1400|2200:0.5|0.4,volume=1.6,afade=t=in:d=4,afade=t=out:st=26:d=6"

# Amanecer final — luz, ascenso. Do mayor con apertura armónica.
generar "amanecer_final" 36 \
  "0.14*sin(2*PI*130.81*t)+0.10*sin(2*PI*261.63*t)+0.08*sin(2*PI*392.00*t)+0.05*sin(2*PI*523.25*t)" \
  "0.12*sin(2*PI*261.63*t)+0.10*sin(2*PI*392.00*t)+0.06*sin(2*PI*523.25*t)+0.04*sin(2*PI*659.25*t)" \
  "lowpass=f=2400,aecho=0.7:0.8:1300|2100:0.5|0.4,volume=1.7,afade=t=in:d=5,afade=t=out:st=29:d=7"

echo
echo "✓ 12 placeholders generados en $DESTINO"
ls -lh "$DESTINO"
