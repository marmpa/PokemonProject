local socket = require("socket")
function ClearLoveCallBacks()
	love.draw = nil
	love.keypressed = nil
	love.keyreleased = nil
	love.mousepressed = nil
	love.mousereleased = nil
	love.update = nil

	--extra

	love.resize = nil

end

function LoadState(name)
	states = {}
	ClearLoveCallBacks()

	local path = "states/"..name
	local state = require(path.. "/main")
	state:load()
end


function love.load()
	LoadState("GameTemporary")
end


