local consts = require("consts")

function love.conf(t)
	t.window.width = consts.windowWidth
	t.window.height = consts.windowHeight

	t.window.title = "Life"

	t.console = true
end
