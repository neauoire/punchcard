
local tracker = {}

tracker.focus = 0

tracker.init = function()
  print('Tracker','Init')
end

tracker.bind = function(self,program)
  print('Tracker',program:print())
  self.program = program
end

tracker.redraw = function(self)
  for id=1,#self.program.data do
    screen.move(0,id*8)
    screen.text(id)
    screen.move(20,id*8)
    screen.text(self.program:get_fn_num(id))
    screen.move(40,id*8)
    screen.text(self.program:get_fn_bin(id))
  end
end

return tracker