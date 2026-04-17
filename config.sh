#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (c) 2026 Hugo Morago Martín
#

launch_audio_player() {
  mpv --no-video $1 2>&1
}
command -v nvim >/dev/null && TEXT_EDITOR="nvim" || TEXT_EDITOR="nano"
IMAGE_VIEWER="viu"
MUSIC_PLAYER=launch_audio_player
TEXT_VIEWER="bat"
VIDEO_VIEWER="./player.sh"
