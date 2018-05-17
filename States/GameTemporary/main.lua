local Game = {}



function Game:load()
	p = 4
    love.update = self.update
	love.draw = self.draw
	love.keypressed = self.keypressed

	--Setting up the world physics
	love.physics.setMeter(64)
	self.world = love.physics.newWorld(0,9.81*64, true)

	--Setting up tables
	self.objects = {}
	self.objects.players = {}

	--Inserting data
	self.objects.players[1] = {}
	self.objects.players[1]['body'] = love.physics.newBody(self.world,250/2,200/2,'dynamic')
	self.objects.players[1]['shape'] = love.physics.newCircleShape(20)
	self.objects.players[1]['fixture'] = love.physics.newFixture(self.objects.players[1]['body'],self.objects.players[1]['shape'],1)
	self.objects.players[1]['fixture']:setRestitution(1)

	self.objects.players[2] = {}
	self.objects.players[2]['body'] = love.physics.newBody(self.world,350/2,200/2,'dynamic')
	self.objects.players[2]['shape'] = love.physics.newCircleShape(20)
	self.objects.players[2]['fixture'] = love.physics.newFixture(self.objects.players[2]['body'],self.objects.players[2]['shape'],1)
	self.objects.players[2]['fixture']:setRestitution(1)

	self.objects.wall = {}
	self.objects.wall['body'] = love.physics.newBody(self.world,400/2,400-50/2)
	self.objects.wall['shape'] = love.physics.newRectangleShape(400,50)
	self.objects.wall['fixture'] = love.physics.newFixture(self.objects.wall['body'],self.objects.wall['shape'],1)



end

function Game:dtUpdate(dt)

end

function Game:update()

	test = {}
	for i,v in pairs(self) do
	for t,k in pairs(self) do
	for j,x in pairs(self) do
		table.insert(test,{j=j,x=x})
	end
	end

	for i,v in pairs(test) do

end
	self.world:update()

	if(love.keyboard.isDown("right")) then
		self.objects.players[1]['body']:applyForce(400,0)
	elseif(love.keyboard.isDown('left')) then
		self.objects.players[1]['body']:applyForce(-400,0)
	elseif(love.keyboard.isDown('left')) then
		self.objects.players[1]['body']:applyForce(0,400)
	elseif(love.keyboard.isDown('left')) then
		self.objects.players[1]['body']:applyForce(0,-400)
	en
dend

function Game:draw()
	love.graphics.print(p, 5, 5)

	for i,v in ipairs(self.objects.players) do
		love.graphics.circle('fill',
			v['body']:getX(),
			v['body']:getY(),
			v['shape']:getRadius()
			)
	end


end

function Game:keypressed(key)
	if(key == 'a') then
		LoadState("Battle")
	elseif(key == 'b') then
		LoadState("GameTemporary") 
	end
end

return Game