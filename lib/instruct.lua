
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

Instruct.make_target = function(self,id)
  return ''
end

Instruct.make_type = function(self,id,bin)
  if char_at(bin,5,2) == '11' then return 'CHANNEL'
  elseif char_at(bin,5) == '1' then return 'OCTAVE'
  elseif char_at(bin,6) == '1' then return 'NOTE'
  else return 'FRAME' end
end

Instruct.make_note = function(self,id,bin)
  key = self:make_number(id,bin)
  names = { 'C','C#','D','D#','E','F','F#','G','G#','A','A#','B' }
  return names[((key-1) % 12)+1]
end

Instruct.make_number = function(self,id,bin)
  if char_at(bin,1,4) == '0000' then return '1' end
  if char_at(bin,1,4) == '0001' then return '2' end
  if char_at(bin,1,4) == '0010' then return '3' end
  if char_at(bin,1,4) == '0011' then return '4' end
  if char_at(bin,1,4) == '0100' then return '5' end
  if char_at(bin,1,4) == '0101' then return '6' end
  if char_at(bin,1,4) == '0110' then return '7' end
  if char_at(bin,1,4) == '0111' then return '8' end
  if char_at(bin,1,4) == '1000' then return '9' end
  if char_at(bin,1,4) == '1001' then return '10' end
  if char_at(bin,1,4) == '1010' then return '11' end
  if char_at(bin,1,4) == '1011' then return '12' end
  if char_at(bin,1,4) == '1100' then return '13' end
  if char_at(bin,1,4) == '1101' then return '14' end
  if char_at(bin,1,4) == '1110' then return '15' end
  if char_at(bin,1,4) == '1111' then return '16' end
  return '0'
end

Instruct.build_if = function(self,id,bin)
  _type = self:make_type(id,bin)
  if _type == 'NOTE' then
    _value = self:make_note(id,bin)
  else
    _value = self:make_number(id,bin)
  end
  self.dict[id] = { name = 'IF '.._type..' IS '.._value }
end

Instruct.build_set = function(self,id,bin)
  _type = self:make_type(id,bin)
  if _type == 'NOTE' then
    _value = self:make_note(id,bin)
  else
    _value = self:make_number(id,bin)
  end
  self.dict[id] = { name = 'SET '.._type..' TO '.._value }
end

Instruct.build_send = function(self,id,bin)
  _type = self:make_type(id,bin)
  if _type == 'NOTE' then
    _value = self:make_note(id,bin)
  else
    _value = self:make_number(id,bin)
  end
  self.dict[id] = { name = 'SEND '.._type..' TO '.._value }
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
    elseif string.sub(bin,2,2) == '1' then
      self.dict[id] = { name = 'DO BANG' }
    elseif string.sub(bin,1,1) == '1' then
      self.dict[id] = { name = 'DO PLAY' }
    end
  end
  self:print()
end

Instruct.bind = function(self,program)
  self.program = program
end

Instruct.get_name = function(self,num)
  if self.dict[num] then
    return self.dict[num].name
  end
  return ''
end

Instruct.print = function(self)
  collection = {}
  
  for id=1,255 do
    collection[self:get_name(id)] = id
  end
  
  count = 0
  for k, v in pairs(collection) do
    bin = num_to_bin(v)
    -- print(bin..' '..k)
    count = count + 1
  end

  print(count..' instructs, '..math.floor((count/255)*100)..'%')
end

return Instruct
