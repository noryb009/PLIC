Function un.deleteGrub
#if found, do nothing
IfFileExists 'C:\boot\grub\grub.exe' +2
IfFileExists 'C:\grldr' 0 NoDeleteGRUB

#see if folder is empty
; Check for Key
EnumRegKey $R0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_UP_ONE}" "0"
;if not found, something funny happend (there has to be 1 for the current install)
StrCmp $R0 "" NoDeleteGRUB 0
;if not found, ask to delete

;you have to have 2 entrys, the one is for the current install
EnumRegKey $R0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_UP_ONE}" "1"
;if found, just remove the entry
StrCmp $R0 "" 0 NoDeleteGRUB
;if not found, ask to delete
MessageBox MB_YESNO "$(un_deleteGrub)" IDNO NoDeleteGRUB
  call un.findWinVersion
  pop $R9
  strcmp $R9 '9x' Win9xUN
  strcmp $R9 'NT' WinNTUN
  strcmp $R9 '7' Win7UN

  #95/98/ME
Win9xUN:
    Delete "C:\boot\grub\grub.exe"
    Delete "C:\menu.lst"
    Delete "C:\Grub_GUI.gz"
    RMDir "C:\boot\grub"
    RMDir "C:\boot"

  iffileexists "C:\config.sys.backup" YesConfigsysBackup
  strcpy $0 "C:\config.sys"    ;file to replace in
  strcpy $1 ""    ;line to be added
  strcpy $2 "menuitem=PUPLINUX, Start Puppy Linux"    ;line to be found

  ClearErrors

  FileOpen $R0 "$0" a
  iferrors unERRORNoConfigsys
  FileOpen $R1 temp.ini w

    FileRead $R0 $R2
    IfErrors +15
;trim string
    strcpy $R3 "$R2"
    push $R3
    Push "6"
    Push ""
      call un.TrimText
    pop $R3

;search for a string
    StrCmp "$2" $R3 +4 0
    StrCmp "$2$\r$\n" $R3 +5 0
;not found yet
    Filewrite $R1 "$R2"
    GOTO -11
;change a line
    Filewrite $R1 "$1"
    GOTO -13
    Filewrite $R1 "$1"
    GOTO -15
;done
    FileClose $R0
    FileClose $R1
  ;use the temp to replace the original file
  Delete "$0"
  CopyFiles temp.ini "$0"
  Delete "$OUTDIR\temp.ini"


  return
YesConfigsysBackup:

    setFileAttributes C:\config.sys NORMAL
    setFileAttributes C:\config.sys.backup NORMAL
    
    delete "C:\config.sys"
    CopyFiles "C:\config.sys.backup" "C:\config.sys"

    setFileAttributes C:\config.sys HIDDEN|SYSTEM|READONLY
    setFileAttributes C:\config.sys.backup HIDDEN|SYSTEM|READONLY

    return

    unERRORNoConfigsys:
      messagebox MB_OK "$(errorFileNotFound_1) config.sys $(errorFileNotFound_2)"
      return

  #NT/XP/Server 2003
WinNTUN:
    Delete "C:\grldr"
    Delete "C:\menu.lst"
    Delete "C:\Grub_GUI.gz"
    #remove entry from boot.ini
    setFileAttributes C:\boot.ini NORMAL
    ClearErrors
    Push '$\r$\nc:\grldr="${WHAT_TO_CALL_ON_BOOT}"$\r$\n'                #-- line to be found
    Push ""                #-- line to be added
    Push "C:\boot.ini"     #-- file to be searched in
    Call un.INIChgLine

   ClearErrors
    Push 'c:\grldr="${WHAT_TO_CALL_ON_BOOT}"$\r$\n'                #-- line to be found
    Push ""                #-- line to be added
    Push "C:\boot.ini"     #-- file to be searched in
    Call un.INIChgLine
    setFileAttributes C:\boot.ini HIDDEN|SYSTEM|READONLY

    return

  #Vista/7/Server 2008
Win7UN:
    Delete "C:\grldr"
    Delete "C:\grldr.mbr"
    Delete "C:\menu.lst"
    Delete "C:\Grub_GUI.gz"

    #id = registry.get_value('HKEY_LOCAL_MACHINE',self.info.registry_key,'VistaBootDrive')
    clearerrors
    ReadRegStr $5 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_UP_ONE}" "BootID"
    #if not id:
    #log.debug("Could not find bcd id")
    #log.debug("Removing bcd entry %s" % id)
    strcmp "" $5 0 +3
    messagebox MB_OK "$(un_errorNoBootId)"
    return

    iferrors 0 +3
    messagebox MB_OK "$(un_errorNoBootId)"
    return

    ;bcdedit location for 32/64 bit
    strcpy $1 "bcdedit"

    ;64 bit
    ${If} ${RunningX64}
      strcpy $1 "$WINDIR\Sysnative\bcdedit.exe"
    ${EndIf}
    
    #command = [bcdedit, '/delete', id , '/f']
    #run_command(command)
    nsExec::Exec  '"$1" /delete $5'
;   ${If} ${RunningX64}
;     MessageBox MB_OK "running on x64"
;   ${EndIf}

    #registry.set_value('HKEY_LOCAL_MACHINE',self.info.registry_key,'VistaBootDrive',"")
    DeleteRegValue ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_UP_ONE}" "BootID"

    return

#else
NoDeleteGRUB:
    IfFileExists C:\menu.lst rootuninstall
    IfFileExists C:\boot\grub\menu.lst bootgrubuninstall
    goto CantFinduninstall
rootuninstall:
      Push 'title ${PRODUCT_NAME} ${PRODUCT_VERSION}$\r$\nfind --set-root --ignore-floppies /${INSTALL_DIR}/initrd.gz$\r$\nkernel /${INSTALL_DIR}/vmlinuz psubdir="${INSTALL_DIR}"$\r$\ninitrd /${INSTALL_DIR}/initrd.gz$\r$\nboot$\r$\n'                #-- line to be found
      Push ""                #-- line to be added
      Push "C:\menu.lst"     #-- file to be searched in
        Call un.DeleteFromMenuLst #delete entry
    return
bootgrubuninstall:
      Push 'title ${PRODUCT_NAME} ${PRODUCT_VERSION}$\r$\nfind --set-root --ignore-floppies /${INSTALL_DIR}/initrd.gz$\r$\nkernel /${INSTALL_DIR}/vmlinuz psubdir="${INSTALL_DIR}"$\r$\ninitrd /${INSTALL_DIR}/initrd.gz$\r$\nboot$\r$\n'                #-- line to be found
      Push ""                #-- line to be added
      Push "C:\boot\grub\menu.lst"     #-- file to be searched in
        Call un.DeleteFromMenuLst #delete entry
      return
CantFinduninstall:
    messagebox MB_OK "$(errorFileNotFound_1) menu.lst $(errorFileNotFound_2)"
FunctionEnd

Function un.DeleteFromMenuLst

  Exch $0    ;file to replace in
  Exch
  Exch $1    ;line to be changed
  Exch
  Exch 2
  Exch $2    ;line to be search
  Exch 2

  Push $R0   ;for open file
  Push $R1   ;for temp file
  Push $R2

  Push $R3
  StrCpy $R3 "0"

  ClearErrors

  strcpy $R9 "" #if found

  FileOpen $R0 "$0" a
  FileOpen $R1 temp.ini w
readMOD:
    FileRead $R0 $R2
    IfErrors exitMOD
    strcpy $R8 $R2
    push $R8
    call un.Trim
    pop $R8
    strlen $9 'title ${PRODUCT_NAME} ${PRODUCT_VERSION}'
    strcpy $8 $R8 $9
    strcmp 'title ${PRODUCT_NAME} ${PRODUCT_VERSION}' $8 0 write2
    
    FileRead $R0 $R3
    IfErrors write2
    push $R3
    call un.Trim
    pop $R3
    strlen $9 'find --set-root --ignore-floppies /${INSTALL_DIR}/initrd.gz'
    strcpy $8 $R3 $9
    strcmp 'find --set-root --ignore-floppies /${INSTALL_DIR}/initrd.gz' $8 0 write3

    FileRead $R0 $R4
    IfErrors write3
    push $R4
    call un.Trim
    pop $R4
    strlen $9 'kernel /${INSTALL_DIR}/vmlinuz'
    strcpy $8 $R4 $9
    strcmp 'kernel /${INSTALL_DIR}/vmlinuz' $8 0 write4

    FileRead $R0 $R5
    IfErrors write4
    push $R5
    call un.Trim
    pop $R5
    strlen $9 'initrd /${INSTALL_DIR}/initrd.gz'
    strcpy $8 $R5 $9
    strcmp 'initrd /${INSTALL_DIR}/initrd.gz' $8 0 write5

    FileRead $R0 $R6
    IfErrors write5
    push $R6
    call un.Trim
    pop $R6
    strlen $9 'boot'
    strcpy $8 $R6 $9
    strcmp 'boot' $8 0 write6

    #found
    strcpy $R9 "found"
    goto readMOD

    #not found yet
    write6: #R6
    Filewrite $R1 $R6
    write5: #R5
    Filewrite $R1 $R5
    write4: #R4
    Filewrite $R1 $R4
    write3: #R3
    Filewrite $R1 $R3
    write2: #R2
    Filewrite $R1 $R2
    GOTO readMOD
;done
exitMOD:
    FileClose $R0
    FileClose $R1
  ;use the temp to replace the original file
  strcmp $R9 "found" 0 +5
  Delete "$0"
  CopyFiles temp.ini "$0"
  Delete "$OUTDIR\temp.ini"
  goto +2

  messagebox MB_OK "$(errorFileNotFound_1) menu.lst $(errorFileNotFound_2)"

  POP $R3
  POP $R2
  POP $R1
  pop $R0
  POP $0
  POP $1
  POP $2
  clearerrors
FunctionEnd
