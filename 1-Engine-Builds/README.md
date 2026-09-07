# README.md

/Dev/ is my custom environment for editor work. See the README there for more info.
/Steam/ is a directory link to the steam downloaded version. If you don't see it, run MakeSteamRef.sh (Linux/macOS) or MakeSteamRef.bat (Windows).
/Vanilla/ is as it sounds. For sanity testing. "CD" into it and just git clone https://github.com/Facepunch/sbox-public

## MakeSteamRef

Finds the Steam-installed sbox-editor and links /Steam/ to it. Re-runnable: an
existing correct link is left alone, a wrong one is repointed, and a real
directory is never deleted.

    ./MakeSteamRef.sh                    # auto-detect
    ./MakeSteamRef.sh /path/to/editor    # explicit path

Auto-detection reads every Steam library, including ones on other drives, from
libraryfolders.vdf. If it cannot find the editor, pass the path directly or set
SBOX_EDITOR. On Windows the .bat uses mklink /D and falls back to a junction
(mklink /J) when symlinks need elevation.
