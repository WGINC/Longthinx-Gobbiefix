@echo off
rem uninstall.bat [/yes] [/nopause] [FOLDER] -- Longthinx gobbiefix: removes what install.bat put in the PlayOnlineViewer
rem folder and puts back the d3d8.dll that was there (d3d8_before_kit.dll). The .ini files and logs stay.
rem Administrator rights as install.bat (V0.7.1): double-click it; it lists what it will remove, asks Y/N, and asks
rem Windows for administrator rights only if it cannot write in the folder.
setlocal
set "SRC=%~dp0files"
set "YES=" & set "NOPAUSE=" & set "ELEV=" & set "DST=" & set "RC=0"
:args
if "%~1"=="" goto argsdone
if /i "%~1"=="/yes" (set "YES=1" & shift & goto args)
if /i "%~1"=="/nopause" (set "NOPAUSE=1" & shift & goto args)
if /i "%~1"=="/elevated" (set "ELEV=1" & shift & goto args)
set "DST=%~1"
shift
goto args
:argsdone
if "%DST%"=="" set "DST=C:\Program Files (x86)\PlayOnline\SquareEnix\PlayOnlineViewer"
:look
if "%DST:~-1%"=="\" set "DST=%DST:~0,-1%"
if exist "%DST%\kit_installed.txt" goto found
echo  Pshhh... gobbie no smell gobbiefix in "%DST%" (no kit_installed.txt).
if defined YES goto notinstalled
set "ASK="
set /p "ASK= Youuu tell gobbie the PlayOnlineViewer folder (paste it, then Enter; just Enter = stop): "
if not defined ASK goto notinstalled
set "DST=%ASK:"=%"
goto look
:found
tasklist /fi "imagename eq pol.exe" | find /i "pol.exe" >nul
if not errorlevel 1 goto running
if defined ELEV goto work
echo(
echo  Gobbie do this in "%DST%", and nothing else:
pushd "%SRC%"
for %%f in (*.dll *.exe *.txt) do if exist "%DST%\%%f" echo    - take away %%f
popd
if exist "%DST%\gfx_recon_ingame.dll" echo    - take away gfx_recon_ingame.dll (an older gobbiefix's)
if exist "%DST%\d3d8_before_kit.dll" echo    - put the old d3d8.dll back (from d3d8_before_kit.dll)
if exist "%DST%\gobbiefix_debug.on" echo    - take away gobbiefix_debug.on
echo    - take away kit_installed.txt
echo    - leave the .ini files and logs
echo(
if defined YES goto confirmed
choice /c YN /n /m " Gobbie go ahead? Y = yes, N = no: "
if errorlevel 2 goto declined
:confirmed
call :canwrite
if not errorlevel 1 goto work
if defined ELEV goto cannotwrite
goto elevate
:work
pushd "%SRC%"
for %%f in (*.dll *.exe *.txt) do if exist "%DST%\%%f" del /q "%DST%\%%f"
popd
if exist "%DST%\gfx_recon_ingame.dll" del /q "%DST%\gfx_recon_ingame.dll"
if exist "%DST%\d3d8_before_kit.dll" move /y "%DST%\d3d8_before_kit.dll" "%DST%\d3d8.dll" >nul
del /q "%DST%\kit_installed.txt"
if exist "%DST%\gobbiefix_debug.on" del /q "%DST%\gobbiefix_debug.on"
echo  Pshhh... gobbie packystow the shinybits. Old d3d8.dll come back outta the sack.
echo  Shkohhh... gobbie leave the .ini files and logs, in case youuu want gobbie back.
echo  Byebye, adventurer! Pshhh...
goto done
:elevate
echo  Shkohhh... that folder is a lockybox: Windows let only an administrator write in it.
echo  Windows ask youuu now, in its own box, if this may make changes. Say Yes, and gobbie workyfix in a new window.
set "GOBBIE_SELF=%~f0"
set "GOBBIE_DST=%DST%"
set "GOBBIE_FLAGS=/elevated /yes"
powershell -NoProfile -Command "$q=[char]34; $a='/c '+$q+$q+$env:GOBBIE_SELF+$q+' '+$env:GOBBIE_FLAGS+' '+$q+$env:GOBBIE_DST+$q+$q; try { Start-Process -FilePath $env:ComSpec -ArgumentList $a -Verb RunAs -ErrorAction Stop } catch { exit 1 }"
if errorlevel 1 goto nouac
echo  Gobbie workyfix in the new window. This one can close.
goto done
:nouac
echo  Pshhh... Windows say no (or youuu did). Gobbie no touchy anything.
set "RC=1"
goto done
:declined
echo  Okay. Gobbie stay. Pshhh...
set "RC=1"
goto done
:cannotwrite
echo  Pshhh! Even as administrator gobbie no could write in "%DST%". Nothing changed.
set "RC=2"
goto done
:notinstalled
echo  Nothing to take.
set "RC=2"
goto done
:running
echo  Shkohhh! Game still running! Youuu close it first, then gobbie workyfix.
set "RC=2"
goto done
:done
if defined NOPAUSE exit /b %RC%
echo(
pause
exit /b %RC%
rem (exit code 1: there is no write access; 0: a test file was made and deleted)
:canwrite
copy /y nul "%DST%\gobbiefix_write_test.tmp" >nul 2>&1
if not exist "%DST%\gobbiefix_write_test.tmp" exit /b 1
del /q "%DST%\gobbiefix_write_test.tmp" >nul 2>&1
exit /b 0
