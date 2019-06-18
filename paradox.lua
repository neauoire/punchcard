--  
--   ////\\\\
--   ////\\\\  PARADOX
--   ////\\\\  BY NEAUOIRE
--   \\\\////  
--   \\\\////  MIDI SEQ
--   \\\\////
--

-- spacetime(study-3) remix

-- ENC 1 - sweep filter
-- ENC 2 - select edit position
-- ENC 3 - choose command
-- KEY 3 - randomize command set

-- + = increase note
-- - = decrease note
-- < = go to bottom note
-- > = go to top note
-- * = random note
-- M = fast metro
-- m = slow metro
-- # = jump random position

engine.name = "PolyPerc"

local counter
local is_playing = true
local viewport = { w = 128, h = 64 }
local template = { size = { w = 6, h = 6 }, bounds = {} }
local playhead = { x = 1, y = 1, direction = 0, octave = 3, note = 'C', sprite = {
      0,0,1,0,0,
      0,1,0,1,0,
      1,0,0,0,1,
      0,1,0,1,0,
      0,0,1,0,0,
    } }

local events = {}
local fns = {
  flip = {
    sprite = {
      0,1,1,1,0,
      1,0,0,0,1,
      1,0,0,0,1,
      1,0,0,0,1,
      0,1,1,1,0,
    },
    run = function()
      print('hit')
    end
  }
}

function init()
  -- Make bounds
  template.bounds.x = math.floor(viewport.w/template.size.w)-1
  template.bounds.y = math.floor(viewport.h/template.size.h)-1
  print('Bounds '..template.bounds.x..','..template.bounds.y)
  -- Events
  add_event(7,1,fns.flip)
  -- Ready
  start()
end

function start()
  -- Start
  counter = metro.init(tic, 0.500, -1)
  counter:start()
  redraw()
end

function tic()
  move()
  run()
end

function add_event(x,y,e)
  print('Added event ')
  events[x..','..y] = e
end

function get_event(x,y)
  return events[x..','..y]
end

function toggle_play()
  if is_playing == true then
    counter:stop()
    is_playing = false
  else
    counter:start()
    is_playing = true
  end
end

-- Playhead

function move()
  playhead.x = (playhead.x + 1) % (template.bounds.x)
  redraw()
end

function run()
  event = get_event(playhead.x,playhead.y)
  if event == nil then return end
  event.run()
end

-- Interaction

function enc(n,delta)
  if n == 2 then
    playhead.x = clamp(playhead.x + delta,1,template.bounds.x)
  elseif n == 3 then
    playhead.y = clamp(playhead.y + delta,1,template.bounds.y)
  end
  
  redraw()
end

function key(n,z)
  if z ~= 1 then return end
  if n == 2 then
    toggle_play()
  end
  redraw()
end

-- Render

function is_selection(x,y)
  return x == playhead.x and y == playhead.y
end

function draw_sprite(x,y,sprite)
  for _y = 1,5 do
    for _x = 1,5 do
      id = ((_y-1) * 5) + _x
      if sprite[id] == 1 then
        sprite_x = _x + (x * template.size.w)
        sprite_y = _y + (y * template.size.h)
        screen.pixel(sprite_x,sprite_y)
      end
    end
  end
  screen.fill()
end

function draw_tile(x,y)
  if is_selection(x,y) then
    draw_sprite(x,y,playhead.sprite)
    return
  end
  event = get_event(x,y)
  if event then
    draw_sprite(x,y,event.sprite)
  end
end

function draw_grid()
  for x = 1,template.bounds.x do
    for y = 1,template.bounds.y do
      draw_tile(x,y)
    end
  end
  screen.stroke()
end

function redraw()
  screen.clear()
  draw_grid()
  screen.update()
end

-- Utils

function midi_to_hz(note)
  return (440/32) * (2 ^ ((note - 9) / 12))
end

function clamp(val,min,max)
  return val < min and min or val > max and max or val
end
