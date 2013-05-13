;settings
!include "Settings.nsh"

; folders and files
!define SUPPORT "support\"
!define SRC "src\"
!define UNINSTALLLOG "Uninstall.log"

;functions for functions
!include "${SRC}InternalFunctions.nsh"

;x64 bit check (needed for GRUB install on vista/7)
!include "x64.nsh"

;functions for installing and configuring GRUB
!include "${SRC}InstallGrubFunctions.nsh"
!include "${SRC}un_UninstallGrubFunctions.nsh"

;functions
!include "${SRC}Functions.nsh"
!include "${SRC}un_Functions.nsh"

;find files to install
!execute "support\listFiles.bat"
!include "src\fileList.nsh"

; MUI 2 compatible ------
!include "MUI2.nsh"

; MUI Settings
!define MUI_ABORTWARNING
;icons
!define MUI_ICON "${SUPPORT}Puppy Linux Install.ico"
!define MUI_UNICON "${SUPPORT}Puppy Linux Uninstall.ico"
;side image
!define MUI_WELCOMEFINISHPAGE_BITMAP "${SUPPORT}Side Image.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${SUPPORT}Side Image.bmp"

!define MUI_PAGE_HEADER_TEXT "${PRODUCT_NAME} ${PRODUCT_VERSION}"
!define MUI_PAGE_HEADER_SUBTEXT ""

; Welcome page
!define MUI_WELCOMEPAGE_TITLE "${PRODUCT_NAME} ${PRODUCT_VERSION} Setup"
!define MUI_WELCOMEPAGE_TEXT "This wizard will install ${PRODUCT_NAME} ${PRODUCT_VERSION}.$\r$\n$\r$\nPress Install to start the installation."
!insertmacro MUI_PAGE_WELCOME

; Instfiles page
!insertmacro MUI_PAGE_INSTFILES

; Finish page
!define MUI_FINISHPAGE_TITLE "Installation complete!"
!define MUI_FINISHPAGE_TEXT "${PRODUCT_NAME} ${PRODUCT_VERSION} has installed successfully.$\r$\n$\r$\nTo run ${PRODUCT_NAME} ${PRODUCT_VERSION}, you must reboot and select $\"Start Puppy Linux$\" from the menu."
;reboot
!define MUI_FINISHPAGE_TEXT_REBOOT "Would you like to reboot now to run ${PRODUCT_NAME} ${PRODUCT_VERSION}?"
!define MUI_FINISHPAGE_TEXT_REBOOTNOW "Reboot Now"
!define MUI_FINISHPAGE_TEXT_REBOOTLATER "Reboot Later"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME} ${PRODUCT_VERSION}.exe"
InstallDir "C:\${INSTALL_DIR}"
RequestExecutionLevel admin

# for Vista/7
Section .onInit
call SeeIfCompatible
call CheckIfAdmin
SectionEnd

Section "MainSection" SEC01
  ;get settings from user (where and how to install)


  ;unzip 7-zip
  ;call UnpackSevenZip

  ;unzip Puppy Linux from the ISO
  call UnzipPuppy
  
  ;configure GRUB4DOS
  call InstallGrubAndConfigureMenu

  ;make readme
  call MakeReadme
  
  ;ask to reboot
  SetRebootFlag true
SectionEnd






Section -AdditionalIcons
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME} ${PRODUCT_VERSION}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME} ${PRODUCT_VERSION}\README.lnk" "$INSTDIR\readme.txt"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME} ${PRODUCT_VERSION}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_THAT_SHOWS_IN_REMOVE_PROGRAMS}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_THAT_SHOWS_IN_REMOVE_PROGRAMS}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_THAT_SHOWS_IN_REMOVE_PROGRAMS}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_THAT_SHOWS_IN_REMOVE_PROGRAMS}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_THAT_SHOWS_IN_REMOVE_PROGRAMS}" "Publisher" "${PRODUCT_PUBLISHER}"
  
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd



Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd



Section Uninstall
SetShellVarContext all
  call un.CheckIfAdmin
  call un.SeeIfCompatible

  call un.deleteFiles
  
  call un.deleteGrub
  
  MessageBox MB_YESNO "Do you want to delete your save file?" IDNO +4
    delete "$INSTDIR\*.2fs"
    delete "$INSTDIR\*.3fs"
    delete "$INSTDIR\*.4fs"
  
  call un.deleteLinks
  
  SetRebootFlag true
SectionEnd
