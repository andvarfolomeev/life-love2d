local consts = require("consts")
local state = require("state")

local Board = require("board")
local board = Board.create({ gridXCount = consts.gridXCount, gridYCount = consts.gridYCount })

local History = require("history")
local history = History.create()

local Ticker = require("ticker")
local ticker = Ticker.create(consts.initialDelay)

local fieldWidth = consts.gridXCount * consts.cellSize
local fieldHeight = consts.gridYCount * consts.cellSize
local fieldX = (consts.windowWidth - fieldWidth) / 2
local fieldY = (consts.windowHeight - fieldHeight) / 2

local function getDebugMessage()
	return "Delay: "
		.. tostring(ticker.getDelay())
		.. "\n"
		.. "IsPlaying: "
		.. tostring(state.isPlaying)
		.. "\n"
		.. "LasKey: "
		.. state.lastKey
		.. "\n"
		.. "Iteration: "
		.. state.iteration
end

function love.load()
	love.graphics.setBackgroundColor(1, 1, 1)
	love.keyboard.setKeyRepeat(true)
end

local function getSelectedCell()
	local x = math.min(math.floor((love.mouse.getX() - fieldX) / consts.cellSize) + 1, consts.gridXCount)
	local y = math.min(math.floor((love.mouse.getY() - fieldY) / consts.cellSize) + 1, consts.gridYCount)
	return { x = x, y = y }
end

function love.update()
	local selectedCell = getSelectedCell()

	if not state.isPlaying then
		if love.mouse.isDown(1) then
			board:set({ x = selectedCell.x, y = selectedCell.y, active = true })
		elseif love.mouse.isDown(2) then
			board:set({ x = selectedCell.x, y = selectedCell.y, active = false })
		end
	end

	ticker.tick(function()
		if state.isPlaying then
			history:add(board.data)
			board:next()
			state.iteration = state.iteration + 1
		end
	end)
end

---@param key string
function love.keypressed(key)
	state.lastKey = key
	if key == "space" then
		state.isPlaying = not state.isPlaying
	end
	if key == "down" then
		ticker.setDelay(ticker.getDelay() + consts.delayStep)
	end
	if key == "up" then
		local newDelay = ticker.getDelay() - consts.delayStep
		if newDelay > 0 then
			ticker.setDelay(ticker.getDelay() - consts.delayStep)
		end
	end
	if not state.isPlaying then
		if key == "left" then
			local prev = history:prev()
			if prev ~= nil then
				board = Board:fromData(prev)
				state.iteration = state.iteration - 1
			end
		end
		if key == "right" then
			local next = history:next()
			if next ~= nil then
				state.iteration = state.iteration + 1
				board = Board:fromData(next)
			end
		end
	end
	if key == "c" then
		board:clear()
		state.iteration = 0
	end
end

function love.draw()
	board:iter(function(opts)
		love.graphics.setColor(0.86, 0.86, 0.86)
		if board:get(opts) then
			love.graphics.setColor(1, 0, 1)
		end

		local rectangleX = fieldX + (opts.x - 1) * consts.cellSize
		local rectangleY = fieldY + (opts.y - 1) * consts.cellSize
		love.graphics.rectangle("line", rectangleX, rectangleY, consts.cellDrawSize, consts.cellDrawSize)
	end)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(getDebugMessage())
end
