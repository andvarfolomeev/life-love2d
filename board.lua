---@class Board
---@field gridXCount number
---@field gridYCount number
---@field data table
local Board = {}
Board.__index = Board

---@alias BoardData boolean[][]
---@alias BoardSize { gridXCount: number, gridYCount: number }

---@param opts BoardSize
local function initData(opts)
	local grid = {}
	for y = 1, opts.gridYCount do
		grid[y] = {}
		for x = 1, opts.gridXCount do
			grid[y][x] = false
		end
	end
	return grid
end

---@param size BoardSize
function Board.create(size)
	local instance = setmetatable(size, Board)
	---@diagnostic disable-next-line: inject-field
	instance.data = initData(size)
	return instance
end

---@param data BoardData
function Board.fromData(data)
	local instance = setmetatable({
		gridXCount = #data[1],
		gridYCount = #data,
	}, Board)
	---@diagnostic disable-next-line: inject-field
	instance.data = data
	return instance
end

---@function
---@param opts { x: number, y: number, active: boolean }
function Board:set(opts)
	if 1 < opts.x and opts.x < self.gridXCount then
		if 1 < opts.y and opts.y < self.gridYCount then
			self.data[opts.y][opts.x] = opts.active
		end
	end
end

---@return boolean
function Board:get(opts)
	return self.data[opts.y][opts.x]
end

---@return nil
function Board:clear()
	self.data = initData({ gridXCount = self.gridXCount, gridYCount = self.gridYCount })
end

function Board:iter(func)
	for y = 1, self.gridYCount do
		for x = 1, self.gridXCount do
			func({ y = y, x = x })
		end
	end
end

---@return BoardData
function Board:getData()
	return self.data
end

---@return nil
function Board:next()
	local nextGrid = {}
	for y = 1, self.gridYCount do
		nextGrid[y] = {}
		for x = 1, self.gridXCount do
			local neighborCount = 0
			for dy = -1, 1 do
				for dx = -1, 1 do
					if not (dy == 0 and dx == 0) and self.data[y + dy] and self.data[y + dy][x + dx] then
						neighborCount = neighborCount + 1
					end
				end
			end
			nextGrid[y][x] = neighborCount == 3 or (self.data[y][x] and neighborCount == 2)
		end
	end
	self.data = nextGrid
end

---@return string
function Board:toString()
	local result = { "{" }
	for _, row in ipairs(self.data) do
		table.insert(result, "{")
		for _, value in ipairs(row) do
			table.insert(result, tostring(value) .. ",")
		end
		table.insert(result, "},")
	end
	table.insert(result, "}")
	return table.concat(result, "")
end

return Board
