# Hi. To make a functional puppy linux installer,
# you just have to edit a few things.
# I have included default (aka. backup) lines. Do not edit these.
# You can copy and paste them over the current lines
# if you make a mistake.

# What directory is “Puppy Linux Installer Creator” in? If it's
# in C:\Puppy Linux Installer Creator, then put down C:\Puppy Linux Installer Creator\
# In Wine, you can mount “/” as “Z:\”, and use
# the hard drive by using “Z:\mnt\sda1\Puppy Linux Installer Creator\”
# YOU MUST INCLUDE A SLASH AT THE END!
# default: !define PLICDIR "C:\Puppy Linux Installer Creator\"
!define PLICDIR "C:\Puppy Linux Installer Creator\"

# First, define what SFS your puppy uses
# default: !define PUPPY_SFS "lupu-520.sfs"
!define PUPPY_SFS "lupu_520.sfs"

# The next 2 settings are self-explanatory

# default: !define PRODUCT_NAME "Puppy Linux"
!define PRODUCT_NAME "Puppy Linux"

# default: !define PRODUCT_VERSION "520"
!define PRODUCT_VERSION "520"

# Next, choose where puppy linux will be installed to. This
# can NOT have spaces.
# default: !define INSTALL_DIR "Puppy-Linux-520"
!define INSTALL_DIR "Puppy-Linux-520"

# If you only need initrd.gz, vmlinuz and the
# main sfs, your done editing this script! Go back to
# HOW TO MAKE AN INSTALLER.txt and follow the rest
# of the instructions. Otherwise, keep going.

Function in #dont delete this line
/*
  Take your extra file(s) name(s) and
  replace the "extra file.txt" in the example,
  and put them under the "#ADD MORE FILES IF NEEDED HERE (for installer)"
  example:
    File "${PLICDIR}extra file.txt"
*/
#ADD MORE FILES IF NEEDED HERE (for installer)







# Almost done... (don't delete the next 2 lines)
FunctionEnd
Function un.uninstall
/*
  Take your extra file(s) name(s) and
  replace the "extra file.txt" in the example,
  and put them under the "#ADD MORE FILES IF NEEDED HERE (for uninstaller)"
  example:
    Delete "$INSTDIR\extra file.txt"
*/
#ADD MORE FILES IF NEEDED HERE (for uninstaller)







# Your done! Go back to HOW TO
# MAKE AN INSTALLER.txt and read the rest of it.
FunctionEnd #don't delete this line



