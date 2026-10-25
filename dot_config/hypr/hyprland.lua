-- CachyOS Hyprland Configuration

require("monitors")


require("config.animations")
require("config.autostart")
require("config.colors")
require("config.decorations")
require("config.variables")
require("config.environment")
require("config.inputs")
require("config.binds")
require("config.misc")
require("config.windowrules")
require("config.workspaces")

-- For Noctalia Color templates
require("noctalia").apply_theme()

-- Extra/self

require("config.noctalia")

-- debug.disable_logs = false
-- debug.gl_debugging = true
