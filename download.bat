@echo off
setlocal EnableDelayedExpansion

@powershell -NoProfile -Command "Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force"


set cacheFolder=cache
if not exist %cacheFolder% (
mkdir %cacheFolder%
)

:: RefreshEnv.cmd
set download_01=download	%cacheFolder%\RefreshEnv.cmd	https://raw.githubusercontent.com/chocolatey/chocolatey/master/src/redirects/RefreshEnv.cmd

:: Chocolatey install file
set download_02=download	%cacheFolder%\installChocolatey.ps1	https://chocolatey.org/install.ps1

:: dot net version 4.5
set download_03=Reg	HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full	Release	378389	http://download.microsoft.com/download/b/a/4/ba4a7e71-2906-4b2d-a0e1-80cf16844f5f/dotnetfx45_full_x86_x64.exe

:: dot net 4.5.1 windows 8.1 2012 r2
::set download_04=Reg	HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full	Release	378675	http://download.microsoft.com/download/1/6/7/167F0D79-9317-48AE-AEDB-17120579F8E2/NDP451-KB2858728-x86-x64-AllOS-ENU.exe

:: dot net 4.5.1 windows 8 and 7
set download_04=Reg	HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full	Release	378758	http://download.microsoft.com/download/1/6/7/167F0D79-9317-48AE-AEDB-17120579F8E2/NDP451-KB2858728-x86-x64-AllOS-ENU.exe

:: dot net 4.5.2 all
set download_05=Reg	HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full	Release	379893	http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe

set download_06=Reg	HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full	Release	378389	http://download.microsoft.com/download/6/F/9/6F9673B1-87D1-46C4-BF04-95F24C3EB9DA/enu_netfx/NDP46-KB3045557-x86-x64-AllOS-ENU_exe/NDP46-KB3045557-x86-x64-AllOS-ENU.exe
set download_07=Reg	HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full	Release	378389	http://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe
set download_08=Reg	HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full	Release	378389	https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe
set download_09=msu	KB4019990	http://download.microsoft.com/download/2/F/4/2F4F48F4-D980-43AA-906A-8FFF40BCB832/Windows8-RT-KB4019990-x64.msu

:: dot net 4.7 everything but 10 creators
rem set download_10=Reg	HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full	Release	460805	http://download.microsoft.com/download/D/D/3/DD35CC25-6E9C-484B-A746-C5BE0C923290/NDP47-KB3186497-x86-x64-AllOS-ENU.exe

:: dot net 4.7 10 creators
rem set download_10=Reg	HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full	Release	460798	http://download.microsoft.com/download/D/D/3/DD35CC25-6E9C-484B-A746-C5BE0C923290/NDP47-KB3186497-x86-x64-AllOS-ENU.exe

set download_11=test	choco /?	n	2
set download_12=psf	%cacheFolder%\installChocolatey.ps1
set download_13=refreshvars
set download_14=test	call npm version	n	2
set download_15=download	%cacheFolder%\node-v6.10.3-x64.msi	https://nodejs.org/dist/v6.10.3/node-v6.10.3-x64.msi
set download_15=msi	%cacheFolder%\node-v6.10.3-x64.msi

rem @powershell -NoProfile -ExecutionPolicy Bypass -File %cacheFolder%\installChocolatey.ps1
rem SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

set skipnext=0
for /f "tokens=2,3,4,5,6,7 usebackq delims==	" %%i in (`set download_`) do (
echo !ERRORLEVEL!
rem start of the loop

if !skipnext! gtr 0 (
rem echo !skipnext!
set /a skipnext+=-1 >nul
echo skipping %%i %%j %%k %%l %%m %%n
rem set skip next to false
) else (
rem echo not skipping %%i %%j %%k %%l %%m %%n
if %%i==download (
if not exist %%j echo downloading %%k&@powershell -NoProfile -ExecutionPolicy Bypass -Command "(New-Object System.Net.WebClient).DownloadFile('%%k', '%%j')" & if not !ERRORLEVEL!==0 echo error downloading %%k &EXIT /B !ERRORLEVEL!
)
rem end of download

if %%i==Reg (
for /f "tokens=3* delims= " %%! in ('Reg.exe QUERY "%%j" /v "%%k" ^|Findstr.exe /ri "%%k"') do (
set /a v=%%!
if !v! geq %%l (
echo already installed %%m
) else (
:: now it needs to be potentially downloaded and installed
echo install %%m

set url=%%m
set f=%%~nxm
set download=%cacheFolder%\!f!
if not exist !download! echo downloading !url!&@powershell -NoProfile -ExecutionPolicy Bypass -Command "(New-Object System.Net.WebClient).DownloadFile('!url!', '!download!')" & if not !ERRORLEVEL!==0 echo error downloading !url!&EXIT /B !ERRORLEVEL!
echo installing from !download!
start /wait !download! /norestart /passive /showrmui
if not !ERRORLEVEL!==0 echo failed while trying to install !download!&exit /b !ERRORLEVEL!
)
)
)
rem end of reg

if %%i==msu (
rem echo %%i
rem echo %%j
rem echo %%k
wmic qfe get hotfixid | findstr "%%j" >nul 2>&1
if !ERRORLEVEL!==0 (
echo already installed %%k
) else (
echo needs to install %%k
set url=%%k
set f=%%~nxk
set fol=%%~nk
set download=%cacheFolder%\!f!
set expanded=%cacheFolder%\!fol!

if not exist !download! echo downloading !url!&@powershell -NoProfile -ExecutionPolicy Bypass -Command "(New-Object System.Net.WebClient).DownloadFile('!url!', '!download!')" & if not !ERRORLEVEL!==0 echo error downloading !url!&EXIT /B !ERRORLEVEL!

if not exist !expanded! (
mkdir !expanded!
)

expand -F:* "!download!" "!expanded!"
start /wait DISM.exe /Online /Add-Package /PackagePath:"!expanded!\!fol!.cab" /Quiet /NoRestart
if not !ERRORLEVEL!==0 echo failed while trying to install "!expanded!\!fol!.cab"&exit /b !ERRORLEVEL!

if exist !expanded! rmdir /q /s !expanded!
)
)
rem end of msu

if %%i==test (
set skipnext=%%l
if [%%l]==[] set skipnext=1
%%j 2>nul 1>nul
if !ERRORLEVEL!==0 (
if [%%k]==[y] set skipnext=0
) else (
if not [%%k]==[y] set skipnext=0
)
)
rem end of test

if %%i==psf (
@powershell -NoProfile -ExecutionPolicy Bypass -File %%j
)
rem end of power script file

if %%i==refreshvars (
call %cacheFolder%\RefreshEnv.cmd
)
rem end of refreshvars

if %%i==msi (
echo errorlevel !ERRORLEVEL!
start /wait %%j /quiet
echo errorlevel !ERRORLEVEL!
if not !ERRORLEVEL!==0 (
echo failed while trying to install "%%j"
exit /b !ERRORLEVEL!
)
)
rem end of refreshvars

)
rem end of skipnext

)

exit /b 0

