#!/bin/bash

cache_dir="$HOME/.config/hypr/.cache"
state_file="$cache_dir/.idle_suspend_disabled"

mkdir -p "$cache_dir"

if [[ ! -f "$state_file" ]]; then
  printf '0' > "$state_file"
fi

state=$(<"$state_file")

print_status() {
  if [[ "$state" == "1" ]]; then
    printf '{"text":"","tooltip":"Idle suspend paused\\nLock after 5 minutes stays active"}\n'
  else
    printf '{"text":"󰒲","tooltip":"Idle suspend active\\nLock after 5 minutes, suspend after 10 minutes"}\n'
  fi
}

toggle() {
  if [[ "$state" == "1" ]]; then
    printf '0' >"$state_file"
    notify-send "Idle suspend" "Suspend after 10 minutes re-enabled"
  else
    printf '1' >"$state_file"
    notify-send "Idle suspend" "Suspend after 10 minutes paused"
  fi
}

suspend_if_enabled() {
  if [[ "$state" != "1" ]]; then
    systemctl suspend
  fi
}

case "$1" in
  --toggle)
    toggle
    ;;
  --suspend-if-enabled)
    suspend_if_enabled
    ;;
  *)
    print_status
    ;;
esac
