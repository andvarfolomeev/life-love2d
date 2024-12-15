---@class Dialog
local Dialog = {
	prompt = "",
	input = "",
	cb = nil,
	isOpen = false,
	ignoreKeypress = false,
}
Dialog.__index = Dialog

---@param cb (fun(text: string))
function Dialog.create(prompt, cb)
	local instance = setmetatable({
		prompt = prompt,
		input = "",
		cb = cb,
		isOpen = false,
		ignoreKeypress = true,
	}, Dialog)
	return instance
end

function Dialog:open()
	self.isOpen = true
	self.ignoreKeypress = true
	self.input = ""
end

function Dialog:close()
	self.isOpen = false
end

function Dialog:draw()
	if self.isOpen then
		local dialogWidth = 400
		local dialogHeight = 200

		local windowWidth = love.graphics.getWidth()
		local windowHeight = love.graphics.getHeight()

		local dialogX = (windowWidth - dialogWidth) / 2
		local dialogY = (windowHeight - dialogHeight) / 2

		love.graphics.setColor(0, 0, 0, 0.7)
		love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)

		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle("fill", dialogX, dialogY, dialogWidth, dialogHeight)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("line", dialogX, dialogY, dialogWidth, dialogHeight)

		love.graphics.print(self.prompt, dialogX + 20, dialogY + 20)
		love.graphics.rectangle("line", dialogX + 20, dialogY + 50, dialogWidth - 40, 30)
		love.graphics.print(self.input, dialogX + 25, dialogY + 55)

		love.graphics.print("[Enter] Save   [Esc] Cancel", dialogX + 20, dialogY + 100)
	end
end

---@param text string
function Dialog:textinput(text)
	if self.isOpen and not self.ignoreKeypress then
		self.input = self.input .. text
	else
		self.input = ""
	end
end

---@param key string
function Dialog:keypressed(key)
	if self.isOpen then
		if self.ignoreKeypress then
			self.ignoreKeypress = false
			return
		end
		if key == "backspace" then
			self.input = self.input:sub(1, -2)
		elseif key == "return" then
			self:close()
			self.cb(self.input)
		elseif key == "escape" then
			self:close()
		end
	end
end

return Dialog
