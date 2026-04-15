# Initialize terminal UI and set up cleanup trap
init_ui() {
  tput civis # Hide cursor
  trap cleanup EXIT
  CURRENT_DIR="$(pwd)"
  SOURCE_DIR="$CURRENT_DIR"
}

# Restore terminal settings on exit
cleanup() {
  tput cnorm # Show cursor
  tput sgr0  # Reset text attributes
  clear
}

# Move cursor to specific row and column
move() {
  printf "\033[%s;%sH" "$1" "$2"
}

# Check if a file exists in the clipboard (collision detection)
has_collision() {
  local file="$1"

  for f in "${CLIPBOARD[@]}"; do
    [[ "${f##*/}" == "$file" ]] && return 0
  done

  return 1
}

# Draw help bar at the top of the screen
draw_help() {
  tput cup 0 0
  tput el

  [[ "$CLIP_MODE" == "copy" ]] && info_mode="📋 COPY MODE"
  [[ "$CLIP_MODE" == "cut" ]] && info_mode="✂️ CUT MODE"
  printf "${BOLD}Copy[y]  Paste[p] Move[P] Rename[r] Make[m] Delete[d]  Select[space]\n"
}

# Draw status bar at the bottom of the screen
draw_statusbar() {
  local lines
  lines=$(tput lines)

  tput cup $((lines - 1)) 0
  tput el

  local clip_count=${#CLIPBOARD[@]}
  local sel_count=${#MULTI_SELECTION[@]}

  local mode_str=""
  [[ "$CLIP_MODE" == "copy" ]] && mode_str="📋 COPY"
  [[ "$CLIP_MODE" == "cut" ]] && mode_str="✂ CUT"

  local warn=""
  [[ $clip_count -gt 0 ]] && warn="⚠"

  if [[ "$MODE" == "rename_mode" ]]; then
    printf "📁 Rename: %s" "$INPUT_BUFFER"
    return
  fi

  if [[ "$MODE" == "make_input" ]]; then
    printf "📁 New directory: %s" "$INPUT_BUFFER"
    return
  fi

  if [[ $MODE == "normal" ]]; then
    printf "📁 %s | %s %s | 📋 %d | ⭐ %d" \
      "$CURRENT_DIR" \
      "$mode_str" \
      "$warn" \
      "$clip_count" \
      "$sel_count"
  fi
}

# Check if a file is currently selected
is_selected() {
  local file="$1"

  for f in "${MULTI_SELECTION[@]}"; do
    [[ "$f" == "$file" ]] && return 0
  done
  return 1
}

# Render the main file list and UI elements
render() {
  tput sgr0 # Global reset
  tput cup 0 0
  tput ed
  draw_help

  local end=$((VIEW_START + VIEW_SIZE))

  for ((i = VIEW_START; i < end && i < ${#FILES[@]}; i++)); do
    local file="${FILES[$i]}"
    local warn=""

    if has_collision "$file"; then
      warn="⚠ "
    fi

    IFS="|" read -r icon color <<<"${FILE_META[$i]}"

    local row=$((2 + i - VIEW_START))
    move "$row" 2

    local selected=0
    is_selected "$file" && selected=1

    if [[ $i -eq $SELECTED_INDEX ]]; then
      tput el

      if ((selected)); then
        printf "${BOLD}${MAGENTA}> %s%s %s${RESET}\n" \
          "$warn" "$icon" "$color$file"
      else
        printf "${BOLD}${CYAN}> %s%s %s${RESET}\n" \
          "$warn" "$icon" "$color$file"
      fi

    else
      if ((selected)); then
        printf "${MAGENTA}* %s%s %s${RESET}\n" \
          "$warn" "$icon" "$color$file"
      else
        printf "  %s%s %s${RESET}\n" \
          "$warn" "$icon" "$color$file"
      fi
    fi
  done

  draw_statusbar
}
