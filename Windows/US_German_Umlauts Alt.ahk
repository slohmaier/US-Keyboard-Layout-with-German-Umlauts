#Requires AutoHotkey v2.0

; Umlaut a (* = fire even with extra modifiers like Shift)
*!a:: {
    if GetKeyState("Shift", "P")
        SendText "Ä"
    else
        SendText "ä"
}

; Umlaut u
*!u:: {
    if GetKeyState("Shift", "P")
        SendText "Ü"
    else
        SendText "ü"
}

; Umlaut o
*!o:: {
    if GetKeyState("Shift", "P")
        SendText "Ö"
    else
        SendText "ö"
}

; Further Symbols/Umlauts
*!s:: {
    if GetKeyState("Shift", "P")
        SendText "ẞ"
    else
        SendText "ß"
}
*!e::SendText "€"

; Example for opening tools:
; CapsLock & c::Run "calc.exe"

^m::Send "{AppsKey}"

; Screenshot to clipboard
^!+s::Send "{PrintScreen}"
