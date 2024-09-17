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

## Install Instructions

All OS Instructions depend on you having US keyboard Layout selected.

### Linux

#### Alternative a: Xmodmap

 - Copy <code>Linux/xmodmap/Xmodmap</code> to <code>~/.Xmodmap</code>
 - Run <code>xmodmap ~/.Xmodmap</code> (You can add this to e.g. gnome-session-properties)

#### Alternative b: X11

 - Copy <code>Linux/X11/us_umlauts</code> to <code>/usr/share/X11/xkb/symbols/us_umlauts</code>
 - Edit <code>/usr/share/X11/xkb/rules/evdev.xml</code> to include the following snippet

   The part is marked with the <code>Start us umlauts</code> and <code>End us umlauts</code> comments.
   
   I pasted mine right before the English layout configuration.

```
  <layoutList>
    <!-- Start us umlauts -->
    <layout>
      <configItem>
        <name>us_umlauts</name>
        <shortDescription>en</shortDescription>
        <description>English (US, with umlauts)</description>
        <languageList>
          <iso639Id>eng</iso639Id>
        </languageList>
      </configItem>
      <variantList></variantList>
    </layout>
    <!-- End us umlauts -->
    <layout>
      <configItem>
        <name>us</name>
        <!-- Keyboard indicator for English layouts -->
        <shortDescription>en</shortDescription>
        <description>English (US)</description>
```

 - Select the layout in the <code>Region & Language</code> Input Sources

### Windows

#### Alternative a: KeyTweak

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

#### Alternative b: AutoHotkey
 - Download and install AutoHotkey Version 1.x (v2 will work with different Syntax)
 - Copy the script file `*.ahk`
 - Right-click on the Start button and choose `Explore All Users`
 - Navigate to the Startup folder inside the Programs folder and paste the script file
 - The shortcut to the script should now be in the Startup folder
 - After reboot it should work, without reboot just Double-Click on the script file


### OSX

(Made with Ukulele http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&item_id=ukelele)

 - Download <code>U.S. German Umlauts.dmg</code>
 - Follow the copy recommendation in the DMG-container.
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
