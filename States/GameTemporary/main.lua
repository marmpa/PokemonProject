local Game = {}



function Game:load()
	p = 4
	love.update = self.update
	love.draw = self.draw
	love.keypressed = self.keypressed
end

function Game:update()
	
end

function Game:draw()
	love.graphics.print(p, 5, 5)
end

function Game:keypressed(key)
	if(key == 'a') then
		LoadState("Battle")
	elseif(key == 'b') then
		LoadState("GameTemporary") 
	end
end

return Game