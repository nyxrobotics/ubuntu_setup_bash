#!/usr/bin/env bash
set -eu

[ "$(id -u)" -eq 0 ] || { echo "run as root" >&2; exit 1; }

current="$(uname -r)"
abi="${current%-*}"

mapfile -t remove < <(
  dpkg-query -W -f='${Package}\n' \
    'linux-image-[0-9]*' 'linux-headers-[0-9]*' \
    'linux-modules-[0-9]*' 'linux-modules-extra-[0-9]*' 2>/dev/null \
    | grep -vF "$abi" || true
)

if [ "${#remove[@]}" -gt 0 ]; then
  apt-get purge -y "${remove[@]}"
fi
apt-get autoremove --purge -y
apt-get install -y "linux-headers-$current"
