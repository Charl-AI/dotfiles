local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Frappe"
config.font = wezterm.font("JetBrains Mono")
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" } -- turn off ligatures
config.hide_tab_bar_if_only_one_tab = true
config.font_size = 13.0

-- adding a border helps to prevent overlapping windows
-- from visually melding into one
config.window_frame = {
  border_left_width = "0.2cell",
  border_right_width = "0.2cell",
  border_bottom_height = "0.1cell",
  border_top_height = "0.1cell",
  border_left_color = "black",
  border_right_color = "black",
  border_bottom_color = "black",
  border_top_color = "black",
}
return config
