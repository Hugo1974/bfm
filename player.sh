#!/usr/bin/env bash

gif_file="myvideo.gif"
gif_path="$HOME/.cache/bfm/video_frames/myvideo"
video_file="$1"
time_cache=3

CHAFA_PID=""
MPV_PID=""
FFMPEG_PID=""

cleanup() {
  echo -e "Matando chafa: $CHAFA_PID" >>./log
  [[ -n "$CHAFA_PID" ]] && kill "$CHAFA_PID" 2>/dev/null
  echo -e "Matando mpv: $MPV_PID" >>./log
  [[ -n "$MPV_PID" ]] && kill "$MPV_PID" 2>/dev/null
  echo -e "Matando ffmpeg: $FFMPEG_PID" >>./log
  [[ -n "$FFMPEG_PID" ]] && kill "$FFMPEG_PID" 2>/dev/null

  pkill -P $$ 2>/dev/null
  kill -9 $(jobs -p) 2>/dev/null

  tput cnorm
  clear
  exit 0
}

trap cleanup SIGINT TERM
trap 'tput cnorm; clear' EXIT

tput civis
clear

make_bar() {
  local n=$1
  local char=$2
  local out=""

  for ((i = 0; i < n; i++)); do
    out+="$char"
  done

  printf "%s" "$out"
}

progress_bar() {
  local duration=$1
  local width=40
  local steps=$((duration * 10))

  # colores (usar \033 en vez de \e)
  GREEN="\033[32m"
  CYAN="\033[36m"
  RESET="\033[0m"

  tput civis

  for ((i = 0; i <= steps; i++)); do
    percent=$((i * 100 / steps))
    filled=$((i * width / steps))
    empty=$((width - filled))

    bar=$(make_bar "$filled" "")
    space=$(make_bar "$empty" "") remaining=$(((steps - i) / 10))

    tput cup 0 0

    printf "%b" "$CYAN"
    printf "Caching $video_file... ["
    printf "%b" "$GREEN$bar"
    printf "%b" "$RESET$space"
    printf "] %3d%% (%ds)\n" "$percent" "$remaining"

    sleep 0.1
  done
  tput civis
  clear

}

# lanzar ffmpeg (NO bloquear ni esperar demasiado)
ffmpeg -loglevel error -analyzeduration 0 \
  -i "$video_file" \
  -vf "setpts=0.9933*PTS,fps=10.033,scale=640:-1" \
  -f gif \
  "$gif_path/$gif_file" -y >/dev/null 2>&1 &
FFMPEG_PID=$!
echo -e "ffmpeg lanzado: $FFMPEG_PID" >>./log

# pequeño delay (necesario para chafa --watch)
progress_bar $time_cache

# lanzar chafa lo antes posible
chafa --watch "$gif_path/$gif_file" &
CHAFA_PID=$!
echo -e "chafa lanzado: $CHAFA_PID" >>./log

# audio en paralelo
mpv --no-video --audio-delay=-0.2 "$video_file" >/dev/null 2>&1 &
MPV_PID=$!
echo -e "mpv lanzado: $MPV_PID" >>./log

# loop input
# while true; do
#   read -rsn1 -t 0.1 key
#   [[ "$key" == "q" ]] && cleanup
# done

# ... (resto de tu script anterior)

# loop input y monitoreo de procesos
while true; do
  # 1. Capturar tecla 'q' (Input del usuario)
  read -rsn1 -t 0.1 key
  [[ "$key" == "q" ]] && cleanup

  # # 2. Si MPV termina (se acabó el audio), cleanup
  # if [[ -n "$MPV_PID" ]] && ! kill -0 "$MPV_PID" 2>/dev/null; then
  #   echo "El audio ha terminado. Saliendo..." >>./log
  #   cleanup
  # fi

  # 3. SI CHAFA TERMINA, cleanup
  if [[ -n "$CHAFA_PID" ]] && ! kill -0 "$CHAFA_PID" 2>/dev/null; then
    echo "Chafa se ha cerrado. Saliendo..." >>./log
    cleanup
  fi
done
