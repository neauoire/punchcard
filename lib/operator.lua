local Operator = {}

Operator.init = function(self)
  
end

Operator.bind = function(self,navi)
  self.navi = navi
end

Operator.run = function(self,id,program)
  print('===== '..id)
  res = { OCT = 4, STEP = tostring(((self.navi.frame-1)%16)+1) }
  -- Each line
  for token in string.gmatch(str, "[^;]+") do
    self:parse(token,res)
  end
  self:render(res)
end

Operator.parse = function(self,line,res)
  words = {}
  for word in line:gmatch("%w+") do table.insert(words, word) end
  cmd = words[1]
  key = words[2]
  val = words[3]
  
  if Operator[cmd] ~= nil then
    Operator[cmd](self,key,val,res)
  else
    print('Unknown cmd:'..cmd)
  end
end

Operator.DO = function(self,key,val,res)
  print(key,val)
end

Operator.IF = function(self,key,val,res)
  if res[key] ~= val then res.skip = true end
end

Operator.SET = function(self,key,val,res)
  if res.skip == true then return end
  res[key] = val
end

Operator.SEND = function(self,key,val,res)
  if res.skip == true then return end
  print('SEND',res.NOTE,res.OCT,key,val)
end

Operator.render = function(self,res)
  -- tab.print(res)
end

function split_lines(str)
  res = {}
  for token in string.gmatch(str, "[^;]+") do
    table.insert(res,token)
  end
  return res
end

return Operator