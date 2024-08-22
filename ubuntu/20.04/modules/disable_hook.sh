#!/bin/bash

# core.hookspathで指定されているディレクトリを取得
hookspath=$(git config --global core.hookspath)

# ~（ホームディレクトリ）を展開
expanded_hookspath=$(eval echo "${hookspath}")

# ディレクトリが存在するか確認
if [ -d "${expanded_hookspath}" ]; then
    # ディレクトリ名をhooks.backupにリネーム
    mv "${expanded_hookspath}" "${expanded_hookspath}.backup"
    echo "Renamed ${expanded_hookspath} to ${expanded_hookspath}.backup"
else
    echo "Directory ${expanded_hookspath} does not exist."
fi
