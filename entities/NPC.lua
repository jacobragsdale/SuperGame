--[[
    This is an abstract class that all non player characters will inherit
]]
local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

-- Ground class inherits Entity class
local NPC = Class{__includes = Entity}

function NPC:init(world, x, y, w, h, xV, yV, health, img, frame)
	self.img = img

    Entity.init(self, world, x, y, w, h)
    
    self.isNPC = true

    self.activeFrame = frame
    self.frameRate = 0.1
	self.curFrame = {}
    
    self.isFacingRight = true

    self.yVelocity = yV
    self.xVelocity = xV

    self.friction = 20 
	self.gravity = 100
	
	self.goalX = 0
	self.goalY = 0
    self.collisions = {}
    self.len = 0

    self.isGrounded = false

    --objects that still need to be spawned into the world
    self.objectQueue = {} 

    self.isAlive = true
    self.maxHealth = health
    self.curHealth = self.maxHealth
	self.canGetHurt = true

	self.isAttacking = false
	
	self.updateHealth = function (amt) 
		--returns true if the players health changes
		if amt < 0 and self.canGetHurt then --lose health
			if self.curHealth + amt >= 0 then --if we have enough health to lose
				self.curHealth = self.curHealth + amt
				self.canGetHurt = false
				return true
			else --we die
				self.curHealth = 0
				self.canGetHurt = false 
				self.isAlive = false
				return true 
			end
		elseif amt > 0 then --regen Health
			if self.curHealth >= self.maxHealth then --if we are already at full Health
				self.curHealth = self.maxHealth
				return false
			elseif self.curHealth + amt >= self.maxHealth then --if we will be at full Health after
				self.curHealth = self.maxHealth
				return true
			else 
				self.curHealth = self.curHealth + amt
				return true 
			end
		else return false end 
	end

	self.applyPhysics = function(dt)
		if self.curHealth <= 0 then self.isAlive = false end 

		-- these store the location the player will arrive at 
		self.goalX = self.x + self.xVelocity
		self.goalY = self.y + self.yVelocity

		--Move the player while testing for collisions
		self.x, self.y, self.collisions, self.len = self.world:move(self, self.goalX, self.goalY, self.collisionFilter)

		--Check collisions
		for i = 1, self.len do
			if self.collisions[i].normal.y < 0 then self.isGrounded = true end
		end

		--friction
		self.xVelocity = self.xVelocity * (1 - math.min(dt * self.friction, 1))
		self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))

		--gravity
		self.yVelocity = self.yVelocity + self.gravity * dt
	end

	self.attackPlayer = function (player)
		if self.x < player.x then --if npc is left of player 
			self.isFacingRight = true
		elseif self.x > player.x then --if npc is right of player
			self.isFacingRight = false
		end

		if self.isFacingRight and player.x - self.x <= self.w then 
			self.isRunning = false
			if math.abs(self.y - player.y) <= (self.h/2 + player.h/2) then 
				self.isAttacking = true 
			else self.isAttacking = false end
		elseif not self.isFacingRight and self.x - player.x <= player.w then
			self.isRunning = false
			if math.abs(self.y - player.y) <= (self.h/2 + player.h/2) then 
				self.isAttacking = true 
			else self.isAttacking = false end
		else
			self.isRunning = true  
			self.isAttacking = false 
		end
	end

	self.applyKnockBack = function(damage, direction)
		if direction == "Left" then 
			self.xVelocity = self.xVelocity - damage
		elseif direction == "Right" then
			self.xVelocity = self.xVelocity + damage
		elseif direction == "Down" then 
			self.yVelocity = self.yVelocity + self.yVelocity * damage
		elseif direction == "Up" then 
			self.yVelocity = self.yVelocity - self.yVelocity * damage
		end
	end

	self.move = function (direction)
		local dt = love.timer.getDelta()
		if direction == "Left" then 
			if self.xVelocity > -self.maxSpeed then
				self.xVelocity = self.xVelocity - self.acceleration * dt
			end
		elseif direction == "Right" then
			if self.xVelocity < self.maxSpeed then
				self.xVelocity = self.xVelocity + self.acceleration * dt
			end
		end
	end

end

return NPC