-- Each level will inherit from this class which itself inherits from Gamestate.
-- This class is Gamestate but with function for loading up Tiled maps.

local bump = require 'libs.bump.bump'
local Gamestate = require 'libs.hump.gamestate'
local Class = require 'libs.hump.class'
local sti = require 'libs.sti.sti' 
local Entities = require 'entities.Entities'
local camera = require 'libs.camera' 

local LevelBase = Class
{
    __includes = Gamestate,
    init = function(self, mapFile)
        self.map = sti(mapFile, {'bump'}) --using sti lib to open map file
        self.world = bump.newWorld()

        --resize the map fo fill the screen
        --self.map:resize(love.graphics.getWidth(), love.graphics.getHeight())
        --initialize our map to use the bump collision library
        self.map:bump_init(self.world)

        Entities:enter()
    end;
  Entities = Entities;
  camera = camera
}
-- All levels will have a pause menu
function LevelBase:keypressed(key)
    if Gamestate.current() ~= pause and key == 'p' then
      Gamestate.push(pause)
    end
end

function LevelBase:removeObjects()
  for i=1, #Entities.entityList do 
    if Entities.entityList[i].despawn then 
      self.world:remove(Entities.entityList[i])
      Entities:removeAt(i)
    end
  end
end

function LevelBase:playerObjects(player)
	if player.objectQueue ~= nil then 
		Entities:addMany(player.objectQueue) 
		
		for i=1, #player.objectQueue do 
			table.remove(player.objectQueue, i)
		end 
	end 

  if not player.isAlive then 
    player.isAlive = true
    player.curHealth = player.maxHealth
    Gamestate.push(dead)
  end
end

function LevelBase:positionCamera(player, camera)
    local mapWidth = self.map.width * self.map.tilewidth -- get width in pixels
    local halfScreen =  love.graphics.getWidth() / 2
  
    if player.x < (mapWidth - halfScreen) then -- use this value until we're approaching the end.
      boundX = math.max(0, player.x - halfScreen) --lock camera at the left side of the screen.
    else
      boundX = math.min(player.x - halfScreen, mapWidth - love.graphics.getWidth()) -- lock camera at the right side of the screen
    end
    
    --keeping the player on the map
    if player.x < 0 then player.x = 0 end
    if player.x > mapWidth - player.w then player.x = mapWidth - player.w end
  
    camera:setPosition(boundX, 0)
end

return LevelBase