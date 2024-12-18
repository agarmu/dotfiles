local wezterm = require("wezterm")
local config = {}

-- set $TERM to `wezterm` for full support
config.term = "wezterm"

-- use wezterm config builder (for cleaner errors, etc.)
-- if it is available
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- rendering & fps
--
-- possibly faster on macOS to use `WebGpu`
-- ref: https://github.com/wez/wezterm/discussions/3664
config.front_end = "WebGpu"

config.max_fps = 120
config.animation_fps = 1

-- colorscheme, tab bar
config.color_scheme = "tokyonight"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_background_opacity = 1

-- font & font shaping
config.font = wezterm.font("Cascadia Code NF")
config.font_size = 14.5

config.harfbuzz_features = {
	"calt",
	"ss01",
	"ss19",
	"ss20",
}

-- cursor configuration
config.default_cursor_style = "BlinkingBar"
config.cursor_thickness = 2

-- start a new tab when using `wezterm start/connect`
config.prefer_to_spawn_tabs = true

-- scrollbar
config.enable_scroll_bar = true

-- macOS fullscreen features
config.native_macos_fullscreen_mode = true

return config
