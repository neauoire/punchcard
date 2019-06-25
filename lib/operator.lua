local Operator = {}

Operator.init = function(self)
end

Operator.run = function(self,id,program)
  print('===== '..id)
  res = {}
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
  val = words[4]
  
  if Operator[cmd] ~= nil then
    Operator[cmd](key,val,res)
  else
    print('Unknown cmd:'..cmd)
  end
end

Operator.IF = function(key,val,res)
  
end

Operator.SET = function(key,val,res)
  
end

Operator.SEND = function(key,val,res)
  
end


Operator.render = function(self,res)
  tab.print(res)
end

function split_lines(str)
  res = {}
  for token in string.gmatch(str, "[^;]+") do
    table.insert(res,token)
  end
  return res
end

return Operator