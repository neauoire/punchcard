
local Program = {}

Program.data = { 0,1,2,3, 0,0,0,0, 0,0,0,0, 0,0,0,0 }

Program.init = function(self)
  print('Program','Init')
end

Program.swap = function(self,x,y)
  if x > #self.data then
    print('Out of bounds')
    return
  end
  bit = self:get(x,y)
  if bit == '1' then
    self:set(x,y,'0')
  else
    self:set(x,y,'1')
  end
end

Program.get = function(self,x,y)
  return self:to_bin(self.data[x]):sub(y,y)
end

Program.set = function(self,x,y,z)
  bits = self:to_bin(self.data[x])
  mod_bits = replace_char(bits,y,z)
  self.data[x] = self:to_num(mod_bits)
end

Program.print = function(self)
  print(table.concat(self.data))
end

Program.get_fn_num = function(self,id)
  return self.data[id]
end

Program.get_fn_bin = function(self,id)
  return self:to_bin(self:get_fn_num(id))
end

-- Utils

function replace_char(str, pos, r)
  return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end

Program.to_num = function(self,bin)
  bin = string.reverse(bin)
  local sum = 0
  for i = 1, string.len(bin) do
    num = string.sub(bin, i,i) == "1" and 1 or 0
    sum = sum + num * math.pow(2, i-1)
  end
  return math.floor(sum)
end

Program.to_bin = function(self,num)
  local t={}
  for b=8,1,-1 do
    rest=math.fmod(num,2)
    t[b]=math.floor(rest)
    num=(num-rest)/2
  end
  return table.concat(t)
end

return Program
