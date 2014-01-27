US-Keyboard-Layout-with-German-Umlauts
======================================
This project provides keyboardlayouts and instructions to achieve:

 - Deactivate Caps Lock
 - CapsLock + a = ä
 - CapsLock + s = ß
 - CapsLock + e = €
 - CapsLock + u = ü
 - CapsLock + o = ö
 - CapsLock + Shift + a = Ä
 - CapsLock + Shift + u = Ü
 - CapsLock + Shift + o = Ö

Install Instructions
====================

All OS Instructions depend on you having US keyboard Layout selected.

Linux
-----
 - Copy <code>Linux/Xmodmap</code> to <code>~/.Xmodmap</code>
 - Run <code>xmodmap ~/.Xmodmap</code> (You can add this to e.g. gnome-session-properties)

Windows
-------
 - Extract <code>Windows/US_German_Umlauts.zip</code>
 - Run <code>setup.exe</code>
 - Go to "Control Panel" -> "Change keyboards or input methods"
 - Hit the button "Change keyboards"
 - In "Default input language" choose "English (United States) - US - German Umlauts"
 - Hit "OK" and "OK"
 - Download and install KeyTweak (e.g. from http://www.pcworld.com/product/947513/keytweak.html )
 - Map CapsLock to Right Alt
 - Reboot

OSX
---
 - Download <code>OSX/US German Umlauts.keylayout</code>
 - Open a Terminal and got to the folder of the download (e.g. <code>cd ~/Downloads</code> ) .
 - Now enter: <code>sudo cp US\ German\ Umlauts.keylayout /Library/Keyboard\ Layouts</code>
 - (You may need to enter your login password)
 - Reboot
 - Go to "System Preferences" -> "Keyboard" -> "Input Sources"
 - Hit the "+" button
 - Go to Others, select "U.S. German Umlauts" and hit the "Add" button
 - Select "U.S. German Umlauts" and exit "System Preferences"
 - Download and install "PCKeyboardHack" (e.g. from https://pqrs.org/macosx/keyremap4macbook/pckeyboardhack.html.en )
 - Start "PCKeyboardHack"
 - Go to section "Caps Lock"
 - Check the checkbox and set keycode (double click the number)
 - Enter 58
