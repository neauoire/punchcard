
local Navi = {}
local g

Navi.init = function(self)
  print('Control','Init')
  self:connect()
end

Navi.bind = function(self,program)
  self.program = program
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
    print(id)
    pos = pos_at(id)
    print('id: '..id..' pos: '..pos.x..','..pos.y..' real: '..x..','..y)
    -- if Navi.card == nil then
    --   Navi:enter_card(id)
    -- elseif Navi.card == id then
    --   Navi:leave_card(id)
    -- end
  end
end

Navi.on_grid_add = function(self,g)
  print('on_add')
end

Navi.on_grid_remove = function(self,g)
  print('on_remove')
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

Navi.redraw = function(self)
  screen.clear()
  if Navi.card then
    screen.move(10,10)
    screen.text(Navi.card)
    screen.fill()
  else
    screen.move(10,10)
    screen.text('home')
    screen.fill()
  end
  screen.update()
end

return Navi