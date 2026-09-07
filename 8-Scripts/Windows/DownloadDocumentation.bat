@echo off
REM Clone the docs/API generator repo into 3-Documentation, then run its updater
REM to pull the manual and regenerate the API reference.
REM
REM Windows equivalent of ..\Linux\DownloadDocumentation.sh
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "REPO_URL=https://github.com/CSEliot/sbox-get-docs-api.git"
set "TARGET_DIR=%SCRIPT_DIR%\..\..\3-Documentation"
set "UPDATER=%TARGET_DIR%\update-all.bat"

where git >nul 2>&1
if errorlevel 1 goto :no_git

echo Downloading all docs from github /CSEliot/sbox-get-docs-api ...
echo.

git clone "%REPO_URL%" "%TARGET_DIR%"
if errorlevel 1 goto :clone_failed

echo.
echo Updating and downloading api ...
echo.

if not exist "%UPDATER%" goto :no_updater

REM update-all.bat anchors itself with %~dp0, so it does not care about the
REM current directory. Any arguments to this script are forwarded to it.
call "%UPDATER%" %*
if errorlevel 1 goto :update_failed

echo.
echo Done.
exit /b 0

:no_git
echo ERROR: git not found on PATH. 1>&2
echo Install Git for Windows: https://git-scm.com/downloads 1>&2
exit /b 1

:clone_failed
echo. 1>&2
echo ERROR: clone failed. If the folder already exists it must be empty. 1>&2
echo   %TARGET_DIR% 1>&2
exit /b 1

:no_updater
echo ERROR: updater not found at %UPDATER% 1>&2
echo The clone succeeded but looks incomplete. 1>&2
exit /b 1

:update_failed
echo. 1>&2
echo ERROR: update-all.bat failed. The docs clone is in place; re-run it 1>&2
echo directly to see the failure: %UPDATER% 1>&2
exit /b 1
