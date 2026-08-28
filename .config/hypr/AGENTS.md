# Hyprland setup — agent guide

Context and guardrails for anyone (human or agent) changing this Hyprland
configuration. Read this before editing files in `~/.config/hypr/`.

`CLAUDE.md` in this directory is a symlink to this file.

---

## 1. This config is Lua, not `.conf`

Hyprland 0.56 introduced a Lua configuration API and is deprecating the old
`.conf` format. This setup uses **Lua**. If you are working from memory of
Hyprland configs, that memory is probably `.conf`-era and **will be wrong**.

- **Entry point:** `hyprland.lua` (Hyprland prefers it over `hyprland.conf`).
- **Typed API stubs:** `/usr/share/hypr/stubs/hl.meta.lua` — ~67KB of
  LSP annotations listing every valid config key, event, dispatcher and spec.
  **This is the authoritative reference.** Grep it before guessing.
- **Shipped example:** `/usr/share/hypr/hyprland.lua` — upstream's own
  example, always correct for the installed version.
- **`.luarc.json`** in this directory points lua-ls at the stubs, so an editor
  with LuaLS gives real autocomplete and type checking on `hl.*`.

Still `.conf` on purpose: `hyprlock.conf`, `hypridle.conf`, `hyprpaper.conf`.
Those are *separate binaries* with their own config format — they did not move
to Lua. Do not "consistency-fix" them into Lua.

### Useful stub queries

```bash
S=/usr/share/hypr/stubs/hl.meta.lua
grep -oE '"misc\.[a-z_]+"' $S | sort -u          # every valid misc.* key
grep -oE '"general\.[a-z_.]+"' $S | sort -u      # every valid general.* key
sed -n '/---@class HL.DspWindowNamespace/,/^local /p' $S   # window dispatchers
sed -n '/---@class HL.API/,/^local /p' $S        # the whole hl.* API surface
```

### Renames already hit during this migration

Do not re-add these; `--verify-config` rejects them:

| Old `.conf`                     | Status in 0.56 |
|---|---|
| `misc { vfr = true }`           | **Removed.** Only `misc.vrr` exists now. |
| `dwindle { pseudotile = true }` | **Removed** as a config key. The dispatcher `hl.dsp.window.pseudo()` still exists. |
| `gestures { workspace_swipe }`  | Replaced by `hl.gesture({ fingers, direction, action })`. The `workspace_swipe_*` tuning sub-keys still exist. |
| `windowrulev2 = ...`            | Deprecated → `hl.window_rule({ match = {...}, ... })` |
| `layerrule = blur, waybar`      | → `hl.layer_rule({ match = { namespace = "^waybar$" }, blur = true })` |
| `bind = ..., togglesplit`       | → `hl.dsp.layout("togglesplit")` |
| `exec-once = ...`               | → `hl.on("hyprland.start", function() hl.exec_cmd(...) end)` |

---

## 2. Hardware and system facts

Verified on the machine, not assumed. Re-verify with §7 before relying on them.

| Fact | Value | Verified via |
|---|---|---|
| Distro | CachyOS (Arch-based, rolling) | `/etc/os-release` |
| GPU | NVIDIA RTX 4070 (AD104) | `lspci` |
| Driver | `nvidia-open` 610.57.04 | `pacman -Qs nvidia` |
| Hyprland | 0.56.2 | `pacman -Q hyprland` |
| Bootloader | **systemd-boot** (not GRUB, not Limine) | `bootctl status` |
| Display manager | SDDM | `systemctl list-unit-files` |
| Monitor | HDMI-A-1, 2560x1440 @ **143.91Hz**, scale 1 | `kscreen-doctor -o` |
| VRR | **Incapable** — display does not support it | `kscreen-doctor -o` |
| Keyboard layout | **`us`** (locale is de_DE, layout is not) | `localectl status` |
| Fallback session | KDE Plasma 6.7.x, still installed | `pacman -Qs plasma` |

### Why there are no kernel/bootloader steps

A common failure mode is an agent "helpfully" adding `nvidia-drm.modeset=1`
to kernel parameters or rebuilding mkinitcpio for NVIDIA. **Do not do this
here.** KDE Plasma already ran on Wayland on this machine before Hyprland
existed on it, which proves DRM modesetting is already active. The NVIDIA
handling needed for Hyprland is entirely in `env.lua` (wlroots-level env
vars). Touching systemd-boot entries risks an unbootable system for zero gain.

---

## 3. File map

```
~/.config/hypr/
├── hyprland.lua      # entry point; only require() calls, no settings
├── env.lua           # environment vars, incl. all NVIDIA handling
├── monitors.lua      # display layout, refresh rate
├── input.lua         # keyboard, mouse, touchpad, gestures
├── looknfeel.lua     # gaps, borders, blur, shadows, animations, layout
├── binds.lua         # all keybindings
├── rules.lua         # window rules + layer rules
├── autostart.lua     # hyprland.start event → daemons
├── local.lua         # untracked machine-local overrides (required LAST)
├── .luarc.json       # points lua-ls at /usr/share/hypr/stubs
├── hyprlock.conf     # separate binary — still .conf
├── hypridle.conf     # separate binary — still .conf
├── hyprpaper.conf    # separate binary — still .conf
└── AGENTS.md         # this file

~/.config/waybar/     # bar: config.jsonc + style.css
~/.config/fuzzel/     # launcher
~/.config/mako/       # notifications
~/dotfiles/scripts/hyprland-install.sh
```

Managed with GNU stow from `~/dotfiles`. Edit files **in the repo**
(`~/dotfiles/.config/hypr/...`), not through the symlink, or changes will not
be tracked.

### Stow gotcha (already hit once)

`scripts/symlink_setup` in this repo creates **absolute** symlinks with
`ln -sf`. Stow only recognises **relative** links it created itself, so a repo
linked by that script makes `stow` abort with "existing target is not owned by
stow" for every file. The fix already applied: delete the stale absolute
symlinks, then `stow -t ~ .`. **Do not run `symlink_setup` again** — it will
re-break stow. That script and the README's stow instructions are in conflict;
stow is the one in use.

---

## 4. Deliberate choices — do not "fix" these

Each looks like an oversight and is not. If you have a genuine reason to
change one, say so explicitly rather than silently reverting it.

- **Lua config, not `.conf`.** See §1. Chosen because it is where upstream is
  going, it matches Omarchy v4, and the typed stubs make the config
  self-verifying — an agent can grep the valid key set instead of guessing.
- **Waybar, not Quickshell.** Quickshell is in Arch `extra` but ships *no*
  default config — it is a QML toolkit, not a bar. Waybar was chosen so bar
  bugs are debuggable in JSON/CSS rather than stacking three unknowns
  (Hyprland + QML + Quickshell API). Revisit once Hyprland is boring.
- **Omarchy's shell was not copied.** Its `shell.qml` depends on ~400
  `omarchy-*` helper scripts in its own repo; it is not portable by copying.
- **KDE is not uninstalled.** Session choice at SDDM is free and reversible;
  removing `plasma-desktop` is neither. Keep the fallback.
- **`dwindle` layout, `force_split = 2`.** Mirrors the macOS yabai config
  (`layout bsp`, `window_placement second_child`) so splitting habits carry
  over. Do not switch to `master` without asking.
- **SUPER is the modifier; ALT is for mouse drags.** ALT-drag matches yabai's
  `mouse_modifier alt`. SUPER is free on Linux, unlike CMD on macOS.
- **h/j/k/l for focus/move/resize.** Consistent with `.tmux.conf`, nvim,
  helix, `.ideavimrc`. Keep vim directions anywhere directional keys appear.
- **Catppuccin palette, copied from `.tmux.conf`.** The values in
  `looknfeel.lua`, `waybar/style.css`, `fuzzel.ini`, `mako/config` and
  `hyprlock.conf` are the same set. Change them **together** or the session
  goes inconsistent. Source of truth: `~/dotfiles/.tmux.conf`.
- **`WLR_NO_HARDWARE_CURSORS` is intentionally absent.** A legacy NVIDIA
  workaround, unnecessary on driver 610.x. Add only if a real cursor bug
  appears.
- **Refresh rate hardcoded to 143.91**, not `preferred`, because `preferred`
  does not reliably select the fastest mode.
- **VRR is off and must stay off** — this panel reports `Vrr: incapable`.

---

## 5. How to change things safely

**Golden rule: never edit config and log out to test.** A broken config plus
a logout can leave you at a black screen. Validate first, reload second, log
out only when it already works.

```bash
# 1. Validate WITHOUT applying — safe to run from inside KDE or Hyprland
hyprland --verify-config          # prints "config ok" when clean

# 2. Apply to the running session — instant, no logout
hyprctl reload

# 3. Check what the reload complained about
hyprctl configerrors
```

Notes:
- `autostart.lua` hooks the `hyprland.start` event, so `hyprctl reload` does
  **not** re-spawn daemons. Restart them by hand: `pkill waybar && waybar &`.
- After changing `waybar/config.jsonc` or `style.css`: `pkill -SIGUSR2 waybar`.
- After changing `mako/config`: `makoctl reload`.
- `hl.bind` accepts a `desc` option; use it, it shows up in keybind listings.

**Recovery if the session is broken**, in escalating order:

1. **`Hyprland --safe-mode`** — starts the compositor ignoring the user config
   entirely. Fastest way back to a usable session after a bad edit.
2. **Log into KDE Plasma from SDDM**, fix the config, log back out. This is
   the entire reason KDE was kept installed.
3. **TTY**: `Ctrl+Alt+F2` gets a text console independent of any compositor.

---

## 6. Known-risky areas on this machine

Ranked by likelihood of biting.

1. **NVIDIA suspend/resume.** The highest-risk path. `hypridle.conf` has the
   suspend listener commented out on purpose (desktop, no battery motive).
   If enabling it, test a suspend/resume cycle deliberately before trusting it
   with unsaved work.
2. **XWayland scaling/blur.** Non-native Wayland apps can look soft. Check
   with `hyprctl clients` and look at the `xwayland` field.
3. **IntelliJ / JetBrains.** Historically renders blank under Wayland.
   `env.lua` has a commented `_JAVA_AWT_WM_NONREPARENTING` line for this, and
   `rules.lua` floats its popups (ported from the yabai `manage=off` rules).
   The app most likely to need fiddling.
4. **Screen sharing.** Needs `xdg-desktop-portal-hyprland` running and the
   `dbus-update-activation-environment` call in `autostart.lua`. If sharing
   shows a black screen, that is the first suspect.
5. **Dispatcher argument shapes.** `--verify-config` validates that a
   dispatcher *exists*, but not always that its arguments are well-formed.
   A bind can pass validation and still misbehave at runtime. Test binds you
   change.
6. **Missing Nerd Font glyphs.** Boxes/tofu in the bar or launcher means
   `ttf-jetbrains-mono-nerd` is missing.

---

## 7. Diagnostic commands

```bash
# Compositor state
hyprctl version
Hyprland --systeminfo         # GPU/driver/version dump — start here for bug reports
hyprctl monitors              # actual resolution/refresh in use
hyprctl clients               # open windows, their class/title (for rules)
hyprctl layers                # layer surfaces (bar, launcher, notifications)
hyprctl configerrors
hyprctl devices               # input device names
hyprctl binds                 # every registered bind, with descriptions

# Logs
cat "$XDG_RUNTIME_DIR"/hypr/*/hyprland.log | tail -50

# Hardware re-verification
lspci | grep -i vga
pacman -Q hyprland
localectl status
kscreen-doctor -o             # only works under a KDE/X session
```

---

## 8. Conventions for future edits

- **One topic per module.** A new keybind goes in `binds.lua`, never in
  `hyprland.lua`. Keep the entry point as pure `require()` calls.
- **Comment the *why*, not the *what*.** `rounding = 8` needs no comment;
  "VRR off because the panel is incapable" does. The value of this config is
  the reasoning — syntax is in the stubs.
- **Machine-specific things go in `local.lua`**, gitignored and required last
  so it always wins. Promote to a tracked module once a setting proves durable.
- **Palette changes are cross-file.** See §4.
- **Verify against the machine before asserting.** Several values here were
  corrected from wrong guesses during setup: keyboard layout is `us` despite a
  German locale; refresh rate is 143.91 not 60; `stow` was not installed even
  though the README assumed it; and the entire config format turned out to be
  Lua, not `.conf`. Run the §7 commands and grep the stubs rather than
  assuming.
- **Always end with `hyprland --verify-config`.** It is fast, it is safe to
  run from any session, and it catches every rename upstream has made.
- **Upstream docs:** <https://wiki.hypr.land/> is authoritative but is
  Cloudflare-protected and often not fetchable by tools. The local stubs and
  `/usr/share/hypr/hyprland.lua` are the offline substitute — and are
  guaranteed to match the installed version, which the wiki is not.

---

## 9. Roadmap / open threads

Deliberately deferred, in rough order:

- [ ] **First real login.** As of writing, the config validates but the
      session has not yet been logged into. Verify §6 items on first run.
- [ ] **Quickshell migration.** Once Hyprland is second nature, replace
      Waybar. Study standalone shells built for reuse (`atmosphera`,
      `bms-shell` in the AUR) rather than lifting Omarchy's.
- [ ] **Wallpaper.** `hyprpaper.conf` is set up but points at no image; the
      solid Catppuccin background shows through.
- [ ] **Reconcile `symlink_setup` vs stow.** The repo has two competing
      linking mechanisms and the README documents the one not in use. See §3.
- [ ] **Hammerspoon replacement.** The macOS setup leans on Hammerspoon
      (`~/dotfiles/.hammerspoon/init.lua`) with no Linux equivalent. Its
      automations need porting to Hyprland binds, `hyprctl` scripts and
      systemd user units. Hyprland's Lua API (`hl.on`, `hl.timer`,
      `hl.get_windows`) is a plausible host for some of it.
- [ ] **Per-app workspace assignment.** e.g. pin IntelliJ to workspace 3 via
      `hl.window_rule`, once daily workspace habits settle.
