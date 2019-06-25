
local navi = include('lib/navi')
local stack = include('lib/stack')
local instruct = include('lib/instruct')

local g
local viewport = { width = 128, height = 64, frame = 0 }
local focus = { x = 1, y = 1, brightness = 15 }

-- Main

function init()
  stack:init()
  navi:init()
  instruct:init()
  
  navi:bind(stack,instruct)
  
  -- Render Style
  screen.level(15)
  screen.aa(0)
  screen.line_width(1)
  
  navi:start()
  test = 'hello'
end

-- Interactions

function key(id,state)
  if id == 2 and state == 1 then
    focus.brightness = 15
  elseif id == 3 and state == 1 then
    focus.brightness = 5
  end
  update()
end

function enc(id,delta)
  if id == 2 then
    focus.x = clamp(focus.x + delta, 1, 16)
  elseif id == 3 then
    focus.y = clamp(focus.y + delta, 1, 8)
  end
  update()
end

-- Render

function draw_pixel(x,y)
  if focus.x == x and focus.y == y then
    screen.stroke()
    screen.level(15)
  end
  screen.pixel((x*offset.spacing) + offset.x, (y*offset.spacing) + offset.y)
  if focus.x == x and focus.y == y then
    screen.stroke()
    screen.level(1)
  end
end

-- Utils

function clamp(val,min,max)
  return val < min and min or val > max and max or val
end

function id_at(x,y)
  return ((y-1)*16)+x
end

function pos_at(id)
  return { x = math.floor(id % 16), y = math.floor(id/16)+1  }
end

function to_hex(int)
  return string.format('%02x',int)
end

function line_to_bin(line)
  bin = ''
  for i=1,#line do
    if line[i] == true then bin = bin..'1' else bin = bin..'0' end
  end
  return bin
end

function bin_to_num(bin)
  bin = string.reverse(bin)
  local sum = 0
  for i = 1, string.len(bin) do
    num = string.sub(bin, i,i) == "1" and 1 or 0
    sum = sum + num * math.pow(2, i-1)
  end
  return math.floor(sum)
end

function num_to_bin(num)
  local t={}
  for b=8,1,-1 do
    rest=math.fmod(num,2)
    t[b]=math.floor(rest)
    num=(num-rest)/2
  end
  return table.concat(t)
end

function char_at(str,index,length)
  length = length or 1
  return string.sub(bin,index,index+length-1)
end
