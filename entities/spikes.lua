local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

-- Ground class inherits Entity class
local spikes = Class{__includes = Entity}

local spikesImage = love.graphics.newImage('/graphics/spikes.png')

function spikes:init(world, x, y)
	self.img = spikesImage

    Entity.init(self, world, x, y, 32, 32)

    self.isSpikes = true
    self.doesDamage = true
    self.damage = 10
    
  	self.world:add(self, self:getRect())
end

function spikes:update(dt)
end

function spikes:draw()
	love.graphics.draw(self.img, self.x, self.y)
end

return spikes