#!/bin/bash

SSID="$@"

usage() {
  echo "$0 ssid"
}

check_required_apps() {
  local required_apps="sudo awk"

  for app in $required_apps; do
    if ! which $app > /dev/null; then
      echo "Necessary application '$app' not found"
      echo "Please install '$app' and try again"
      exit 1
    fi
  done
}

get_password() {
  local base_path="/etc/NetworkManager/system-connections"
  local config_file="$base_path/$SSID"

  if ! [ -f "$config_file" ]; then
    echo "'$config_file' not found"
    echo "Are you on Ubuntu?"
    echo "Is this the correct SSID for the WiFi network?"
    exit 1
  fi

  local password=$(sudo awk -F= '/psk=/{print $2}' "$config_file")
  if [ x"$password" = x ]; then
    echo "Could not get the password for WiFi '$SSID'"
    echo "Are you sure this is the correct SSID?"
    echo "Is the password saved for this network?"
    exit 1
  fi
  echo $password
}

#====
# Party starts here :)
#

if [ x"$SSID" = "x" ]; then
  usage
  exit
fi

check_required_apps
get_password
