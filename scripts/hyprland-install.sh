#!/usr/bin/env bash
#
# Hyprland installation for CachyOS (Arch-based).
#
# Read this before running it. It installs packages system-wide via pacman
# and needs sudo. It does NOT touch the bootloader, mkinitcpio, kernel
# parameters, or the NVIDIA driver — all of those are already correct on this
# machine (KDE Plasma runs on Wayland here, which proves DRM/KMS is fine).
#
# It also does NOT remove KDE. Plasma stays installed and selectable at the
# SDDM login screen as a fallback.
#
# Usage:  ./hyprland-install.sh
#
set -euo pipefail

info() { printf '\033[1;34m::\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$1"; }

if [[ $EUID -eq 0 ]]; then
    warn "Do not run this as root. It calls sudo itself where needed."
    exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
    warn "pacman not found — this script is for Arch/CachyOS only."
    exit 1
fi

# --- Packages -------------------------------------------------------------
# Grouped by purpose so it is obvious what to drop if you want a leaner set.

CORE=(
    hyprland                      # the compositor
    hyprpaper                     # wallpaper daemon
    hypridle                      # idle management
    hyprlock                      # screen locker
    hyprpolkitagent               # auth prompts (pkexec, etc.)
    hyprcursor                    # cursor theme engine
)

PORTALS=(
    xdg-desktop-portal-hyprland   # screen share, file pickers
    xdg-desktop-portal-gtk        # GTK file picker backend
)

SHELL_UI=(
    waybar                        # status bar
    fuzzel                        # launcher (SUPER+SPACE)
    mako                          # notification daemon
)

TOOLKIT=(
    qt6-wayland
    qt5-wayland
)

UTILS=(
    grim                          # screenshots
    slurp                         # region select
    wl-clipboard                  # wl-copy / wl-paste
    cliphist                      # clipboard history
    brightnessctl
    playerctl
    pavucontrol
    network-manager-applet
    nautilus                      # file manager (SUPER+E)
)

FONTS=(
    ttf-jetbrains-mono-nerd       # bar/launcher/lock icons need a Nerd Font
)

DOTFILES=(
    stow                          # NOT installed on this machine despite the
                                  # README assuming it — the existing symlinks
                                  # in ~ predate this system's package set.
)

CURSOR=(
    bibata-cursor-theme           # matches XCURSOR_THEME in env.conf
)

ALL=("${CORE[@]}" "${PORTALS[@]}" "${SHELL_UI[@]}" "${TOOLKIT[@]}" "${UTILS[@]}" "${FONTS[@]}" "${DOTFILES[@]}")

info "The following packages will be installed:"
printf '   %s\n' "${ALL[@]}"
echo
read -r -p "Proceed? [y/N] " reply
[[ "$reply" =~ ^[Yy]$ ]] || { info "Aborted."; exit 0; }

info "Installing core packages..."
sudo pacman -S --needed "${ALL[@]}"

# Cursor theme may live in the AUR depending on repo state; try it separately
# so a failure here does not abort the whole install.
info "Installing cursor theme (optional)..."
if ! sudo pacman -S --needed "${CURSOR[@]}" 2>/dev/null; then
    if command -v yay >/dev/null 2>&1; then
        yay -S --needed "${CURSOR[@]}" || warn "Cursor theme failed; edit XCURSOR_THEME in hypr/env.conf or install another theme."
    else
        warn "Cursor theme not in repos and yay not found."
        warn "Either install it from the AUR later, or change XCURSOR_THEME in ~/.config/hypr/env.conf to a theme you have."
    fi
fi

# --- Enable the polkit agent user service --------------------------------
info "Enabling hyprpolkitagent user service..."
systemctl --user enable hyprpolkitagent.service 2>/dev/null || \
    warn "Could not enable hyprpolkitagent.service; autostart.conf starts it anyway."

# --- Verify the session file exists --------------------------------------
if [[ -f /usr/share/wayland-sessions/hyprland.desktop ]]; then
    info "Hyprland session registered with SDDM."
else
    warn "/usr/share/wayland-sessions/hyprland.desktop is missing."
    warn "SDDM will not offer Hyprland as a session. Check the hyprland package."
fi

# --- Stow the configs -----------------------------------------------------
info "Next step — link the configs from the dotfiles repo:"
echo
echo "    cd ~/dotfiles && stow -t ~ ."
echo
info "Then validate the config WITHOUT logging out:"
echo
echo "    hyprland --config ~/.config/hypr/hyprland.conf --verify-config"
echo
info "Then log out and pick 'Hyprland' at the SDDM session selector."
info "KDE Plasma remains available in that same menu if anything goes wrong."
