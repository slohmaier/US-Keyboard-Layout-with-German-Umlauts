#!/usr/bin/env bash
#
# Install US keyboard layout with German umlauts on Linux.
# Detects the display server and installs the matching configuration:
#   - Wayland: XKB layout (AltGr modifier) via ~/.config/xkb
#   - X11:     Xmodmap (CapsLock modifier) via ~/.Xmodmap
#
set -euo pipefail

XKB_SYMBOLS="$HOME/.config/xkb/symbols/us_umlauts"
XMODMAP_SRC="$(dirname "$(readlink -f "$0")")/Xmodmap"
XMODMAP_DST="$HOME/.Xmodmap"

detect_session() {
    if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
        echo "wayland"
    elif [[ -n "${DISPLAY:-}" ]]; then
        echo "x11"
    else
        echo "unknown"
    fi
}

install_wayland() {
    echo "Wayland erkannt - installiere XKB-Layout (Alt + a = ä, u = ü, o = ö, s = ß, e = €)."
    mkdir -p "$(dirname "$XKB_SYMBOLS")"
    cat > "$XKB_SYMBOLS" <<'EOF'
// US layout with German umlauts on both Alt keys (left and right Alt)
// Alt + a = ä, Alt + u = ü, Alt + o = ö, Alt + s = ß, Alt + e = €
// Alt + Shift + a/u/o = Ä/Ü/Ö, Alt + Shift + s = ẞ
partial alphanumeric_keys
xkb_symbols "basic" {
    include "us(basic)"

    name[Group1] = "English (US, German Umlauts)";

    // Both Alt keys act as Level3 modifier (like AltGr)
    key <LALT> { [ Alt_L, ISO_Level3_Shift ] };
    key <RALT> { [ Alt_R, ISO_Level3_Shift ] };

    key <AD01> { [ q, Q, ä, Ä ] };
    key <AD03> { [ e, E, €, € ] };
    key <AD07> { [ u, U, ü, Ü ] };
    key <AD09> { [ o, O, ö, Ö ] };
    key <AC01> { [ a, A, ä, Ä ] };
    key <AC02> { [ s, S, ß, ẞ ] };
};
EOF
    echo "XKB-Datei geschrieben: $XKB_SYMBOLS"

    if command -v gsettings >/dev/null 2>&1; then
        gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us_umlauts')]"
        echo "Layout in GNOME registriert."
    else
        echo "Hinweis: gsettings nicht gefunden. Layout manuell in den Systemeinstellungen aktivieren."
    fi

    echo "Fertig. Bitte abmelden und neu anmelden, damit das Layout greift."
}

install_x11() {
    echo "X11 erkannt - installiere Xmodmap (CapsLock + a = ä, u = ü, o = ö, s = ß, e = €)."
    if [[ ! -f "$XMODMAP_SRC" ]]; then
        echo "Fehler: $XMODMAP_SRC nicht gefunden." >&2
        exit 1
    fi
    cp "$XMODMAP_SRC" "$XMODMAP_DST"
    echo "Xmodmap kopiert: $XMODMAP_DST"
    xmodmap "$XMODMAP_DST"
    echo "Xmodmap angewendet (gilt fuer die aktuelle Session)."
    echo "Fuer Autostart: 'xmodmap $XMODMAP_DST' in den Autostart aufnehmen."
}

case "$(detect_session)" in
    wayland) install_wayland ;;
    x11)     install_x11 ;;
    *)
        echo "Fehler: Weder Wayland noch X11 erkannt." >&2
        exit 1
        ;;
esac
