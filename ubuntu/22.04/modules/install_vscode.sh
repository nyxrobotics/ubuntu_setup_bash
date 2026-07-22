#!/bin/bash

set -euo pipefail

keyring=/usr/share/keyrings/microsoft-vscode.gpg
repository=/etc/apt/sources.list.d/vscode.sources
legacy_repository=/etc/apt/sources.list.d/vscode.list
temporary_keyring=$(mktemp)
trap 'rm -f "$temporary_keyring"' EXIT

arch=$(dpkg --print-architecture)
case "$arch" in
  amd64|arm64|armhf) ;;
  *)
    echo "Unsupported architecture: $arch" >&2
    exit 1
    ;;
esac

sudo apt-get update
sudo apt-get install -y curl ca-certificates gnupg

curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --dearmor --batch --yes --output "$temporary_keyring"
sudo install -o root -g root -m 0644 "$temporary_keyring" "$keyring"

# 旧リポジトリ設定 (repos/vscode を向いた vscode.list) が残っていれば削除
# ※ repos/vscode はarm64の更新が2023年9月 (1.82.0) で止まっているレガシーリポジトリ
sudo rm -f "$legacy_repository"

# 現行の公式リポジトリ repos/code を deb822 形式で登録
# (code パッケージ自身が管理するファイル名に合わせて vscode.sources にする)
printf '%s\n' \
  'Types: deb' \
  'URIs: https://packages.microsoft.com/repos/code' \
  'Suites: stable' \
  'Components: main' \
  "Architectures: $arch" \
  "Signed-By: $keyring" \
  | sudo tee "$repository" >/dev/null

sudo apt-get update
sudo apt-get install -y code

# Codex issue #33108: https://github.com/openai/codex/issues/33108
mkdir -p ~/.local/share/applications
cp /usr/share/applications/code.desktop \
  ~/.local/share/applications/code.desktop

sed -i \
  's#^Exec=/usr/share/code/code#Exec=/usr/bin/code#g' \
  ~/.local/share/applications/code.desktop

update-desktop-database ~/.local/share/applications

echo "Installed: $(code --version | head -n1) (arch: $arch)"
