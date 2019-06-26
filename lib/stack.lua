
local Stack = { cards = {} }

Stack.init = function(self)
  print('Control','Init')
  self:build()
end

Stack.bind = function(self,instruct)
  self.instruct = instruct
end

Stack.build = function(self)
  self.cards = {}
  for x=1,16 do
    for y=1,8 do
      id = id_at(x,y)
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

Stack.get_line = function(self,id,line_id)
  res = {}
  for y=1,8 do
    table.insert(res,self:read(id,id_at(line_id,y)))
  end
  bin = line_to_bin(res)
  num = bin_to_num(bin)
  return self.instruct:get_name(num)
end

Stack.get_program = function(self,id)
  str = ''
  for y=1,16 do
    name = self:get_line(id,y)
    if name ~= '' and name ~= '--' then
      str = str..name..';'
    end
  end
  return str
end

Stack.get_card = function(self,id)
  return self.cards[id]
end

return Stack