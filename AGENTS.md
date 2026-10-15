# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Project Overview

This project provides keyboard layout configurations for multiple operating systems to add German umlaut support to US keyboard layouts. The modifier key (CapsLock or Alt) combined with letter keys produces German special characters:

| Shortcut | Output |
|----------|--------|
| Modifier + a | ä |
| Modifier + u | ü |
| Modifier + o | ö |
| Modifier + s | ß |
| Modifier + e | € |
| Shift + Modifier + a/u/o | Ä/Ü/Ö |
| Shift + Modifier + s | ẞ |

## Modifier by OS

- **Windows:** CapsLock or Alt (both AutoHotkey v2; also shipped as signed exes)
- **Linux X11:** CapsLock (Xmodmap, `Mode_switch`)
- **Linux Wayland:** both Alt keys via XKB layout (`ISO_Level3_Shift`), leaving CapsLock free for Orca
- **macOS:** CapsLock (via PCKeyboardHack) or Alt

## File Structure by OS

### Windows (`Windows/`)
- `US_German_Umlauts.ahk` - AutoHotkey v2 script using CapsLock as modifier
- `US_German_Umlauts Alt.ahk` - AutoHotkey v2 script using Alt as modifier (also includes Ctrl+M for Menu key, Ctrl+Alt+Shift+S for screenshot)
- `US_German_Umlauts.klc` - Microsoft Keyboard Layout Creator source file
- `US_German_Umlauts.zip` - Compiled keyboard layout installer
- `copy_to_startup.bat` - Copies a chosen script to the user's Startup folder
- `build/` - Signed-executable tooling (see below)

#### Signed executables (`Windows/build/`)

`build/build.ps1` compiles the two `.ahk` scripts into standalone exes. The
scripts are used **as-is** - the `uiAccess` + version-info Ahk2Exe directives
are injected into a temporary copy, so the repository sources stay untouched.
Output is unsigned in `build/output/`; signing is a separate step (no signing
material lives in this repo). `build/installer/US_German_Umlauts.iss` is the
Inno Setup script: it installs the chosen scheme into `%ProgramFiles%` (required
for uiAccess) with an optional Startup autostart. Rebuild order: `build.ps1` ->
sign exes -> ISCC -> sign installer.

### Linux (`Linux/`)
- `install.sh` - Install script that detects Wayland vs X11 and installs the matching configuration
- `Xmodmap` - X11 keyboard remapping using Mode_switch (CapsLock) as modifier
- `us_umlauts` - XKB symbols file for the Wayland layout (both Alt keys as `ISO_Level3_Shift`)

### Wayland XKB installation (important)

GNOME/Wayland resolves layout names through the system XKB rules in `/usr/share/X11/xkb/rules/evdev.xml`, and loads the symbols file from `/usr/share/X11/xkb/symbols/`. Installing requires sudo:

1. Copy `Linux/us_umlauts` to `/usr/share/X11/xkb/symbols/us_umlauts`
2. Register the layout in `/usr/share/X11/xkb/rules/evdev.xml` and `evdev.lst`
3. Set it via `gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us_umlauts')]"`

**Gotcha:** libxkbcommon **prefers a per-user copy** at `~/.config/xkb/symbols/us_umlauts` over the system file. A stale/old copy there silently shadows the system-wide layout and breaks it (e.g. the right Alt stops acting as `ISO_Level3_Shift` and becomes plain `Alt_R`). Always remove `~/.config/xkb/symbols/us_umlauts` before installing system-wide.

`install.sh` automates all of this (including removing the stale user file).

### macOS (`OSX/`)
- `US German Umlauts.keylayout` - XML keyboard layout file created with Ukelele
- `U.S. German Umlauts.dmg` - Installable disk image
- `remove-us-layout.sh` - Removes the default US layout after installing

## Key Technical Notes

- AutoHotkey v1 and v2 have different syntax - check file header for `#Requires AutoHotkey v2.0`
- The AHK scripts use `GetKeyState("Shift", "P")` to detect Shift for capital umlauts
- Linux Xmodmap uses keycodes 26, 30, 32, 38, 39 for e, u, o, a, s respectively
- Xmodmap only works under X11; under Wayland it has no effect
- The Wayland XKB layout is based on `us(intl)` and maps both the left and right Alt (`<LALT>`, `<RALT>`) to `ISO_Level3_Shift` via `include "level3(ralt_switch)"` and `include "level3(lalt_switch)"`. Alt+Tab still works, but Alt + a/u/o/s/e now type umlauts instead of menu shortcuts.
- XKB keysyms must use their internal names (`adiaeresis`, `udiaeresis`, `odiaeresis`, `ssharp`, `EuroSign`), not literal Unicode characters
- The Alt keys only stay Level3 modifiers if the layout does **not** get `pc`'s `Alt_R`/Mod1 binding; basing on `us(intl)` (which omits `us(basic)`) avoids this
- macOS keylayout uses XML with modifier maps and key actions
- The Xmodmap file must stay idempotent: do not re-add `remove Lock = Caps_Lock`, since `keycode 66 = Mode_switch` already removes CapsLock from the lock modifier
