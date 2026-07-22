#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

activate_hiragana() {
    local ibus_address
    local input_context

    # IBus may still be starting when this script is launched by GNOME.
    for _ in {1..30}; do
        if ibus list-engine >/dev/null 2>&1; then
            break
        fi
        sleep 1
    done

    if [[ $(ibus engine 2>/dev/null) != "mozc-jp" ]]; then
        ibus engine mozc-jp >/dev/null 2>&1 || return 1
    fi
    sleep 0.2

    ibus_address=$(ibus address) || return 1
    input_context=$(
        gdbus call \
            --address "$ibus_address" \
            --dest org.freedesktop.IBus \
            --object-path /org/freedesktop/IBus \
            --method org.freedesktop.IBus.CurrentInputContext 2>/dev/null \
            | sed -n "s/.*'\([^']*\)'.*/\1/p"
    )
    [[ $input_context == /org/freedesktop/IBus/InputContext_* ]] || return 1

    # PropertyActivate does not reliably send a reply, so use a one-way call.
    dbus-send \
        --address="$ibus_address" \
        --type=method_call \
        --dest=org.freedesktop.IBus \
        "$input_context" \
        org.freedesktop.IBus.InputContext.PropertyActivate \
        string:InputMode.Hiragana uint32:1
}

watch_hiragana() {
    local event
    local ibus_address

    while true; do
        if activate_hiragana; then
            ibus_address=$(ibus address 2>/dev/null)
            while IFS= read -r event; do
                if [[ $event == *"GlobalEngineChanged ('mozc-jp'"* ]]; then
                    activate_hiragana
                fi
            done < <(
                gdbus monitor \
                    --address "$ibus_address" \
                    --dest org.freedesktop.IBus \
                    --object-path /org/freedesktop/IBus 2>/dev/null
            )
        fi
        sleep 1
    done
}

if [[ ${1:-} == "--activate" ]]; then
    activate_hiragana
    exit $?
fi

if [[ ${1:-} == "--watch" ]]; then
    watch_hiragana
    exit $?
fi

# >>>Install and enable Mozc (Japanese input)
sudo apt install -y ibus-mozc emacs-mozc
im-config -n ibus

# Keep the existing keyboard layouts and add Mozc only when it is missing.
input_sources=$(gsettings get org.gnome.desktop.input-sources sources)
if [[ $input_sources != *"'mozc-jp'"* ]]; then
    if [[ $input_sources == "@a(ss) []" || $input_sources == "[]" ]]; then
        input_sources="[('xkb', 'us')]"
    fi
    gsettings set org.gnome.desktop.input-sources sources \
        "${input_sources%]}, ('ibus', 'mozc-jp')]"
fi

# Switch between English and Japanese with Ctrl+Space.
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Control>space']"

# Start Mozc in Hiragana mode at login and whenever it is selected.
install -Dm755 "$SCRIPT_DIR/japanese_input.sh" \
    "$HOME/.local/bin/japanese-input"
install -Dm644 "$SCRIPT_DIR/mozc_hiragana.desktop" \
    "$HOME/.config/autostart/mozc-hiragana.desktop"

if ibus list-engine >/dev/null 2>&1; then
    ibus restart
elif [[ -n ${DISPLAY:-} || -n ${WAYLAND_DISPLAY:-} ]]; then
    ibus-daemon --daemonize --xim
else
    echo "Mozc was installed. Log out and log back in to start IBus."
fi

activate_hiragana || echo "Log out and log back in to enable Mozc Hiragana mode."
