local Utils = {}

Utils.clamp = function(val,min,max)
  return val < min and min or val > max and max or val
end

Utils.id_at = function(x,y)
  return ((y-1)*16)+x
end

Utils.note_to_num = function(note)
  return Utils.index_of({ 'C','c','D','d','E','F','f','G','g','A','a','B' },note)-1
end

Utils.index_of = function(list,value)
  for i=1,#list do
    if list[i] == value then return i end
  end
  return -1
end

return Utils