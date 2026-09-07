# Install

How to set up this workspace. Nothing here is automatic and nothing here is
mandatory: each directory is independent, so clone the ones you want and skip
the rest. The numbered prefixes are sort order, not a required sequence.

The workspace root is a plain folder holding several unrelated git clones. It
does not pull them in for you, and there is no submodule wiring.

## What you need

- **git** - <https://git-scm.com/downloads>
- **Python 3.10 or newer** - <https://www.python.org/downloads/>, only for the
  API reference generator in `3-Documentation/`. Skip it if you skip that step.

Nothing else. No pip packages, no SDK, no build step. The engine itself is a
separate concern, see `9-Archive/How-To-Build-For-Linux-Proton.md`.

On Windows, prefer the `py` launcher over `python3`. A bare `python3` is usually
the Microsoft Store stub, which opens the store instead of running anything.
