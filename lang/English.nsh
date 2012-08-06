!insertmacro MUI_LANGUAGE "English" ; 3: Change this to !insertmacro MUI_LANGUAGE "YourLanguage"

; 4: Replace ${LANG_ENGLISH} with ${LANG_YOUR_LANGUAGE} in this file


; 5: Convert English strings below to your language
; Interface
LangString welcomeTitle ${LANG_ENGLISH} "${PRODUCT_NAME} ${PRODUCT_VERSION} Setup"
LangString welcomeText ${LANG_ENGLISH} "This wizard will install ${PRODUCT_NAME} ${PRODUCT_VERSION}.$\r$\n$\r$\nClick Install to start the installation."

LangString finishTitle ${LANG_ENGLISH} "Installation complete!"
LangString rebootQuestion ${LANG_ENGLISH} "Would you like to reboot now to run ${PRODUCT_NAME} ${PRODUCT_VERSION}?"
LangString rebootNow ${LANG_ENGLISH} "Reboot Now"
LangString rebootLater ${LANG_ENGLISH} "Reboot Later"

; Messages
LangString un_confirm ${LANG_ENGLISH} "Are you sure you want to completely remove $(^Name) and all of its components?"
LangString un_success ${LANG_ENGLISH} "$(^Name) was successfully removed from your computer."

LangString un_delSaveFile ${LANG_ENGLISH} "Do you want to delete your save file?"
LangString un_deleteGrub ${LANG_ENGLISH} "Do you want to delete GRUB? If you have any other Linux installations using it, click no. Otherwise, click yes. (If in doubt, just click YES)"

; Errors
LangString unknownWinVer ${LANG_ENGLISH} "Unknown windows version. Please report this in the forum."
LangString notCompatibleWinVer ${LANG_ENGLISH} "Your windows version is not compatible with this program."
LangString mustBeAdmin ${LANG_ENGLISH} "You must be an administrator to use this program."

LangString errorFileNotFound_1 ${LANG_ENGLISH} "Error:" ; part 1
LangString errorFileNotFound_2 ${LANG_ENGLISH} "not found." ; part 2

LangString aborting ${LANG_ENGLISH} "The software installation will stop now."

LangString cantFindMenuLst ${LANG_ENGLISH} "GRUB is installed on your computer, but the installer can$\'t find menu.lst. Please manually add the following to it:"

LangString errorWriteRegistry ${LANG_ENGLISH} "Error: Could not write to the registry."

LangString un_errorNoBootId ${LANG_ENGLISH} "Error: Could not find the BootID in the registry."

; Readme File
LangString readme_ln_1 ${LANG_ENGLISH} "To run Puppy Linux, just reboot. When your computer comes back on, you will see a screen asking if you want to run windows, or Puppy Linux.$\r$\n"
LangString readme_ln_2 ${LANG_ENGLISH} "Press down then enter to select Puppy Linux.$\r$\n"
LangString readme_ln_3 ${LANG_ENGLISH} "$\r$\n"
LangString readme_ln_4 ${LANG_ENGLISH} "To uninstall Puppy Linux, just go to Start > All Programs > ${PRODUCT_NAME} ${PRODUCT_VERSION} > Uninstall.$\r$\n"
