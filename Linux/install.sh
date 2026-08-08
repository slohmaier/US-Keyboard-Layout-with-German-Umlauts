#!/usr/bin/env bash
#
# Install US keyboard layout with German umlauts on Linux.
# Detects the display server and installs the matching configuration:
#   - Wayland: XKB layout (AltGr modifier) registered in the system XKB rules
#   - X11:     Xmodmap (CapsLock modifier) via ~/.Xmodmap
#
# Note: GNOME/Wayland resolves layout names only through the system XKB rules
# (/usr/share/X11/xkb/rules/evdev.xml). The per-user ~/.config/xkb folder is
# ignored by GNOME, so the layout must be installed system-wide (needs sudo).
#
set -euo pipefail

XKB_SYMBOLS_SRC="$(dirname "$(readlink -f "$0")")/us_umlauts"
XKB_SYMBOLS_DST="/usr/share/X11/xkb/symbols/us_umlauts"
XKB_RULES_XML="/usr/share/X11/xkb/rules/evdev.xml"
XKB_RULES_LST="/usr/share/X11/xkb/rules/evdev.lst"
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
    echo "Wayland erkannt - installiere XKB-Layout (AltGr + a = ä, u = ü, o = ö, s = ß, e = €)."

    if [[ ! -f "$XKB_SYMBOLS_SRC" ]]; then
        echo "Fehler: $XKB_SYMBOLS_SRC nicht gefunden." >&2
        exit 1
    fi

    # A stale per-user copy under ~/.config/xkb would shadow the system-wide
    # file (libxkbcommon prefers the user path). Remove it if present.
    if [[ -f "$HOME/.config/xkb/symbols/us_umlauts" ]]; then
        echo "Entferne veraltete User-Datei $HOME/.config/xkb/symbols/us_umlauts ..."
        rm -f "$HOME/.config/xkb/symbols/us_umlauts"
        rmdir "$HOME/.config/xkb/symbols" "$HOME/.config/xkb" 2>/dev/null || true
    fi

    echo "Kopiere Symbols-Datei nach $XKB_SYMBOLS_DST (sudo)..."
    sudo cp "$XKB_SYMBOLS_SRC" "$XKB_SYMBOLS_DST"

    echo "Registriere Layout in $XKB_RULES_XML (sudo)..."
    sudo python3 - "$XKB_RULES_XML" <<'PYEOF'
import sys
p = sys.argv[1]
with open(p) as f:
    content = f.read()
block = '''    <layout>
      <configItem>
        <name>us_umlauts</name>
        <shortDescription>en</shortDescription>
        <description>English (US, German Umlauts)</description>
        <countryList>
          <iso3166Id>US</iso3166Id>
        </countryList>
        <languageList>
          <iso639Id>eng</iso639Id>
        </languageList>
      </configItem>
    </layout>
'''
needle = '''    <layout>
      <configItem>
        <name>us</name>'''
if "us_umlauts" in content:
    print("evdev.xml: bereits vorhanden")
elif needle in content:
    content = content.replace(needle, block + needle, 1)
    with open(p, "w") as f:
        f.write(content)
    print("evdev.xml: eingefuegt")
else:
    print("evdev.xml: FEHLER - needle nicht gefunden")
    sys.exit(1)
PYEOF

    echo "Registriere Layout in $XKB_RULES_LST (sudo)..."
    sudo python3 - "$XKB_RULES_LST" <<'PYEOF'
import sys
p = sys.argv[1]
with open(p) as f:
    content = f.read()
needle = "  us              English (US)\n"
if "us_umlauts" in content:
    print("evdev.lst: bereits vorhanden")
elif needle in content:
    content = content.replace(needle, "  us_umlauts     English (US, German Umlauts)\n" + needle, 1)
    with open(p, "w") as f:
        f.write(content)
    print("evdev.lst: eingefuegt")
else:
    print("evdev.lst: FEHLER - needle nicht gefunden")
    sys.exit(1)
PYEOF

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
