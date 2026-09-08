# INDEX

One-line map of this workspace.
Root: this folder is itself a git repo; AND several folders below
(3-Documentation/, 4-SBox-Resources-Subway-Map/, 3-Documentation/2-Docs-Github-Repo/, and the
project clones under 2-Projects/) are separate git clones nested inside it, retrieved via /8-Scripts/.

0-Builds/ -         Drop folder for standalone game exports.
1-Engine-Builds/ -  S&Box engine source checkouts.
    /Dev/ -             Holds a curated sbox-public fork maintained by CSEliot & Co. See its own README.
    /Steam/ -           Symbolic link to the live Steam-installed sbox-editor folder.
    /Vanilla/ -         Clean sbox-public clone for sanity-testing against stock engine behavior.

3-Documentation/ -  All reference docs and researched knowledge.
    /1-API/ -               Scraped per-type API reference (Class/Enum/Interface/Struct), plus schema_downloader.py.
    /2-Docs-Github-Repo/ -  Local clone of the official sbox.game manual (docs/).
    /3-Research/ -          Non-project-specific lessons learned and deep-dive notes (see its own list below).

4-SBox-Resources-Subway-Map/ - Clone of the community "Subway Map" index of external sbox resources.
    8-Scripts/ -        Setup/maintenance scripts, paired Linux .sh + Windows .bat per task.
    9-Archive/ -        Dead/superseded docs kept for reference (e.g. old Linux-Proton build guide).
    2-Projects/ -       Working area of project clones and scratch copies (gitignored).
