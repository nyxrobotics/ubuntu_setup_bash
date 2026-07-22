#!/bin/bash

set -euo pipefail

keyring=/usr/share/keyrings/microsoft-vscode.gpg
repository=/etc/apt/sources.list.d/vscode.list
temporary_keyring=$(mktemp)
trap 'rm -f "$temporary_keyring"' EXIT

sudo apt-get update
sudo apt-get install -y curl ca-certificates gnupg

curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --dearmor --batch --yes --output "$temporary_keyring"
sudo install -o root -g root -m 0644 "$temporary_keyring" "$keyring"

printf '%s\n' \
  "deb [arch=amd64 signed-by=$keyring] https://packages.microsoft.com/repos/vscode stable main" \
  | sudo tee "$repository" >/dev/null

sudo apt-get update
sudo apt-get install -y code
