-- Autostart
--
-- Everything here runs once, on compositor start, via the "hyprland.start"
-- event. This is the Lua equivalent of the old `exec-once =` lines.
--
-- IMPORTANT: this fires on start, NOT on config reload — so a `hyprctl reload`
-- will not spawn duplicate daemons. If you need a daemon restarted after a
-- config change, restart it by hand (e.g. `pkill waybar && waybar &`).

hl.on("hyprland.start", function()
    -- Authentication agent. Without this, anything asking for a password
    -- (pkexec, GParted, some installers) silently fails.
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Status bar and notification daemon
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")

    -- Clipboard history (text and images)
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Idle management (dim/lock/suspend rules live in hypridle.conf)
    hl.exec_cmd("hypridle")

    -- Wallpaper daemon. Solid Catppuccin background by default.
    hl.exec_cmd("hyprpaper")

    -- Network applet in the tray
    hl.exec_cmd("nm-applet --indicator")

    -- Export the session environment to systemd + D-Bus so that portals,
    -- screen sharing and user services see the right variables. Without this,
    -- screen sharing and file pickers can misbehave.
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)
