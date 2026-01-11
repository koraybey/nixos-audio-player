#!/usr/bin/env bash

DEVICE="/dev/sr0"
CD_SPEED=8

# VLC flags: error tolerance, ALSA output, suppress GUI errors
VLC_FLAGS=(
  --intf dummy
  --quiet
  --aout=alsa
  --alsa-audio-device=default
  --alsa-samplerate=44100
  --alsa-audio-channels=4
  --file-caching=5000
  --network-caching=5000
  --cr-average=1000
  --clock-jitter=1000
)

play_cd() {
  local start_track="$1"

  @eject@ -x "$CD_SPEED" "$DEVICE"

  if [[ -n "$start_track" ]]; then
    @vlc@ "${VLC_FLAGS[@]}" "cdda://$DEVICE" --cdda-track="$start_track"
  else
    @vlc@ "${VLC_FLAGS[@]}" "cdda://$DEVICE"
  fi
}

case "${1:-}" in
  ""|play)
    play_cd
    ;;
  [0-9]*)
    play_cd "$1"
    ;;
  eject)
    @eject@ "$DEVICE"
    ;;
  *)
    echo "Usage: cdplay [track_number|eject]"
    echo ""
    echo "  cdplay          - Play entire CD"
    echo "  cdplay 3        - Play from track 3 to end"
    echo "  cdplay eject    - Eject CD"
    ;;
esac
