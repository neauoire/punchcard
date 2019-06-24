
local Instructions = {}

Instructions.dict = {}

Instructions.dict[0] = {
  name = '',
  run = function() end
}

Instructions.dict[1] = {
  name = 'INCR',
  run = function(operation)
    operation.offset = mod_offset(operation,1)
  end
}

Instructions.dict[2] = {
  name = 'DECR',
  run = function(operation)
    operation.offset = mod_offset(operation,-1)
  end
}

Instructions.dict[3] = {
  name = 'INCR2',
  run = function(operation)
    operation.offset = mod_offset(operation,-2)
  end
}

Instructions.dict[5] = {
  name = 'INCRM',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.dict[6] = {
  name = 'DECR2',
  run = function(operation)
    operation.offset = operation.offset - 2
  end
}

Instructions.dict[7] = {
  name = 'REST', 
  run = function(operation)
    operation.offset = 0
  end
}

Instructions.dict[9] = {
  name = 'INCRO',
  run = function(operation)
    operation.offset = mod_offset(operation,12)
  end
}

Instructions.dict[10] = {
  name = 'DECRM',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.dict[11] = {
  name = 'RESTM', 
  docs = 'Go to nearest major',
  run = function(operation)
    operation.offset = 0
  end
}

Instructions.dict[13] = {
  name = 'INCRM2',
  run = function(operation)
    operation.offset = mod_offset_major(operation,-2)
  end
}

Instructions.dict[17] = {
  name = 'INCRS2',
  docs = 'Increase speed to 2',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.dict[18] = {
  name = 'DECRO',
  run = function(operation)
    operation.offset = mod_offset(operation,-12)
  end
}

Instructions.dict[19] = {
  name = 'RESTO', 
  docs = 'Go to nearest octave',
  run = function(operation)
    operation.offset = 0
  end
}

Instructions.dict[25] = {
  name = 'INCRO2',
  run = function(operation)
    operation.offset = mod_offset(operation,24)
  end
}

Instructions.dict[26] = {
  name = 'DECRM2',
  run = function(operation)
    operation.offset = mod_offset_major(operation,-2)
  end
}

Instructions.dict[34] = {
  name = 'DECRS4',
  docs = 'Decrease speed to 2',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.dict[35] = {
  name = 'RESTS', 
  docs = 'Reset speed',
  run = function(operation)
    operation.offset = 0
  end
}

Instructions.dict[49] = {
  name = 'INCRS4',
  docs = 'Increase speed to 4',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.dict[50] = {
  name = 'DECRO2',
  run = function(operation)
    operation.offset = mod_offset(operation,-24)
  end
}

Instructions.dict[98] = {
  name = 'DECRS4',
  docs = 'Decrease speed to 1/4',
  run = function(operation)
    operation.offset = operation.offset - 1
  end
}

Instructions.dict[128] = {
  name = 'PLAY',
  run = function(operation)
    
  end
}

Instructions.dict[129] = {
  name = 'INCRP',
  run = function(operation)
    operation.offset = mod_offset(operation,1)
  end
}

-- 

function loop_around(value,range)
  return value
end

function mod_offset(op,value)
  return loop_around(op.offset + value,op.range)
end

function mod_offset_major(op,value)
  return loop_around(op.offset + value,op.range)
end

-- 

Instructions.init = function(self)
  print('Instructions','Init')
end

Instructions.bind = function(self,program)
  self.program = program
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

Instructions.print = function(self)
  html = ''
  count = 0 
  for num=1,255 do
    if self:get_fn(num) then
      print(self.program:to_bin(num)..' '..self:get_name(num))
      count = count + 1
    end
  end
  print(count..' instructions, '..math.floor((count/255)*100)..'%')
end

return Instructions