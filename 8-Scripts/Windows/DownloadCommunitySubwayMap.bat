@echo off
REM Clone Sbox-Resources, the community "Subway Map" index of where things are.
REM
REM Windows equivalent of ..\Linux\DownloadCommunitySubwayMap.sh
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "REPO_URL=https://github.com/CSEliot/sbox-resources"
set "TARGET_DIR=%SCRIPT_DIR%\..\..\4-SBox-Resources-Subway-Map"

where git >nul 2>&1
if errorlevel 1 goto :no_git

echo Downloading Sbox-Resources, a Community Subway Map of 'where is this thing?'
echo.

git clone "%REPO_URL%" "%TARGET_DIR%"
if errorlevel 1 goto :clone_failed

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
