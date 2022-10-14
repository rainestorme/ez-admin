# ez-admin
Get admin on any windows computer in about 30 seconds.

1. Go to the target computer and restart it. Try to get into BIOS (try all the function keys, F1 through F12, on your keyboard). If you can, proceed onward. Otherwise, you can try the alternate method listed below and follow them accordingly.
2. Shut down the computer. We won't need it for a bit.
3. Grab a USB drive, 3gb or more.
4. Download or clone this repo and the files within it. You can do all the steps in this tutorial manually, but it's significantly easier to do automatically (using this repo).
5. Take your USB drive and make it bootable with Windows 10. You can do this with the official iso or the built-in recovery media creator but it's much lighter-weight and easier for our purposes to just flash it using [RUFUS](https://github.com/pbatard/rufus/releases/download/v3.20/rufus-3.20.exe) and a copy of [Tiny10](https://www.mediafire.com/file/jxyc8n25s1asati/tiny10_21H2_x64_2209.iso/file). If you need more specific instructions on flashing a drive with Tiny10, see below.
6. At this point, to make your life easier you should download all the installers for the software you want to use and put them on the root of the drive's filesystem.
7. If you're doing this process manually, skip this step. You now need to copy all the files in this repo (which you already downloaded) to the root of the drive.
8. Eject the USB drive your PC.
9. Plug the USB into the target PC.
10. Get into BIOS and boot from the USB drive. It should be the model name of your USB drive followed by "Partition 1".
11. You should be presented with a Windows installer window. Press Shift+F10 to open cmd.
12. Find your USB drive. It's probably at `d:` on most machines, or `e:` or `f:` on PCs with multiple drives.
13. Got the drive letter? Great. Type the drive letter (including the colon) into the prompt and press enter.
14. Type `dir` and press enter. If it contains a listing named `ez-admin.bat`, then you've found the right drive. If it doesn't, or if the output is obscenely long, try a different drive letter.
15. Type `ez-admin.bat` and press enter. Ez-Admin should automatically perform the steps required for the exploit and reboot your computer. Unplug the drive when the screen goes black.
16. Once the target PC has rebooted and is on the login screen, click on the ease-of-access icon in the bottom right corner. If nothing happens, try clicking it again after waiting a few seconds. Keep retrying until cmd appears.
17. There will be an error at the top of the window. Ignore it. Type `cmd` and press enter.
18. At this point, you're basically done. You have access to the system admin account and can go around trashing things if you want, but I reccomend making an admin account for you to use.
19. Type the following commands, replacing `username` with the username you want for the admin user and `password` the password you want for the account:
```
net user username password /add

net localgroup Administrators username /add
```
20. Sign in to the account. If the system you ran this on has a domain used for accounts, type `.\` (note the backslash) followed by your username and your password as normal.

Congratulations. You've gotten admin access on a computer with just a few minutes of your precious time.

## Alternate methods of booting from your USB

1. If you have access to a user account on the target device and have access to settings, this is your best bet. Find the Advanced Startup option in your windows settings and click the button to restart your PC. On the screen that follows, select Boot from USB and select your USB drive. Complete the rest of the steps as normal.
2. If you don't have access to a user account or the previous method didn't work, try this. Reboot the target PC and hold shift. Spam F8 until the installer appears. We're going to run Ez-Admin manually for this one, so you won't have to follow any of the normal steps up to step 16. Press Shift+F10 and run the following commands:
```
C:
copy C:\Windows\System32\Utilman.exe C:\Windows\System32\Utilman.bak
xcopy C:\Windows\System32\cmd.exe C:\Windows\System32\Utilman.exe
```
Close the cmd and the installer window, rebooting the PC. Unplug the USB drive and continue from the normal step from step 16.

## Flashing your drive with Tiny10

1. Download [RUFUS](https://github.com/pbatard/rufus/releases/download/v3.20/rufus-3.20.exe) and [Tiny10](https://www.mediafire.com/file/jxyc8n25s1asati/tiny10_21H2_x64_2209.iso/file).
2. Run RUFUS and select Tiny10 as the disk image. Click on START to begin. Keep all the settings at default and confirm.
3. Proceed with instructions as normal.

![image](https://user-images.githubusercontent.com/115757568/195742308-02a5e4b1-5cdd-4f34-bd76-3ca4cc1e9a11.png)
