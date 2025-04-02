#!/usr/bin/env bash
set -euo pipefail

SHARE=/home/steam/.local/share
STEAMAPP="${SHARE}/Steam/steamapps/common/Euro Truck Simulator 2 Dedicated Server"
GAMEDIR="${SHARE}/Euro Truck Simulator 2"

function install_gamedata() {
  # Check if GAMEDATA_URL is set to download and install
  if [[ -n ${GAMEDATA_URL:-} ]]; then
    log "Installing server config from ${GAMEDATA_URL}..."
    curl -sSfL "${GAMEDATA_URL}" | tar -xz -C "${GAMEDIR}"
    return 0
  fi

  if [[ -e /config/server_config.sii ]]; then
    log "Installing server config from /config/..."
    rsync -rv /config/ "${GAMEDIR}/"
    return 0
  fi

  log "No sources provided, skipping gamedata-install"
}

function log() {
  echo "[$(date +%H:%M:%S)] $@" >&2
}

function main() {
  # Check for updates / do first-time installation
  log "Starting game installation / update"
  steamcmd +runscript /home/steam/ets2-install.txt

  if ! [[ -e "${GAMEDIR}/server_config.sii" ]]; then
    log "No server config found, running game for first time to generate..."
    run_game || true # exit(1) is expected here
  fi

  install_gamedata
  wait_for_gamedata
  run_game
}

function run_game() {
  # Execute server
  log "Starting server..."
  cd "${STEAMAPP}/bin/linux_x64"
  export LD_LIBRARY_PATH='$ORIGIN/../../linux64'
  exec ./eurotrucks2_server
}

function wait_for_gamedata() {
  local backoff=1
  local max_backoff=120

  until [[ -e "${GAMEDIR}/server_packages.sii" ]]; do
    log "server_packages.sii not found, you need to install it manually into ${GAMEDIR}"
    sleep $backoff

    backoff=$((backoff * 2))
    [ $backoff -lt $max_backoff ] || backoff=$max_backoff
  done
}

main
