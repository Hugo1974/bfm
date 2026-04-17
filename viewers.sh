clean_viewers() {
  tput sgr0
  clear
}

launch_viewer() {
  echo -e "$@" >>./log
  local file="$1"
  local command=$2
  local mode="$3"

  echo -e "$2 $1" >>./log
  "$command" "$file"

  if [[ "$mode" == "video" || $mode == "audio" ]]; then
    restore_browser
    return
  fi

  read -rsn1 q
  restore_browser
}
restore_browser() {
  tput reset
  stty sane
  tput civis
  load_files
  render
}

open_image_viewer() {
  clean_viewers
  launch_viewer "$1" "${IMAGE_VIEWER[@]}"
}

open_text_viewer() {
  clean_viewers
  launch_viewer "$1" "${TEXT_VIEWER[@]}"
}

open_video_viewer() {
  clean_viewers
  launch_viewer "$1" "${VIDEO_VIEWER[@]}" "video"
}

open_pdf_viewer() {
  clean_viewers
  launch_viewer "$1" "${PDF_VIEWER[@]}"
}

open_audio_viewer() {
  clean_viewers
  launch_viewer "$1" "$MUSIC_PLAYER" "audio"
}
