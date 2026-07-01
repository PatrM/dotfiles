local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'carbonfox'
config.font_size = 14.0
config.font = wezterm.font_with_fallback {
    { family = 'Cascadia Code', weight = 600 }
}

-- Hide macOS title bar, use integrated buttons
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_alignment = "Left"
config.macos_window_background_blur = 0

-- Minimal flat tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
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

-- Clean tab title: just the process name or title, no index prefix
wezterm.on('format-tab-title', function(tab, _, _, _, _, _)
    local title = tab.active_pane.title
    -- Trim to keep it short
    if #title > 28 then
        title = title:sub(1, 26) .. '…'
    end
    local pad = ' '
    if tab.is_active then
        return pad .. title .. pad
    else
        return pad .. title .. pad
    end
end)

config.keys = {
    {
        key = "Return",
        mods = "CMD",
        action = wezterm.action { SplitHorizontal = {} }
    },
    {
        key = "Return",
        mods = "CMD|SHIFT",
        action = wezterm.action { SplitVertical = {} }
    },
    -- Word navigation (OPT as primary; CTRL works if Mission Control shortcuts are disabled)
    { key = 'LeftArrow',  mods = 'OPT',  action = wezterm.action.SendString '\x1bb' },
    { key = 'RightArrow', mods = 'OPT',  action = wezterm.action.SendString '\x1bf' },
    { key = 'LeftArrow',  mods = 'CTRL', action = wezterm.action.SendString '\x1bb' },
    { key = 'RightArrow', mods = 'CTRL', action = wezterm.action.SendString '\x1bf' },
}

return config
