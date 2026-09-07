# INDEX

One-line map of this workspace. Root: this folder is itself a git repo; several folders below
(3-Documentation/, some projects) are separate clones nested inside it.

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
  MEMORY.md - index/map of this folder, grouped by topic.
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
  sbox-editor-stale-assembly.md - editor may run the old assembly after Code/ edits; force a recompile first.
  sbox-textrenderer-empty-clear.md - TextRenderer won't clear on Text=""; toggle GameObject.Enabled.
  sbox-localhost-network-gate.md - localhost dev server blocked by PORT not hostname; use 8080 or -allowlocalhttp.
  dev-toolchain-paths.md - PATH/SBOX_ROOT exports needed on this machine before any dotnet/sbox build.
  sbox-game-code-conventions.md - shared game-code style + *-verify compile-gate pattern across all game projects.

2-Projects/ project list:
  MySampleProj/ - placeholder showing the expected project layout (.sbproj, Assets/, Code/,
    Documentation/ for that project's own lesson files).
  kingofgamesmuseum/ - Rubixo game; Node backend in Server/. Two working copies exist in a full
    checkout (original on branch steam-independent, plus a -B-Branch clone on main).
  terrygotchi/ - Tamagotchi-style game project.

Per-project lesson files live in each project's own Documentation/ subfolder. Anything tied to one
project belongs there, not in 3-Documentation/3-Research/:
  kingofgamesmuseum/Documentation/ - kingofgamesmuseum-editor-mcp.md (which working copy the editor
    MCP server can drive + the 2026-07-10 verification log), kingofgamesmuseum-shader-examples.md
    (the glow_pulse_outline worked example and the vendored community shader packages).
  terrygotchi/Documentation/ - terrygotchi-xml-doc-tooltips.md (the SessionConfig doc-comment pass
    and how to catch CS1570 offline), terrygotchi-inline-todos-origin.md (the incident behind the
    workspace-wide ignore-inline-todos rule).

Content formerly in the long root CLAUDE.md/AGENTS.md is now fully distributed above (project-specific
into each project folder, generic into 3-Documentation/3-Research/). CLAUDE.md is gone; AGENTS.md
remains at root but is only a one-line stance pointing here.
