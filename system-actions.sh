open_file() {
  local file="$1"
  local ext="${file##*.}"
  ext="${ext,,}"

  echo "open_file -> $file ($ext)" >./log

  case "$ext" in
  jpg | jpeg | png | gif | webp)
    open_image_viewer "$file"
    ;;

  pdf)
    open_pdf_viewer "$file"
    ;;

  txt | md | sh | log)
    open_text_viewer "$file"
    ;;

  mp4 | mkv | avi | webm)
    open_video_viewer "$file"
    ;;

  mp3 | ogg | wav | flac)
    open_audio_viewer "$file"
    ;;

  *)
    echo "No viewer for: $file" >>./log
    read -rsn1
    ;;
  esac
}
