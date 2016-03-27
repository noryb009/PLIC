# Puppy Linux Installer Creator (PLIC)

## Please Use LICK Instead

There are some architectural flaws in PLIC that have been addressed in
[LICK](https://github.com/noryb009/lick).
LICK supports more versions of Windows, such as Windows 10, and supports UEFI
bootloaders.
Additionally, LICK takes ISO files as input - users no longer need to wait for
the latest distribution of Puppy is compiled to an EXE before installing it.

## How to Use

Open up your .iso, and put the sfs, intrd.gz, vmlinuz and any other needed files (like "zdrv_123.sfs") into the "puppyFiles" folder.

Next, open up "Settings.nsh" in a text editor, and fill in the info there. Make sure you save it!

Now open up NSIS (C:\Program Files\NSIS\makensisw.exe), then drag "main.nsi" into the box.

Your installer will then be created, and put into the same folder as main.nsi.
