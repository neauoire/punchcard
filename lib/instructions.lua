
local Instructions = {}

Instructions.dict = {}

Instructions.dict[1] = {
  name = 'INCR'
}

Instructions.dict[2] = {
  name = 'DECR'
}

Instructions.init = function(self)
  print('Instructions','Init')
end

Instructions.get_name = function(self,num)
  if self.dict[num] then
    return self.dict[num].name
  else
    return '?'
  end
end

return Instructions