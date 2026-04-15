#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (c) 2026 Hugo Morago Martín

load_files() {
  FILES=()
  FILE_META=()

  local dirs=()
  local files=()

  for item in "$CURRENT_DIR"/*; do
    [[ -e "$item" ]] || continue

    local file=$(basename "$item")

    if [[ -d "$item" ]]; then
      dirs+=("$file")
    else
      files+=("$file")
    fi
  done

  # unir (dirs primero)
  FILES=("${dirs[@]}" "${files[@]}")

  # generar metadata
  for file in "${FILES[@]}"; do
    FILE_META+=("$(get_meta "$file")")
  done
}

get_meta() {
  local file="$1"
  local full_path="$CURRENT_DIR/$file"

  local icon=""
  local color=""

  if [[ -d "$full_path" ]]; then
    icon="$ICON_DIR"
    color="$DIR_COLOR"
  else
    icon="$ICON_FILE"
    color="$FILE_COLOR"
  fi

  echo "$icon|$color"
}
