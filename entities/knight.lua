local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'
local NPC = require 'entities.NPC'
 
-- Ground class inherits Entity class
local Knight = Class{__includes = NPC}

local frameHeight = 64
local i = 0

local idleSheet = love.graphics.newImage('/graphics/knight/knightIdle.png')
    local idleFrameWidth = 64
    local idleFrames = { }
    local curIdleFrame = 1
    for i=0, 14 do
        idleFrames[i+1] = love.graphics.newQuad(i * idleFrameWidth, 0, idleFrameWidth, frameHeight, idleSheet:getDimensions())
    end
local runSheet = love.graphics.newImage('/graphics/knight/knightRun.png')
    local runFrameWidth = 96
    local runFrames = { }
    local curRunFrame = 1
    for i=0, 7 do
        runFrames[i+1] = love.graphics.newQuad(i * runFrameWidth, 0, runFrameWidth, frameHeight, runSheet:getDimensions())
    end
local attackSheet = love.graphics.newImage('/graphics/knight/knightAttack.png') 
    local attackFrameWidth = 144
    local attackFrames = { } 
    local curAttackFrame = 11
    for i=0, 21 do
        attackFrames[i+1] = love.graphics.newQuad(i * attackFrameWidth, 0, attackFrameWidth, frameHeight, attackSheet:getDimensions()) 
    end
local deathSheet = love.graphics.newImage('/graphics/knight/knightDeath.png')
    local deathFrameWidth = 96
    local deathFrames = { } 
    local curDeathFrame = 1
    for i=0, 14 do
        deathFrames[i+1] = love.graphics.newQuad(i * deathFrameWidth, 0, deathFrameWidth, frameHeight, deathSheet:getDimensions()) 
    end
local jumpFallSheet = love.graphics.newImage('/graphics/knight/knightJumpAndFall.png')
    local jumpFallFrameWidth = 154.28
    local jumpFallFrames = { } 
    local curJumpFallFrame = 1
    for i=0, 13 do
        jumpFallFrames[i+1] = love.graphics.newQuad(i * jumpFallFrameWidth, 0, jumpFallFrameWidth, frameHeight, jumpFallSheet:getDimensions()) 
    end
local rollSheet = love.graphics.newImage('/graphics/knight/knightRoll.png')
    local rollFrameWidth = 180
    local rollFrames = { } 
    local curRollFrame = 1
    for i=0, 14 do
        rollFrames[i+1] = love.graphics.newQuad(i * rollFrameWidth, 0, rollFrameWidth, frameHeight, rollSheet:getDimensions()) 
    end
local shieldSheet = love.graphics.newImage('/graphics/knight/knightShield.png')
    local shieldFrameWidth = 96
    local shieldFrames = { } 
    local curShieldFrame = 1
    for i=0, 6 do
        shieldFrames[i+1] = love.graphics.newQuad(i * shieldFrameWidth, 0, shieldFrameWidth, frameHeight, shieldSheet:getDimensions()) 
    end

function Knight:init(world, x, y)
    --object, world, x, y, width, height, xV, yV, health, img, frame
    NPC.init(self, world, x, y, 96, 48, 3, 0, 100, idleSheet, idleFrames[1])

    self.damage = -10 
    
    self.acceleration = 75 
	self.maxSpeed = 400 
    
    self.isRunning = true
    self.isJumping = false
    self.isRolling = false
    self.isShielding = false
    --self.isAttacking = false
    self.isDying = false

    self.canGetHurtTimerMax = 0.25
	self.canGetHurtTimer = self.canGetHurtTimerMax


  	self.world:add(self, self:getRect())
end

function Knight:update(dt)
	
    self.applyPhysics(dt)

    if not self.canGetHurt then 
        self.canGetHurtTimer = self.canGetHurtTimer - (1 * dt)
        if self.canGetHurtTimer < 0 then
            self.canGetHurt = true 
            self.canGetHurtTimer = self.canGetHurtTimerMax
        end 
    end

    if self.isRunning then 
        if self.isFacingRight then self.move("Right")
        else self.move("Left") end
    end

    for i = 1, self.len do 
        if self.collisions[i].other.isPlayer and self.isAttacking then 
            self.collisions[i].other:updateHealth(self.damage) 
        end
    end

    if not self.isAlive then self.isDying = true end
    if self.isDying then self.xVelocity = 0 end

    if self.activeFrame == deathFrames[15] then self.despawn = true end

    self:getFrame()
end

function Knight:draw()
    if self.isFacingRight then
        love.graphics.draw(self.img, self.activeFrame, self.x, self.y)
    else
        love.graphics.draw(self.img, self.activeFrame, self.x, self.y, 0, -1, 1, self.w, 0)
    end

    --drawing health bar
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle('fill', self.x, self.y - 5, self.curHealth, 2.5)
    love.graphics.setColor(255, 255, 255)
end

local elapsedTime = 0
function Knight:getFrame()
    elapsedTime = elapsedTime + love.timer.getDelta()
    if elapsedTime > self.frameRate then
        if self.isJumping then 
            if curJumpFallFrame < 14 then curJumpFallFrame = curJumpFallFrame + 1
            else curJumpFallFrame = 1 end
            self.img = jumpFallSheet
            self.activeFrame = jumpFallFrames[curJumpFallFrame]
        elseif self.isDying  then 
            if curDeathFrame < 15 then curDeathFrame = curDeathFrame + 1
            else curDeathFrame = 15 end
            self.img = deathSheet
            self.activeFrame = deathFrames[curDeathFrame]
        elseif self.isAttacking then
            if curAttackFrame < 22 then curAttackFrame = curAttackFrame + 1
            else curAttackFrame = 1 end
            self.img = attackSheet
            self.activeFrame = attackFrames[curAttackFrame]
        elseif self.isRolling then 
            if curRollFrame < 15 then curRollFrame = curRollFrame + 1
            else curRollFrame = 1 end
            self.img = rollSheet
            self.activeFrame = rollFrames[curRollFrame]
        elseif self.isRunning then 
            if curRunFrame < 8 then curRunFrame = curRunFrame + 1
            else curRunFrame = 1 end
            self.img = runSheet
            self.activeFrame = runFrames[curRunFrame]
        elseif self.isShielding then
            if curShieldFrame < 15 then curShieldFrame = curShieldFrame + 1
            else curShieldFrame = 1 end
            self.img = shieldSheet
            self.activeFrame = shieldFrames[curShieldFrame]
        else 
            if curIdleFrame < 15 then curIdleFrame = curIdleFrame + 1
            else curIdleFrame = 1 end
            self.img = idleSheet
            self.activeFrame = idleFrames[curIdleFrame]
        end
        
        elapsedTime = 0
    end
end

return Knight