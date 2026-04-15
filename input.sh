#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (c) 2026 Hugo Morago Martín

# Log error messages to a file with timestamp
log_error() {
  echo "[$(date +%H:%M:%S)] $*" >>"/tmp/filebrowser.log"
}

# Copy selected items to clipboard
yank_copy() {
  CLIPBOARD=("${MULTI_SELECTION[@]}")
  CLIP_MODE="copy"
  SOURCE_DIR="$CURRENT_DIR"
  MULTI_SELECTION=() # Clear visual selection
}

# Paste (copy) items from clipboard to current directory
paste_copy() {
  [[ -z "$SOURCE_DIR" ]] && {
    echo "SOURCE_DIR is empty, aborting" >&2
    return
  }

  for item in "${CLIPBOARD[@]}"; do
    local src="$SOURCE_DIR/$item"
    local dst="$CURRENT_DIR/$item"

    cp -r "$src" "$dst" 2>>"/tmp/filebrowser.log" || {
      log_error "Error copying $src -> $dst"
      continue
    }
  done

  # Clear clipboard and selection after paste
  CLIPBOARD=()
  CLIP_MODE=""
  SOURCE_DIR=""
  MULTI_SELECTION=()
  load_files
}

# Paste (move) items from clipboard to current directory
paste_move() {
  [[ -z "$SOURCE_DIR" ]] && {
    echo "SOURCE_DIR is empty, aborting" >&2
    return
  }

  for item in "${CLIPBOARD[@]}"; do
    local src="$SOURCE_DIR/$item"
    local dst="$CURRENT_DIR/$item"

    mv "$src" "$dst" 2>>"/tmp/filebrowser.log" || {
      log_error "Error moving $src -> $dst"
      continue
    }
  done

  # Clear clipboard and selection after move
  CLIPBOARD=()
  CLIP_MODE=""
  SOURCE_DIR=""
  MULTI_SELECTION=()
  load_files
}

# Delete all selected items
delete_selected() {
  for item in "${MULTI_SELECTION[@]}"; do
    rm -rf "$CURRENT_DIR/$item"
  done

  MULTI_SELECTION=()
  load_files
}

# Toggle selection of the current file under cursor
toggle_select() {
  local file="${FILES[$SELECTED_INDEX]}"
  local new=()
  local found=0

  for f in "${MULTI_SELECTION[@]}"; do
    if [[ "$f" == "$file" ]]; then
      found=1
    else
      new+=("$f")
    fi
  done

  if ((found)); then
    MULTI_SELECTION=("${new[@]}")
  else
    MULTI_SELECTION+=("$file")
  fi

  echo "TOGGLE: $file" >&2
  echo "SEL: ${MULTI_SELECTION[*]}" >&2
}

# Handle keyboard input for navigation and actions
handle_input() {
  local key
  IFS= read -rsn1 key

  # Handle input modes ( make or rename)
  if [[ "$MODE" == "make_input" ]] || [[ "$MODE" == "rename_mode" ]]; then
    case "$key" in
    $'\x7f') # Backspace
      INPUT_BUFFER="${INPUT_BUFFER%?}"
      ;;
    "") # Enter key
      if [[ "$MODE" == "make_input" ]]; then
        mkdir -p "$CURRENT_DIR/$INPUT_BUFFER"
        MODE="normal"
        INPUT_BUFFER=""
        load_files
      fi
      if [[ "$MODE" == "rename_mode" ]]; then
        local file="${FILES[$SELECTED_INDEX]}"
        mv "$CURRENT_DIR/$file" "$CURRENT_DIR/$INPUT_BUFFER"
        MODE="normal"
        INPUT_BUFFER=""
        load_files
      fi
      ;;
    $'\e') # Escape key
      MODE="normal"
      INPUT_BUFFER=""
      ;;
    *) # Regular character input
      INPUT_BUFFER+="$key"
      ;;
    esac

    return
  fi

  # Handle escape sequences (arrow keys)
  if [[ $key == $'\x1b' ]]; then
    read -rsn2 key
    case $key in
    "[A") ((SELECTED_INDEX--)) ;; # Up arrow
    "[B") ((SELECTED_INDEX++)) ;; # Down arrow
    "[C") enter_dir ;;            # Right arrow
    "[D") exit_dir ;;             # Left arrow
    esac
  else
    # Handle regular key presses
    case "$key" in
    $' ') toggle_select ;;  # Space
    "y") yank_copy ;;       # Y - copy to clipboard
    "p") paste_copy ;;      # P - paste (copy)
    "P") paste_move ;;      # Shift+P - paste (move)
    "d") delete_selected ;; # D - delete selected
    "q") exit 0 ;;          # Q - quit
    "r")
      tput cnorm
      MODE="rename_mode"
      INPUT_BUFFER=""
      ;;
    "m")
      tput cnorm
      MODE="make_input"
      INPUT_BUFFER=""
      ;;
    esac
  fi

  # Boundary limits for selection index
  ((SELECTED_INDEX < 0)) && SELECTED_INDEX=0
  ((SELECTED_INDEX >= ${#FILES[@]})) && SELECTED_INDEX=$((${#FILES[@]} - 1))

  # Centered scrolling logic
  local half=$((VIEW_SIZE / 2))
  VIEW_START=$((SELECTED_INDEX - half))

  ((VIEW_START < 0)) && VIEW_START=0

  local max_start=$((${#FILES[@]} - VIEW_SIZE))
  ((max_start < 0)) && max_start=0
  ((VIEW_START > max_start)) && VIEW_START=$max_start
}

# Enter the selected directory
enter_dir() {
  local target="${FILES[$SELECTED_INDEX]}"

  if [[ -d "$CURRENT_DIR/$target" ]]; then
    LAST_DIR="$target"
    CURRENT_DIR="$CURRENT_DIR/$target"
    SELECTED_INDEX=0
    load_files
  fi
}

# Go back to the parent directory
exit_dir() {
  CURRENT_DIR="$(dirname "$CURRENT_DIR")"
  load_files

  # Find the index of the previous directory to restore cursor position
  for i in "${!FILES[@]}"; do
    if [[ "${FILES[$i]}" == "$LAST_DIR" ]]; then
      SELECTED_INDEX=$i
      return
    fi
  done

  SELECTED_INDEX=0
}
