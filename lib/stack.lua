
local Stack = {}

Stack.init = function(self)
  print('Control','Init')
  self:build()
end

Stack.build = function(self)
  self.cards = {}
  for x=1,16 do
    for y=1,8 do
      print('Creating card '..x..','..y..' -> ')
    end
  end
end

return Stack