-- Input devices

hl.config({
    input = {
        -- Verified against `localectl status` (X11 Layout: us). The system
        -- locale is de_DE for time/currency/paper, but the layout is US.
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        -- 1 = focus follows mouse, but keyboard focus wins on click.
        -- Set to 0 for strict click-to-focus.
        follow_mouse = 1,

        sensitivity       = 0,
        numlock_by_default = true,

        touchpad = {
            natural_scroll       = true,
            disable_while_typing = true,
        },
    },
})

-- Three-finger horizontal swipe switches workspaces.
-- NOTE: the old `gestures { workspace_swipe = true }` option no longer exists
-- in Hyprland 0.56 — gestures are declared with hl.gesture() now.
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
