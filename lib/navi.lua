local Navi = { focus = 1, frame = 1, is_playing = true, grid = nil }

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
  redraw()
end

Navi.bind = function(self,stack,instructor,operator)
  self.stack = stack
  self.instructor = instructor
  self.operator = operator
end

Navi.connect = function(self)
  print('Navi','Connecting..')
  self.grid = grid.connect()
  self.grid.key = self.on_grid_key
  print('Navi','Connected')
end

Navi.is_connected = function(self)
  return self.grid.device ~= nil
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
  redraw()
end

Navi.stop = function(self)
  print('stop')
  self.is_playing = false
  self.operator:release_midi()
  Navi.metro:stop()
  redraw()
end

-- 

Navi.grid_card = function(self)
  -- Active Card
  local pos = pos_at(self.card)
  if self.operator.senders[self.card] then
    self.grid:led(pos.x,pos.y,10)
  else
    self.grid:led(pos.x,pos.y,5)
  end
  -- Draw Bytes
  for x=1,16 do
    for y=1,8 do
      local is_light = self.stack:read(self.card,id_at(x,y))
      if is_light then
        self.grid:led(x,y,15)
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
          self.grid:led(x,y,10)
        else
          self.grid:led(x,y,5)
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
          screen.level(5)
        end
      else
        screen.level(1)
      end
      screen.pixel(offset.x+(x*offset.spacing),offset.y+(y*offset.spacing))
      screen.fill()
    end
  end
end

Navi.view_error = function(self)
  screen.move(0,10)
  screen.text('Grid is not connected.')
  screen.fill()
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
  redraw()
end

Navi.run = function(self)
  self.operator:run()
  redraw()
  self.frame = self.frame + 1
end

-- 

Navi.enter_card = function(self,id)
  print('enter '..id)
  Navi.focus = 1
  Navi.card = id
  redraw()
end

Navi.leave_card = function(self)
  print('leave '..Navi.card)
  Navi.card = nil
  redraw()
end

Navi.get_bangs = function(self,id)
  local ns = {}
  local origin = pos_at(id)

  local west = id_at(origin.x-1,origin.y)
  local north_west = id_at(origin.x-1,origin.y-1)
  local north = id_at(origin.x,origin.y-1)
  local north_east = id_at(origin.x+1,origin.y-1)

  if self.operator.bangs[west] then ns[self.operator.bangs[west]] = true end
  if self.operator.bangs[north_west] then ns[self.operator.bangs[north_west]] = true end
  if self.operator.bangs[north] then ns[self.operator.bangs[north]] = true end
  if self.operator.bangs[north_east] then ns[self.operator.bangs[north_east]] = true end

  return ns
end

Navi.get_step = function(self)
  return ((self.frame-1)%16)+1
end

Navi.in_card = function(self)
  return self.card ~= nil
end

-- Metro

Navi.set_bpm = function(self,bpm)
  print('BPM',params:get("bpm"))
  params:set("bpm",bpm)
  self.metro.time = 60 / (params:get("bpm")*2)
end

Navi.metro = metro.init()
Navi.metro.time = 1.0 / 15
Navi.metro.event = function()
  Navi:run()
end

return Navi