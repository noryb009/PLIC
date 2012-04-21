Function un.Trim
	Exch $R1 ; Original string
	Push $R2

Loop:
	StrCpy $R2 "$R1" 1
	StrCmp "$R2" " " TrimLeft
	StrCmp "$R2" "$\r" TrimLeft
	StrCmp "$R2" "$\n" TrimLeft
	StrCmp "$R2" "$\t" TrimLeft
	GoTo Loop2
TrimLeft:
	StrCpy $R1 "$R1" "" 1
	Goto Loop

Loop2:
	StrCpy $R2 "$R1" 1 -1
	StrCmp "$R2" " " TrimRight
	StrCmp "$R2" "$\r" TrimRight
	StrCmp "$R2" "$\n" TrimRight
	StrCmp "$R2" "$\t" TrimRight
	GoTo Done
TrimRight:
	StrCpy $R1 "$R1" -1
	Goto Loop2

Done:
	Pop $R2
	Exch $R1
FunctionEnd

Function un.TrimText
 Exch $R9 ; char
 Exch
 Exch $R8 ; length
 Exch 2
 Exch $R7 ; text
 Push $R6
 Push $R5

 StrLen $R6 $R7
 IntCmp $R6 $R8 Done Done

 StrCpy $R7 $R7 $R8

 StrCpy $R6 0
  IntOp $R6 $R6 + 1
  StrCpy $R5 $R7 1 -$R6
  StrCmp $R5 "" Done
  StrCmp $R5 $R9 0 -3

  IntOp $R6 $R6 + 1
  StrCpy $R5 $R7 1 -$R6
  StrCmp $R5 "" Done
  StrCmp $R5 $R9 -3

  IntOp $R6 $R6 - 1
  StrCpy $R7 $R7 -$R6
  StrCpy $R7 $R7

 Done:
 StrCpy $R9 $R7
 Pop $R5
 Pop $R6
 Pop $R7
 Pop $R8
 Exch $R9 ; output
FunctionEnd

Function un.findWinVersion

  Push $R9
  Push $R1

  ClearErrors

  ReadRegStr $R9 HKLM \
  "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion

  IfErrors 0 lbl_winnt

  ; not NT
  ReadRegStr $R9 HKLM \
  "SOFTWARE\Microsoft\Windows\CurrentVersion" VersionNumber

  StrCpy $R1 $R9 1
  StrCmp $R1 '4' 0 lbl_error

  StrCpy $R1 $R9 3
  StrCmp $R1 '4.0' lbl_win32_95
  StrCmp $R1 '4.9' lbl_win32_ME lbl_win32_98

  lbl_win32_95:
    #StrCpy $R9 '95'
    StrCpy $R9 '9x'
    Goto lbl_done

  lbl_win32_98:
    #StrCpy $R9 '98'
    StrCpy $R9 '9x'
    Goto lbl_done

  lbl_win32_ME:
    #StrCpy $R9 'ME'
    StrCpy $R9 '9x'
    Goto lbl_done

  lbl_winnt:

  StrCpy $R1 $R9 1

  StrCmp $R1 '3' lbl_winnt_x
  StrCmp $R1 '4' lbl_winnt_x

  StrCpy $R1 $R9 3

  StrCmp $R1 '5.0' lbl_winnt_2000
  StrCmp $R1 '5.1' lbl_winnt_XP
  StrCmp $R1 '5.2' lbl_winnt_2003
  StrCmp $R1 '6.0' lbl_winnt_vista
  StrCmp $R1 '6.1' lbl_winnt_7 lbl_error

  lbl_winnt_x:
    #StrCpy $R0 "NT $R0" 6
    StrCpy $R9 'NT'
  Goto lbl_done

  lbl_winnt_2000:
    #Strcpy $R9 '2000'
    StrCpy $R9 'NT'
    Goto lbl_done

  lbl_winnt_XP:
    #Strcpy $R9 'XP'
    StrCpy $R9 'NT'
    Goto lbl_done

  lbl_winnt_2003:
    #Strcpy $R9 '2003'
    StrCpy $R9 'NT'
    Goto lbl_done

  lbl_winnt_vista:
    #Strcpy $R9 'Vista'
    Strcpy $R9 '7'
    Goto lbl_done

  lbl_winnt_7:
    #Strcpy $R9 '7'
    Strcpy $R9 '7'
  Goto lbl_done

  lbl_error:
    Strcpy $R9 ''
    MessageBox MB_OK|MB_ICONQUESTION "Your windows version is unknown. Please report this in the forum." IDOK
    quit
  lbl_done:
  Pop $R1
  Exch $R9
FunctionEnd

;-----------------------------------------
; Desc. replace one line after the first instance
; of "something\r\n" is found
;-----------------------------------------
;how to use
;Push "line search"                #-- line to be found
;Push "line replacing"                #-- line to be added
;Push "C:\XXX\XXX.ini"     #-- file to be searched in
;
Function un.INIChgLine

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

  ClearErrors

  FileOpen $R0 "$0" a
  FileOpen $R1 temp.ini w

    FileRead $R0 $R2
    IfErrors +9
;search for a string
    StrCmp "$2" $R2 +4 0
    StrCmp "$2$\r$\n" $R2 +5 0
;not found yet
    Filewrite $R1 $R2
    GOTO -5
;change a line
    Filewrite $R1 "$1"
    GOTO -7
    Filewrite $R1 "$1$\r$\n"
    GOTO -9
;done
    FileClose $R0
    FileClose $R1
  ;use the temp to replace the original file
  Delete "$0"
  CopyFiles temp.ini "$0"
  Delete "$OUTDIR\temp.ini"

  POP $R2
  POP $R1
  pop $R0
  POP $0
  POP $1
  POP $2

FunctionEnd