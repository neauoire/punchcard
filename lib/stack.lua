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
  print('Stack','Init')
  self:build()
end

Stack.bind = function(self,navi,instructor)
  self.navi = navi
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

Stack.get_line_val = function(self,id,line_id)
  local res = {}
  for y=1,4 do
    table.insert(res,self:read(id,id_at(line_id,y)))
  end
  return line_to_bin(res)
end

Stack.get_line = function(self,id,line_id)
  local res = {}
  for y=1,8 do
    table.insert(res,self:read(id,id_at(line_id,y)))
  end
  return line_to_bin(res)
end

Stack.get_instruction = function(self,id,line_id)
  return bin_to_num(self:get_line(id,line_id))
end

Stack.get_instructions = function(self,id)
  local a = {}
  for y=1,16 do
    table.insert(a,{line = y, inst = self:get_instruction(id,y)})
  end
  return a
end

Stack.get_card = function(self,id)
  return self.cards[id]
end

Stack.set_line_val = function(self,id,line_id,bin)
  for y=1,#bin do
    local i = id_at(line_id,y)
    if bin:sub(y,y) == '1' then
      self:write(id,i,true)
    else
      self:write(id,i,false)
    end
  end
end

Stack.erase_card = function(self,id)
  id = id or self.navi.card
  if id == nil then print('Cannot erase',id); return end
  print('erase',id)
  for i=1,128 do
    self.cards[id][i] = false
  end
  redraw()
end

return Stack