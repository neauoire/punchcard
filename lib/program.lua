
local program = {}

program.data = { 0,1,2,3, 0,0,0,0, 0,0,0,0, 0,0,0,0 }

program.init = function()
  print('Program','Init')
end

program.swap = function(self,x,y)
  bit = self:get(x,y)
  if bit == '1' then
    self:set(x,y,'0')
  else
    self:set(x,y,'1')
  end
end

program.get = function(self,x,y)
  return to_bin(self.data[x]):sub(y,y)
end

program.set = function(self,x,y,z)
  bits = to_bin(self.data[x])
  mod_bits = replace_char(bits,y,z)
  self.data[x] = to_num(mod_bits)
end

function replace_char(str, pos, r)
  return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end

function to_num(bin)
  bin = string.reverse(bin)
  local sum = 0
  for i = 1, string.len(bin) do
    num = string.sub(bin, i,i) == "1" and 1 or 0
    sum = sum + num * math.pow(2, i-1)
  end
  return math.floor(sum)
end

function to_bin(num)
  local t={}
  for b=8,1,-1 do
    rest=math.fmod(num,2)
    t[b]=math.floor(rest)
    num=(num-rest)/2
  end
  return table.concat(t)
end

return program
