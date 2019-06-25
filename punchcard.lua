
local navi = include('lib/navi')
local stack = include('lib/stack')

local g
local viewport = { width = 128, height = 64, frame = 0 }
local focus = { x = 1, y = 1, brightness = 15 }

-- Main

function init()
  stack:init()
  navi:init()
  
  -- Render Style
  screen.level(15)
  screen.aa(0)
  screen.line_width(1)
  -- Render
  update()
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

function draw_label()
  screen.level(15)
  line_height = 8
  screen.move(5,viewport.height - (line_height * 1))
  if navi:is_connected() ~= true then
    screen.text('Grid is not connected.')
  else
    screen.text(focus.x..','..focus.y)
  end
  screen.stroke()
end

function update()
  redraw()
end

function redraw()
  screen.clear()
  navi:redraw()
  draw_label()
  screen.stroke()
  screen.update()
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
