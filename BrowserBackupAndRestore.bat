@echo off



tasklist /FI "IMAGENAME eq chrome.exe" 2>NUL | find /I /N "chrome.exe">NUL

if "%ERRORLEVEL%"=="0" GOTO CHROMEQUIT

tasklist /FI "IMAGENAME eq firefox.exe" 2>NUL | find /I /N "firefox.exe">NUL

if "%ERRORLEVEL%"=="0" GOTO FFQUIT



ECHO -------------
ECHO Type 1,2 or 3
ECHO -------------
ECHO 1 - Backup
ECHO 2 - Restore
ECHO 3 - Exit
ECHO -------------
ECHO.
SET /P M=Type 1, 2, 3 then press ENTER:
IF %M%==1 GOTO BACKUP
IF %M%==2 GOTO RESTORE
IF %M%==3 GOTO QUIT


:QUIT
EXIT

:CHROMEQUIT
color FC
echo Chrome is running. Please exit and reopen script.
pause
EXIT


:FFQUIT
color FC
echo Firefox is running. Please exit and reopen script.
pause
EXIT


:BACKUP
cls
REM -----------BACKUP-----------
echo -------------------------------------
echo This script will back up all Firefox and Chrome profiles/bookmarks
echo for USER: %USERNAME% 
echo to the Directory: %CD%\%COMPUTERNAME%
echo -------------------------------------
pause

REM Make Directory on jumpdrive
if not exist "%CD%\%COMPUTERNAME%" mkdir "%CD%\%COMPUTERNAME%"




REM ----------CHROME-----------
color 0e

REM Make Directory on jumpdrive for Chrome
if not exist "%CD%\%COMPUTERNAME%\ChromeBackup" mkdir "%CD%\%COMPUTERNAME%\ChromeBackup"

REM Copy Chrome profiles to jumpdrive
xcopy /e /y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default" %CD%\%COMPUTERNAME%\ChromeBackup



REM -----------FIREFOX------------
color 0b

REM Make Directory on jumpdrive for Firefox
if not exist "%CD%\%COMPUTERNAME%\FFBackup" mkdir "%CD%\%COMPUTERNAME%\FFBackup"

REM Copy Firefox profiles to jumpdrive
xcopy /e /y "c:\users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles" %CD%\%COMPUTERNAME%\FFBackup

REM rename firefox profile folder to restore
pushd %CD%\%COMPUTERNAME%\FFBackup
for /D %%j in (*) do move "%%j" "%%~dpj\restore"





color 0a
pause
EXIT



:RESTORE
cls
echo -------------------------------------
echo This script will restore  all firefox and chrome profiles/bookmarks
echo for USER: %USERNAME% 
echo -------------------------------------
pause

REM -----------FIREFOX------------
color 0b

REM Make Directory for Firefox config file
if not exist "c:\users\%USERNAME%\AppData\Roaming\Mozilla\Firefox" mkdir "c:\users\%USERNAME%\AppData\Roaming\Mozilla\Firefox"

REM copy firefox profile redirect file
xcopy /e /y "%CD%\profiles.ini" "C:\Users\%USERNAME%\AppData\Roaming\Mozilla\Firefox"
rd /q/s C:\Users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\%COMPUTERNAME%
rd /q/s C:\Users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles\%COMPUTERNAME%

REM Make Directory for Firefox 
if not exist "c:\users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles" mkdir "c:\users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles"

REM copy firefox profiles
xcopy /e /y "%CD%\%COMPUTERNAME%\FFBackup" c:\users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles

REM ----------CHROME-----------
color 0e

REM Make Directory for Chrome
if not exist "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default" mkdir "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default"

REM copy Chrome bookmarks
xcopy /e /y "%CD%\%COMPUTERNAME%\ChromeBackup" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default"


color 0a
pause 
EXIT