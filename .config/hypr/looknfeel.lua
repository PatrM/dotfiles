-- Look & feel
--
-- Palette is Catppuccin, carried over verbatim from ~/.tmux.conf so the
-- desktop, terminal multiplexer and lock screen share one color scheme.
--   bg #1e1e28   fg #dadae8   gray #332e41   black4 #575268
--   blue #a4b9ef  magenta #c6aae8  pink #e5b4e2  cyan #c2e7f0
--   red #e38c8f   green #b1e3ad    yellow #ebddaa  orange #f9c096

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(a4b9efee)", "rgba(c6aae8ee)" }, angle = 45 },
            inactive_border = "rgba(332e41aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,

        -- Dwindle = binary split tree. This is the closest analogue to the
        -- `layout bsp` used in the macOS yabai config, so window-splitting
        -- instincts carry over.
        layout = "dwindle",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        blur = {
            enabled           = true,
            size              = 5,
            passes            = 2,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = false,
        },

        shadow = {
            enabled      = true,
            range        = 12,
            render_power = 3,
            color        = 0xaa15121c,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
        -- New window takes the second half of the split — same convention as
        -- yabai's `window_placement second_child`.
        force_split    = 2,
    },

    master = {
        new_status = "master",
    },

    misc = {
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        focus_on_activate       = true,
        animate_manual_resizes  = false,
        -- vrr = 0 is the default; this display is VRR-incapable anyway.
        -- NOTE: `misc.vfr` no longer exists in Hyprland 0.56 — it was removed
        -- upstream. Do not re-add it; --verify-config will reject it.
    },
})

-- Animation curves. The four numbers are a cubic bezier's two control points.
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 } } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

-- Tuned to read as "smooth but not slow" — nothing here should ever make you
-- wait on the animation before the window is usable.
hl.animation({ leaf = "global",        enabled = true, speed = 7,    bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
