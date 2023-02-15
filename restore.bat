:start 
cls
@echo off
color D
title -- Ez-Admin - Made by rainestorme --
echo                --------------------------------------
echo                  Welcome to Ez-Admin! (restore.bat) 
echo                --------------------------------------
echo.
echo                   Stage 1: Restoring Utilman.exe
echo.
C:
cd C:\Windows\System32
copy Utilman-ez.bak Utilman.exe
timeout /t 3
cls
echo                --- Utilman.exe has been restored. ---
exit
