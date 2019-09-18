local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

-- Ground class inherits Entity class
local HUD = Class{__includes = Entity}

function HUD:init(world, x, y, playerHealth, playerMana)
  	Entity.init(self, world, x, y, 1, 1)

	self.playerHealth = playerHealth
	self.playerMana = playerMana

  	self.world:add(self, self:getRect())
end

function HUD:update(x, y, playerHealth, playerMana)
	self.x = x 
	self.y = y + 10
	self.playerHealth = playerHealth
	self.playerMana = playerMana
end

function HUD:draw()
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle('fill', self.x + 10, self.y, self.playerHealth, 10)
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle('fill', self.x + 10, self.y + 20, self.playerMana, 10)
  love.graphics.setColor(255, 255, 255)
end

return HUD