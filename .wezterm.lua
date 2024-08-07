-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'carbonfox'

config.font_size = 14.0

config.font = wezterm.font_with_fallback {
    {family='Cascadia Code', weight=600}
}

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
}

-- and finally, return the configuration to wezterm
return config
