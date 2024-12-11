---@class History
---@field list table
---@field current number
local History = {}
History.__index = History

function History.create()
	local instance = setmetatable({}, History)
	instance.list = {}
	return instance
end

function History:add(x)
	self.list[#self.list + 1] = x
	self.current = #self.list
end

function History:tail()
	return self.list[self.current]
end

function History:prev()
	if self.current > 1 then
		self.current = self.current - 1
		return self.list[self.current]
	end
	return nil
end

function History:next()
	if self.current < #self.list then
		self.current = self.current + 1
		return self.list[self.current]
	end
	return nil
end

function History:clear()
	self.current = 1
	self.list = {}
end

return History
