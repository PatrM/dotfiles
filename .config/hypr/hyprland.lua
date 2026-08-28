-- Hyprland — top-level config (Lua API, Hyprland 0.56+)
--
-- This file only requires the modules below. Keep it that way: every real
-- setting belongs in a topic module so changes stay reviewable in git.
--
-- Agents: read AGENTS.md in this directory before editing anything here.
--
-- API reference: /usr/share/hypr/stubs/hl.meta.lua (typed LSP stubs)
-- Shipped example: /usr/share/hypr/hyprland.lua

require("env")
require("monitors")
require("looknfeel")
require("input")
require("binds")
require("rules")
require("autostart")

-- Machine-local, uncommitted overrides. Optional — see AGENTS.md.
-- pcall so a missing local.lua is not an error.
pcall(require, "local")
