--zip -9 -r SuperGame.love .

-- Pull in Gamestate from the HUMP library
Gamestate = require 'libs.hump.gamestate'

-- Pull in each of our game states
local mainMenu = require 'gamestates.mainMenu'
local castleLevel = require 'gamestates.castleLevel'
local pause = require 'gamestates.pause'
local dead = require 'gamestates.dead'

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(castleLevel)
end

function love.keypressed(key)
  if key == "escape" then
      love.event.push("quit")
  end
end

--[[
	Midieval player is abducted by aliens and flown to an advanced world
	a [solar flare] has destroyed all of the planet's technology and they are
	recruiting the best pre electricity fighters from across the galaxy.

	You could have fighting first with just your fists and the one sword.
	Magic could exist and the player could learn interesting spells for new
	upgrades that would be easier to code and animate 

	Aliens that abducted you do not have magic and relied on their tech alone,
	that's why they need you now. Maybe they can tell where magical beings are. 
]]