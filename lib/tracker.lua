
local tracker = {}

tracker.frame = 1
tracker.playhead = 1
tracker.is_playing = false

tracker.metro = metro.init()

tracker.init = function(self)
  print('Tracker','Init')
  self:set_bpm(120)
  self.metro:start()
end

tracker.bind = function(self,program)
  print('Tracker',program:print())
  self.program = program
end

tracker.draw_fn = function(self,id,line)
  screen.move(0,(8 * line)+8)
  id = (id % #self.program.data)+1
  screen.text(id)
  screen.move(12,(8 * line)+8)
  screen.text(self.program:get_fn_num(id))
end

tracker.redraw = function(self)
  screen.clear()
  screen.rect(0,8,128,7)
  screen.fill()
  for y=1,7 do
    self:draw_fn(self.frame + y,y)
  end
  screen.move(100,7)
  screen.text(self.frame)
  screen.update()
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
  self.metro.time = 60 / (bpm*2)
end

tracker.update = function(self)
  self:redraw()
  self.frame = self.frame + 1
  self.playhead = (self.playhead % #self.program.data)+1
end

tracker.metro.event = function()
  tracker:update()
end

return tracker