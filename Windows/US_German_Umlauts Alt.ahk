#Requires AutoHotkey v2.0

SetCapsLockState "AlwaysOff"

; Umlaut a
!a:: {
    if GetKeyState("Shift", "P")
        Send "Ä"
    else
        Send "ä"
}

; Umlaut u
!u:: {
    if GetKeyState("Shift", "P")
        Send "Ü"
    else
        Send "ü"
}

; Umlaut o
!o:: {
    if GetKeyState("Shift", "P")
        Send "Ö"
    else
        Send "ö"
}

; Further Symbols/Umlauts
!s::Send "ß"
!e::Send "€"

; Example for opening tools:
; CapsLock & c::Run "calc.exe"

^m::Send "{AppsKey}"
