
local Tracker = {}

Tracker.focus = 1
Tracker.frame = 1
Tracker.playhead = 1
Tracker.is_playing = false
Tracker.operation = { root = 60, offset = 0, range = { from = 0, to = 127 }, rate = 1, speed = 1}
Tracker.metro = metro.init()

Tracker.init = function(self)
  print('Tracker','Init')
  self:set_bpm(120)
  self.metro:start()
end

Tracker.bind = function(self,program,instructions,control)
  self.program = program
  self.instructions = instructions
  self.control = control
end

Tracker.play = function(self)
  print('Tracker','play')
  self.is_playing = true
end

Tracker.stop = function(self)
  print('Tracker','stop')
  self.is_playing = false
end

Tracker.toggle_play = function(self)
  if self.is_playing == true then
    self:stop()
  else
    self:play()
  end
end

Tracker.set_bpm = function(self,bpm)
  self.metro.time = 60 / (bpm*4)
end

Tracker.mod_length = function(self,delta)
  if #self.program.data <= 1 and delta == -1 then return end
  if #self.program.data >= 16 and delta == 1 then return end
  
  if delta == 1 then
    table.insert(self.program.data, 0)
  elseif delta == -1 then
    table.remove(self.program.data)
  end
end

Tracker.mod_focus = function(self,delta)
  self.focus = clamp(self.focus + delta, 1, #self.program.data)
end

Tracker.set_focus = function(self,id)
  self.focus = id
end

-- Render

Tracker.draw_fn = function(self,id,line,offset)
  offset = offset or 0
  
  y = (6 * line)+10
  id = (id % #self.program.data)+1
  num = self.program:get_fn_num(id)
  name = self.instructions:get_name(num)
  
  screen.level(5)
  
  if self.playhead == id then
    screen.move(0 + offset,y)
    screen.level(15)
    screen.text('>')
  elseif self.focus == id then
    screen.move(0 + offset,y)
    screen.level(10)
    screen.text('*')
  end
  
  screen.move(6 + offset,y)
  screen.text(id)
  screen.move(15 + offset,y)
  screen.text(num)
  screen.move(30 + offset,y)
  screen.text(name)
  screen.fill()
end

Tracker.draw_header = function(self)
  screen.level(15)
  -- Player
  screen.move(6,7)
  screen.text(self.playhead)
  screen.move(15,7)
  screen.text(#self.program.data)
  -- Operation
  screen.move(30,7)
  screen.text(self.operation.root..'('..self.operation.offset..')'..' <'..self.operation.range.from..','..self.operation.range.to..'>'..' '..self.operation.rate..' '..self.operation.speed)
  screen.fill()
end

Tracker.redraw = function(self)
  length = #self.program.data
  screen.clear()
  self:draw_header()
  for y=1,9 do
    self:draw_fn(self.frame + y + length - 2,y)
  end
  for y=1,9 do
    self:draw_fn(self.focus + y + length - 2,y,66)
  end
  screen.update()
end

Tracker.update = function(self)
  if self.is_playing == false then return end
  self:redraw()
  self.control:redraw()
  self.frame = self.frame + 1
  self.playhead = (self.playhead % #self.program.data)+1
end

Tracker.run = function(self)
  num = self.program:get_fn_num(self.playhead)
  fn = self.instructions:get_fn(num)
  if fn and fn.run then
    fn.run(self.operation)  
  else
    print(num..' is missing run phase')
  end
end

Tracker.metro.event = function()
  Tracker:update()
  Tracker:run()
end

-- Utils

function clamp(val,min,max)
  return val < min and min or val > max and max or val
end

return Tracker