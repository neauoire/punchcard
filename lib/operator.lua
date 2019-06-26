local Operator = { senders = {} }

Operator.init = function(self)
  
end

Operator.bind = function(self,navi)
  self.navi = navi
end

Operator.run = function(self,id,program)
  print('===== '..id)
  -- Defaults
  res = { id = id, OCT = 5, STEP = tostring(((self.navi.frame-1)%16)+1), VEL = 16 }
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
    print('Unknown CMD:'..cmd)
  end
end

Operator.IF = function(self,key,val,res)
  res.skip = false
  if key == 'STEP' then
    if tonumber(val) ~= limit(self.navi.frame,val) then res.skip = true end
  elseif key == 'NOTE' then
    if tonumber(res[key]) ~= note_to_num(val) then res.skip = true end
  else 
    if tonumber(res[key]) ~= tonumber(val) then res.skip = true end
  end
end

Operator.SET = function(self,key,val,res)
  if res.skip == true then return end
  if key == 'NOTE' then
    res.NOTE = math.floor(note_to_num(val))
  else
    res[key] = val
  end
  res.LAST = key
end

Operator.SEND = function(self,key,val,res)
  if res.skip == true then return end
  if res.NOTE == nil then return end
  print('SEND: '..res.NOTE+(res.OCT*12)..' VEL: '..math.floor((res.VEL/16)*127)..' '..key..': '..val)
  self.senders[res.id] = true
end

Operator.DO = function(self,key,val,res)
  if res.skip == true then return end
  if res.LAST == nil then return end
  if res[res.LAST] == nil then return end
  if key == 'INCR' then
    res[res.LAST] = tonumber(res[res.LAST]) + tonumber(val)
  end
  if key == 'DECR' then
    res[res.LAST] = tonumber(res[res.LAST]) - tonumber(val)
  end
  if key == 'CLAMP' then
    res[res.LAST] = clamp(tonumber(res[res.LAST]),1,tonumber(val))
  end
  if key == 'LIMIT' then
    res[res.LAST] = limit(tonumber(res[res.LAST]),tonumber(val))
  end
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