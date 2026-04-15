#!/usr/bin/bash

source ./ui.sh
source ./state.sh
source ./fs.sh
source ./input.sh
source ./icons.sh
source ./colors.sh

# tput init
# tput reset

init_ui

VIEW_SIZE=$(($(tput lines) - 3))

load_files

while true; do
  render
  handle_input
done
