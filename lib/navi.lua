local Navi = { focus = 1, frame = 1, is_playing = true}
local g

-- Utils

local pos_at = function(id)
  return { x = math.floor(id % 16), y = math.floor(id/16)+1  }
end

local to_hex = function(int)
  return string.format('%02x',int):upper()
end

local id_at = function(x,y)
  return ((y-1)*16)+x
end

-- Begin

Navi.init = function(self)
  print('Control','Init')
  self:connect()
end

Navi.start = function(self)
  self:set_bpm(120)
  Navi.metro:start()
  self:redraw()
end

Navi.bind = function(self,stack,instructor,operator)
  self.stack = stack
  self.instructor = instructor
  self.operator = operator
end

Navi.connect = function(self)
  print('Navi','Connecting..')
  g = grid.connect()
  g.key = self.on_grid_key
  g.add = self.on_grid_add
  g.remove = self.on_grid_remove
  print('Navi','Connected')
end

Navi.is_connected = function(self)
  return g.device ~= nil
end

Navi.on_grid_key = function(x,y,z)
  if z == 1 then
    local id = id_at(x,y)
    if Navi:in_card() == true then
      if Navi.card == id then
        Navi:leave_card()
      else
        Navi:toggle(id)
      end
    else
      Navi:enter_card(id)
    end
  end
end

Navi.on_grid_add = function(self,g)
  print('on_add')
end

Navi.on_grid_remove = function(self,g)
  print('on_remove')
end

Navi.toggle_play = function(self)
  if self.is_playing == true then
    self:stop()
  else
    self:play()
  end
end

Navi.play = function(self)
  print('play')
  self.is_playing = true
  Navi.metro:start()
  self:redraw()
end

Navi.stop = function(self)
  print('stop')
  self.is_playing = false
  Navi.metro:stop()
  self:redraw()
end

-- 

Navi.grid_card = function(self)
  -- Active Card
  local pos = pos_at(self.card)
  if self.operator.senders[self.card] then
    g:led(pos.x,pos.y,10)
  else
    g:led(pos.x,pos.y,5)
  end
  -- Draw Bytes
  for x=1,16 do
    for y=1,8 do
      local is_light = self.stack:read(self.card,id_at(x,y))
      if is_light then
        g:led(x,y,15)
      end
    end
  end 
end

Navi.grid_home = function(self)
  -- Draw Bytes
  for x=1,16 do
    for y=1,8 do
      local id = id_at(x,y)
      local is_light = self.stack:known(id)
      if is_light then
        if self.operator.senders[id] then
          g:led(x,y,10)
        else
          g:led(x,y,5)
        end
      end
    end
  end 
end

-- 

Navi.view_card = function(self)
  screen.fill()
  local count = 1
  for l=1,16 do
    local inst_id = self.stack:get_instruction(self.card,l)
    local instruction = self.instructor:get(inst_id)
    local x = 0 ; 
    local y = count*7
    if count > 8 then x = 64 ; y = (count-8)*7 end
    y = y + 2
    screen.level(5)
    screen.move(x,y)
    if l == self.focus then
      screen.text(' >')
    else
      screen.text(to_hex(inst_id))
    end
    screen.fill()
    screen.level(15)
    if instruction then
      name = self.instructor:name(instruction)
      screen.move(x+11,y)
      screen.text(name)
    end
    screen.fill()
    count = count + 1
  end
end

Navi.view_home = function(self)
  local offset = { x = 30, y = 13, spacing = 4 }
  for x=1,16,1 do 
    for y=1,8,1 do 
      local id = id_at(x,y)
      local is_light = self.stack:known(id)
      if is_light then
        if self.operator.senders[id] then
          screen.level(15)
        else
          screen.level(10)
        end
      else
        screen.level(1)
      end
      screen.pixel(offset.x+(x*offset.spacing),offset.y+(y*offset.spacing))
      screen.fill()
    end
  end
end

-- 

Navi.toggle = function(self,id)
  if self:in_card() ~= true then print('Not in a card') ; return end
  local is_light = self.stack:read(self.card,id)
  self.focus = pos_at(id).x
  if is_light == true then
    self.stack:write(self.card,id,false)
  else
    self.stack:write(self.card,id,true)
  end
  self:redraw()
end

Navi.run = function(self)
  self.operator:run()
  self:redraw()
  self.frame = ((self.frame-1)%16)+1
end

-- 

Navi.enter_card = function(self,id)
  print('enter '..id)
  Navi.focus = 1
  Navi.card = id
  Navi:redraw()
end

Navi.leave_card = function(self)
  print('leave '..Navi.card)
  Navi.card = nil
  Navi:redraw()
end

Navi.in_card = function(self)
  return self.card ~= nil
end

Navi.redraw = function(self)
  g:all(0)
  screen.clear()
  if self:in_card() then
    self:grid_card()
    self:view_card()
  else
    self:grid_home()
    self:view_home()
  end
  g:refresh()
  screen.update()
end

-- Metro

Navi.set_bpm = function(self,bpm)
  self.bpm = bpm
  self.metro.time = 60 / (self.bpm*2)
end

Navi.metro = metro.init()
Navi.metro.time = 1.0 / 15
Navi.metro.event = function()
  Navi:run()
end

return Navi