# ez-admin v2
Get admin on any windows computer in about 30 seconds (with physical access, of course). Now improved significantly!

1. Go to the target computer and restart it. Try to get into BIOS (try all the function keys, F1 through F12, on your keyboard). If you can, proceed onward. Otherwise, you can try the alternate method listed below and follow them accordingly.
2. Shut down the computer. We won't need it for a bit.
3. Grab a USB drive, 2gb or more.
4. Hopefully in the coming days there will be a prebuilt release available. For now, you need a Linux box with around 4gb of space available to build the project. Clone the repo and run: `chmod +x *.sh`
5. Run `./build.sh` and the project will be built automatically.
6. Take your USB drive and either flash it with `dd` or [RUFUS](https://github.com/pbatard/rufus/releases/download/v3.20/rufus-3.20.exe). The ISO file that you use should be located in the directory you cloned ez-admin to. In previous versions of the project, ez-admin used a slightly modified Windows installer, but it now runs on a custom Linux built with BusyBox. (Thanks to @HENRYMARTIN5 for the AurumLinux project)
7. Eject the USB drive from your PC.
8. Plug the USB into the target PC.
9. Get into BIOS and boot from the USB drive. It should be the model name of your USB drive.
10. Follow the on-screen prompts and identify the block device for the Windows root drive. Once you have, enter it into the prompt and press enter.
11. The machine should reboot automatically after a few seconds. Once the target PC has rebooted and is on the login screen, click on the ease-of-access icon in the bottom right corner. If nothing happens, try clicking it again after waiting a few seconds. Keep retrying until a command prompt appears.
12. There will be an error at the top of the window. Ignore it. Type `cmd` and press enter.
13. At this point, you're basically done. You have access to the system admin account and can go around trashing things if you want, but I reccomend making an admin account for you to use.
14. Type the following commands, replacing `username` with the username you want for the admin user and `password` the password you want for the account:
```
net user username password /add

net localgroup Administrators username /add
```
15. Sign in to the account. If the system you ran this on has a domain used for accounts, type `.\` (note the backslash) followed by your username and your password as normal.
16. (OPTIONAL) Once you're signed into your new account, you can restore the original Utilman.exe to avoid arousing suspicion. To do so, just open a command prompt as administrator and type: `ez-restore.bat`.

Congratulations. You've gotten admin access on a computer with just a few minutes of your precious time.

## Alternate methods of booting from your USB

1. If you have access to a user account on the target device and have access to settings, this is your best bet. Find the Advanced Startup option in your windows settings and click the button to restart your PC. On the screen that follows, select Boot from USB and select your USB drive. Complete the rest of the steps as normal.

2. If you don't have access to a user account or the previous method didn't work, try this. Reboot the target PC and hold shift. Spam F8 until the installer appears. We're going to run ez-admin manually for this one, so you won't have to follow any of the normal steps up to step 16. Press Shift+F10 and run the following commands:
```
C:
copy C:\Windows\System32\Utilman.exe C:\Windows\System32\Utilman.exe.bak
xcopy C:\Windows\System32\cmd.exe C:\Windows\System32\Utilman.exe
shutdown
```
Close the cmd and the installer window, rebooting the PC. Unplug the USB drive and continue from the normal step from step 11.

## Flashing your drive with Tiny10

1. Download [RUFUS](https://github.com/pbatard/rufus/releases/download/v3.20/rufus-3.20.exe) and get a copy of `ez-admin.iso`.
2. Run RUFUS and select the ez-admin ISO as the disk image. Click on START to begin. Keep all the settings at default and confirm.

![image](https://user-images.githubusercontent.com/115757568/195742308-02a5e4b1-5cdd-4f34-bd76-3ca4cc1e9a11.png)
