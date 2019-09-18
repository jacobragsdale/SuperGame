dead = Gamestate.new()

-- record previous state
function dead:enter(from)
  self.from = from 
end

function dead:draw()
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()
  -- draw previous screen
  self.from:draw()

  -- overlay with dead message
  love.graphics.setColor(0,0,0, 100)
  love.graphics.rectangle('fill', 0,0, w, h)
  love.graphics.setColor(255,255,255)
  love.graphics.printf('YOU DIED', 0, h/2, w, 'center')
end

-- return to previous state
function dead:keypressed(key)
  if key == 'r' then
    return Gamestate.pop() 
  end
end

return dead