#!/bin/bash
# Create the 1-Engine-Builds/Steam link, pointing at the Steam-installed s&box
# editor so the live install is reachable from inside this workspace.
#
# Safe to re-run. An existing correct link is left alone; an existing wrong link
# is repointed. A real directory is never deleted.
#
# Usage:
#   ./MakeSteamRef.sh                    auto-detect the editor
#   ./MakeSteamRef.sh /path/to/editor    use an explicit path, skipping detection
#
# The SBOX_EDITOR environment variable does the same as passing a path.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LINK_PATH="$SCRIPT_DIR/../../1-Engine-Builds/Steam"
EDITOR_DIRNAME="sbox-editor"

hr() {
    echo "-----------------------------------------------------------------------"
}

info() {
    echo "  [info] $1"
}

ok() {
    echo "  [ ok ] $1"
}

warn() {
    echo "  [warn] $1"
}

fail() {
    echo "  [FAIL] $1" >&2
}

# Resolve a directory to its physical path. 'readlink -f' is GNU; BSD and older
# macOS do not have it, so fall back to cd/pwd, which is POSIX.
resolve_dir() {
    local p="$1"
    if [ -d "$p" ]; then
        (cd "$p" && pwd -P)
    else
        # Broken link: report the raw target rather than nothing.
        readlink "$p" 2>/dev/null || true
    fi
}

# Extract the "path" values from a libraryfolders.vdf. Uses sed rather than
# 'grep -oP', which is a GNU extension that BSD grep does not have.
vdf_paths() {
    sed -n 's/.*"path"[[:space:]]*"\([^"]*\)".*/\1/p' "$1" 2>/dev/null || true
}

echo
hr
echo " Steam reference link"
hr
echo "  Link to create : $LINK_PATH"
echo "  Looking for    : $EDITOR_DIRNAME"
echo

# ---------------------------------------------------------------------------
# Find the editor install.
#
# Steam can spread games across several libraries on different drives, so the
# well-known paths are only the starting point. Every Steam root also holds a
# libraryfolders.vdf listing the others; those get scanned too.
# ---------------------------------------------------------------------------

# Collect candidate library roots into LIBRARY_ROOTS, deduplicated.
LIBRARY_ROOTS=()

add_root() {
    local root="$1" existing
    [ -d "$root" ] || return 0
    for existing in "${LIBRARY_ROOTS[@]:-}"; do
        [ "$existing" = "$root" ] && return 0
    done
    LIBRARY_ROOTS+=("$root")
}

echo "Scanning for Steam libraries ..."

# The usual Steam roots on Linux, including the Flatpak location.
for root in \
    "$HOME/.local/share/Steam" \
    "$HOME/.steam/steam" \
    "$HOME/.steam/root" \
    "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam" \
    "/usr/local/share/Steam" \
    "/usr/share/steam"
do
    if [ -d "$root" ]; then
        info "Found Steam root: $root"
        add_root "$root"
    fi
done

if [ ${#LIBRARY_ROOTS[@]} -eq 0 ]; then
    warn "No Steam root found in the usual locations."
else
    # Each root's libraryfolders.vdf lists every other library, including ones
    # on external drives. Pull the "path" values out of it. Several roots are
    # usually symlinks to the same place, so only report a path the first time.
    REPORTED=()
    already_reported() {
        local p="$1" seen
        for seen in "${REPORTED[@]:-}"; do
            [ "$seen" = "$p" ] && return 0
        done
        REPORTED+=("$p")
        return 1
    }

    for root in "${LIBRARY_ROOTS[@]}"; do
        for vdf in "$root/steamapps/libraryfolders.vdf" "$root/config/libraryfolders.vdf"; do
            [ -f "$vdf" ] || continue
            while IFS= read -r extra; do
                [ -n "$extra" ] || continue
                already_reported "$extra" && continue
                if [ -d "$extra" ]; then
                    info "Library listed in libraryfolders.vdf: $extra"
                    add_root "$extra"
                else
                    warn "Library listed but not mounted: $extra"
                fi
            done < <(vdf_paths "$vdf")
        done
    done
fi

# ---------------------------------------------------------------------------
# Resolve the target directory.
# ---------------------------------------------------------------------------

TARGET=""

# An explicit path always wins: argument first, then the environment variable.
EXPLICIT="${1:-${SBOX_EDITOR:-}}"

if [ -n "$EXPLICIT" ]; then
    echo
    info "Explicit path supplied, skipping auto-detection."
    if [ ! -d "$EXPLICIT" ]; then
        fail "Not a directory: $EXPLICIT"
        exit 1
    fi
    TARGET="$(cd "$EXPLICIT" && pwd)"
    ok "Using: $TARGET"
else
    echo
    echo "Searching those libraries for the editor ..."
    for root in "${LIBRARY_ROOTS[@]:-}"; do
        candidate="$root/steamapps/common/$EDITOR_DIRNAME"
        if [ -d "$candidate" ]; then
            ok "Found: $candidate"
            [ -z "$TARGET" ] && TARGET="$candidate"
        else
            info "Not here: $candidate"
        fi
    done
fi

if [ -z "$TARGET" ]; then
    echo
    fail "Could not find '$EDITOR_DIRNAME' in any Steam library."
    fail "Install the s&box editor through Steam, or pass the path directly:"
    fail "    ./MakeSteamRef.sh /path/to/steamapps/common/$EDITOR_DIRNAME"
    exit 1
fi

# Resolve through any symlinks so the stored target is the real location.
TARGET="$(cd "$TARGET" && pwd -P)"

echo
info "Link target resolved to: $TARGET"

# A quick sanity check. Not fatal, since the layout may change.
FOUND_EXE=""
for exe in "$TARGET"/*.exe; do
    if [ -e "$exe" ]; then
        FOUND_EXE="$(basename "$exe")"
        break
    fi
done
if [ -n "$FOUND_EXE" ]; then
    ok "Editor executable present: $FOUND_EXE"
else
    warn "No .exe found in there. Linking anyway, but double-check it."
fi

# ---------------------------------------------------------------------------
# Create the link.
# ---------------------------------------------------------------------------

echo
echo "Creating the link ..."

if [ -L "$LINK_PATH" ]; then
    CURRENT="$(resolve_dir "$LINK_PATH")"
    info "A link already exists here."
    info "  currently points to: ${CURRENT:-<broken>}"
    if [ "$CURRENT" = "$TARGET" ]; then
        ok "Already correct. Nothing to do."
        echo
        exit 0
    fi
    info "Repointing it to the resolved target ..."
    rm -f "$LINK_PATH"
elif [ -d "$LINK_PATH" ]; then
    fail "$LINK_PATH is a real directory, not a link."
    fail "Something is actually stored there. Move or delete it yourself, then"
    fail "re-run this script. Refusing to delete it for you."
    exit 1
elif [ -e "$LINK_PATH" ]; then
    fail "$LINK_PATH exists and is not a directory or a link."
    fail "Move or delete it, then re-run this script."
    exit 1
fi

echo "  [ run] ln -s \"$TARGET\" \"$LINK_PATH\""
ln -s "$TARGET" "$LINK_PATH"

if [ ! -d "$LINK_PATH" ]; then
    fail "Link created but does not resolve to a directory. Check the target."
    exit 1
fi

ok "Link created."

echo
hr
echo " Done."
hr
echo "  $LINK_PATH"
echo "    -> $(resolve_dir "$LINK_PATH")"
echo
echo "  Contents visible through the link:"
# Capture once rather than piping ls into head: under 'set -o pipefail' a large
# directory would give ls a SIGPIPE when head closed early, and that would kill
# the script on its very last step.
ENTRIES="$(ls -1 "$LINK_PATH" 2>/dev/null || true)"
if [ -z "$ENTRIES" ]; then
    echo "    (empty)"
else
    COUNT=$(printf '%s\n' "$ENTRIES" | wc -l)
    printf '%s\n' "$ENTRIES" | head -8 | sed 's/^/    /'
    if [ "$COUNT" -gt 8 ]; then
        echo "    ... and $((COUNT - 8)) more entries"
    fi
fi
echo
