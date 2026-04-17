#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (c) 2026 Hugo Morago Martín

tput clear

source ./config.sh
source ./ui.sh
source ./state.sh
source ./fs.sh
source ./input.sh
source ./icons.sh
source ./colors.sh
source ./system-actions.sh
source ./viewers.sh

init_ui

VIEW_SIZE=$(($(tput lines) - 3))

load_files

RUNNING=1

while [[ "$RUNNING" -eq 1 ]]; do
  render
  handle_input
done
