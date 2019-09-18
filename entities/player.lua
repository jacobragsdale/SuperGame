local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'
local PlayerData = require 'entities.playerData'
local ShockSpell = require 'entities.shockSpell'

-- Player class inherits our Entity class.
local player = Class{__includes = Entity}

function player:init(world, x, y)
	
	self.isPlayer = true
	--setting the player image
	self.img = PlayerData:getImg()

	self.tallHeight = 37
	self.shortHeight = self.tallHeight / 2

	--initializing player as an entity object
	Entity.init(self, world, x, y, 50, self.tallHeight)

	self.objectQueue = {} --objects that still need to be spawned into the world

	--physics
	self.xVelocity = 0 
	self.yVelocity = 0
	self.acceleration = 100
	self.maxSpeed = 10
	self.friction = 20 
	self.gravity = 100

	--cliff hanging
	self.isCliffHanging = false 
	self.isCliffSaving = false
		self.isCliffSavingTimerMax = 0.5
		self.isCliffSavingTimer = self.isCliffSavingTimerMax

	--health
	self.maxHealth = 120
	self.curHealth = self.maxHealth
	self.isAlive = true
	self.canGetHurt = true
		self.canGetHurtTimerMax = 0.5
		self.canGetHurtTimer = self.canGetHurtTimerMax

	--mana
	self.maxMana = 300
	self.curMana = self.maxMana
	self.canCast = true
		self.canCastTimerMax = 0.25
		self.canCastTimer = self.canCastTimerMax
	self.isCasting = false
		self.isCastingTimerMax = 0.4
		self.isCastingTimer = self.isCastingTimerMax
	
	--attacking
	self.damage = -15
	self.canAttack = true
	self.curAttack = 1
	self.prevAttack = self.curAttack
	self.isAttacking = false
		self.isAttackingTimerMax = 0.4  
		self.isAttackingTimer = self.isAttackingTimerMax

	--swapping weapon
	self.swordDrawn = true
	self.canSwap = true
		self.canSwapTimerMax = 0.5
		self.canSwapTimer = self.canSwapTimerMax
	self.isSwapping = false
		self.isSwappingTimerMax = 0.4
		self.isSwappingTimer = self.isSwappingTimerMax

	--jumping
	self.jumpAcceleration = 45
	self.isGrounded = false
	self.canJump = true
		self.canJumpTimerMax = 0.25
		self.canJumpTimer = self.canJumpTimerMax

	--double jumping
	self.canDoubleJump = false
		self.canDoubleJumpTimerMax = 0.5
		self.canDoubleJumpTimer = self.canDoubleJumpTimerMax
	self.isDoubleJumping = false
		self.isDoubleJumpingTimerMax = 0.4
		self.isDoubleJumpingTimer = self.isDoubleJumpingTimerMax
	self.hasDoubleJumped = false

	--wall jumping
	self.canWallJump = false
		self.canWallJumpTimerMax = 0.5
		self.canWallJumpTimer = self.canWallJumpTimerMax

	--running
	self.isRunning = false

	--sliding
	self.isSliding = false
		self.isSlidingTimerMax = 1
		self.isSlidingTimer = self.isSlidingTimerMax
	self.canSlide = true

	--wall sliding
	self.isWallSliding = false
	self.slideSpeed = 2

	--crouching
	self.isCrouching = false
	self.canStand = true

	--orientation
	self.isFacingRight = true

	--animation
	self.frameRate = 0.1
	self.curFrame = {}
	for i=1, 20 do self.curFrame[i] = 1 end

	self.activeFrame = PlayerData:getFrame(0, 0)

	--adding player to the world
	self.world:add(self, self:getRect())
end

function player:update(dt)

	--saving the player's x and y value before moving
	local prevX, prevY = self.x, self.y

	--cooldown timer before player can take damage again
	if not self.canGetHurt then 
		self.canGetHurtTimer = self.canGetHurtTimer - (1 * dt)
		if self.canGetHurtTimer < 0 then 
			self.canGetHurtTimer = self.canGetHurtTimerMax
			self.canGetHurt = true
		end
	end

--======================GROUND MOVEMENT==========================================--
	--rotating and then moving player left or right if able
	if love.keyboard.isDown("a") then self:run("Left")
	elseif love.keyboard.isDown("d") then self:run("Right")
	else self.isRunning = false end

	if love.keyboard.isDown('s') and not self.isRunning then self:crouch("Down")
	elseif self.isCrouching then self:crouch("Up") end

	if love.keyboard.isDown('s') and self.isRunning then self:slide("Down")
	elseif self.isSliding then self:slide("Up") end

	if not self.isGrounded then self:wallSlide() end
--===================JUMPING==============================================--
	
	--jump
	if love.keyboard.isDown('w') and self.canJump then self:jump(dt) end

		--running jump timer
		if self.isGrounded then --player can jump after timer that starts when on the ground
			self.canDoubleJump = false
			self.canJumpTimer = self.canJumpTimer - (1 * dt)
			if self.canJumpTimer < 0 then
				self.canJump = true
				self.hasDoubleJumped = false
				self.canJumpTimer = self.canJumpTimerMax
			end
		end

	--double jump
	if love.keyboard.isDown("w") and self.canDoubleJump then self:doubleJump() end

	--can double jump after jumping and releasing w
	if not love.keyboard.isDown("w") and not self.canJump and not self.hasDoubleJumped then 
		self.canDoubleJump = true
	end

		--running timer for double jump animation
		if self.isDoubleJumping then 
			self.isDoubleJumpingTimer = self.isDoubleJumpingTimer - (1 * dt)
			if self.isDoubleJumpingTimer < 0 then
				self.isDoubleJumpingTimer = self.isDoubleJumpingTimerMax
				self.isDoubleJumping = false
			end
		end

	--wall jump
	if love.keyboard.isDown('w') and self.canWallJump then self:wallJump() end
	
		--running wall jump timer
		if self.isWallSliding then 
			self.canWallJumpTimer = self.canWallJumpTimer - (1 * dt)
			if self.canWallJumpTimer < 0 then 
				self.canWallJumpTimer = self.canWallJumpTimerMax
				self.canWallJump = true
			end
		else self.canWallJump = false end

--==================WEAPON SWAPPING============================--
	if love.keyboard.isDown("e") and self.canSwap then self:swapWeapon() end

	if not self.isGrounded then self.canSwap = false end

		--running can swap timer
		if not self.canSwap then 
			self.canSwapTimer = self.canSwapTimer - (1 * dt)
			if self.canSwapTimer < 0 then
				self.canSwap = true
				self.canSwapTimer = self.canSwapTimerMax
			end
		end

		--running swap animation timer
		if self.isSwapping then
			self.isSwappingTimer = self.isSwappingTimer - (1 * dt)
			if self.isSwappingTimer < 0 then
				self.isSwapping = false
				self.isSwappingTimer = self.isSwappingTimerMax
			end
		end

--===================SPELL CASTING==============================================================--
	if love.keyboard.isDown("1") and self.canCast then 
		self.canCast = false
		self.isCasting = true
	end

	if self.isCasting then 
		self.isCastingTimer = self.isCastingTimer - (1 * dt)
		if self.isCastingTimer < 0 and self:updateMana(-10) then 
			if self.isFacingRight then 
				table.insert(self.objectQueue, ShockSpell(self.world, self.x + self.w, self.y, self.isFacingRight))
			else 
				table.insert(self.objectQueue, ShockSpell(self.world, self.x - self.w, self.y, self.isFacingRight)) 
			end
			self.isCastingTimer = self.isCastingTimerMax
			self.isCasting = false
		end
	end

	--cooldown timer starts after spell is finished casting
	if not self.canCast and not self.isCasting then 
		self.canCastTimer = self.canCastTimer - (1 * dt)
		if self.canCastTimer < 0 then 
			self.canCastTimer = self.canCastTimerMax
			self.canCast = true
		end
	end

	--ensures that the cast frames start from the beginning each time
	if not self.isCasting then self.curFrame[8] = 1 end

--===================MELEE ATTACKING==============================================================--
	if love.keyboard.isDown('space') and self.canAttack then self:meleeAttack() end 
	
		--running attack timer
		if self.curAttack ~= 6 then 
			self.isAttackingTimer = self.isAttackingTimer - (1 * dt)
			if self.isAttackingTimer < 0 then 
				self.isAttacking = false
				if self.isGrounded then self.canAttack = true end
			end
		elseif self.isGrounded then 
			self.isAttackingTimer = self.isAttackingTimer - (1 * dt)
			if self.isAttackingTimer < 0 then 
				self.isAttacking = false
				if self.swordDrawn then self.canAttack = true end
			end
		end

	--cliff hanging 
	if not self.isGrounded then self:cliffHang() end

	if (self.isCliffHanging and love.keyboard.isDown('w')) or self.isCliffSaving then self:cliffSave(dt) end

	if not self.isCliffHanging then self:move() end

	self:setActiveFrame(dt)
end

function player:jump(dt)
	self.yVelocity = self.yVelocity - self.jumpAcceleration
	self.canJump = false
	self.isGrounded = false
end

function player:doubleJump()
	self.isDoubleJumping = true
	self.yVelocity = self.yVelocity - self.jumpAcceleration
	self.canDoubleJump = false
	self.hasDoubleJumped = true
end

function player:wallJump()
	if self.isFacingRight then 
		self.xVelocity = self.xVelocity - 15
		self:rotate("Left")
	else 
		self.xVelocity = self.xVelocity + 15
		self:rotate("Right") 
	end
	self.yVelocity = self.yVelocity - self.jumpAcceleration / 2
	self.canWallJump = false
end

function player:meleeAttack()
	--deciding which attack 
	if self.isGrounded then 
		if self.curAttack < 3 then self.curAttack = self.curAttack + 1
		else self.curAttack = 1 end
	else --if it's an air attack
		if love.keyboard.isDown('s') then self.curAttack = 6
		elseif self.yVelocity < 0 then self.curAttack = 5
		else self.curAttack = 4 end 
	end 

	--changing timer for different length attacks
	if self.curAttack == 3 then self.isAttackingTimerMax = 0.6
	elseif self.curAttack == 5 or self.curAttack == 6 then self.isAttackingTimerMax = 0.3
	else self.isAttackingTimerMax = 0.4 end
	
	self.canAttack = false
	self.isAttacking = true
	self.isAttackingTimer = self.isAttackingTimerMax

	local items, len, dir
	if self.curAttack ~= 6 and self.isFacingRight then 
		items, len = self.world:queryRect(self.x + self.w, self.y, 1, self.h)
		dir = "Right"
	elseif self.curAttack ~= 6 and not self.isFacingRight then  
		items, len = self.world:queryRect(self.x - 1, self.y, 1, self.h) 
		dir = "Left"
	else
		items, len = self.world:queryRect(self.x, self.y + self.h, self.w, 10) 
		dir = "Down"
	end
	for i=1, len do 
		if items[i].isNPC then 
			items[i].updateHealth(self.damage)
			items[i].applyKnockBack(self.damage, dir) 
		end
	end
end

function player:cliffHang()
	--[[
		Checks two rectangles, one immedieatly to the (left/right) of the player
		and one directly above the first rectangle. Iff the top rectanle has nothing
		in it and the bottom rectangle has exactly one thing in it then the player is
		cliff hanging/ 
	]]
	local items1, len1, items2, len2 
	local tileWidth = 32
	if self.isFacingRight then
		items1, len1 = self.world:queryRect(self.x + self.w, self.y - self.h, tileWidth, self.h)
		items2, len2 = self.world:queryRect(self.x + self.w, self.y, tileWidth, self.h)
		if len1 == 0 and len2 == 1 and not items2[1].isNPC and not items2[1].isPlayerObject then 
			self.x = items2[1].x - self.w
			self.y = items2[1].y
			self.isCliffHanging = true
		else self.isCliffHanging = false end
	else
		items1, len1 = self.world:queryRect(self.x - tileWidth, self.y - self.h, tileWidth, self.h)
		items2, len2 = self.world:queryRect(self.x - tileWidth, self.y, tileWidth, self.h)
		if len1 == 0 and len2 == 1 and not items2[1].isNPC and not items2[1].isPlayerObject then 
			self.x = items2[1].x + self.w
			self.y = items2[1].y
			self.isCliffHanging = true
		else self.isCliffHangin = false end
	end
end

function player:cliffSave(dt)
	self.isCliffSaving = true
	self.isCliffSavingTimer = self.isCliffSavingTimer - (1 * dt)
	if self.isCliffSavingTimer < 0 then
		self.isCliffSavingTimer = self.isCliffSavingTimerMax
		self.isCliffHanging = false
		self.isCliffSaving = false 
		self.curFrame[20] = 1
		self.yVelocity = -25
		self:move()
	end
end

function player:swapWeapon()
	self.isSwapping = true
	if self.swordDrawn then self.swordDrawn = false
	else self.swordDrawn = true end
	self.canSwapTimer = self.canSwapTimerMax
	self.canSwap = false
end

function player:run(direction)
	local dt = love.timer.getDelta()
	--determing if player can move
	if (self.isAttacking and (self.curAttack == 6 or self.isGrounded))
		or self.isCasting or self.isSwapping then return 
	else
		self.isRunning = true
		if direction == "Right" then
			self:rotate(direction)
			if self.xVelocity < self.maxSpeed then
				self.xVelocity = self.xVelocity + self.acceleration * dt
			end
		elseif direction == "Left" then 
			self:rotate(direction)
			if self.xVelocity > -self.maxSpeed then
				self.xVelocity = self.xVelocity - self.acceleration * dt
			end
		end
	end
end

function player:crouch(direction)
	if direction == "Down" and self.h == self.tallHeight then 
		self.isCrouching = true
		self.canSlide = false
		self.h = self.shortHeight
	elseif direction == "Up" and self.h == self.shortHeight then 
		self.isCrouching = false
		self.canSlide = true 
		self.h = self.tallHeight
	end
	self.world:update(self, self.x, self.y, self.w, self.h)
end

function player:slide(direction)
	if direction == "Down" then
		self.isSliding = true 
		self.h = self.shortHeight
		self.world:update(self, self.x, self.y, self.w, self.h)
	elseif direction == "Up" then 
		if not self:checkRect(self.x - (self.w / 2), self.y - (self.tallHeight - self.shortHeight), self.w * 2 , self.tallHeight - self.shortHeight) then 
			self.isSliding = false
			self.h = self.tallHeight
			self.world:update(self, self.x, self.y, self.w, self.h)
			return true
		else return false end
	end
end

function player:wallSlide()
	local isWall = false
	if self.isFacingRight then isWall = self:checkRect(self.x + self.w, self.y, 1, self.h)
	else isWall = self:checkRect(self.x - 1, self.y, 1, self.h) end

	if isWall then 
		self.isWallSliding = true
		self.yVelocity = self.slideSpeed 
	else self.isWallSliding = false end
end

function player:updateMana(amt)
	if amt <= 0 then --spend mana
		if self.curMana + amt >= 0 then --if we have enough mana to spend
			self.curMana = self.curMana + amt
			return true
		else return false end
	else --regen mana
		if self.curMana >= self.maxMana then --if we are already at full mana
			self.curMana = self.maxMana
			return false
		elseif self.curMana + amt >= self.maxMana then --if we will be at full mana after
			self.curMana = self.maxMana
			return true
		else 
			self.curMana = self.curMana + amt
			return true 
		end
	end 
end

function player:updateHealth(amt)
	--returns true if the players health changes
	if amt < 0 and self.canGetHurt then --lose health
		if self.curHealth + amt >= 0 then --if we have enough health to lose
			self.curHealth = self.curHealth + amt
			self.canGetHurt = false
			return true
		else --we die
			self.curHealth = 0
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

function player:rotate(direction)
	if not self.isCliffHanging then 
		if direction == "Right" then self.isFacingRight = true 
		elseif direction == "Left" then self.isFacingRight = false end
	end
end

function player:checkRect(l, t, w, h) --checks the world for a given rectangle and returns true if something is there
	local items, len = self.world:queryRect(l, t, w, h)
	if len == 0 then return false
	else return true end
end

local playerFilter = function(item, other)
	if other.isNPC then return 'bounce'
	else return 'slide' end
end

function player:move()

	local dt = love.timer.getDelta()

	-- these store the location the player will arrive at 
	local goalX = self.x + self.xVelocity
	local goalY = self.y + self.yVelocity

	--Move the player while testing for collisions
	self.x, self.y, collisions, len = self.world:move(self, goalX, goalY, playerFilter)

	--updating player stats based on collisions 
	for i=1, len do
		--checks if player is on the ground
		if collisions[i].normal.y < 0 then self.isGrounded = true end
	end

	--friction
	self.xVelocity = self.xVelocity * (1 - math.min(dt * self.friction, 1))
	self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))

	--gravity
	self.yVelocity = self.yVelocity + self.gravity * dt
end  


  
--================================Animation================================================================================--
local elapsedTime = 0
function player:setActiveFrame(dt)
	elapsedTime = elapsedTime + dt

	if elapsedTime >= self.frameRate then 
		if self.isCliffSaving then 
			if(self.curFrame[20] < 5) then self.curFrame[20] = self.curFrame[20] + 1
			else self.curFrame[20] = 1 end
			self.activeFrame = PlayerData:getFrame(20, self.curFrame[20])
		elseif not self.isGrounded then 											--air animations
			if self.isCliffHanging then 
				if(self.curFrame[19] < 4) then self.curFrame[19] = self.curFrame[19] + 1
				else self.curFrame[19] = 1 end
				self.activeFrame = PlayerData:getFrame(19, self.curFrame[19])
			elseif self.isWallSliding then 
				if(self.curFrame[17] < 2) then self.curFrame[17] = self.curFrame[17] + 1
				else self.curFrame[17] = 1 end
				self.activeFrame = PlayerData:getFrame(17, self.curFrame[17])
			elseif self.isAttacking and self.swordDrawn then 						--air attacks
				if self.curAttack == 4 then   
					if(self.curFrame[12] < 4) then self.curFrame[12] = self.curFrame[12] + 1
					else self.curFrame[12] = 1 end
					self.activeFrame = PlayerData:getFrame(12, self.curFrame[12])
				elseif self.curAttack == 5 then
					if(self.curFrame[13] < 3) then self.curFrame[13] = self.curFrame[13] + 1
					else self.curFrame[13] = 1 end
					self.activeFrame = PlayerData:getFrame(13, self.curFrame[13])
				elseif self.curAttack == 6 then 									--part one of attack 6
					if(self.curFrame[14] < 3) then self.curFrame[14] = self.curFrame[14] + 1
					else self.curFrame[14] = 2 end
					self.activeFrame = PlayerData:getFrame(14, self.curFrame[14])
				end
			elseif self.isDoubleJumping then 										--double jump animation
				if self.curFrame[7] < 4 then self.curFrame[7] = self.curFrame[7] + 1
				else self.curFrame[7] = 1 end
				self.activeFrame = PlayerData:getFrame(7, self.curFrame[7])
			elseif self.yVelocity > 0 then 											--falling animation
				if self.curFrame[6] < 6 then self.curFrame[6] = self.curFrame[6] + 1
				else self.curFrame[6] = 5 end
				self.activeFrame = PlayerData:getFrame(6, self.curFrame[6])
			else                  													--jumping animation
				if self.curFrame[6] < 6 then self.curFrame[6] = self.curFrame[6] + 1
				else self.curFrame[6] = 1 end
				self.activeFrame = PlayerData:getFrame(6, self.curFrame[6])
			end
		elseif self.isAttacking and self.swordDrawn then 							--sword attack animations
			if self.curAttack == 1 then
					if(self.curFrame[9] < 4) then self.curFrame[9] = self.curFrame[9] + 1
					else self.curFrame[9] = 1 end
					self.activeFrame = PlayerData:getFrame(9, self.curFrame[9])
			elseif self.curAttack == 2 then
					if(self.curFrame[10] < 4) then self.curFrame[10] = self.curFrame[10] + 1
					else self.curFrame[10] = 1 end
					self.activeFrame = PlayerData:getFrame(10, self.curFrame[10])
			elseif self.curAttack == 3 then 
					if(self.curFrame[11] < 6) then self.curFrame[11] = self.curFrame[11] + 1
					else self.curFrame[11] = 1 end
					self.activeFrame = PlayerData:getFrame(11, self.curFrame[11])
			elseif self.curAttack == 6 then  										--second part of attack 6 
					if(self.curFrame[14] < 6) then self.curFrame[14] = self.curFrame[14] + 1
					else self.curFrame[14] = 4 end
					self.activeFrame = PlayerData:getFrame(14, self.curFrame[14])
			end	
		elseif self.isCasting then 
				if(self.curFrame[8] < 4) then self.curFrame[8] = self.curFrame[8] + 1
				else self.curFrame[8] = 1 end
				self.activeFrame = PlayerData:getFrame(8, self.curFrame[8])
		elseif self.isSliding then 													--sliding animation
				if(self.curFrame[16] < 5) then self.curFrame[16] = self.curFrame[16] + 1
				else self.curFrame[16] = 1 end
				self.activeFrame = PlayerData:getFrame(16, self.curFrame[16])
		elseif self.isHurt then 													--guarding animation
				if(self.curFrame[15] < 2) then self.curFrame[15] = self.curFrame[15] + 1 
				else self.curFrame[15] = 1 end
				self.activeFrame = PlayerData:getFrame(15, self.curFrame[15])
		elseif self.isSwapping then
			if not self.swordDrawn then   											--draw sword animation
				if(self.curFrame[3] < 4) then self.curFrame[3] = self.curFrame[3] + 1
				else self.curFrame[3] = 1 end
				self.activeFrame = PlayerData:getFrame(3, self.curFrame[3])
			else                          											--sheath sword animation
				if(self.curFrame[4] < 4) then self.curFrame[4] = self.curFrame[4] + 1
				else self.curFrame[4] = 1 end
				self.activeFrame = PlayerData:getFrame(4, self.curFrame[4])
			end
		elseif self.isRunning then 													--run animation
				if(self.curFrame[5] < 6) then self.curFrame[5] = self.curFrame[5] + 1
				else self.curFrame[5] = 1 end
				self.activeFrame = PlayerData:getFrame(5, self.curFrame[5])
		elseif self.isCrouching then 												--crouch animation
				if(self.curFrame[18] < 4) then self.curFrame[18] = self.curFrame[18] + 1
				else self.curFrame[18] = 1 end
				self.activeFrame = PlayerData:getFrame(18, self.curFrame[18])
		elseif self.swordDrawn then 												--idle drawn sword animation
				if(self.curFrame[2] < 4) then self.curFrame[2] = self.curFrame[2] + 1
				else self.curFrame[2] = 1 end
				self.activeFrame = PlayerData:getFrame(2, self.curFrame[2])
		else 																		--idle sheathed sword animation
				if(self.curFrame[1] < 4) then self.curFrame[1] = self.curFrame[1] + 1
				else self.curFrame[1] = 1 end
				self.activeFrame = PlayerData:getFrame(1, self.curFrame[1])
		end 

		elapsedTime = 0
	end
end

function player:draw()
	--Changing x or y to draw under certain circumstances
	local newX, newY
	if not self.isFacingRight and self.isCliffHanging then newX = self.x - self.w/2 else newX = self.x end
	if self.h == self.shortHeight then newY = self.y - self.h else newY = self.y end
	--rotating the image based on orientation
    if self.isFacingRight then love.graphics.draw(self.img, self.activeFrame, newX, newY)
	else love.graphics.draw(self.img, self.activeFrame, newX, newY, 0, -1, 1, self.w, 0) end
end

return player