Function un.checkIfCompatible
  userInfo::getAccountType  #see if admin (goes to stack)
    pop $0
    strCmp $0 "Admin" +3

    #not admin
    messageBox MB_OK "You must be an administrator to install this program. Debug: return from userInfo::getAccountType: $0"
    quit
FunctionEnd

Function un.deleteFiles
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\readme.txt"
  
  call un.unInstallFiles ; in fileList.nsh, generated from listFiles.bat
FunctionEnd

Function un.deleteLinks
Delete "$SMPROGRAMS\${PRODUCT_NAME} ${PRODUCT_VERSION}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME} ${PRODUCT_VERSION}\README.lnk"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME} ${PRODUCT_VERSION}"
  RMDir "$INSTDIR"

  DeleteRegValue ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_THAT_SHOWS_IN_REMOVE_PROGRAMS}" "DisplayName"
  DeleteRegValue ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_THAT_SHOWS_IN_REMOVE_PROGRAMS}" "UninstallString"
  DeleteRegValue ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_THAT_SHOWS_IN_REMOVE_PROGRAMS}" "DisplayVersion"
  DeleteRegValue ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_THAT_SHOWS_IN_REMOVE_PROGRAMS}" "URLInfoAbout"
  DeleteRegValue ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_THAT_SHOWS_IN_REMOVE_PROGRAMS}" "Publisher"


  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_THAT_SHOWS_IN_REMOVE_PROGRAMS}"

  ;check if you can delete folder
  ClearErrors
        ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_UP_ONE}" 'BootID'
        IfErrors 0 UNend

strcpy $R1 "0"
; Check for a key
ClearErrors
EnumRegValue $R0 ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY_UP_ONE} "$R1"
iferrors +3
  IntOp $R1 $R1 + 1
  StrCmp $R0 "BootID" +2 -3

;delete if not found
DeleteRegKey /ifempty ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_UP_ONE}"

UNend:
  SetAutoClose true
FunctionEnd
