!macro mSeeIfCompatible un
Function ${un}SeeIfCompatible
  ;value
  push $R9

  ;call
  call ${un}findWinVersion
  pop $R9
  StrCmp $R9 '9x' +5
  StrCmp $R9 'NT' +4
  StrCmp $R9 '7' +3
    MessageBox MB_OK|MB_ICONQUESTION "Your windows version is not compatible with this program." IDOK
    quit
  
  ;return to before
  pop $R9
FunctionEnd
!macroend
!insertmacro mSeeIfCompatible ""
!insertmacro mSeeIfCompatible "un."

!macro mCheckIfAdmin un
Function ${un}CheckIfAdmin
  ;back up
  push $R9
  ;see if admin
  userInfo::getAccountType
  pop $R9
  strCmp $R9 "Admin" +3
  
  ;not admin
  messageBox MB_OK "You must be an administrator to use this program."
  quit
  ;is admin
  pop $R9
FunctionEnd
!macroend
!insertmacro mCheckIfAdmin ""
!insertmacro mCheckIfAdmin "un."

#Function UnpackSevenZip
#SetOutPath "%temp%"
#File "${SUPPORT}7z.exe"
#File "${SUPPORT}7z.sfx"
#FunctionEnd

Function UnzipPuppy
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  call InstallFiles ; in fileList.nsh, generated from listFiles.bat
FunctionEnd

Function MakeReadme
#fill readme.txt
  FileOpen $0 $INSTDIR\readme.txt w ;Opens a Empty File an fills it
  FileWrite $0 'To run Puppy Linux, just reboot. When your computer comes back on, you will see a screen asking if you want to run windows, or Puppy Linux.$\r$\n'
  FileWrite $0 'Press down then enter to select Puppy Linux.$\r$\n$\r$\n'

  FileWrite $0 'To uninstall Puppy Linux, just go to Start > All Programs > ${PRODUCT_NAME} ${PRODUCT_VERSION} > Uninstall.$\r$\n'
  FileClose $0 ;Closes the filled file
FunctionEnd



Function InstallGrubAndConfigureMenu
  ;check if GRUB is installed
  IfFileExists 'C:\boot\grub\grub.exe' DontInstallGRUB
  IfFileExists 'C:\grldr' DontInstallGRUB

  call findWinVersion
  pop $R9

  ;GRUB isn't installed, find out
  strcmp $R9 '9x' Win9x
  strcmp $R9 'NT' WinNT
  strcmp $R9 '7' Win7
  
  
  DontInstallGRUB:
  call GrubAlreadyInstalled
  return
#Configure GRUB4DOS
  

  #95/98/ME
Win9x:
  call Win9x
  call CreateMenuLst
  return

  #NT/XP/Server 2003
WinNT:
  call WinNT
  call CreateMenuLst
  return

  #Vista/7/Server 2008
Win7:
  call Win7
  call CreateMenuLst
FunctionEnd
