
local Instructions = {}

Instructions.dict = {}

Instructions.dict[0] = {
  name = '',
  run = function() end
}

Instructions.dict[1] = {
  name = 'INCR',
  run = function(operation)
    operation.offset = operation.offset + 1
  end
}

Instructions.dict[2] = {
  name = 'DECR',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.dict[3] = {
  name = 'DECR',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.dict[5] = {
  name = 'INCRM',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.dict[6] = {
  name = 'DECRM',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.dict[9] = {
  name = 'INCRO',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.dict[10] = {
  name = 'DECRO',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.init = function(self)
  print('Instructions','Init')
end

Instructions.get_name = function(self,num)
  if self:get_fn(num) then
    return self:get_fn(num).name
  else
    return ''
  end
end

Instructions.get_fn = function(self,num)
  return self.dict[num]
end

return Instructions