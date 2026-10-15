# TASKS

## Done

- Windows signed-executable tooling in `Windows/build/`:
  - `build.ps1` compiles the two `Windows/*.ahk` scripts (as-is) into standalone
    exes with a `uiAccess="true"` manifest, using Ahk2Exe + the installed
    AutoHotkey v2 base.
  - `installer/US_German_Umlauts.iss` (Inno Setup): installs the chosen scheme
    (CapsLock or Alt) into `%ProgramFiles%\USGermanUmlauts`, Start-menu shortcut,
    optional autostart; uninstall removes the tool and autostart.
- Built and signed `US_German_Umlauts.exe`, `US_German_Umlauts_Alt.exe` and
  `US_German_Umlauts-Setup-2.0.exe` with the project code-signing certificate.
- Release 2.0: signed exes + installer as GitHub release assets.

## Open / follow-up

- Verify the installer's scheme selection + autostart/uninstall on a clean
  machine.
- Optional: no automated release pipeline yet - build, sign, ISCC, sign,
  `gh release create` are manual.
- Keep `Windows/build/build.ps1` and the installer in sync when the `.ahk`
  scripts change.
