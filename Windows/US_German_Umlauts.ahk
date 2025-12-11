#Requires AutoHotkey v2.0

; Remap Umlaute
; http://www.autohotkey.com/

SetCapsLockState "AlwaysOff"

; Umlaut a
CapsLock & a:: {
    if GetKeyState("Shift", "P")
        Send "Ä"
    else
        Send "ä"
}

; Umlaut u
CapsLock & u:: {
    if GetKeyState("Shift", "P")
        Send "Ü"
    else
        Send "ü"
}

; Umlaut o
CapsLock & o:: {
    if GetKeyState("Shift", "P")
        Send "Ö"
    else
        Send "ö"
}

; Further Symbols/Umlauts
CapsLock & s::Send "ß"
CapsLock & e::Send "€"
; Example for opening tools:
; CapsLock & c::Run "calc.exe"
