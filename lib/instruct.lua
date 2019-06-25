
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

Instruct.build_conditional = function(self,id,bin)
  target = 'ANY'
  condition = 'IS ANY'
  
  if string.sub(bin,6,6) == '1' then
    target = 'FRAME'
    if string.sub(bin,5,5) == '1' then
      condition = 'IS 1'
    elseif string.sub(bin,4,4) == '1' then
      condition = 'IS 2'
    elseif string.sub(bin,3,3) == '1' then
      condition = 'IS 4'
    elseif string.sub(bin,2,2) == '1' then
      condition = 'IS 8'
    elseif string.sub(bin,1,1) == '1' then
      condition = 'IS 16'
    end
  elseif string.sub(bin,5,5) == '1' then
    target = 'TODO'
  elseif string.sub(bin,4,4) == '1' then
    target = 'TODO'
  elseif string.sub(bin,3,3) == '1' then
    target = 'TODO'
  elseif string.sub(bin,2,2) == '1' then
    target = 'BANG'
    if string.sub(bin,1,1) == '1' then
      condition = 'IS FALSE'
    else
      condition = 'IS TRUE'
    end
  elseif string.sub(bin,1,1) == '1' then
    target = 'TODO'
  end
  
  self.dict[id] = { name = 'WHEN '..target..' '..condition, type = types.conditional }
end

Instruct.build = function(self)
  print('Instruct','Build')
  for id=1,255 do
    bin = num_to_bin(id)
    if string.sub(bin,7,8) == '11' then
      self:build_conditional(id,bin)
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
    print(bin..' '..k)
    count = count + 1
  end

  print(count..' instructs, '..math.floor((count/255)*100)..'%')
end

return Instruct
