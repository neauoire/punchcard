
local Instruct = {}
local types = {}
types.conditional = 1

Instruct.dict = {}
Instruct.dict[0] = {
  name = '',
  run = function()end
}

Instruct.init = function(self)
  print('Instruct','Init')
  self:build()
end

Instruct.bind = function(self,utils,program)
  self.utils = utils
  self.program = program
end

-- IF

Instruct.make_if_type = function(self,id,bin)
  if char_at(bin,5,2) == '11' then return 'BANG'
  elseif char_at(bin,5) == '1' then return 'STEP'
  elseif char_at(bin,6) == '1' then return 'OCT'
  else return 'NOTE' end
end

Instruct.build_if = function(self,id,bin)
  _type = self:make_if_type(id,bin)
  if _type == 'NOTE' then
    _value = self:make_note(id,bin)
  else
    _value = self:make_number(id,bin)
  end
  self.dict[id] = { name = 'IF '.._type..'='.._value }
end

-- SET

Instruct.make_set_type = function(self,id,bin)
  if char_at(bin,5,2) == '11' then return 'RATE'
  elseif char_at(bin,5) == '1' then return 'VEL'
  elseif char_at(bin,6) == '1' then return 'OCT'
  else return 'NOTE' end
end

Instruct.build_set = function(self,id,bin)
  _type = self:make_set_type(id,bin)
  if _type == 'NOTE' then
    _value = self:make_note(id,bin)
  elseif _type == 'OCT' then
    _value = self:make_octave(id,bin)
  else
    _value = self:make_number(id,bin)
  end
  self.dict[id] = { name = 'SET '.._type..'='.._value }
end

-- SEND

Instruct.make_send_type = function(self,id,bin)
  if char_at(bin,5,2) == '11' then return 'SYS'
  elseif char_at(bin,5) == '1' then return 'BANG'
  elseif char_at(bin,6) == '1' then return 'OSC'
  else return 'CHAN' end
end

Instruct.build_send = function(self,id,bin)
  _type = self:make_send_type(id,bin)
  _value = self:make_number(id,bin)
  self.dict[id] = { name = 'SEND '.._type..'>'.._value }
end

-- WHEN

Instruct.make_do_type = function(self,id,bin)
  if char_at(bin,5,2) == '11' then return 'CLAMP'
  elseif char_at(bin,5) == '1' then return 'INCR'
  elseif char_at(bin,6) == '1' then return 'DECR'
  else return 'LIMIT' end
end

Instruct.build_do = function(self,id,bin)
  _type = self:make_do_type(id,bin)
  if _type == 'NOTE' then
    _value = self:make_note(id,bin)
  else
    _value = self:make_number(id,bin)
  end
  self.dict[id] = { name = 'DO '.._type..':'.._value }
end

-- Generics

Instruct.make_note = function(self,id,bin)
  key = self:make_number(id,bin)
  if key == 16 then return 'NEXT^' end
  if key == 15 then return 'PREV^' end
  if key == 14 then return 'NEXT#' end
  if key == 13 then return 'PREV#' end
  if key == 12 then return 'NEXT' end
  if key == 11 then return 'PREV' end
  if key == 10 then return 'INC' end
  if key ==  9 then return 'DEC' end
  names = { 'C','c','D','d','E','F','f','G','g','A','a','B' }
  return names[((key-1) % 12)+1]
end

Instruct.make_octave = function(self,id,bin)
  key = self:make_number(id,bin)
  if key == 10 then return 'INC' end
  if key ==  9 then return 'DEC' end
  return math.floor(((key-1) % 8)+1)
end

Instruct.make_number = function(self,id,bin)
  if char_at(bin,1,4) == '0000' then return 1 end
  if char_at(bin,1,4) == '0001' then return 2 end
  if char_at(bin,1,4) == '0010' then return 3 end
  if char_at(bin,1,4) == '0011' then return 4 end
  if char_at(bin,1,4) == '0100' then return 5 end
  if char_at(bin,1,4) == '0101' then return 6 end
  if char_at(bin,1,4) == '0110' then return 7 end
  if char_at(bin,1,4) == '0111' then return 8 end
  if char_at(bin,1,4) == '1000' then return 9 end
  if char_at(bin,1,4) == '1001' then return 10 end
  if char_at(bin,1,4) == '1010' then return 11 end
  if char_at(bin,1,4) == '1011' then return 12 end
  if char_at(bin,1,4) == '1100' then return 13 end
  if char_at(bin,1,4) == '1101' then return 14 end
  if char_at(bin,1,4) == '1110' then return 15 end
  if char_at(bin,1,4) == '1111' then return 16 end
  return '0'
end

Instruct.build = function(self)
  print('Instruct','Build')
  for id=1,255 do
    bin = num_to_bin(id)
    if string.sub(bin,7,8) == '11' then
      self:build_if(id,bin)
    elseif string.sub(bin,7,8) == '10' then
      self:build_send(id,bin)
    elseif string.sub(bin,7,8) == '01' then
      self:build_set(id,bin)
    else
      self:build_do(id,bin)
    end
  end
  self:print()
end

-- Utils

Instruct.get_name = function(self,num)
  if self.dict[num] then
    return self.dict[num].name
  end
  return '--'
end

Instruct.operate = function(self,op)
  
end

Instruct.print = function(self)
  collection = {}
  for id=1,255 do collection[self:get_name(id)] = id end
  count = 0
  for k, v in pairs(collection) do
    bin = num_to_bin(v)
    -- print(bin..' '..k)
    count = count + 1
  end
  print(count..' instructs, '..math.floor((count/255)*100)..'% coverage')
end

-- Utils

char_at = function(str,index,length)
  length = length or 1
  return string.sub(bin,index,index+length-1)
end

num_to_bin = function(num)
  local t={}
  for b=8,1,-1 do
    rest=math.fmod(num,2)
    t[b]=math.floor(rest)
    num=(num-rest)/2
  end
  return table.concat(t)
end

return Instruct
