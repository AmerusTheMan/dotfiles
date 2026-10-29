-- Input configuration

hl.config({
	input = {
		sensitivity = 0.1,
        accel_profile = "adaptive",
		kb_layout =	'se',

        touchpad = {
            natural_scroll = true
        },
    },
    cursor = {
        no_warps = true,
    }
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       action = "close" })
hl.gesture({ fingers = 3, direction = "up",         action = "fullscreen" })
hl.gesture({ fingers = 4, direction = "left",       action = "float" })
