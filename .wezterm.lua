-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'carbonfox'

config.font_size = 14.0

config.keys = {
    {
        key = "Return",
        mods = "CMD",
        action = wezterm.action { SplitHorizontal = {} }
    },
}

-- and finally, return the configuration to wezterm
return config
