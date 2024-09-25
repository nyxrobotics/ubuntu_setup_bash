#!/bin/bash

# core.hookspathで指定されているディレクトリを取得
hookspath=$(git config --global core.hookspath)

# ~（ホームディレクトリ）を展開
expanded_hookspath=$(eval echo "${hookspath}")

# hooks.backupが存在するか確認
if [ -d "${expanded_hookspath}.backup" ]; then
    # ディレクトリ名をhooksにリネーム
    mv "${expanded_hookspath}.backup" "${expanded_hookspath}"
    echo "Renamed ${expanded_hookspath}.backup to ${expanded_hookspath}"
else
    echo "Directory ${expanded_hookspath}.backup does not exist."
fi
