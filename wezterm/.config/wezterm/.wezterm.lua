local wezterm = require("wezterm")

return {
	color_scheme = "Catppuccin Mocha",
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_size = 13.0,

	enable_tab_bar = false,
	window_decorations = "RESIZE",
	window_padding = {
		left = 2,
		right = 2,
		top = 2,
		bottom = 2,
	},

	window_background_opacity = 1.0,

	set_environment_variables = {
		TERM = "xterm-256color",
	},

	animation_fps = 120,
	max_fps = 120,
	front_end = "WebGpu",
}
