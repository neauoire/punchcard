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

local sprites = {}

sprites['*'] ={
  0,0,0,0,0,
  0,0,0,0,0,
  0,0,0,0,0,
  0,0,0,0,0,
  0,0,0,0,0,
}

sprites['*'] ={
  0,0,0,0,0,
  0,0,0,0,0,
  0,0,1,0,0,
  0,0,0,0,0,
  0,0,0,0,0,
}

sprites['1'] = { 0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0 }
sprites['2'] = { 1,1,1,1,0,0,0,0,0,1,0,1,1,1,0,1,0,0,0,0,0,1,1,1,1 }
sprites['3'] = { 1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0 }
sprites['A'] = { 0,0,1,0,0,0,1,0,1,0,1,1,1,1,1,1,0,0,0,1,1,0,0,0,1 }
sprites['B'] = { 1,1,1,1,0,1,0,0,0,1,1,1,1,1,0,1,0,0,0,1,1,1,1,1,0 }
sprites['C'] = { 0,1,1,1,0,1,0,0,0,1,1,0,0,0,0,1,0,0,0,1,0,1,1,1,0 }
sprites['D'] = { 1,1,1,1,0,1,0,0,0,1,1,0,0,0,1,1,0,0,0,1,1,1,1,1,0 }
sprites['E'] = { 1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1 }
sprites['F'] = { 1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0 }
sprites['G'] = { 0,1,1,1,1,1,0,0,0,0,1,0,1,1,1,1,0,0,0,1,0,1,1,1,0 }
sprites['#'] = { 0,1,0,1,0,1,1,1,1,1,0,1,0,1,0,1,1,1,1,1,0,1,0,1,0 }
sprites['.'] = { 0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0 }

local counter
local is_playing = true
local viewport = { w = 128, h = 64 }
local template = { size = { w = 6, h = 6 }, bounds = {} }
local playhead = { x = 1, y = 1, o = 1, octave = 3, note = 'C' }

local events = {}

local fns = {
  -- FLIP
  flip = {
    sprite = {
      0,0,1,0,0,
      0,1,0,1,0,
      1,0,0,0,1,
      0,1,0,1,0,
      0,0,1,0,0,
    },
    run = function()
    if playhead.o == 0 then
      playhead.o = 2
    elseif playhead.o == 1 then
      playhead.o = 3
    elseif playhead.o == 2 then
      playhead.o = 0
    else
      playhead.o = 1
    end
  end
},
-- TURN
turn = {
  sprite = {
    0,1,0,1,0,
    1,1,1,1,1,
    0,1,0,1,0,
    1,1,1,1,1,
    0,1,0,1,0,
  },
  run = function()
  playhead.o = (playhead.o + 1) % 4
end
},
-- SKIP
skip = {
  sprite = {
    0,0,1,0,0,
    0,0,1,1,0,
    1,1,1,0,1,
    0,0,1,1,0,
    0,0,1,0,0,
  },
  run = function()
  move()
end
},
-- MUTE
mute = {
  sprite = {
    1,0,1,0,1,
    0,0,0,0,0,
    1,0,1,0,1,
    0,0,0,0,0,
    1,0,1,0,1,
  },
  run = function()
  move()
end
}
}

function init()
  -- Make bounds
  template.bounds.x = math.floor(viewport.w/template.size.w)-1
  template.bounds.y = math.floor(viewport.h/template.size.h)-1
  print('Bounds '..template.bounds.x..','..template.bounds.y)
  -- Events
  move_to(3,3)
  add_event(15,3,fns.flip)
  add_event(10,3,fns.turn)
  add_event(10,2,fns.turn)
  add_event(11,2,fns.flip)
  add_event(12,2,fns.skip)
  add_event(13,6,fns.mute)
  -- Ready
  start()
end

function start()
  -- Start
  counter = metro.init(tic, 0.125, -1)
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
  if playhead.o == 0 then
    playhead.y = (playhead.y + 1) % (template.bounds.y+2)
  elseif playhead.o == 1 then
    playhead.x = (playhead.x + 1) % (template.bounds.x+2)
  elseif playhead.o == 2 then
    playhead.y = (playhead.y - 1) % (template.bounds.y+2)
  else
    playhead.x = (playhead.x - 1) % (template.bounds.x+2)
  end
  redraw()
end

function move_to(x,y)
  playhead.x = x
  playhead.y = y
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

function get_sprite(id)
  return sprites[id]
end

function draw_sprite(x,y,sprite,brightness,invert)
  if brightness then
    screen.level(brightness)
  end
  if invert == true then
    screen.level(15)
  end
  for _y = 1,5 do
    for _x = 1,5 do
      id = ((_y-1) * 5) + _x
      if (sprite[id] == 1 and invert == false) or (sprite[id] == 0 and invert == true)  then
        sprite_x = _x + ((x-1) * template.size.w)
        sprite_y = _y + ((y-1) * template.size.h)
        screen.pixel(sprite_x,sprite_y)
      end
    end
  end
  screen.fill()
end

function draw_tile(x,y)
  event = get_event(x,y)
  if event then
    draw_sprite(x,y,event.sprite,10,is_selection(x,y))
  else
    draw_sprite(x,y,sprites['.'],1,is_selection(x,y))
  end
end

function draw_grid()
  for x = 1,template.bounds.x+1 do
    for y = 1,template.bounds.y+1 do
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
