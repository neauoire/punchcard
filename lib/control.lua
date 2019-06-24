
local Control = {}
local g

Control.init = function(self)
  print('Control','Init')
  self:connect()
end

Control.bind = function(self,program,instructions,tracker)
  self.program = program
  self.instructions = instructions
  self.tracker = tracker
end

Control.connect = function(self)
  g = grid.connect()
  g.key = self.on_grid_key
  g.add = self.on_grid_add
  g.remove = self.on_grid_remove
end

Control.is_connected = function(self)
  return g.device ~= nil
end

Control.on_grid_key = function(x,y,z)
  if z == 1 then
    Control.program:swap(x,y)
    Control.tracker:set_focus(x)
    redraw()
  end
end

Control.on_grid_add = function(self,g)
  print('on_add')
end

Control.on_grid_remove = function(self,g)
  print('on_remove')
end

Control.draw_function = function(self,x)
  for y=1,8 do
    bit = self.program:get(x,y)
    if bit == '1' then
      brightness = 10
      g:led(x,y,brightness)
    end
  end
end

Control.draw_program = function(self)
  g:all(0)
  -- Playhead
  for y=1,8 do
    g:led(self.tracker.playhead,y,3)
  end
  -- Focus
  for y=1,8 do
    g:led(self.tracker.focus,y,2)
  end
  -- Program
  for x=1,#self.program.data do
    self:draw_function(x)
  end
  g:refresh()
end

Control.redraw = function(self)
  self:draw_program()
end

return Control