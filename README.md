# US-Keyboard-Layout-with-German-Umlauts

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

On Linux (Wayland) the layout uses **AltGr** (right Alt) as the modifier instead of CapsLock, so CapsLock stays free for Orca:

 - AltGr + a = ä, AltGr + Shift + a = Ä
 - AltGr + u = ü, AltGr + Shift + u = Ü
 - AltGr + o = ö, AltGr + Shift + o = Ö
 - AltGr + s = ß, AltGr + Shift + s = ẞ
 - AltGr + e = €

## Install Instructions

All OS Instructions depend on you having US keyboard Layout selected.

#### Linux

The recommended way is the install script, which detects your display server and installs the matching configuration:

```bash
./Linux/install.sh
```

It detects the session via `WAYLAND_DISPLAY` (Wayland) or `DISPLAY` (X11):

 - **Wayland:** installs an XKB layout system-wide (needs sudo), removes any stale `~/.config/xkb` copy (which libxkbcommon would otherwise prefer), and registers it in GNOME via `gsettings`. AltGr (right Alt) acts as the modifier, leaving CapsLock free for Orca. Log out and back in for it to take effect.
 - **X11:** copies `Linux/Xmodmap` to `~/.Xmodmap` and applies it with `xmodmap`. For autostart, add `xmodmap ~/.Xmodmap` to your session startup.

Manual X11 setup:

 - Copy <code>Linux/Xmodmap</code> to <code>~/.Xmodmap</code>
 - Run <code>xmodmap ~/.Xmodmap</code> (You can add this to e.g. gnome-session-properties)

Note: Xmodmap only works under X11. Under Wayland it has no effect — use the XKB layout instead.

### Windows

#### Alternative a

(Made with Microsoft Keyboard Layout Creator 1.4 https://www.microsoft.com/en-us/download/details.aspx?id=22339 )

 - Extract <code>Windows/US_German_Umlauts.zip</code>
 - Run <code>setup.exe</code>
 - Go to "Control Panel" -> "Change keyboards or input methods"
 - Hit the button "Change keyboards"
 - In "Default input language" choose "English (United States) - US - German Umlauts"
 - Hit "OK" and "OK"
 - Download and install KeyTweak (e.g. from http://www.pcworld.com/product/947513/keytweak.html )
 - Map CapsLock to Right Alt
 - Reboot

#### Alternative b
 - Download and install AutoHotkey Version 1.x (v2 will work with different Syntax)
 - Copy the script file `*.ahk`
 - Right-click on the Start button and choose `Explore All Users`
 - Navigate to the Startup folder inside the Programs folder and paste the script file
 - The shortcut to the script should now be in the Startup folder
 - After reboot it should work, without reboot just Double-Click on the script file


### macOS

(Made with Ukulele http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&item_id=ukelele)

 - Download <code>U.S. German Umlauts.dmg</code>
 - Copy the keyboard layout to <code>/Library/Keyboard Layouts/</code> (system-wide, recommended) instead of <code>~/Library/Keyboard Layouts/</code>. Installing system-wide allows removing the default US layout.
 - Reboot
 - Go to "System Settings" -> "Keyboard" -> "Input Sources" -> "Edit..."
 - Hit the "+" button
 - Go to Others, select "U.S. German Umlauts" and hit the "Add" button
 - Select "U.S. German Umlauts" and exit System Settings

#### Removing the default US keyboard layout

macOS requires at least one keyboard layout and won't let you remove the last "Latin character" layout via the UI. After adding "U.S. German Umlauts", run the provided script to remove the default US layout:

```bash
./OSX/remove-us-layout.sh
```

The script will show your current layouts, ask for confirmation, and remove the US layout. Restart your Mac afterwards.

#### CapsLock as modifier (optional)

 - Download and install "PCKeyboardHack" (e.g. from https://pqrs.org/macosx/keyremap4macbook/pckeyboardhack.html.en )
 - Start "PCKeyboardHack"
 - Go to section "Caps Lock"
 - Check the checkbox and set keycode (double click the number)
 - Enter 58
