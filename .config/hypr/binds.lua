-- Keybindings
--
-- Modifier choice: SUPER is the main modifier. On Linux it is essentially
-- unused by applications, unlike macOS where CMD is heavily taken — so it
-- gives a conflict-free namespace. ALT is reserved for mouse drag actions
-- to preserve the yabai muscle memory (`mouse_modifier alt`).
--
-- Directional keys are h/j/k/l everywhere, matching the vim bindings already
-- used in .tmux.conf (bind h/j/k/l select-pane), nvim, helix and .ideavimrc.

local mainMod = "SUPER"

-- Programs. Change these to swap terminal/browser everywhere.
local terminal    = "kitty"
local fileManager = "nautilus"
local menu        = "fuzzel"

-- --- Core ---
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal),    { desc = "Terminal" })
hl.bind(mainMod .. " + Q",      hl.dsp.window.close(),        { desc = "Close window" })
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager), { desc = "File manager" })
hl.bind(mainMod .. " + SPACE",  hl.dsp.exec_cmd(menu),        { desc = "Launcher" })
hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }), { desc = "Toggle floating" })
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo(),       { desc = "Pseudotile" })
hl.bind(mainMod .. " + J",      hl.dsp.layout("togglesplit"), { desc = "Toggle split axis" })
hl.bind(mainMod .. " + F",      hl.dsp.window.fullscreen(),   { desc = "Fullscreen" })

-- Exit compositor. SHIFT+M to make it hard to hit by accident.
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit(), { desc = "Exit Hyprland" })

-- --- Focus movement (vim keys) ---
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))

-- Arrow keys too, for when the hands are already off home row.
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))

-- --- Moving windows ---
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))

-- --- Resizing (repeatable: hold the keys down) ---
hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -40, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 40 }),  { repeating = true })
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -40 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 40, y = 0 }),  { repeating = true })

-- --- Workspaces ---
-- 1..9 map to their own key; 10 maps to key 0.
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

-- Cycle workspaces with the scroll wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Scratchpad (Hyprland calls it the "special" workspace)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- --- Mouse drag window management ---
-- Mirrors the yabai config: ALT + drag to move, ALT + right-drag to resize.
-- Kept on ALT rather than SUPER precisely because that is the existing
-- muscle memory from macOS.
hl.bind("ALT + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- --- Screenshots ---
hl.bind("PRINT",         hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'), { desc = "Region to clipboard" })
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd('grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png'), { desc = "Screen to file" })

-- --- Clipboard history ---
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"), { desc = "Clipboard history" })

-- --- Lock ---
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"), { desc = "Lock session" })

-- --- Media & volume keys ---
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),     { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
