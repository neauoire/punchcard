
local Instructions = {}

Instructions.dict = {}
Instructions.dict[0] = {
  name = '',
  run = function()
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

Instructions.build = function(self)
  for num=1,255 do
    self.dict[num] = {
      name = self:make_name(num),
      run = function() end
    }
  end
  -- Overrides
  self.dict[128] = {
    name = 'PLAY',
    run = function() end
  }
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

Instructions.make_name = function(self,num)
  bin = self.program:to_bin(num)
  name = ''
  
  -- Cmd
  if string.sub(bin, 7,8) == '11' then
    name = 'RDM' -- Random
  elseif string.sub(bin, 7,8) == '00' then
    name = 'SET' -- Set
    
  elseif string.sub(bin, 8,8) == '1' then
    name = 'INC' -- Increment
  elseif string.sub(bin, 8,8) == '0' then
    name = 'DEC' -- Decrement
  end
  
  -- Target
  if string.sub(bin, 5,6) == '11' then
    name = name..'N2' -- Mod Note x 2
  elseif string.sub(bin, 4,5) == '11' then
    name = name..'M2' -- Mod Major x 2
  elseif string.sub(bin, 3,4) == '11' then
    name = name..'O2' -- Mod Octave x 2
  elseif string.sub(bin, 2,3) == '11' then
    name = name..'R2' -- Mod Rate x 2
    
  elseif string.sub(bin,6,6) == '1' then
    name = name..'N' -- Mod Note
  elseif string.sub(bin,5,5) == '1' then
    name = name..'M' -- Mod Major
  elseif string.sub(bin,4,4) == '1' then
    name = name..'O' -- Mod Octave
  elseif string.sub(bin,3,3) == '1' then
    name = name..'R' -- Mod Rate
  end

  if string.sub(bin, 1,1) == '1' then
    name = name..'P' -- Play Mode
  end
  
  return name
end

Instructions.print = function(self)
  html = ''
  count = 0 
  for num=1,255 do
    if self:get_fn(num) then
      print(self.program:to_bin(num)..' '..self:get_name(num))
      count = count + 1
    end
    print(self:make_name(num))
  end
  print(count..' instructions, '..math.floor((count/255)*100)..'%')
end

return Instructions