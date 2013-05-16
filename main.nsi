; Settings
!include "Settings.nsh"

; Folders and files
!define SUPPORT "support\"
!define SRC "src\"
!define LANG "lang\"

!define MUI_LANGDLL_ALWAYSSHOW
!define MUI_LANGDLL_ALLLANGUAGES

; Functions for functions
!include "${SRC}InternalFunctions.nsh"

; x64 bit check (needed for GRUB install on vista/7)
!include "x64.nsh"

; Functions for installing and configuring GRUB
!include "${SRC}InstallGrubFunctions.nsh"
!include "${SRC}un_UninstallGrubFunctions.nsh"

; Functions
!include "${SRC}Functions.nsh"
!include "${SRC}un_Functions.nsh"

; Find files to install
!execute "support\listFiles.bat"
!include "src\fileList.nsh"

; EXE Info
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME} ${PRODUCT_VERSION}.exe"
InstallDir "C:\${INSTALL_DIR}"
RequestExecutionLevel admin

; MUI 2
!include "MUI2.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_CUSTOMFUNCTION_GUIINIT guiInit
!define MUI_CUSTOMFUNCTION_UNGUIINIT un.guiInit
; Icons
!define MUI_ICON "${SUPPORT}Puppy Linux Install.ico"
!define MUI_UNICON "${SUPPORT}Puppy Linux Uninstall.ico"
; Side image
!define MUI_WELCOMEFINISHPAGE_BITMAP "${SUPPORT}Side Image.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${SUPPORT}Side Image.bmp"

; Welcome page
!define MUI_WELCOMEPAGE_TITLE "$(welcomeTitle)"
!define MUI_WELCOMEPAGE_TEXT "$(welcomeText)"
!insertmacro MUI_PAGE_WELCOME
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_TITLE "$(finishTitle)"
; Reboot
!define MUI_FINISHPAGE_TEXT_REBOOT "$(rebootQuestion)"
!define MUI_FINISHPAGE_TEXT_REBOOTNOW "$(rebootNow)"
!define MUI_FINISHPAGE_TEXT_REBOOTLATER "$(rebootLater)"
!insertmacro MUI_PAGE_FINISH
; Uninstall page
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!include "${LANG}lang.nsh"
!insertmacro MUI_RESERVEFILE_LANGDLL

; Install sections

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY ; Ask user for language
FunctionEnd

Function guiInit
  Call SeeIfCompatible ; See if bootloader is supported
  Call CheckIfAdmin ; make sure the user has admin privileges
FunctionEnd

Section "MainSection" SEC01
  ; Unzip 7-zip
  ;Call UnpackSevenZip

  ; Unzip Puppy Linux from the ISO
  Call UnzipPuppy
  
  ; Configure GRUB4DOS
  Call InstallGrubAndConfigureMenu

  ; Make readme
  Call MakeReadme
  
  ; Ask to reboot
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

; Uninstall sections

Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE
FunctionEnd

Function un.guiInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(un_confirm)" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(un_success)"
FunctionEnd

Section Uninstall
  SetShellVarContext all
  Call un.SeeIfCompatible
  Call un.CheckIfAdmin

  Call un.deleteFiles ; Delete files
  Call un.deleteGrub ; Delete GRUB4DOS
  
  MessageBox MB_YESNO "$(un_delSaveFile)" IDNO +4
    Delete "$INSTDIR\*.2fs"
    Delete "$INSTDIR\*.3fs"
    delete "$INSTDIR\*.4fs"

  Call un.deleteLinks

  SetRebootFlag true
SectionEnd
