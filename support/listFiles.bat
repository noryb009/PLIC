@echo off
cd puppyfiles
echo Function InstallFiles > ..\src\fileList.nsh
for %%G in (*) DO (
  echo File "puppyFiles\%%G" >> ..\src\fileList.nsh
)
echo FunctionEnd >> ..\src\fileList.nsh

echo Function un.unInstallFiles >> ..\src\fileList.nsh
for %%G in (*) DO (
  echo Delete "$INSTDIR\%%G" >> ..\src\fileList.nsh
)
echo FunctionEnd >> ..\src\fileList.nsh

cd ..
