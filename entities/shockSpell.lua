local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

-- Ground class inherits Entity class
local shock = Class{__includes = Entity}

local shockImage = love.graphics.newImage('/graphics/shockSpell.png')
local shockFrames = {}
for i=0, 3 do shockFrames[i + 1] = love.graphics.newQuad(i * 64, 24, 64, 16, shockImage:getDimensions()) end
local curFrame = 1

function shock:init(world, x, y, isFacingRight)
	self.isPlayerObject = true
	self.img = shockImage

	--to not spawn it right on top of the player
	if not isFacingRight then Entity.init(self, world, x - 15, y + 10, 64, 16)
	else Entity.init(self, world, x, y + 10, 64, 16) end

	self.activeFrame = shockFrames[1]

	if isFacingRight then self.xVelocity = 25
	else self.xVelocity = -25 end

	self.yVelocity = 0

	self.damage = -25

	self.manaCost = 10

  	self.world:add(self, self:getRect())
end

local elapsedTime = 0
function shock:update(dt)
	--saving position before movement for collision testing
	local prevX, prevY = self.x, self.y

	--sprite animation
	elapsedTime = elapsedTime + dt

	if(elapsedTime > 0.05) then
		if(curFrame < 4) then curFrame = curFrame + 1
		else curFrame = 1 end
		self.activeFrame = shockFrames[curFrame]
		elapsedTime = 0
	end

	-- these store the location the player will arrive at 
	local goalX = self.x + self.xVelocity
	local goalY = self.y + self.yVelocity

	--Move the player while testing for collisions
  	self.x, self.y, collisions, len = self.world:move(self, goalX, goalY, self.collisionFilter)

	for i = 1, len do
		if collisions[i].normal.x ~= 0 then self.despawn = true end

		if collisions[i].other.isNPC then collisions[i].other.updateHealth(self.damage) end
	end
end

function shock:draw()
	love.graphics.draw(self.img, self.activeFrame, self.x, self.y)
end

return shock