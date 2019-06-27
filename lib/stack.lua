local Stack = { cards = {} }

-- Utils

local line_to_bin = function(line)
  local bin = ''
  for i=1,#line do
    if line[i] == true then bin = bin..'1' else bin = bin..'0' end
  end
  return bin
end

local bin_to_num = function(bin)
  local bin = string.reverse(bin)
  local sum = 0
  for i = 1, string.len(bin) do
    num = string.sub(bin, i,i) == "1" and 1 or 0
    sum = sum + num * math.pow(2, i-1)
  end
  return math.floor(sum)
end

local id_at = function(x,y)
  return ((y-1)*16)+x
end

-- Begin

Stack.init = function(self)
  print('Control','Init')
  self:build()
end

Stack.bind = function(self,instructor)
  self.instructor = instructor
end

Stack.build = function(self)
  self.cards = {}
  for x=1,16 do
    for y=1,8 do
      local id = id_at(x,y)
      self.cards[id] = {}
      for b=1,128 do
        self.cards[id][b] = false
      end
    end
  end
end

Stack.read = function(self,i,b)
  return self.cards[i][b]
end

Stack.write = function(self,i,b,v)
  self.cards[i][b] = v
end

Stack.known = function(self,id)
  for b=1,128 do 
    if self:get_card(id)[b] ~= false then 
      return true 
    end 
  end
  return false
end

Stack.get_cards = function(self)
  local cards = {}
  for id=1,128 do
    if self:known(id) == true then
      table.insert(cards,id)
    end
  end
  return cards
end

Stack.get_instruction = function(self,id,line_id)
  res = {}
  for y=1,8 do
    table.insert(res,self:read(id,id_at(line_id,y)))
  end
  return bin_to_num(line_to_bin(res))
end

Stack.get_instructions = function(self,id)
  local a = {}
  for y=1,16 do
    table.insert(a,self:get_instruction(id,y))
  end
  return a
end

Stack.get_card = function(self,id)
  return self.cards[id]
end

return Stack