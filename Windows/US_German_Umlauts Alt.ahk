SetCapsLockState AlwaysOff

>! & a::
	GetKeyState, state, Shift
	If state = D
		Send, Ä
	else
		Send, ä
Return

>! & u::
	GetKeyState, state, Shift
	If state = D
		Send, Ü
	else
		Send, ü
Return

>! & o::
	GetKeyState, state, Shift
	If state = D
		Send, Ö
	else
		Send, ö
Return

>! & s::Send, ß
>! & e::Send, €

^m::Send {AppsKey}
