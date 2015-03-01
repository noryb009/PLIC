#|| goto :batch
#!/bin/bash
cd puppyFiles #
echo "Function InstallFiles" > ../src/fileList.nsh #
for i in *; do [ "x$i" != "x.gitignore" ] && echo "File \"puppyFiles/$i\"" >> ../src/fileList.nsh; done #
echo "FunctionEnd" >> ../src/fileList.nsh #
 #
echo "Function un.unInstallFiles" >> ../src/fileList.nsh #
for i in *; do [ "x$i" != "x.gitignore" ] && echo "Delete \"puppyFiles/$i\"" >> ../src/fileList.nsh; done #
echo "FunctionEnd" >> ../src/fileList.nsh #
 #
cd .. #
exit #
||#
:batch
@echo off
cd puppyfiles
echo Function InstallFiles> ..\src\fileList.nsh
for %%G in (*) DO (
  if not .%%G==..gitignore echo File "puppyFiles\%%G">> ..\src\fileList.nsh
)
echo FunctionEnd>> ..\src\fileList.nsh

echo Function un.unInstallFiles>> ..\src\fileList.nsh
for %%G in (*) DO (
  if not .%%G==..gitignore echo Delete "$INSTDIR\%%G">> ..\src\fileList.nsh
)
echo FunctionEnd>> ..\src\fileList.nsh

cd ..
