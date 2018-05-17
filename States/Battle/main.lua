local Battle = {}

function Battle:load()
	t = 0
	socket = require "socket.core"

 	address,port = "localhost",12345

 	updateRate = 0.1

 	udp = socket.udp()

 	udp:settimeout(0)
 	udp:setpeername(address,port)

 	math.randomseed(os.time())

 	entity = tostring(math.random(99999))

 	local dg = string.format("%s %s %d %d", entity, 'at', 320, 240)
 	udp:send(dg)

 	t=0

	p = 5
	love.update = self.update
	love.draw = self.draw
	love.keypressed = self.keypressed
	love.resize = self.OnResize

	testImg = love.graphics.newImage("assets/mewFront.png")
	testImg1 = love.graphics.newImage("assets/mewBack.png")
	testImg:setFilter('nearest','nearest')
	testImg1:setFilter('nearest','nearest')

	imgScaleX = 2
	imgScaleY = 2

	img1X,img1Y = 10,love.graphics.getHeight() - testImg1:getHeight()*imgScaleY - 10
	imgX,imgY = love.graphics.getWidth() - testImg1:getHeight()*imgScaleX - 10, 10

	font = love.graphics.newFont(20)
	text = love.graphics.newText(font,"Hello")

	currentWidth = love.graphics.getWidth()
	currentHeight = love.graphics.getHeight()
	
	movementSpeed = 5


	time = 0;
end

function Battle.update(dt)
	time=dt
	t=t+dt
	if(t>5) then
		if(love.keyboard.isDown("left")) then
			img1X = img1X - movementSpeed
		elseif(love.keyboard.isDown("right")) then
			img1X = img1X + movementSpeed
		end

		if(love.keyboard.isDown("up")) then
			img1Y = img1Y - movementSpeed
		elseif(love.keyboard.isDown("down")) then
			img1Y = img1Y + movementSpeed
		end
	
		local dg = string.format("%s %s %f %f", entity, 'moveC', img1X, img1Y)
		--udp:send(dg)
		

		local dg = string.format("%s %s $", entity, 'update')
		udp:send(dg)
 
		t=0 -- set t for the next round
	
	end


	repeat
		-- and here is something new, the much anticipated other end of udp:send!
		-- receive return a waiting packet (or nil, and an error message).
		-- data is a string, the payload of the far-end's send. we can deal with it
		-- the same ways we could deal with any other string in lua (needless to 
		-- say, getting familiar with lua's string handling functions is a must.
		data, msg = udp:receive()
 
		if data then -- you remember, right? that all values in lua evaluate as true, save nil and false?
 
			-- match is our freind here, its part of string.*, and data is
			-- (or should be!) a string. that funky set of characters bares some 
			-- explanation, though.
			-- (need summary of patterns, and link to section 5.4.1)
			ent, cmd, parms = data:match("^(%S*) (%S*) (.*)")
			if cmd == 'at' then
				-- more patterns, this time with sets, and more length selectors!
				local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
				assert(x and y) -- validation is better, but asserts will serve.
 
				-- don't forget, even if you matched a "number", the result is still a string!
				-- thankfully conversion is easy in lua.
				x, y = tonumber(x), tonumber(y)
				if(ent==entity) then
					img1X=x
					img1Y=y
				end
				-- and finally we stash it away
				--world[ent] = {x=x, y=y}
			else
				-- this case shouldn't trigger often, but its always a good idea
				-- to check (and log!) any unexpected messages and events.
				-- it can help you find bugs in your code...or people trying to hack the server.
				-- never forget, you can not trust the client!
				print("unrecognised command:", cmd)
			end
 
		-- if data was nil, then msg will contain a short description of the
		-- problem (which are also error id...).
		-- the most common will be 'timeout', since we settimeout() to zero,
		-- anytime there isn't data *waiting* for us, it'll timeout.
		--
		-- but we should check to see if its a *different* error, and act accordingly.
		-- in this case we don't even try to save ourselves, we just error out.
		elseif msg ~= 'timeout' then 
			error("Network error: "..tostring(msg))
		end
	until not data 

end

function Battle:draw()
	love.graphics.print(p,5,5)
	love.graphics.draw(testImg,imgX,imgY,0,imgScaleX,imgScaleY)
	love.graphics.draw(testImg1,img1X,img1Y,0,imgScaleX,imgScaleY)

	love.graphics.print(love.graphics.getWidth().." "..love.graphics.getHeight().." yes",300)

	love.graphics.print(testImg:getWidth()*imgScaleX.." "..testImg:getHeight()*imgScaleY.." and the second object "..testImg1:getWidth()*imgScaleX.." "..testImg1:getHeight()*imgScaleY.." and dt"..time,0,200)

	love.graphics.draw(text,love.graphics.getWidth()-text:getWidth(),love.graphics.getHeight()-text:getHeight())

end

function Battle:keypressed(key)
	if(key == 'a') then
		LoadState("Battle")
	elseif(key == 'b') then
		LoadState("GameTemporary") 
	end

	if(key=="4") then
		love.window.setMode(400,400,{resizable=true})
	end

	if(key=="kp+") then
		movementSpeed = movementSpeed + 5
	elseif(key=="kp-") then
		movementSpeed = movementSpeed -5
	end

end

function Battle.OnResize(w,h)
	--imgX,imgY = 10,love.graphics.getWidth() - 10
	--img1X,img1Y = love.graphics.getHeight() - 10, 10

	imgScaleX = 2 * ( w/400)
	imgScaleY = 2 * ( h/400)


	img1X,img1Y = 10,love.graphics.getHeight() - testImg1:getHeight()*imgScaleY - 10
	imgX,imgY = love.graphics.getWidth() - testImg1:getHeight()*imgScaleX - 10, 10

	--if(w>h) then
	--	love.window.setMode(w,w,{resizable=true})
	--else
	--	love.window.setMode(h,h,{resizable=true})
	--end
end

return Battle