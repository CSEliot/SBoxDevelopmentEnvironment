@echo off
REM Create the 1-Engine-Builds\Steam link, pointing at the Steam-installed s&box
REM editor so the live install is reachable from inside this workspace.
REM
REM Safe to re-run. An existing correct link is left alone; an existing wrong
REM link is repointed. A real directory is never deleted.
REM
REM Usage:
REM   MakeSteamRef.bat                     auto-detect the editor
REM   MakeSteamRef.bat C:\path\to\editor   use an explicit path, skipping detection
REM
REM The SBOX_EDITOR environment variable does the same as passing a path.
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "LINK_PATH=%SCRIPT_DIR%\Steam"
set "EDITOR_DIRNAME=sbox-editor"

set "HR=-----------------------------------------------------------------------"

echo.
echo %HR%
echo  Steam reference link
echo %HR%
echo   Link to create : %LINK_PATH%
echo   Looking for    : %EDITOR_DIRNAME%
echo.

REM ---------------------------------------------------------------------------
REM Resolve the target directory.
REM
REM An explicit path always wins: argument first, then the environment variable.
REM ---------------------------------------------------------------------------

set "TARGET="
set "EXPLICIT=%~1"
if not defined EXPLICIT set "EXPLICIT=%SBOX_EDITOR%"

if defined EXPLICIT goto :use_explicit
goto :autodetect

:use_explicit
call :info "Explicit path supplied, skipping auto-detection."
if not exist "%EXPLICIT%\" (
    call :fail "Not a directory: %EXPLICIT%"
    exit /b 1
)
for %%I in ("%EXPLICIT%") do set "TARGET=%%~fI"
call :ok "Using: !TARGET!"
goto :have_target

REM ---------------------------------------------------------------------------
REM Find the editor install.
REM
REM Steam can spread games across several libraries on different drives, so the
REM registry path is only the starting point. Every Steam root also holds a
REM libraryfolders.vdf listing the others; those get scanned too.
REM ---------------------------------------------------------------------------

:autodetect
echo Scanning for Steam libraries ...

set /a ROOT_COUNT=0

REM Steam records its install location in the registry. This is the reliable
REM source; the hardcoded guesses below are only a fallback.
for /f "tokens=2,*" %%a in ('reg query "HKCU\Software\Valve\Steam" /v SteamPath 2^>nul ^| find "SteamPath"') do (
    set "REG_PATH=%%b"
)
if defined REG_PATH (
    REM The registry stores forward slashes. Normalize them.
    set "REG_PATH=!REG_PATH:/=\!"
    call :add_root "!REG_PATH!" "registry"
)

for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\WOW6432Node\Valve\Steam" /v InstallPath 2^>nul ^| find "InstallPath"') do (
    set "REG_PATH64=%%b"
)
if defined REG_PATH64 (
    set "REG_PATH64=!REG_PATH64:/=\!"
    call :add_root "!REG_PATH64!" "registry"
)

REM The usual install locations, in case the registry keys are missing.
call :add_root "%ProgramFiles(x86)%\Steam" "default location"
call :add_root "%ProgramFiles%\Steam" "default location"
call :add_root "C:\Steam" "default location"

if %ROOT_COUNT% EQU 0 (
    call :warn "No Steam root found in the registry or the usual locations."
    goto :search_libraries
)

REM Each root's libraryfolders.vdf lists every other library, including ones on
REM external drives. Pull the "path" values out of it.
set /a I=0
:vdf_loop
if %I% GEQ %ROOT_COUNT% goto :search_libraries
set "THIS_ROOT=!ROOT_%I%!"
for %%V in ("!THIS_ROOT!\steamapps\libraryfolders.vdf" "!THIS_ROOT!\config\libraryfolders.vdf") do (
    if exist "%%~V" (
        for /f "tokens=1,* delims=	 " %%p in ('type "%%~V" ^| find /i "path"') do (
            set "LIB=%%~q"
            if defined LIB (
                REM The vdf stores escaped backslashes. Unescape them.
                set "LIB=!LIB:\\=\!"
                if exist "!LIB!\" (
                    call :add_root "!LIB!" "libraryfolders.vdf"
                ) else (
                    call :warn "Library listed but not mounted: !LIB!"
                )
            )
        )
    )
)
set /a I+=1
goto :vdf_loop

:search_libraries
echo.
echo Searching those libraries for the editor ...
set /a I=0
:search_loop
if %I% GEQ %ROOT_COUNT% goto :searched
set "THIS_ROOT=!ROOT_%I%!"
set "CANDIDATE=!THIS_ROOT!\steamapps\common\%EDITOR_DIRNAME%"
if exist "!CANDIDATE!\" (
    call :ok "Found: !CANDIDATE!"
    if not defined TARGET set "TARGET=!CANDIDATE!"
) else (
    call :info "Not here: !CANDIDATE!"
)
set /a I+=1
goto :search_loop

:searched
if not defined TARGET (
    echo.
    call :fail "Could not find '%EDITOR_DIRNAME%' in any Steam library."
    call :fail "Install the s^&box editor through Steam, or pass the path directly:"
    call :fail "    MakeSteamRef.bat C:\path\to\steamapps\common\%EDITOR_DIRNAME%"
    exit /b 1
)

:have_target
for %%I in ("%TARGET%") do set "TARGET=%%~fI"
if "%TARGET:~-1%"=="\" set "TARGET=%TARGET:~0,-1%"

echo.
call :info "Link target resolved to: %TARGET%"

REM A quick sanity check. Not fatal, since the layout may change.
set "FOUND_EXE="
for %%E in ("%TARGET%\*.exe") do if not defined FOUND_EXE set "FOUND_EXE=%%~nxE"
if defined FOUND_EXE (
    call :ok "Editor executable present: %FOUND_EXE%"
) else (
    call :warn "No .exe found in there. Linking anyway, but double-check it."
)

REM ---------------------------------------------------------------------------
REM Create the link.
REM ---------------------------------------------------------------------------

echo.
echo Creating the link ...

if not exist "%LINK_PATH%" goto :make_link

REM Distinguish a link from a real directory. /a:l lists reparse points only, so
REM a bare listing filtered to an exact name match tells us which one this is.
set "IS_LINK="
for /f "delims=" %%L in ('dir /a:l /b "%SCRIPT_DIR%" 2^>nul') do (
    if /i "%%L"=="Steam" set "IS_LINK=1"
)

if not defined IS_LINK (
    call :fail "%LINK_PATH% is a real directory, not a link."
    call :fail "Something is actually stored there. Move or delete it yourself, then"
    call :fail "re-run this script. Refusing to delete it for you."
    exit /b 1
)

call :info "A link already exists here."
call :info "Repointing it at the resolved target ..."
echo   [ run] rmdir "%LINK_PATH%"
rmdir "%LINK_PATH%"
if exist "%LINK_PATH%" (
    call :fail "Could not remove the existing link. Close anything using it and retry."
    exit /b 1
)

:make_link
REM Try a real symlink first. Outside Developer Mode that needs elevation, so
REM fall back to a directory junction, which never does and behaves the same for
REM a local path like this one.
echo   [ run] mklink /D "%LINK_PATH%" "%TARGET%"
mklink /D "%LINK_PATH%" "%TARGET%" >nul 2>&1
if not errorlevel 1 (
    call :ok "Symbolic link created."
    goto :verify
)

call :info "Symlink refused (needs Developer Mode or an admin prompt)."
call :info "Falling back to a directory junction, which needs neither."
echo   [ run] mklink /J "%LINK_PATH%" "%TARGET%"
mklink /J "%LINK_PATH%" "%TARGET%" >nul 2>&1
if errorlevel 1 (
    call :fail "Could not create a link at %LINK_PATH%"
    call :fail "Check the target path and that you can write to %SCRIPT_DIR%"
    exit /b 1
)
call :ok "Directory junction created."

:verify
if not exist "%LINK_PATH%\" (
    call :fail "Link created but does not resolve to a directory. Check the target."
    exit /b 1
)

echo.
echo %HR%
echo  Done.
echo %HR%
echo   %LINK_PATH%
echo     -^> %TARGET%
echo.
echo   Contents visible through the link:
set /a SHOWN=0
set /a TOTAL_ENTRIES=0
for /f "delims=" %%F in ('dir /b "%LINK_PATH%" 2^>nul') do (
    set /a TOTAL_ENTRIES+=1
    if !SHOWN! LSS 8 (
        echo     %%F
        set /a SHOWN+=1
    )
)
if %TOTAL_ENTRIES% EQU 0 echo     (empty)
if %TOTAL_ENTRIES% GTR 8 (
    set /a EXTRA=%TOTAL_ENTRIES%-8
    echo     ... and !EXTRA! more entries
)
echo.
exit /b 0

REM ===========================================================================
REM Subroutines
REM ===========================================================================

:info
echo   [info] %~1
exit /b 0

:ok
echo   [ ok ] %~1
exit /b 0

:warn
echo   [warn] %~1
exit /b 0

:fail
echo   [FAIL] %~1 1>&2
exit /b 0

REM Add a Steam root to the list, skipping duplicates.
REM %1 = path, %2 = where it came from (for the log line)
:add_root
set "NEW=%~1"
if "%NEW%"=="" exit /b 0
if "%NEW:~-1%"=="\" set "NEW=%NEW:~0,-1%"
if not exist "%NEW%\" exit /b 0
set /a J=0
:dedupe_loop
if %J% GEQ %ROOT_COUNT% goto :dedupe_done
set "EXISTING=!ROOT_%J%!"
if /i "!EXISTING!"=="%NEW%" exit /b 0
set /a J+=1
goto :dedupe_loop
:dedupe_done
set "ROOT_%ROOT_COUNT%=%NEW%"
set /a ROOT_COUNT+=1
call :info "Steam library (%~2): %NEW%"
exit /b 0
