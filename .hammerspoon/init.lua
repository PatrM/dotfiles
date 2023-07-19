-- Shortcuts to open / focus applications
local bindToCtrlLaunchOrFocus = function(key, application)
    hs.hotkey.bind({"alt"}, key, function()
    hs.application.launchOrFocus(application)
  end)
end
bindToCtrlLaunchOrFocus("1", "kitty")
bindToCtrlLaunchOrFocus("2", "IntelliJ IDEA")
bindToCtrlLaunchOrFocus("3", "Obsidian")
bindToCtrlLaunchOrFocus("4", "Brave Browser")
bindToCtrlLaunchOrFocus("5", "Slack")
bindToCtrlLaunchOrFocus("6", "Spotify")
