@echo off
rem install.bat [/defaults] [/yes] [/nopause] [FOLDER] -- Longthinx gobbiefix: installs into the game's PlayOnlineViewer
rem folder (FOLDER, or the usual place; if the game is not there it asks for the folder). Once installed nothing has to be
rem started before the game: the game loads d3d8.dll from that folder, and d3d8.dll applies gobbiefix.ini and loads the
rem kit (and speedfix) itself when it knows the game's build.
rem Kept: the d3d8.dll that was there (dgVoodoo's) as d3d8_before_kit.dll; your gobbiefix.ini (with /defaults it is
rem replaced, yours kept as gobbiefix.ini.before_gobbiefix). The other .ini files are gobbiefix's own and are replaced
rem (an older one is kept once as NAME.ini.before_gobbiefix). uninstall.bat puts it back.
rem Administrator rights (V0.7.1): it can be double-clicked. It first lists everything it will change and asks Y/N (/yes
rem skips the question). Then it writes a test file in the folder; only if Windows refuses (Program Files is writable by
rem administrators only) does it ask Windows to run it again as administrator, which shows Windows' own permission box,
rem and the work is done in that new window. /nopause: no "press a key" at the end (for running it from another script).
setlocal
set "SRC=%~dp0files"
set "DEF=" & set "YES=" & set "NOPAUSE=" & set "ELEV=" & set "DST=" & set "RC=0"
:args
if "%~1"=="" goto argsdone
if /i "%~1"=="/defaults" (set "DEF=1" & shift & goto args)
if /i "%~1"=="/yes" (set "YES=1" & shift & goto args)
if /i "%~1"=="/nopause" (set "NOPAUSE=1" & shift & goto args)
if /i "%~1"=="/elevated" (set "ELEV=1" & shift & goto args)
set "DST=%~1"
shift
goto args
:argsdone
if "%DST%"=="" set "DST=C:\Program Files (x86)\PlayOnline\SquareEnix\PlayOnlineViewer"
if exist "%~dp0logo.txt" type "%~dp0logo.txt"
:look
if "%DST:~-1%"=="\" set "DST=%DST:~0,-1%"
echo  Pshhh... Shkohhh... Gobbie sniffysnoop for game in "%DST%"...
if exist "%DST%\pol.exe" goto found
if exist "%DST%\polcore.dll" goto found
echo  Pshhh... Hmmm. Gobbie no smell game there.
if defined YES goto nofolder
set "ASK="
set /p "ASK= Youuu tell gobbie the PlayOnlineViewer folder (paste it, then Enter; just Enter = stop): "
if not defined ASK goto nofolder
set "DST=%ASK:"=%"
goto look
:found
tasklist /fi "imagename eq pol.exe" | find /i "pol.exe" >nul
if not errorlevel 1 goto running
echo  Found it! Yesyes. Pshhh...
if defined ELEV goto work
echo(
echo  Gobbie do this in that folder, and nothing else (no registry, no other folder, nothing downloaded):
pushd "%SRC%"
for %%f in (*.dll *.exe *.txt) do echo    - put in %%f
popd
if exist "%DST%\d3d8.dll" if not exist "%DST%\d3d8_before_kit.dll" echo    - keep the d3d8.dll there now as d3d8_before_kit.dll (uninstall.bat put it back)
echo    - put in d3d8on11.ini, speedfix.ini, xikit.ini (gobbie's own; an older one kept once as NAME.ini.before_gobbiefix)
if exist "%DST%\gfx_recon_ingame.dll" echo    - take away gfx_recon_ingame.dll (an older gobbiefix's; this one no need it)
if not exist "%DST%\gobbiefix.ini" echo    - put in gobbiefix.ini (youknobs)
if exist "%DST%\gobbiefix.ini" if defined DEF echo    - put gobbiefix.ini back to gobbieway; yours kept as gobbiefix.ini.before_gobbiefix
if exist "%DST%\gobbiefix.ini" if not defined DEF echo    - leave youuu gobbiefix.ini as it is
echo    - write kit_installed.txt (so uninstall.bat know what is gobbie's)
echo(
if defined YES goto confirmed
choice /c YN /n /m " Gobbie go ahead? Y = yes, N = no: "
if errorlevel 2 goto declined
:confirmed
call :canwrite
if not errorlevel 1 goto work
if defined ELEV goto cannotwrite
set "GOBBIE_FLAGS=/elevated /yes"
if defined DEF set "GOBBIE_FLAGS=/elevated /yes /defaults"
goto elevate
:work
if exist "%DST%\d3d8_before_kit.dll" goto copyfiles
if not exist "%DST%\d3d8.dll" goto copyfiles
copy /y "%DST%\d3d8.dll" "%DST%\d3d8_before_kit.dll" >nul
echo  Old d3d8.dll go in gobbiesack, safeykeep. (d3d8_before_kit.dll)
:copyfiles
rem (wildcards unquoted, from inside the folder: some cmd versions do not expand a quoted pattern)
pushd "%SRC%"
for %%f in (*.dll *.exe *.txt) do copy /y "%%f" "%DST%\" >nul
popd
rem (an older gobbiefix put the reconstruction DLL here; this one runs without it)
if exist "%DST%\gfx_recon_ingame.dll" del /q "%DST%\gfx_recon_ingame.dll"
echo  Shkohhh... gobbie stuff in the shinybits.
for %%f in (d3d8on11.ini speedfix.ini xikit.ini) do if exist "%DST%\%%f" if not exist "%DST%\%%f.before_gobbiefix" copy /y "%DST%\%%f" "%DST%\%%f.before_gobbiefix" >nul
for %%f in (d3d8on11.ini speedfix.ini xikit.ini) do copy /y "%SRC%\%%f" "%DST%\" >nul
if defined DEF if exist "%DST%\gobbiefix.ini" copy /y "%DST%\gobbiefix.ini" "%DST%\gobbiefix.ini.before_gobbiefix" >nul
if defined DEF copy /y "%SRC%\gobbiefix.ini" "%DST%\" >nul
if exist "%DST%\gobbiefix.ini" goto keepknobs
copy /y "%SRC%\gobbiefix.ini" "%DST%\" >nul
echo  Gobbie leave youknobs: gobbiefix.ini. Pokepoke if youuu want.
goto marked
:keepknobs
if not defined DEF echo  Youuu already got gobbiefix.ini. Gobbie no touchy youknobs.
if defined DEF echo  gobbiefix.ini back to gobbieway. Yours wait in gobbiefix.ini.before_gobbiefix.
:marked
>"%DST%\kit_installed.txt" echo installed by Longthinx gobbiefix (install.bat)
echo(
echo  Pshhh... Allfixed! Youuu go play now. Start game sameway as always. Shkohhh...
goto done
:elevate
echo  Shkohhh... that folder is a lockybox: Windows let only an administrator write in it.
echo  Windows ask youuu now, in its own box, if this may make changes. Say Yes, and gobbie workyfix in a new window.
set "GOBBIE_SELF=%~f0"
set "GOBBIE_DST=%DST%"
powershell -NoProfile -Command "$q=[char]34; $a='/c '+$q+$q+$env:GOBBIE_SELF+$q+' '+$env:GOBBIE_FLAGS+' '+$q+$env:GOBBIE_DST+$q+$q; try { Start-Process -FilePath $env:ComSpec -ArgumentList $a -Verb RunAs -ErrorAction Stop } catch { exit 1 }"
if errorlevel 1 goto nouac
echo  Gobbie workyfix in the new window. This one can close.
goto done
:nouac
echo  Pshhh... Windows say no (or youuu did). Gobbie no touchy anything.
set "RC=1"
goto done
:declined
echo  Okay. Gobbie no touchy anything. Pshhh...
set "RC=1"
goto done
:cannotwrite
echo  Pshhh! Even as administrator gobbie no could write in "%DST%". Nothing changed.
set "RC=2"
goto done
:nofolder
echo  Pshhh... Youuu tell gobbie where, like this:
echo      install.bat "C:\path\to\PlayOnlineViewer"
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
