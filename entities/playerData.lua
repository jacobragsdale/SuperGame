local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

-- playerStates class inherits our Entity class
local playerData = Class{__includes = Entity}

local playerSpriteSheet = love.graphics.newImage('/graphics/playerSpriteSheet.png')
local spriteWidth, spriteHeight = playerSpriteSheet:getDimensions()
local playerFrames = {}

--sheathed idle frames
playerFrames[1] = { 		
	love.graphics.newQuad(0, 0, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(50, 0, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 0, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(150, 0, 50, 37, spriteWidth, spriteHeight)
}
--2 drawn idle frames
playerFrames[2] = {
	love.graphics.newQuad(150, 185, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(200, 185, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(250, 185, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 185, 50, 37, spriteWidth, spriteHeight)
}
--3 drawing frames
playerFrames[3] = {
	love.graphics.newQuad(0, 370, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(50, 370, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 370, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(150, 370, 50, 37, spriteWidth, spriteHeight)
}
--4 sheathing frames
playerFrames[4] = {
	love.graphics.newQuad(150, 370, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(200, 370, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(250, 370, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 370, 50, 37, spriteWidth, spriteHeight)
}
--5 run frames
playerFrames[5] = {
	love.graphics.newQuad(50, 37, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 37, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(150, 37, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 37, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(250, 37, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 37, 50, 37, spriteWidth, spriteHeight)
}
--6 jump frames
playerFrames[6] = {
	love.graphics.newQuad(0, 74, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(50, 74, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 74, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(150, 74, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(50, 111, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 111, 50, 37, spriteWidth, spriteHeight)
}
--7 double jump frames
playerFrames[7] = {
	love.graphics.newQuad(200, 74, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(250, 74, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 74, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(0, 111, 50, 37, spriteWidth, spriteHeight)
}
--8 cast frames
playerFrames[8] = {
	love.graphics.newQuad(50, 444, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 444, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(150, 444, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(200, 444, 50, 37, spriteWidth, spriteHeight)
}
--9 attack 1 frames
playerFrames[9] = {
	love.graphics.newQuad(0, 222, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(50, 222, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 222, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(150, 222, 50, 37, spriteWidth, spriteHeight)
}
--10 attack 2 frames
playerFrames[10] = {
	love.graphics.newQuad(0, 259, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(50, 259, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 259, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(150, 259, 50, 37, spriteWidth, spriteHeight)
}
--11 attack 3 frames
playerFrames[11] = {
	love.graphics.newQuad(200, 259, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(250, 259, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 259, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(0, 296, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(50, 296, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 296, 50, 37, spriteWidth, spriteHeight)
}
--12 attack 4 frames
playerFrames[12] = {
	love.graphics.newQuad(250, 481, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 481, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(0, 518, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(50, 518, 50, 37, spriteWidth, spriteHeight)
}
--13 attack 5 frames 
playerFrames[13] = {
	love.graphics.newQuad(100, 518, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(150, 518, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(200, 518, 50, 37, spriteWidth, spriteHeight)
}
--14 attack 6 frames
playerFrames[14] = { 
	love.graphics.newQuad(250, 518, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 518, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(0, 555, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(50, 555, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 555, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(150, 555, 50, 37, spriteWidth, spriteHeight)
}
--15 hurt frames
playerFrames[15] = {
	love.graphics.newQuad(150, 296, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(200, 296, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(250, 296, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 296, 50, 37, spriteWidth, spriteHeight)
}
--16 slide frames
playerFrames[16] = {
	love.graphics.newQuad(150, 111, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(200, 111, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(250, 111, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 111, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(0, 148, 50, 37, spriteWidth, spriteHeight)
}
--17 wall slide frames
playerFrames[17] = {
	love.graphics.newQuad(100, 407, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(150, 407, 50, 37, spriteWidth, spriteHeight)
}
--18 crouch frames
playerFrames[18] = {
	love.graphics.newQuad(200, 0, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(250, 0, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 0, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(0, 37, 50, 37, spriteWidth, spriteHeight)
} 
--19 cliff hang frames
playerFrames[19] = {
	love.graphics.newQuad(50, 148, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 148, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(150, 148, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(200, 148, 50, 37, spriteWidth, spriteHeight)
}
--20 cliff save frames
playerFrames[20] = {
	love.graphics.newQuad(250, 148, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(300, 148, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(0, 185, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(50, 185, 50, 37, spriteWidth, spriteHeight),
	love.graphics.newQuad(100, 185, 50, 37, spriteWidth, spriteHeight)
}

function playerData:getImg()
	return playerSpriteSheet
end

function playerData:getFrame(table, frame)
	if table > 0 and table < #playerFrames + 1 and frame > 0 and frame < #playerFrames[table] + 1 then 
	return playerFrames[table][frame]
	else return playerFrames[1][1] end 
end

return playerData