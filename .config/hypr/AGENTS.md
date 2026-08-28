# Hyprland setup — agent guide

Context and guardrails for anyone (human or agent) changing this Hyprland
configuration. Read this before editing files in `~/.config/hypr/`.

`CLAUDE.md` in this directory is a symlink to this file.

---

## 1. Hardware and system facts

These were verified on the machine, not assumed. Re-verify with the commands
in §6 before relying on them — hardware and drivers change.

| Fact | Value | Verified via |
|---|---|---|
| Distro | CachyOS (Arch-based, rolling) | `/etc/os-release` |
| Kernel | `linux-cachyos` | `uname -r` |
| GPU | NVIDIA RTX 4070 (AD104) | `lspci` |
| Driver | `nvidia-open` 610.57.04 | `pacman -Qs nvidia` |
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
handling needed for Hyprland is entirely in `env.conf` (wlroots-level env
vars). Touching systemd-boot entries risks an unbootable system for zero gain.

---

## 2. File map

```
~/.config/hypr/
├── hyprland.conf     # sources everything else; no real settings here
├── env.conf          # environment vars, incl. all NVIDIA handling
├── monitors.conf     # display layout, refresh rate
├── input.conf        # keyboard, mouse, touchpad, ALT-drag bindings
├── looknfeel.conf    # gaps, borders, blur, shadows, animations, layout
├── binds.conf        # all keybindings
├── rules.conf        # window rules + layer rules
├── autostart.conf    # exec-once daemons
├── local.conf        # untracked machine-local overrides (sourced LAST)
├── hyprlock.conf     # lock screen
├── hypridle.conf     # idle timeouts
├── hyprpaper.conf    # wallpaper
└── AGENTS.md         # this file

~/.config/waybar/     # bar: config.jsonc + style.css
~/.config/fuzzel/     # launcher
~/.config/mako/       # notifications
~/dotfiles/scripts/hyprland-install.sh
```

Everything is managed with GNU stow from `~/dotfiles`. Edit files **in the
repo** (`~/dotfiles/.config/hypr/...`), not through the symlink target, or
changes will not be tracked.

---

## 3. Deliberate choices — do not "fix" these

Each of these looks like an oversight and is not. If you have a genuine
reason to change one, say so explicitly rather than silently reverting it.

- **Waybar, not Quickshell.** Quickshell is installed-capable and in Arch
  `extra`, but it ships *no* default config — it is a QML toolkit, not a bar.
  Waybar was chosen so that while Hyprland itself is still unfamiliar, bar
  bugs are debuggable in JSON/CSS rather than stacking three unknowns
  (Hyprland + QML + Quickshell API). Revisit only once Hyprland is boring.
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
- **Catppuccin palette, copied from `.tmux.conf`.** The hex values in
  `looknfeel.conf`, `waybar/style.css`, `fuzzel.ini`, `mako/config` and
  `hyprlock.conf` are all the same set. Change them **together** or the
  session goes inconsistent. Source of truth: `~/dotfiles/.tmux.conf`.
- **`WLR_NO_HARDWARE_CURSORS` is intentionally absent.** It is a legacy
  NVIDIA workaround, unnecessary on driver 610.x. Add only if a real cursor
  bug appears.
- **Refresh rate is hardcoded to 143.91**, not `preferred`, because
  `preferred` does not reliably select the fastest mode.
- **VRR is off and must stay off** — this panel reports `Vrr: incapable`.
- **`vfr = true`** (variable frame rate) is a power saving win, not a bug.

---

## 4. How to change things safely

**Golden rule: never edit config and log out to test.** A broken config plus
a logout can leave you at a black screen. Always validate first, reload
second, log out only when it already works.

```bash
# 1. Validate syntax without applying (run from anywhere, even inside KDE)
hyprland --verify-config

# 2. Apply to the running session — instant, no logout
hyprctl reload

# 3. Watch for errors the reload printed
hyprctl configerrors
```

Notes:
- `hyprctl reload` re-runs `exec` lines but **not** `exec-once`. Daemons in
  `autostart.conf` will not restart on reload — restart them by hand
  (`pkill waybar && waybar &`).
- Never put daemons on `exec` instead of `exec-once` to work around that; it
  spawns a duplicate on every single reload.
- After changing `waybar/config.jsonc` or `style.css`: `pkill -SIGUSR2 waybar`
  reloads Waybar in place.
- After changing `mako/config`: `makoctl reload`.

**Recovery if the session is broken**, in escalating order:

1. **`Hyprland --safe-mode`** — starts the compositor ignoring the user
   config entirely. This is the fastest way to get a usable session when a
   config edit made Hyprland refuse to start. (Verified present in Hyprland's
   `main.cpp` alongside `--verify-config`.)
2. **Log into KDE Plasma from SDDM**, fix the config in a terminal, log back
   out. This is the entire reason KDE was kept installed.
3. **TTY**: `Ctrl+Alt+F2` gets a text console independent of any compositor.

---

## 5. Known-risky areas on this machine

Ranked by likelihood of biting.

1. **NVIDIA suspend/resume.** The highest-risk path. `hypridle.conf` has the
   suspend listener commented out on purpose (desktop, no battery motive).
   If enabling it, test a suspend/resume cycle deliberately before trusting
   it with unsaved work.
2. **XWayland scaling/blur.** Apps not running natively on Wayland (some
   Electron apps, older Java UIs) can look soft. Check with
   `hyprctl clients | grep -i xwayland` to see what is actually on XWayland.
3. **IntelliJ / JetBrains.** Historically renders blank under Wayland.
   `env.conf` has a commented `_JAVA_AWT_WM_NONREPARENTING` line for this,
   and `rules.conf` has float rules for its popups (ported from the yabai
   `manage=off` rules). This is the app most likely to need fiddling.
4. **Screen sharing.** Needs `xdg-desktop-portal-hyprland` running and the
   `dbus-update-activation-environment` line in `autostart.conf`. If sharing
   shows a black screen, that env export is the first suspect.
5. **Missing Nerd Font glyphs.** The bar, launcher and lock screen use
   Nerd Font icons. Boxes/tofu instead of icons means
   `ttf-jetbrains-mono-nerd` is missing.

---

## 6. Diagnostic commands

```bash
# Compositor state
hyprctl version
Hyprland --systeminfo         # GPU/driver/version dump — start here for bug reports
hyprctl monitors              # actual resolution/refresh in use
hyprctl clients               # open windows, their class/title (for rules)
hyprctl layers                # layer surfaces (bar, launcher, notifications)
hyprctl configerrors
hyprctl devices               # input device names for input.conf

# Find a window's class/title so you can write a rule for it
hyprctl clients | grep -E 'class|title'

# Logs from the running session
journalctl --user -u hyprland -b --no-pager | tail -50
cat "$XDG_RUNTIME_DIR"/hypr/*/hyprland.log | tail -50

# Hardware re-verification
lspci | grep -i vga
pacman -Qs nvidia
localectl status
bootctl status
```

---

## 7. Conventions for future edits

- **One topic per file.** A new keybind goes in `binds.conf`, never in
  `hyprland.conf`. Keep the top-level file as pure `source =` lines.
- **Comment the *why*, not the *what*.** `rounding = 8` needs no comment;
  "VRR off because the panel is incapable" does. The value of this config is
  the reasoning, since the syntax is already in the wiki.
- **Machine-specific things go in `local.conf`**, which is gitignored and
  sourced last so it always wins. Promote to a tracked file only once a
  setting proves durable.
- **Palette changes are cross-file.** See §3.
- **Verify against the machine before asserting.** Several defaults here were
  corrected from wrong guesses during setup (keyboard layout is `us` despite
  a German locale; refresh rate is 143.91 not 60). Run the §6 commands rather
  than assuming.
- **Upstream docs:** <https://wiki.hypr.land/> is authoritative and changes
  often. Prefer it over memory for syntax — Hyprland has renamed config
  options between releases (e.g. `decoration:drop_shadow` became the
  `decoration { shadow { } }` block).

---

## 8. Roadmap / open threads

Deliberately deferred, in rough order:

- [ ] **Quickshell migration.** Once Hyprland is second nature, replace
      Waybar. Study standalone shells built for reuse (`atmosphera`,
      `bms-shell` in the AUR) rather than lifting Omarchy's.
- [ ] **Wallpaper.** `hyprpaper.conf` is set up but points at no image; the
      solid Catppuccin background shows through.
- [ ] **Hammerspoon replacement.** The macOS setup leans on Hammerspoon
      (`~/dotfiles/.hammerspoon/init.lua`) with no Linux equivalent. Its
      automations need porting to some mix of Hyprland binds, `hyprctl`
      scripts and systemd user units. Not yet attempted.
- [ ] **Per-app workspace assignment.** e.g. pin IntelliJ to workspace 3 via
      `workspace` window rules, once daily workspace habits settle.
- [ ] **Screen recording.** Omarchy uses `gpu-screen-recorder`; nothing is
      configured here yet.
