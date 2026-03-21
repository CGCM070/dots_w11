@echo off
start wt -p "Windows PowerShell" powershell -NoExit -Command "nvim ."
timeout /t 1 /nobreak >nul
start wt -p "Windows PowerShell" powershell -NoExit -Command "claude --chrome"
