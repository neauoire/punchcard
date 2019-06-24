
local tracker = {}

tracker.focus = 1
tracker.frame = 1
tracker.playhead = 1
tracker.is_playing = false
tracker.metro = metro.init()

tracker.init = function(self)
  print('Tracker','Init')
  self:set_bpm(120)
  self.metro:start()
end

tracker.bind = function(self,program,instructions)
  print('Tracker',program:print())
  self.program = program
  self.instructions = instructions
end

tracker.play = function(self)
  print('Tracker','play')
  self.is_playing = true
end

tracker.stop = function(self)
  print('Tracker','stop')
  self.is_playing = false
end

tracker.toggle_play = function(self)
  if self.is_playing == true then
    self:stop()
  else
    self:play()
  end
end

tracker.set_bpm = function(self,bpm)
  self.metro.time = 60 / (bpm*4)
end

tracker.mod_focus = function(self,delta)
  self.focus = (self.focus + delta)
end

tracker.set_focus = function(self,id)
  self.focus = id
end

-- Render

tracker.draw_fn = function(self,id,line,offset)
  offset = offset or 0
  
  y = (6 * line)+10
  id = (id % #self.program.data)+1
  num = self.program:get_fn_num(id)
  name = self.instructions:get_name(num)
  
  if self.playhead == id then
    screen.move(0 + offset,y)
    screen.text('>')
  elseif self.focus == id then
    screen.move(0 + offset,y)
    screen.text('*')
  end
  
  screen.move(6 + offset,y)
  screen.text(id)
  screen.move(16 + offset,y)
  screen.text(num)
  screen.move(34 + offset,y)
  screen.text(name)
end

tracker.draw_header = function(self)
  screen.level(15)
  screen.move(100,7)
  screen.text(self.frame)
  screen.move(80,7)
  screen.text(self.playhead)
  screen.fill()
end

tracker.redraw = function(self)
  length = #self.program.data
  screen.clear()
  self:draw_header()
  for y=1,9 do
    self:draw_fn(self.frame + y + length - 2,y)
  end
  for y=1,9 do
    self:draw_fn(self.focus + y + length - 2,y,60)
  end
  screen.update()
end

tracker.update = function(self)
  if self.is_playing == false then return end
  self:redraw()
  self.frame = self.frame + 1
  self.playhead = (self.playhead % #self.program.data)+1
end

tracker.metro.event = function()
  tracker:update()
end

return tracker