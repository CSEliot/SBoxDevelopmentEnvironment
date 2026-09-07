# INDEX

One-line map of this workspace. Root: /home/cseliot/1-Development/1-SBox is itself a git repo;
several folders below (3-Documentation/, 4-SBox-Resources-Subway-Map/, some projects) are
separate clones nested inside it.

AGENTS.md - one-line workspace stance, points back here. ToDo.md - scratch personal todo list,
not project-scoped.

0-Builds/ - drop folder for standalone game exports (MyGame1, MyGame2 placeholders).
1-Engine-Builds/ - s&box engine source checkouts.
  Dev/ - working/dev engine environment, actively modified (Linux build fixes, PR candidates);
    holds two trees, ampersand/ and sbox-public/. See its own README.
  Steam/ - symlink to the live Steam-installed sbox-editor.
  Vanilla/ - clean sbox-public clone for sanity-testing against stock engine behavior.
3-Documentation/ - all reference docs and researched knowledge.
  1-API/ - scraped per-type API reference (Class/Enum/Interface/Struct), plus schema_downloader.py.
  2-Docs-Github-Repo/ - local clone of the official sbox.game manual (docs/).
  3-Research/ - non-project-specific lessons learned and deep-dive notes (see its own list below).
4-SBox-Resources-Subway-Map/ - clone of the community "Subway Map" index of external sbox resources.
9-Archive/ - dead/superseded docs kept for reference (e.g. old Linux-Proton build guide).
2-Projects/ - all project clones and scratch copies, one subfolder each (see project list below).

3-Documentation/3-Research/ contents (grab-bag of engine/tooling lessons, not tied to one project):
  MEMORY.md - misc distilled lessons snapshot.
  SBox-For-Developers.md, SBox-Quirks.md - engine quirks not obvious from official docs.
  ignore-inline-todos.md - don't act on in-code TODOs unless user names them.
  planmode-answer-before-exitplan.md - answer clarifying questions before calling ExitPlanMode.
  reread-before-edit-parallel-sessions.md - re-check file state before editing, user runs parallel sessions.
  rider-mcp.md - Rider MCP server: tool list, rootFolder requirement, vs sbox editor MCP.
  sbox-editor-mcp.md, sbox-editor-mcp-server.md - the sbox editor's own MCP server (scene/console/play state).
  sbox-inspector-tooltips.md - Inspector tooltips come from XML <summary>, not [Description].
  sbox-stale-api-sources.md - recalled Sandbox.* API is unreliable, verify against 1-API/ and 2-Docs-Github-Repo/.
  multithreading-in-sbox-editor.md - threading model/pitfalls in the editor.
  networking.md - s&box networking research notes.
  shader-authoring-in-sbox.md - shader authoring deep dive.
  agent-behavior-conventions.md - standing AI-agent tone/attribution/tool-usage rules (from old root CLAUDE.md/AGENTS.md).
  sbox-docs-mirror.md - which local doc mirrors to check before WebSearch, and how to refresh them.
  sbox-standalone-no-menu.md - standalone exports have no built-in pause menu/settings modal.
  dev-toolchain-paths.md - PATH/SBOX_ROOT exports needed on this machine before any dotnet/sbox build.
  sbox-game-code-conventions.md - shared game-code style + *-verify compile-gate pattern across all game projects.

2-Projects/ project list:
  1-SecBox-Core/ - primary .NET security scanner project (Secbox.slnx), own git repo.
  2-SecBox/ - not a project, holds updatePrefixFromDev (Linux rsync into the Proton prefix).
  kingofgamesmuseum/ - Rubixo game; Node backend in Server/.
  kingofgamesmuseum-B-Branch/ - same repo as above, second working copy.
  terrygotchi/ - Tamagotchi-style game project.
  mysweeper/, sweeper/, sbox-scenestaging/, sbox-bombroyale/, howtosandbox/, frontendtest/,
    securitytesting/, settings-gui/, reduce_size/ - other/smaller game or experiment repos.
  deletemeking/, deletemeproj2/, deletemeproj3/, deteteme3/, terrygotchi - Copy/,
    terrygotchi-backup.7z, sbox-linux/ - scratch/dead, do not edit.

Per-project lesson files (moved out of the old IMPORT_ME import folder, kept alongside each project):
  kingofgamesmuseum/Documentation/ - kingofgamesmuseum-overview.md, kingofgamesmuseum-clones.md,
    kingofgamesmuseum-compile-check.md, kingofgamesmuseum-cube-state.md, kingofgamesmuseum-music-bug.md,
    kingofgamesmuseum-ws-protocol.md, reread-before-edit-parallel-sessions.md, rider-mcp-rootfolder.md,
    sbox-localhost-network-gate.md.
  kingofgamesmuseum-B-Branch/ - kingofgamesmuseum-b-branch-overview.md, kingofgamesmuseum-clones.md,
    kingofgamesmuseum-compile-check.md (at project root, not in a Documentation/ subfolder).
  terrygotchi/ - terrygotchi-overview.md, terrygotchi-build-state.md, terrygotchi-compile-check.md,
    sbox-editor-stale-assembly.md.
  1-SecBox-Core/ - secbox-architecture-notes.md (component layout, CI/CD, dev-drop; project's own
    README/CONTRIBUTING/docs/ are still primary).
  2-SecBox/ - updateprefixfromdev-stale-path.md (verified bug: hardcoded source path is stale).
  mysweeper/ - mysweeper-overview.md.
  sbox-scenestaging/ - sbox-scenestaging-overview.md.
  sbox-bombroyale/ - sbox-bombroyale-overview.md.
  securitytesting/ - securitytesting-overview.md.

Content formerly in the long root CLAUDE.md/AGENTS.md is now fully distributed above (project-specific
into each project folder, generic into 3-Documentation/3-Research/). CLAUDE.md is gone; AGENTS.md
remains at root but is only a one-line stance pointing here.
