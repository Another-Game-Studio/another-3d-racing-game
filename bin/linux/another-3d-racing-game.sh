#!/bin/sh
echo -ne '\033c\033]0;KartingJam\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/another-3d-racing-game.x86_64" "$@"
