; Remap Umlaute
; http://www.autohotkey.com/
; 2016-03-31

SetCapsLockState AlwaysOff

; Umlaut a
Alt & a::
	GetKeyState, state, Shift
	If state = D
		Send, Ä
	else
		Send, ä
Return

; Umlaut u
Alt & u::
	GetKeyState, state, Shift
	If state = D
		Send, Ü
	else
		Send, ü
Return

; Umlaut o
Alt & o::
	GetKeyState, state, Shift
	If state = D
		Send, Ö
	else
		Send, ö
Return

; Further Symbols/Umlauts
Alt & s::Send, ß
Alt & e::Send, €
; Example for opening tools:
; Capslock & c::Run calc.exe
