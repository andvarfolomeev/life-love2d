local M = {
	isPlaying = false,
	lastKey = "",
	iteration = 0,
}

function M:clear()
	self.iteration = 0
	self.lastKey = ""
	self.isPlaying = false
end

return M
