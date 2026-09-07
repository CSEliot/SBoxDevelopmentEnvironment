@echo off
REM TODO: Do nothing if \Dev\sbox-public\ already exists and echo as much.
REM
REM Clone the community fork into 1-Engine-Builds\Dev, then run the repo's own
REM setup script to recreate the remote/branch wiring that git never clones.
REM
REM Windows equivalent of ..\Linux\DownloadCommunityRepository.sh
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "REPO_URL=https://github.com/CSEliot/sbox-public"
set "TARGET_DIR=%SCRIPT_DIR%\..\..\1-Engine-Builds\Dev\sbox-public"

where git >nul 2>&1
if errorlevel 1 goto :no_git

echo Cloning /CSEliot/sbox-public/ into 1-Engine-Builds\Dev\sbox-public ...
echo.

git clone "%REPO_URL%" "%TARGET_DIR%"
if errorlevel 1 goto :clone_failed

echo.
echo Cloning success? Running repo setup ...
echo.

REM setup-community-fork.sh ships only as a shell script, and it lives in the
REM sbox-public repo rather than this workspace. Git for Windows installs bash,
REM so run it through that. Nothing else here needs bash.
set "SETUP_SH=%TARGET_DIR%\setup-community-fork.sh"
if not exist "%SETUP_SH%" goto :no_setup

where bash >nul 2>&1
if errorlevel 1 goto :no_bash

bash "%SETUP_SH%"
if errorlevel 1 goto :setup_failed

echo.
echo Repo Setup Success? Done.
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

:no_setup
echo. 1>&2
echo ERROR: setup script not found at %SETUP_SH% 1>&2
echo The clone landed on a branch that does not carry it. It only exists on 1>&2
echo the 'community' branch: 1>&2
echo   cd "%TARGET_DIR%" ^&^& git checkout community 1>&2
exit /b 1

:no_bash
echo. 1>&2
echo ERROR: bash not found on PATH, so the setup script cannot run. 1>&2
echo It is a shell script and has no .bat equivalent. Git for Windows ships 1>&2
echo bash: https://git-scm.com/downloads 1>&2
echo. 1>&2
echo The clone itself succeeded. Once bash is available, finish with: 1>&2
echo   bash "%SETUP_SH%" 1>&2
exit /b 1

:setup_failed
echo. 1>&2
echo ERROR: setup-community-fork.sh failed. The clone is in place; re-run 1>&2
echo the setup directly to see why: 1>&2
echo   bash "%SETUP_SH%" 1>&2
exit /b 1
