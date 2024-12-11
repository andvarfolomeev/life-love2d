---@class Ticker
local Ticker = {}

---@return {
---   getDelay: (fun(): number),
---   setDelay: (fun(newDelay: number): nil),
---   tick: fun(function)
--- }
function Ticker.create(delay)
	local socket = require("socket")
	local lastTime = socket.gettime()
	return {
		getDelay = function()
			return delay
		end,
		setDelay = function(newDelay)
			delay = newDelay
		end,
		tick = function(func)
			if socket.gettime() - lastTime > delay then
				lastTime = socket.gettime()
				func()
			end
		end,
	}
end

return Ticker
