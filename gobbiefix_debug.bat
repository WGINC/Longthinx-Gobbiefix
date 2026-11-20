@echo off
rem gobbiefix_debug.bat [on|off] [/nopause] [FOLDER] -- Longthinx gobbiefix: debug mode. on: makes the file
rem gobbiefix_debug.on in the PlayOnlineViewer folder (FOLDER, or the usual place); off: deletes it. At the next start
rem d3d8.dll sees it (as debug=1 in gobbiefix.ini) and puts the statistics lines in the logs (d3d8on11.ini log_stats=1,
rem speedfix.ini stats_every=60); without it, and debug=0, they stay out. Takes effect at the game's next start.
rem V0.7.1: double-clicked (no on/off) it asks which; it asks Windows for administrator rights only if it cannot write
rem in the folder (as install.bat).
setlocal
set "V=" & set "NOPAUSE=" & set "ELEV=" & set "DST=" & set "RC=0"
:args
if "%~1"=="" goto argsdone
if /i "%~1"=="on" (set "V=1" & shift & goto args)
if /i "%~1"=="off" (set "V=0" & shift & goto args)
if /i "%~1"=="/nopause" (set "NOPAUSE=1" & shift & goto args)
if /i "%~1"=="/elevated" (set "ELEV=1" & shift & goto args)
set "DST=%~1"
shift
goto args
:argsdone
if "%DST%"=="" set "DST=C:\Program Files (x86)\PlayOnline\SquareEnix\PlayOnlineViewer"
if "%DST:~-1%"=="\" set "DST=%DST:~0,-1%"
if not exist "%DST%\kit_installed.txt" goto noini
if defined V goto chosen
choice /c 10Q /n /m " Pshhh... gobbie debug: 1 = on, 0 = off, Q = never mind: "
if errorlevel 3 goto done
if errorlevel 2 (set "V=0") else set "V=1"
:chosen
call :canwrite
if not errorlevel 1 goto work
if defined ELEV goto failed
echo  Shkohhh... the gamefolder is a lockybox: Windows let only an administrator write in it.
echo  Windows ask youuu now, in its own box, if this may make changes. Say Yes, and gobbie do it in a new window.
set "GOBBIE_SELF=%~f0"
set "GOBBIE_DST=%DST%"
set "GOBBIE_FLAGS=/elevated off"
if "%V%"=="1" set "GOBBIE_FLAGS=/elevated on"
powershell -NoProfile -Command "$q=[char]34; $a='/c '+$q+$q+$env:GOBBIE_SELF+$q+' '+$env:GOBBIE_FLAGS+' '+$q+$env:GOBBIE_DST+$q+$q; try { Start-Process -FilePath $env:ComSpec -ArgumentList $a -Verb RunAs -ErrorAction Stop } catch { exit 1 }"
if errorlevel 1 goto nouac
echo  Gobbie do it in the new window. This one can close.
goto done
:work
if "%V%"=="1" >"%DST%\gobbiefix_debug.on" echo gobbiefix debug mode: d3d8.dll sees this file and writes the statistics lines
if "%V%"=="0" if exist "%DST%\gobbiefix_debug.on" del /q "%DST%\gobbiefix_debug.on"
if "%V%"=="1" if not exist "%DST%\gobbiefix_debug.on" goto failed
if "%V%"=="0" if exist "%DST%\gobbiefix_debug.on" goto failed
if "%V%"=="1" echo  Pshhh... Debug on! Gobbie scribblywrite lotsa stats in d3d8on11.log and xikit.log next gamestart.
if "%V%"=="0" echo  Shkohhh... Debug off. Gobbie keep logs shortytidy next gamestart.
echo  Logs is in "%DST%".
goto done
:nouac
echo  Pshhh... Windows say no (or youuu did). Nothing changed.
set "RC=1"
goto done
:noini
echo  Shkohhh... gobbie no smell gobbiefix in "%DST%". Youuu install gobbiefix first: install.bat
echo  (Game somewhere else? gobbiefix_debug.bat on "C:\path\to\PlayOnlineViewer")
set "RC=2"
goto done
:failed
echo  Pshhh! Gobbie no could scribble in the gamefolder. Nothing changed.
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
