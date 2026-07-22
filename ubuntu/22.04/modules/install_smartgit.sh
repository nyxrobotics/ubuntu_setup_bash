#!/bin/bash

set -euo pipefail

install_dir=/opt/smartgit
fallback_version=26_1_045   # ダウンロードページの解析に失敗した場合に使うバージョン
download_page=https://www.smartgit.dev/download/

arch=$(dpkg --print-architecture)
case "$arch" in
  amd64|arm64) ;;
  *)
    echo "Unsupported architecture: $arch" >&2
    exit 1
    ;;
esac

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

sudo apt-get update
sudo apt-get install -y curl ca-certificates

# arm64にはネイティブ版がないため、amd64バンドルから jre/ と git/ を除去し、
# システム側のarm64版 OpenJDK 21 + Git で動かす (syntevo公式の手順)
if [ "$arch" = "arm64" ]; then
  sudo apt-get install -y git git-lfs openjdk-21-jre
fi

# 最新バージョンをダウンロードページから取得 (失敗時は fallback_version)
version=$(curl -fsSL "$download_page" \
  | grep -oE 'smartgit-[0-9]+_[0-9]+_[0-9]+-linux-amd64\.tar\.gz' \
  | head -n1 \
  | grep -oE '[0-9]+_[0-9]+_[0-9]+' || true)
version=${version:-$fallback_version}

url="https://download.smartgit.dev/smartgit/smartgit-${version}-linux-amd64.tar.gz"

echo "Downloading SmartGit ${version} (${arch}) ..."
curl -fL "$url" -o "$tmpdir/smartgit.tar.gz"

# 一時ディレクトリに展開し、アーカイブの階層構造に依存せず
# bin/smartgit.sh を含むディレクトリを特定してから配置する
extract_dir="$tmpdir/extract"
mkdir -p "$extract_dir"
tar -xzf "$tmpdir/smartgit.tar.gz" -C "$extract_dir"

launcher=$(find "$extract_dir" -type f -path '*/bin/smartgit.sh' | head -n1)
if [ -z "$launcher" ]; then
  echo "error: bin/smartgit.sh not found in the archive" >&2
  exit 1
fi
src_dir=$(cd "$(dirname "$launcher")/.." && pwd)

# 再実行時は丸ごと入れ替え (ユーザー設定は ~/.config/smartgit にあるので消えない)
sudo rm -rf "$install_dir"
sudo cp -a "$src_dir" "$install_dir"
sudo chown -R root:root "$install_dir"

if [ "$arch" = "arm64" ]; then
  sudo rm -rf "$install_dir/jre" "$install_dir/git"
fi

if [ ! -x "$install_dir/bin/smartgit.sh" ]; then
  echo "error: $install_dir/bin/smartgit.sh is missing or not executable" >&2
  exit 1
fi

# コマンドラインから smartgit で起動できるようにする
sudo ln -sfn "$install_dir/bin/smartgit.sh" /usr/local/bin/smartgit

# アプリケーションメニューに登録 (ユーザー権限で実行)
if [ -x "$install_dir/bin/add-menuitem.sh" ]; then
  "$install_dir/bin/add-menuitem.sh" || echo "warning: failed to add menu item" >&2
fi

command -v smartgit >/dev/null || {
  echo "error: smartgit is not on PATH" >&2
  exit 1
}
echo "SmartGit ${version} installed to ${install_dir} (arch: ${arch})"
