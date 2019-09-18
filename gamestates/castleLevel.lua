-- Import libraries
local Gamestate = require 'libs.hump.gamestate'
local Class = require 'libs.hump.class'

-- Import Classes
local LevelBase = require 'gamestates.levelBase'

-- Import objects
local Player = require 'entities.player'
local ShockSpell = require 'entities.shockSpell'
local Spikes = require 'entities.spikes'
local Knight = require 'entities.knight'
local HUD = require 'entities.headsUpDisplay'
local Camera = require 'libs.camera'

-- Create Gamestate
local CastleLevel = Class{__includes = LevelBase}

function CastleLevel:init()
    LevelBase.init(self, '/gamestates/castle_level.lua')
end

function CastleLevel:enter()
    --where the player spawns
    player = Player(self.world, 64, 220)
    hud = HUD(self.world, camera.x, camera.y, player.curHealth, player.curMana)
    --mage = Mage(self.world, 128, 380)
    knight = Knight(self.world, 128, 430)
    
    
    --adds the player to the list of entities
    LevelBase.Entities:add(player)
    LevelBase.Entities:add(hud)
    --LevelBase.Entities:add(mage)
    LevelBase.Entities:add(knight)
end


function CastleLevel:update(dt)

    self.map:update(dt) --since we inherited map from LevelBase
    LevelBase.Entities:update(dt) --updates for each entity

    LevelBase.playerObjects(self, player)
    --camera
    LevelBase.positionCamera(self, player, camera)

    LevelBase.removeObjects(self)

    hud:update(camera.x, camera.y, player.curHealth, player.curMana)
    knight.attackPlayer(player)
end


function CastleLevel:draw()
    camera:set() --first attach the camera
  
    self.map:draw(-camera.x, -camera.y) --draw the map relative to the camera
    LevelBase.Entities:draw() --draw all the entities

    camera:unset() --detach the camera
end

--all levels will have a pause menu
function CastleLevel:keypressed(key)
    LevelBase:keypressed(key)
end

return CastleLevel