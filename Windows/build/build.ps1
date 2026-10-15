# Build the Windows tools for "US Keyboard Layout with German Umlauts".
#
# Compiles the AutoHotkey v2 scripts in ..\ into standalone exes. The scripts
# are used AS-IS: the uiAccess + version-info compiler directives are injected
# into a temporary copy, so the repository sources stay untouched.
#
# - Downloads Ahk2Exe into .tools\ if missing (never committed).
# - Uses the installed AutoHotkey64.exe as the base interpreter.
# - Output: output\US_German_Umlauts.exe and output\US_German_Umlauts_Alt.exe,
#   UNSIGNED. Signing is a separate, deliberate step; no signing material lives
#   in this repository.
#
# The exes request uiAccess="true". Windows grants the token only when the exe
# is signed and runs from %ProgramFiles% - which the installer takes care of.

[CmdletBinding()]
param(
    [string]$AutoHotkeyDir = 'C:\Program Files\AutoHotkey\v2',
    [string]$Version = '2.0.0'
)

$ErrorActionPreference = 'Stop'
$Here    = Split-Path -Parent $MyInvocation.MyCommand.Path
$WinDir  = Split-Path -Parent $Here
$Tools   = Join-Path $Here '.tools\ahk2exe'
$Ahk2Exe = Join-Path $Tools 'Ahk2Exe.exe'
$Base    = Join-Path $AutoHotkeyDir 'AutoHotkey64.exe'
$Output  = Join-Path $Here 'output'

if (-not (Test-Path -LiteralPath $Base)) {
    throw "Base interpreter not found: $Base (install AutoHotkey v2 or pass -AutoHotkeyDir)."
}

if (-not (Test-Path -LiteralPath $Ahk2Exe)) {
    Write-Host '==> Downloading Ahk2Exe...'
    $release = Invoke-RestMethod 'https://api.github.com/repos/AutoHotkey/Ahk2Exe/releases/latest'
    $asset = $release.assets | Where-Object { $_.name -like '*.zip' } | Select-Object -First 1
    if (-not $asset) { throw 'No Ahk2Exe .zip asset found in the latest release.' }
    New-Item -ItemType Directory -Force -Path $Tools | Out-Null
    $zip = Join-Path $env:TEMP $asset.name
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $Tools -Force
}

$targets = @(
    [pscustomobject]@{
        Script       = 'US_German_Umlauts.ahk'
        Out          = 'US_German_Umlauts.exe'
        ManifestName = 'US German Umlauts'
        Description  = 'US German Umlauts - German umlauts on a US keyboard (CapsLock scheme)'
    },
    [pscustomobject]@{
        Script       = 'US_German_Umlauts Alt.ahk'
        Out          = 'US_German_Umlauts_Alt.exe'
        ManifestName = 'US German Umlauts Alt'
        Description  = 'US German Umlauts Alt - German umlauts on a US keyboard (Alt scheme)'
    }
)

New-Item -ItemType Directory -Force -Path $Output | Out-Null
$staging = Join-Path $env:TEMP ("usgu-build-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $staging | Out-Null

foreach ($t in $targets) {
    $srcPath = Join-Path $WinDir $t.Script
    if (-not (Test-Path -LiteralPath $srcPath)) { throw "Source script not found: $srcPath" }

    $directives = @"
;@Ahk2Exe-UpdateManifest 0, $($t.ManifestName), , 1
;@Ahk2Exe-SetName $($t.ManifestName)
;@Ahk2Exe-SetProductName US Keyboard Layout with German Umlauts
;@Ahk2Exe-SetDescription $($t.Description)
;@Ahk2Exe-SetCompanyName Stefan Lohmaier
;@Ahk2Exe-SetCopyright Copyright (c) 2026 Stefan Lohmaier
;@Ahk2Exe-SetFileVersion $Version.0
;@Ahk2Exe-SetProductVersion $Version.0

"@
    $tempScript = Join-Path $staging $t.Script
    $body = Get-Content -LiteralPath $srcPath -Raw -Encoding UTF8
    Set-Content -LiteralPath $tempScript -Value ($directives + $body) -Encoding UTF8

    $outExe = Join-Path $Output $t.Out
    Write-Host "==> Compiling $($t.Script) -> $outExe"
    # Ahk2Exe is a GUI-subsystem exe: use Start-Process so we can wait on it and
    # read a real exit code ($LASTEXITCODE is not set for GUI apps).
    $argStr = "/in `"$tempScript`" /out `"$outExe`" /base `"$Base`" /silent verbose"
    $proc = Start-Process -FilePath $Ahk2Exe -ArgumentList $argStr -Wait -PassThru -NoNewWindow
    if ($proc.ExitCode -ne 0) { throw "Ahk2Exe failed for $($t.Script) (exit $($proc.ExitCode))." }
}

Remove-Item -Recurse -Force $staging -ErrorAction SilentlyContinue

Write-Host '==> Build complete:'
Get-ChildItem $Output -Filter *.exe | ForEach-Object { Write-Host "    $($_.FullName)" }
