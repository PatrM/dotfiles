-- Window & layer rules
--
-- Ported in spirit from the macOS yabai rules: dialogs, preference panes and
-- IDE popups should float rather than be forced into the tiling tree.
--
-- NOTE: `windowrulev2` is deprecated in Hyprland 0.56. The Lua equivalent is
-- hl.window_rule({ match = {...}, <rule fields> }).

-- Ignore maximize requests from all apps (recommended upstream default).
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix dragging issues with XWayland windows.
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- --- Float dialogs and utility windows ---
hl.window_rule({
    name  = "float-system-dialogs",
    match = { class = "^(pavucontrol|nm-connection-editor|blueman-manager)$" },
    float = true,
})

hl.window_rule({
    name  = "float-appearance-tools",
    match = { class = "^(nwg-look|qt5ct|qt6ct)$" },
    float = true,
})

hl.window_rule({
    name  = "float-file-dialogs",
    match = { title = "^(Open File|Save File|Save As|Open Folder)$" },
    float = true,
})

hl.window_rule({
    name  = "pip-always-on-top",
    match = { title = "^(Picture-in-Picture)$" },
    float = true,
    pin   = true,
})

-- --- JetBrains / IntelliJ ---
-- Equivalent of the yabai `manage=off` rules. IntelliJ's splash, project
-- structure and settings windows tile badly; float them.
hl.window_rule({
    name  = "float-jetbrains-splash",
    match = { class = "^(jetbrains-.*)$", title = "^$" },
    float = true,
})

hl.window_rule({
    name  = "float-jetbrains-dialogs",
    match = { class = "^(jetbrains-.*)$", title = "^(Project Structure|Settings|Preferences|Edit configuration.*)$" },
    float = true,
})

-- IntelliJ autocomplete popups must never steal focus.
hl.window_rule({
    name     = "jetbrains-popups-no-focus",
    match    = { class = "^(jetbrains-.*)$", float = true, title = "^win.*$" },
    no_focus = true,
})

-- --- Secrets: never allow screen capture of the password manager ---
hl.window_rule({
    name            = "1password-no-screencopy",
    match           = { class = "^1Password$" },
    no_screen_share = true,
})

-- --- Layer rules: blur the shell surfaces ---
hl.layer_rule({
    name         = "blur-waybar",
    match        = { namespace = "^waybar$" },
    blur         = true,
    ignore_alpha = 0.0,
})

hl.layer_rule({
    name         = "blur-launcher",
    match        = { namespace = "^launcher$" },
    blur         = true,
    ignore_alpha = 0.0,
})

hl.layer_rule({
    name         = "blur-notifications",
    match        = { namespace = "^notifications$" },
    blur         = true,
    ignore_alpha = 0.0,
})
