#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

sudo apt install -y checkinstall gettext
mkdir -p ~/lib
cd ~/lib
if [ ! -d checkinstall/.git ]; then
    git clone git@github.com:giuliomoro/checkinstall.git
fi
cd checkinstall

# Reference: https://bbs.archlinux.org/viewtopic.php?id=265659
if patch --dry-run -p1 < "$SCRIPT_DIR/fix-checkinstall.patch" >/dev/null 2>&1; then
    patch -p1 < "$SCRIPT_DIR/fix-checkinstall.patch"
elif ! patch --dry-run -R -p1 < "$SCRIPT_DIR/fix-checkinstall.patch" >/dev/null 2>&1; then
    echo "fix-checkinstall.patch cannot be applied cleanly" >&2
    exit 1
fi

./configure
make
sudo checkinstall -yD --install=no --pkgname=checkinstall --pkgversion=1.6.3
sudo apt purge -y checkinstall
sudo apt autoremove -y
sudo dpkg -i checkinstall_1.6.3-1_amd64.deb
