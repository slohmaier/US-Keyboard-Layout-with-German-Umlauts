# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

## File Structure by OS

### Windows (`Windows/`)
- `US_German_Umlauts.ahk` - AutoHotkey v1 script using CapsLock as modifier
- `US_German_Umlauts Alt.ahk` - AutoHotkey v2 script using Alt as modifier (also includes Ctrl+M for Menu key, Ctrl+Alt+Shift+S for screenshot)
- `US_German_Umlauts.klc` - Microsoft Keyboard Layout Creator source file
- `US_German_Umlauts.zip` - Compiled keyboard layout installer

### Linux (`Linux/`)
- `Xmodmap` - X11 keyboard remapping using Mode_switch (CapsLock) as modifier

### macOS (`OSX/`)
- `US German Umlauts.keylayout` - XML keyboard layout file created with Ukelele
- `U.S. German Umlauts.dmg` - Installable disk image

## Key Technical Notes

- AutoHotkey v1 and v2 have different syntax - check file header for `#Requires AutoHotkey v2.0`
- The AHK scripts use `GetKeyState("Shift", "P")` to detect Shift for capital umlauts
- Linux Xmodmap uses keycodes 26, 30, 32, 38, 39 for e, u, o, a, s respectively
- macOS keylayout uses XML with modifier maps and key actions
