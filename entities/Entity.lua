--This file uses HUMP library to add classes to lua
--Every object in the game will be an entity object

local Class = require 'libs.hump.class'

local Entity = Class{}

function Entity:init(world, x, y, w, h)
  self.world = world
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.despawn = false
end

--for now every object is a rectangle
function Entity:getRect()
  return self.x, self.y, self.w, self.h
end

function Entity:draw()
  -- Do nothing by default
end

function Entity:update(dt)
  -- Do nothing by default
end

return Entity