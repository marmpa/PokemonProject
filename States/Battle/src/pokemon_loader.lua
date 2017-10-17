local Class = require "lib/middleclass"
local PokemonLoader = Class('PokemonLoader')


function PokemonLoader:initialize(spriteName)
	self.pokemon = {}
	self.pokemon.image = love.graphics.newImage(spriteName)
	self.pokemon.image:setFilter('nearest','nearest')
end


function PokemonLoader:LoadSprite()

end

return PokemonLoader