local wezterm = require("wezterm")
local act = wezterm.action
local config = {} -- wezterm.config_builder()

config.default_prog = { "pwsh.exe", "-NoLogo" }
config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.term = "xterm-256color"

config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.cell_width = 0.9
config.window_background_opacity = 0.5
config.prefer_egl = true
config.font_size = 18.0

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

wezterm.on("toggle-colorscheme", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme == "Zenburn" then
		overrides.color_scheme = "Cloud (terminal.sexy)"
	else
		overrides.color_scheme = "Zenburn"
	end
	window:set_config_overrides(overrides)
end)

config.keys = {
	{
		key = "E",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.EmitEvent("toggle-colorscheme"),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "U",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "I",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "P",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{ key = "9", mods = "CTRL", action = act.PaneSelect },
	{ key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
	{
		key = "O",
		mods = "CTRL|ALT",
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = 0.5
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Cloud (terminal.sexy)"
-- config.colors = {
-- 	background = "#0c0b0f",
-- 	cursor_border = "#bea3c7",
-- 	cursor_bg = "#bea3c7",
-- 	tab_bar = {
-- 		background = "#0c0b0f",
-- 		active_tab = {
-- 			bg_color = "#0c0b0f",
-- 			fg_color = "#bea3c7",
-- 			intensity = "Normal",
-- 			underline = "None",
-- 			italic = false,
-- 			strikethrough = false,
-- 		},
-- 		inactive_tab = {
-- 			bg_color = "#0c0b0f",
-- 			fg_color = "#f8f2f5",
-- 			intensity = "Normal",
-- 			underline = "None",
-- 			italic = false,
-- 			strikethrough = false,
-- 		},
-- 		new_tab = {
-- 			bg_color = "#0c0b0f",
-- 			fg_color = "white",
-- 		},
-- 	},
-- }

config.window_frame = {
	font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Regular" }),
	active_titlebar_bg = "#0c0b0f",
}

config.window_decorations = "NONE | RESIZE"
config.initial_cols = 80

return config
