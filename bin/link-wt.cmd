@echo off
:: Crea el symlink de Windows Terminal settings.json -> dots_w11
:: Ejecutar con Windows Terminal CERRADO

set DOTS=%USERPROFILE%\dots_w11
set WT_SETTINGS=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

del "%WT_SETTINGS%" 2>nul
mklink "%WT_SETTINGS%" "%DOTS%\windows-terminal\settings.json"

echo.
echo Symlink creado. Ya puedes abrir Windows Terminal.
pause
