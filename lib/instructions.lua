local instructions = {}

instructions.dict = {}

instructions.dict[1] = {
  name = 'INCR'
}

instructions.get_name = function(self,num)
  if instructions.dict[num] then
    return instructions.dict[num].name
  else
    return '?'
  end
end

return instructions