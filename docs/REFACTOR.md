# Dotfiles Refactor: Audit, Learnings, Migration Plan

Investigation date: 2026-05-19. No code changes yet - this is the plan-of-record.

---

## Part 1: Audit Findings

### Dotbot features unused

| Feature | Use case in this repo |
| --- | --- |
| `backup: true` on links | Safer first-time install over existing files |
| Standalone `create:` directive | Replace inline `mkdir -p ~/.config/kopia` |
| `clean: { ~/.config: { recursive: true } }` | Currently `~` only - dead links under `~/.config/*` never reaped |
| `exclude:` on glob | Fixes waybar host-config selection cleanly |
| `if:` on individual link | Removes need for repeated `defaults: { if: hostname }` sections |
| `mode:` on create | Replace manual `chmod 600` on kopia env |
| `type: hardlink` | Sudoers (kernel refuses symlinks here anyway) |
| `canonicalize: false` | When linking to `/usr/bin/voxtype`-style indirection |
| Link shortcut `~/.vim:` (path auto-derived) | Half the link entries could collapse to one line |
| Shell list shorthand `- [cmd, description]` | Trims `shell:` blocks ~30% |
| YAML anchors / aliases | Reuse the `create:true, glob:true` triplet |

### Dotbot plugins worth pulling in

| Pain point | Plugin |
| --- | --- |
| Inline pacman/AUR install script | [dotbot-paru](https://github.com/michaelray27/dotbot-paru) |
| Inline git config chains | [dotbot-git](https://github.com/DrDynamic/dotbot-git) |
| 9x `sudo cp/ln` inline | [dotbot-sudo](https://github.com/DrDynamic/dotbot-sudo) |
| `tony@nighthawk` baked in fish_variables | [dotbot-template](https://github.com/ssbanerje/dotbot-template) (Jinja) |
| Monolithic 228-line manifest | [dotbot-includes](https://github.com/vanduc2514/dotbot-includes) - split per-app |
| Conditional per host | [dotbot-ifhostname](https://github.com/johnlettman/dotbot-ifhostname) |
| Secret material (kopia env) | [dotbot-age](https://github.com/fcatuhe/dotbot-age) or [dotbot-sops](https://github.com/elogiclab/dotbot-sops) |

### High-severity structural issues
1. **Voyager waybar broken** - `waybar/config_voyager.jsonc` exists, never selected (yaml line 71 globs all waybar/, voyager symlinks nighthawk's config).
2. **No `packages/voyager.txt`** - installer expects it, voyager runs common-only (undocumented).
3. **Host symmetry broken** - nighthawk has wireplumber + DualSense + nighthawk-layout; voyager has none. Wireplumber linked unconditionally, would clobber laptop audio.
4. **Fish prompt hardcoded** - `fish/fish_variables` literally contains `tony@nighthawk` in tide config.
5. **`$(pwd)` in 9 sudo commands** - fragile.

### Medium severity
6. **`clean: ["~"]` too narrow** - doesn't recurse `~/.config`.
7. **Inline shell commands** - greetd/wireguard/gamemode/voxtype/yazi-dbus sudo block (lines 31-42) should be a script.
8. **`scripts/` mixed grab-bag** - bootstrap, bar-handlers, hypr-keybinds, system installers all flat. Only `scripts/vpn/` is subgrouped.
9. **DRY in link blocks** - `create:true, glob:true` repeated 12+ times. Lift into `defaults:`.
10. **`docs/INSTALL.md` drift** - lists packages not in `packages/common.txt`.

### Low severity
11. `wireplumber/main.lua.d.old/` - 8 dead lua backups committed.
12. `streamcontroller/pages/backups/` - autogen timestamped backups.
13. `hypr/host.conf` symlink-in-git noise (dotbot rewrites per host).
14. `userChrome.css` orphan at root, install manual per INSTALL.md (not in yaml).
15. `.tmux.conf` + `.theme.tmux` at root; tmux has no dir.

---

## Part 2: Omarchy Learnings

DHH's [omarchy](https://github.com/basecamp/omarchy) is a full distro project, not pure dotfiles - but several patterns translate.

### Structure
```
omarchy/
├── install.sh           # entry point
├── boot.sh              # bootstrap
├── version              # single version string
├── applications/        # .desktop files
├── bin/                 # 100+ user-facing tools, prefixed omarchy-*
├── config/              # the actual dotfiles (per-app subdirs)
├── default/             # pristine vendor copies (themed reset baseline)
├── install/             # phased install scripts
│   ├── preflight/       # checks
│   ├── packaging/       # pkg install
│   ├── config/          # config link/copy
│   ├── login/           # display manager
│   ├── post-install/    # final wiring
│   ├── first-run/       # one-shot on first boot
│   └── helpers/         # shared shell funcs
├── migrations/          # timestamped upgrade scripts (KEY PATTERN)
├── themes/              # swappable themes (catppuccin, gruvbox, etc)
├── test/
└── AGENTS.md            # AI agent instructions
```

`install.sh` is just:
```bash
source $OMARCHY_INSTALL/helpers/all.sh
source $OMARCHY_INSTALL/preflight/all.sh
source $OMARCHY_INSTALL/packaging/all.sh
source $OMARCHY_INSTALL/config/all.sh
source $OMARCHY_INSTALL/login/all.sh
source $OMARCHY_INSTALL/post-install/all.sh
```

### Patterns worth stealing

1. **Phased install** - clear lifecycle (preflight/packaging/config/post-install). Maps to our needs: pkg install, symlink, sudo, enable services.

2. **`bin/` with prefixed user scripts** - 100+ tools all `omarchy-*`. Prefix ours `dot-*` or `nh-*`. Discoverable: `compgen -c | grep ^dot-`. **ADOPTING.**

3. ~~`migrations/`~~ - **SKIPPED**. Dotbot's `relink: true` + `force: true` + `clean: { recursive: true }` handle symlink churn. Migrations only needed for state dotbot can't see (removed systemd services, renamed configs already in `~/.config`). Edge cases handled with one-time grep-and-fix at the time, not a framework.

4. ~~`themes/`~~ - **SKIPPED**. Locked to Catppuccin Mocha intentionally. No swap mechanism needed.

5. ~~`default/`~~ - **SKIPPED**. Theme reset baseline irrelevant without theme switcher.

6. ~~`version` file~~ - **SKIPPED**. Paired with migrations; no value standalone.

### Tools omarchy has that we don't (consider)

| Tool | Worth adding? |
| --- | --- |
| `lazygit` | Maybe - we have `gh-dash` already |
| `swayosd` | Maybe - on-screen display for volume/brightness (we hand-roll via dunst) |
| `wiremix` | TUI audio mixer (vs pavucontrol GUI) |
| `imv` | Image viewer (no current default?) |
| `xournalpp` | PDF annotation - niche |
| `fcitx5` | Input method - skip unless multi-lang |
| Audio in/out switch scripts | Already have `change_volume.sh` but no source switching |
| Brightness scripts | Voyager (laptop) would benefit |
| Theme switcher | High value - see pattern #4 above |
| Battery monitor scripts | Voyager would benefit |
| Capture pipeline (screenshot/record/OCR) | We have `screenshot.sh`; OCR + screen-record are gaps |

### Tools omarchy doesn't have that we do (keep)
- `voxtype` (voice dictation) - unique to us
- `kopia` (backup) - we have, omarchy doesn't
- `streamcontroller` (Stream Deck) - hardware-specific
- `wireguard` netns VPN - we have full setup, omarchy doesn't
- `gh-dash` (GitHub TUI) - we have
- `posting` (HTTP client) - we have

---

## Part 3: Migration Plan

Two phases. Phase A is safe quick wins. Phase B is the big restructure (#15) using migration scripts so existing installs don't break.

### Phase A: Safe quick wins (no structural changes)

Order matters - each is independent and can be tested in isolation before moving on.

| # | Change | Files touched | Risk |
| --- | --- | --- | --- |
| A1 | Fix voyager waybar (exclude config_voyager from default link, add hostname conditional) | install.conf.yaml | low |
| A2 | Add `packages/voyager.txt` (even empty) + comment | new file | none |
| A3 | Gate wireplumber link behind `if: hostname=nighthawk` | install.conf.yaml | low |
| A4 | Add `~/.config` recursive clean | install.conf.yaml | low |
| A5 | Lift `create:true, glob:true` into top-level `defaults:` (drop ~30 lines) | install.conf.yaml | low |
| A6 | Extract inline sudo block (lines 31-42) into `scripts/bootstrap/install-system-files.sh` | install.conf.yaml + new script | low |
| A7 | Drop `hypr/host.conf` symlink from git index (dotbot rewrites) | git rm + .gitignore | low |
| A8 | Delete `wireplumber/main.lua.d.old/`, gitignore `streamcontroller/pages/backups/` | rm + .gitignore | low |
| A9 | Fish prompt: convert hardcoded tide config to `fish_prompt.fish` function that reads `$hostname` (or use dotbot-template) | fish/ | medium |
| A10 | Reconcile `docs/INSTALL.md` with `packages/common.txt` (single source of truth) | docs/INSTALL.md | low |
| A11 | Subcategorize `scripts/` (bootstrap/, bar/, keybinds/, system/, vpn/) - keep `vpn/` as anchor convention | mv + yaml path updates | low |

Test after each: `./install` on nighthawk, verify clean run. Voyager test once accessible.

### Phase B: Structural refactor (#15) with migration safety

**The risk**: top-level dir renames break absolute paths in linked configs (`source = ~/.config/hypr/...` is fine since dotbot relinks; but anything that references `~/.dotfiles/...` directly breaks).

**The plan**: borrow omarchy's `migrations/` pattern.

#### New top-level layout
```
.dotfiles/
├── install                          # entry point (unchanged)
├── install.conf.yaml                # thin manifest -> meta/includes
├── README.md
├── docs/
├── dotbot/                          # submodule (unchanged)
├── plugins/                         # NEW - dotbot plugins as submodules
│   └── dotbot-includes/
├── meta/                            # NEW - manifest fragments
│   ├── base.yaml                    # defaults, clean
│   ├── hosts/
│   │   ├── nighthawk.yaml
│   │   └── voyager.yaml
│   └── apps/
│       ├── hypr.yaml
│       ├── waybar.yaml
│       ├── fish.yaml
│       └── ...
├── apps/                            # MOVED FROM TOP LEVEL
│   ├── hypr/
│   ├── waybar/
│   ├── fish/
│   ├── nvim/
│   ├── ghostty/
│   ├── tmux/                        # consolidate .tmux.conf + .theme.tmux
│   └── ...
├── system/                          # sudo/root files (unchanged location)
│   ├── pam.d/
│   ├── sudoers.d/
│   ├── systemd/
│   └── udev/
├── scripts/                         # subgrouped (internal/glue scripts)
│   ├── bootstrap/                   # invoked by install.conf.yaml
│   ├── bar/                         # waybar/dunst handlers
│   ├── keybinds/                    # hypr-invoked
│   ├── system/                      # dualsense-init, etc
│   └── vpn/
├── bin/                             # NEW - user-facing CLI, prefixed dot-*, symlinked into PATH
└── packages/
    ├── common.txt
    ├── nighthawk.txt
    └── voyager.txt                  # NEW
```

**`scripts/` vs `bin/` distinction**:
- `scripts/` = internal glue (invoked by dotbot/hypr/waybar/keybinds). Not in PATH.
- `bin/` = user-facing tools (typed by hand). Symlinked into `~/.local/bin/` via dotbot, prefixed `dot-*` for discoverability.

**What stays at root**: `install`, `install.conf.yaml`, `README.md`, `version`, `docs/`, `dotbot/`, top-level dot-files we want as-is (none, ideally - hoist `.tmux.conf`/`.theme.tmux` into `apps/tmux/`).

**What moves**: every app config dir (`hypr/`, `waybar/`, `fish/`, etc) into `apps/<name>/`.

#### Migration strategy (no broken installs)

Step B0: Add `dotbot-includes` plugin as submodule. Validate `./install` still works with no other changes (just routes through new include mechanism on existing flat layout).

Step B1: Single big-bang commit doing the move:
- `git mv hypr/ apps/hypr/`, repeat for each app dir
- Update split yaml fragments in `meta/apps/*.yaml` with new `path:` values
- Add `~/.config: { recursive: true }` to clean directive so dead symlinks under `~/.config` get reaped on next install
- Audit-grep for absolute path references like `~/.dotfiles/<old-path>` in hypr keybinds, fish funcs, waybar scripts - rewrite these inline in the same commit (one-time)

Step B2: On each host, the flow becomes:
1. `git pull` in `~/.dotfiles`
2. `./install` - dotbot does:
   - `clean` with recursive sweep removes old symlinks pointing at now-gone `~/.dotfiles/hypr/` etc
   - relink + force creates new symlinks pointing at `~/.dotfiles/apps/hypr/`
3. Verify with `scripts/post-install-checklist.sh`

#### Why this is safe
- Dotbot creates symlinks pointing at `~/.dotfiles/<source>`. After `git mv`, working tree is consistent (old path gone, new path present).
- Rerunning `./install` with `relink: true` + `force: true` + recursive `clean` tears down stale links and rebuilds from new paths. Native dotbot behavior, no extra framework.
- Edge cases (user-created symlinks pointing at moved paths, removed apps, host-specific cleanup) - handle inline in the commit via grep, not a migration runner.
- Atomic git commit means no half-state.
- Test on VM first.

#### Test plan
1. Clone the refactored repo into a fresh VM, run `./install` cold - should produce identical `~/.config/` state to current setup.
2. On nighthawk: snapshot current `~/.config/` symlink targets; pull refactor; run `./install`; diff symlink targets; confirm only the source paths changed.
3. Sanity boot: log out, log in, verify Hyprland/waybar/dunst/voxtype come up clean.
4. Voyager: same.

### Phase C: Optional follow-ups

| # | Item | Decision needed |
| --- | --- | --- |
| C1 | `dotbot-paru` plugin replacing `install-missing-packages.sh` | Current script works; plugin is cleaner but adds dep. |
| C2 | `dotbot-template` for fish prompt + other host-specific config | Adds Jinja dep; alternative is dynamic fish function (covered by Phase A9). |
| C3 | `dotbot-sudo` plugin replacing `scripts/bootstrap/install-system-files.sh` | Declarative vs script. Either works. |
| C4 | Voyager helper scripts (battery/brightness/AC monitoring) | Voyager is bare; these would fill the gap. |
| C5 | Capture pipeline expansion (screen-record + OCR via tesseract) | Currently only `screenshot.sh`. |
| C6 | Audio in/out switch scripts | We have volume control, not source switching. |

---

## Part 4: Recommended Execution Order

1. **Phase A1-A11** - one PR each (or grouped low-risk ones). Test on nighthawk between each. ~1 evening total.
2. **Phase B0** (add `dotbot-includes` plugin, prove no regression). ~30 min.
3. **Phase B1** (the big move + recursive clean). Test on VM first, then nighthawk, then voyager. ~1-2 hours.
4. **Phase C** items: cherry-pick. None required.

## Open questions (decide before starting Phase B)

1. **Subdir naming**: `apps/` vs `config/` vs `dotfiles/`? Recommend `apps/` (`config/` collides mentally with `~/.config/`).
2. **Plugin posture**: install dotbot plugins as git submodules (like dotbot itself) or pip? Submodules keep repo self-bootstrapping.
3. **`bin/` prefix**: `dot-*`, `nh-*`, or none (just rely on `~/.dotfiles/bin/` being in PATH)?
