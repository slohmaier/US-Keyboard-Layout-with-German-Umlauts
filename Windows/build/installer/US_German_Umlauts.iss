; Inno Setup script for the Windows tools of
; "US Keyboard Layout with German Umlauts".
;
; The user picks ONE scheme - CapsLock or Alt. Only the chosen tool is installed
; and only it gets a Start-menu shortcut and the autostart shortcut. The finish
; page offers to start the chosen tool only.
;
; Installs into %ProgramFiles% (required for uiAccess to take effect at launch),
; so the installer needs admin rights. Autostart is an all-users Startup-folder
; shortcut, launched by Explorer via ShellExecute; Inno removes it on uninstall
; automatically.
;
; Signing is done outside this script (project code-signing cert) - no signing
; material lives in this repo. Build the exes first (build.ps1), sign them, then
; compile this installer, then sign the installer.

#define AppName "US German Umlauts"
#define AppVersion "2.0"
#define AppPublisher "Stefan Lohmaier"

[Setup]
AppId={{E9C92901-54B7-4E43-80AC-E3CA3D8EAC56}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={autopf}\USGermanUmlauts
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
UninstallDisplayName={#AppName}
OutputDir=output
OutputBaseFilename=US_German_Umlauts-Setup-{#AppVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]
; Exclusive group: the user selects exactly one scheme (radio buttons).
; The first entry is selected by default.
Name: "scheme_capslock"; Description: "CapsLock scheme - CapsLock + A/U/O/S/E (add Shift for capitals)"; GroupDescription: "Choose your umlaut scheme:"; Flags: exclusive
Name: "scheme_alt"; Description: "Alt scheme - Alt + A/U/O/S/E, plus Ctrl+M (menu key) and Ctrl+Alt+Shift+S (screenshot)"; GroupDescription: "Choose your umlaut scheme:"; Flags: exclusive
Name: "autostart"; Description: "Start automatically at login"; GroupDescription: "Startup:"; Flags: checkedonce

[Files]
; Only the selected scheme's tool is installed.
Source: "..\output\US_German_Umlauts.exe"; DestDir: "{app}"; Flags: ignoreversion; Tasks: scheme_capslock
Source: "..\output\US_German_Umlauts_Alt.exe"; DestDir: "{app}"; Flags: ignoreversion; Tasks: scheme_alt

[Icons]
Name: "{group}\US German Umlauts (CapsLock)"; Filename: "{app}\US_German_Umlauts.exe"; Tasks: scheme_capslock
Name: "{group}\US German Umlauts (Alt)"; Filename: "{app}\US_German_Umlauts_Alt.exe"; Tasks: scheme_alt
Name: "{group}\Uninstall {#AppName}"; Filename: "{uninstallexe}"
; Autostart for the chosen scheme only. Explorer launches Startup shortcuts via
; ShellExecute, the only way Windows starts a uiAccess exe. Inno removes these
; on uninstall (no uninsneveruninstall flag).
Name: "{commonstartup}\US German Umlauts (CapsLock)"; Filename: "{app}\US_German_Umlauts.exe"; Tasks: scheme_capslock autostart
Name: "{commonstartup}\US German Umlauts (Alt)"; Filename: "{app}\US_German_Umlauts_Alt.exe"; Tasks: scheme_alt autostart

[Run]
; Offer to start the chosen tool only - never both.
; shellexec is mandatory: a uiAccess exe cannot be started via CreateProcess (WinError 740).
Filename: "{app}\US_German_Umlauts.exe"; Description: "Start US German Umlauts (CapsLock) now"; Flags: nowait postinstall skipifsilent shellexec; Tasks: scheme_capslock
Filename: "{app}\US_German_Umlauts_Alt.exe"; Description: "Start US German Umlauts (Alt) now"; Flags: nowait postinstall skipifsilent shellexec; Tasks: scheme_alt
