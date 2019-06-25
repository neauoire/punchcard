
local Navi = {}
local g

Navi.init = function(self)
  print('Control','Init')
  self:connect()
end

Navi.start = function(self)
  self:redraw()
end

Navi.bind = function(self,stack)
  self.stack = stack
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
    id = id_at(x,y)
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

-- 

Navi.grid_card = function(self)
  -- Active Card
  pos = pos_at(self.card)
  g:led(pos.x,pos.y,15)
  -- Draw Bytes
  for x=1,16 do
    for y=1,8 do
      is_light = self.stack:read(self.card,id_at(x,y))
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
      is_light = self.stack:known(id_at(x,y))
      if is_light then
        g:led(x,y,5)
      end
    end
  end 
end

-- 

Navi.view_card = function(self)
  screen.move(10,10)
  screen.text(Navi.card)
  screen.fill()
end

Navi.view_home = function(self)
  screen.move(10,10)
  screen.text('home')
  screen.fill()
end

-- 

Navi.toggle = function(self,id)
  if self:in_card() ~= true then print('Not in a card') ; return end
  print('toggle '..id)
  is_light = self.stack:read(self.card,id)
  if is_light == true then
    print('turn off')
    self.stack:write(self.card,id,false)
  else
    print('turn on')
    self.stack:write(self.card,id,true)
  end
  self:redraw()
end

-- 

Navi.enter_card = function(self,id)
  print('enter '..id)
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

return Navi