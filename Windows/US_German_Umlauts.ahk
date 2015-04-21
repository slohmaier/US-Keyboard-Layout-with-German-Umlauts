; Remap Umlaute
; http://www.autohotkey.com/
; 2015-04-21
SetCapsLockState AlwaysOff
Capslock::RAlt
>!+a::
   Send, Ä
Return
>!+u::
   Send, Ü
Return
>!+o::
   Send, Ö
Return
>!a::
   Send, ä
Return
>!u::
   Send, ü
Return
>!o::
   Send, ö
Return
>!s::
   Send, ß
Return
>!e::
   Send, €
Return
