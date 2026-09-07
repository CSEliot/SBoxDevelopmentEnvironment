@echo off
REM Clone the stock Facepunch/sbox-public engine tree into 1-Engine-Builds\Vanilla,
REM the clean checkout kept for sanity-testing against unmodified engine behavior.
REM
REM Windows equivalent of ..\Linux\DownloadFacePunchRepository.sh
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "REPO_URL=https://github.com/Facepunch/sbox-public"
set "TARGET_DIR=%SCRIPT_DIR%\..\..\1-Engine-Builds\Vanilla\sbox-public"

where git >nul 2>&1
if errorlevel 1 goto :no_git

echo Downloading the sbox-public FacePunch via git clone ...
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
