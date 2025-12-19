@echo off
setlocal EnableDelayedExpansion

set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SCRIPT_DIR=%~dp0"

if "%~1"=="-alt" (
    set "SCRIPT=US_German_Umlauts Alt.ahk"
    goto copy
)
if "%~1"=="-capslock" (
    set "SCRIPT=US_German_Umlauts.ahk"
    goto copy
)

echo.
echo Which AutoHotkey script do you want to copy to Startup?
echo.
echo   1) US_German_Umlauts.ahk (CapsLock as modifier)
echo   2) US_German_Umlauts Alt.ahk (Alt as modifier)
echo.
echo Or run with: copy_to_startup.bat -capslock / -alt
echo.
set /p choice="Enter 1 or 2: "

if "%choice%"=="1" (
    set "SCRIPT=US_German_Umlauts.ahk"
) else if "%choice%"=="2" (
    set "SCRIPT=US_German_Umlauts Alt.ahk"
) else (
    echo Invalid choice.
    pause
    exit /b 1
)

:copy
copy "%SCRIPT_DIR%%SCRIPT%" "%STARTUP%\"

if %errorlevel%==0 (
    echo.
    echo Copied "%SCRIPT%" to Startup folder.
    echo It will run automatically on next login.
    echo.
    set /p "runNow=Start the script now? (Y/N): "
    if /i "!runNow!"=="Y" (
        start "" "%STARTUP%\%SCRIPT%"
        echo Script started.
    )
) else (
    echo.
    echo Failed to copy file.
    pause
)
