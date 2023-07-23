REM This needs to be placed in the root of the installation folder to works properly and prevent errors
REM (tends cause error with "npm start" when meilisearch path is not root)
REM
REM Warning: The termination of services is "aggressive" an will kill all instances of node.exe
REM 
REM if you want to fill this manually replace the following variables with your own values: 
REM _finaldir=<put your install directory here> 
REM _MEILIMASTERKEY=<put your MeiliSearch master key here>

echo off
title LibreChat
setlocal enabledelayedexpansion

set _finaldir=$final_dir
set _MEILIMASTERKEY=$MEILI_MASTER_KEY

set _APPPID=
set "logfile=%_finaldir%\ngrok.log"
set "search=url="
set url=unavailable

for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a

:menu
cls
echo. %ESC%[38;2;255;128;0m
echo ===========================================================
echo +=+=+=+=+=+=+=+=+=+=+=+={LibreChat}=+=+=+=+=+=+=+=+=+=+=+=+
echo -----------------------------------------------------------
echo  {Press Ctrl+Shift+R or Ctrl+F5 on the LibreChat page}
echo           {to clear cache files after an update!}
echo ===========================================================
echo.
echo Select an option:
echo.
echo 1) start the server (local)
echo 2) start the server (local with public access)
echo 3) Update the project
echo 4) Exit
echo.
set /p choice=Type your choice and hit ENTER: 
echo.
if "%choice%"=="1" goto start_local
if "%choice%"=="2" goto start_public
if "%choice%"=="3" goto update
if "%choice%"=="4" goto exit
if "%choice%"=="x" goto menu2
goto menu

:menu2
cls
echo. %ESC%[38;2;255;128;0m
echo ===========================================================
echo +=+=+=+=+=+=+=+=+=+=+=+={LibreChat}=+=+=+=+=+=+=+=+=+=+=+=+
echo -----------------------------------------------------------
echo {note: if the page is not available wait a bit and refresh}
echo            {it might take a minute if indexing}  
echo ===========================================================
echo %ESC%[38;2;32;100;200mPublic URL: !url!
echo Local URL: http://localhost:3080
echo %ESC%[38;2;255;128;0m===========================================================
echo. 
echo Select an option:
echo.
echo 1) Open the web-app
echo 2) Exit
echo.
set /p choice2=Type your choice and hit ENTER:
echo.
if "%choice2%"=="1" goto web-app
if "%choice2%"=="2" goto exit
if "%choice2%"=="x" goto menu
goto menu2

:start_local
set running=0
tasklist /FI "IMAGENAME eq node.exe" | find /i "node.exe" > nul
if "%ERRORLEVEL%"=="0" (
    set /a running+=1
)

tasklist /FI "IMAGENAME eq meilisearch.exe" | find /i "meilisearch.exe" > nul
if "%ERRORLEVEL%"=="0" (
    set /a running+=1
)

if "%running%" NEQ "0" (
    echo One or more services are already running, they will be terminated before we continue.
    pause
	taskkill /F /IM node.exe > nul 2>&1
	taskkill /F /IM meilisearch.exe > nul 2>&1
	taskkill /F /IM ngrok.exe > nul 2>&1
	goto start_local
	
) else (
	start /MIN cmd /k "meilisearch --master-key %_MEILIMASTERKEY% --max-indexing-memory 8192"
	start /MIN cmd /k "npm run backend"
	goto menu2
)

:start_public
set running=0
tasklist /FI "IMAGENAME eq node.exe" | find /i "node.exe" > nul
if "%ERRORLEVEL%"=="0" (
    set /a running+=1
)

tasklist /FI "IMAGENAME eq meilisearch.exe" | find /i "meilisearch.exe" > nul
if "%ERRORLEVEL%"=="0" (
    set /a running+=1
)

tasklist /FI "IMAGENAME eq ngrok.exe" | find /i "ngrok.exe" > nul
if "%ERRORLEVEL%"=="0" (
    set /a running+=1
)

if "%running%" NEQ "0" (
    echo One or more services are already running, they will be terminated before we continue.
    pause
	taskkill /F /IM node.exe > nul 2>&1
	taskkill /F /IM meilisearch.exe > nul 2>&1
	taskkill /F /IM ngrok.exe > nul 2>&1
	goto start_public
	
) else (
    start "MeiliSearch" /MIN cmd /k "meilisearch --master-key %_MEILIMASTERKEY% --max-indexing-memory 8192"
    start "LibreChat" /MIN cmd /k "npm run backend"

	REM Start ngrok and redirect the output to a file
	start "Public URL" /MIN cmd /k "ngrok http 3080 --log=stdout > ngrok.log &"
	ping 127.0.0.1 -n 4 > nul
	for /f "delims=" %%a in ('findstr /c:"%search%" "%logfile%"') do (
    set "line=%%a"

    rem extract the URL string
    set "start_pos=!line:*url=!"
    set "url=!start_pos:*http=http!"
    echo !url!
	)
    goto menu2
)

:update
set running=0
taskkill /F /IM node.exe > nul 2>&1
taskkill /F /IM meilisearch.exe > nul 2>&1
cls
call npm run update:local
echo update complete 
pause
goto menu

:web-app
start msedge --app=http://localhost:3080
goto menu2

:exit
rem wmic process where 'commandline like "%%node server/index.js%%"' call terminate
taskkill /F /IM node.exe > nul 2>&1
taskkill /F /IM meilisearch.exe > nul 2>&1
taskkill /F /IM ngrok.exe > nul 2>&1
echo bye
pause
taskkill /F /IM cmd.exe > nul 2>&1
exit /b 0
