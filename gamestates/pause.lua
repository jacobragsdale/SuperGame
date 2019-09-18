--this gamestate wil freeze everything and then load the 
--previous gamestate to unpause
pause = Gamestate.new()

-- record previous state
function pause:enter(from)
  self.from = from 
end

function pause:draw()
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()
  -- draw previous screen
  self.from:draw()

  -- overlay with pause message
  --love.graphics.setColor(0,0,0, 100)
  --love.graphics.rectangle('fill', 0,0, w, h)
  love.graphics.setColor(255,255,255)
  love.graphics.printf('PAUSE', 0, h/2, w, 'center')
end

-- return to previous state
function pause:keypressed(key)
  if key == 'p' then
    return Gamestate.pop() 
  end
end

return pause