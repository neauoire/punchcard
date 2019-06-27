local Operator = { senders = {} }

-- Utils

local limit = function(val,length)
  return ((val-1) % length)+1
end

local clamp = function(val,min,max)
  return val < min and min or val > max and max or val
end

local index_of = function(list,value)
  for i=1,#list do
    if list[i] == value then return i end
  end
  return -1
end

local note_to_num = function(note)
  return index_of({ 'C','c','D','d','E','F','f','G','g','A','a','B' },note)-1
end

-- Begin

Operator.init = function(self)
  
end

Operator.bind = function(self,navi,stack,instruct)
  self.navi = navi
  self.stack = stack
  self.instruct = instruct
end

Operator.reset = function(self)
  for id=1,128 do
    self.senders[id] = false
  end
end

Operator.run_instruction = function(self,instruction,res)
  if Operator[instruction.cmd] ~= nil then
    Operator[instruction.cmd](self,instruction.key,instruction.val,res)
  else
    print('Unknown CMD:'..cmd)
  end
end

Operator.run_card = function(self,id,instructions)
  print('===== '..id)
  -- Defaults
  res = { id = id, OCT = 5, VEL = 16, STEP = self.navi.frame }

  for id=1,#instructions do
    local i = instructions[id]
    if i > 0 then
      local instruction = self.instruct:get(i)
      self:run_instruction(instruction,res)
    end
  end
end

Operator.run_cards = function(self,cards)
  for i=1,#cards do
    local id = cards[i]
    local instructions = self.stack:get_instructions(id)
    self:run_card(id,instructions)
  end  
end

Operator.run = function(self)
  self:reset()
  local cards = self.stack:get_cards()
  self:run_cards(cards)
end

Operator.parse = function(self,line,res)
  local words = {}
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