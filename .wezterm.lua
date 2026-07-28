local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'carbonfox'
config.font_size = 14.0
config.font = wezterm.font_with_fallback {
    { family = 'Cascadia Code', weight = 600 }
}

-- Hide macOS title bar, use integrated buttons
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- Buttons on the right so they don't overlap herdr's top-left "spaces" sidebar header
config.integrated_title_button_alignment = "Right"
config.macos_window_background_blur = 0

-- Minimal flat tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
-- Keep the tab bar visible even with one tab, so the next-meeting right status
-- always shows (WezTerm only renders right status when the tab bar is drawn).
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32

-- Carbonfox-matched tab bar colors
config.colors = {
    tab_bar = {
        background = '#161616',
        active_tab = {
            bg_color = '#282828',
            fg_color = '#f2f4f8',
            intensity = 'Normal',
            underline = 'None',
            italic = false,
            strikethrough = false,
        },
        inactive_tab = {
            bg_color = '#161616',
            fg_color = '#6e6f70',
        },
        inactive_tab_hover = {
            bg_color = '#1c1c1c',
            fg_color = '#a8aab0',
        },
        new_tab = {
            bg_color = '#161616',
            fg_color = '#6e6f70',
        },
        new_tab_hover = {
            bg_color = '#1c1c1c',
            fg_color = '#f2f4f8',
        },
    },
}

-- Claude Code agent state -> tab indicator (set via OSC 1337 SetUserVar by
-- ~/.claude/hooks/wezterm-claude-state.sh). Non-Claude panes have no var and
-- render unchanged.
local CLAUDE_STATE = {
    running = { icon = '●', color = '#25be6a' }, -- working
    blocked = { icon = '◐', color = '#f3be7c' }, -- needs answer / permission
    idle    = { icon = '○', color = '#6e6f70' }, -- finished, waiting
}

-- Clean tab title: just the process name or title, no index prefix
wezterm.on('format-tab-title', function(tab, _, _, _, _, _)
    -- Prefer an explicit tab title (set via `wezterm cli set-tab-title` or
    -- the rename key binding); fall back to the active pane's process title.
    local title = tab.tab_title
    if not title or #title == 0 then
        title = tab.active_pane.title
    end
    -- Trim to keep it short
    if #title > 28 then
        title = title:sub(1, 26) .. '…'
    end
    local pad = ' '

    -- If a Claude session in this pane reported a state, show a colored dot
    -- and tint the title text to match.
    local state = tab.active_pane.user_vars.claude_state
    local style = state and CLAUDE_STATE[state]
    if style then
        return {
            { Foreground = { Color = style.color } },
            { Text = pad .. style.icon .. ' ' .. title .. pad },
        }
    end

    return pad .. title .. pad
end)

-- Next-meeting indicator in the right status bar.
-- Reads macOS Calendar (the same EventKit store MeetingBar/Google Calendar feed)
-- via ~/.config/wezterm/next-meeting.sh. The script call is throttled to once a
-- minute; the result is cached so per-frame status updates never block the GUI.
local MEETING_SCRIPT = wezterm.home_dir .. '/.config/wezterm/next-meeting.sh'
local meeting_cache = ''
local meeting_last = 0

wezterm.on('update-status', function(window, _)
    local now = os.time()
    if now - meeting_last >= 60 then
        meeting_last = now
        -- pcall returns (pcall_ok, ...); run_child_process returns (success, stdout, stderr)
        local pcall_ok, success, stdout = pcall(wezterm.run_child_process, { 'bash', MEETING_SCRIPT })
        meeting_cache = (pcall_ok and success and stdout) or ''
    end

    if meeting_cache and #meeting_cache > 0 then
        window:set_right_status(wezterm.format {
            { Foreground = { Color = '#78a9ff' } },
            { Text = ' 󰃰 ' },
            { Foreground = { Color = '#a8aab0' } },
            { Text = meeting_cache .. '  ' },
        })
    else
        window:set_right_status('')
    end
end)

config.keys = {
    -- Rename the current tab (prompts for a name; empty clears it)
    {
        key = 'E',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.PromptInputLine {
            description = 'Enter new tab name',
            action = wezterm.action_callback(function(window, _, line)
                if line ~= nil then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
    -- Pane splitting is handled by herdr (the multiplexer), not wezterm, to avoid
    -- splitting the wrong layer. wezterm stays a single-window outer terminal.
    -- Word navigation (OPT as primary; CTRL works if Mission Control shortcuts are disabled)
    { key = 'LeftArrow',  mods = 'OPT',  action = wezterm.action.SendString '\x1bb' },
    { key = 'RightArrow', mods = 'OPT',  action = wezterm.action.SendString '\x1bf' },
    { key = 'LeftArrow',  mods = 'CTRL', action = wezterm.action.SendString '\x1bb' },
    { key = 'RightArrow', mods = 'CTRL', action = wezterm.action.SendString '\x1bf' },
}

return config
