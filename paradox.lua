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

notes = {}
notes[0]  = { name = 'C', sharp = false }
notes[1]  = { name = 'C', sharp = true  }
notes[2]  = { name = 'D', sharp = false }
notes[3]  = { name = 'D', sharp = true  }
notes[4]  = { name = 'E', sharp = false }
notes[5]  = { name = 'F', sharp = false }
notes[6]  = { name = 'F', sharp = true  }
notes[7]  = { name = 'G', sharp = false }
notes[8]  = { name = 'G', sharp = true  }
notes[9]  = { name = 'A', sharp = false }
notes[10] = { name = 'A', sharp = true  }
notes[11] = { name = 'B', sharp = false }

sprites[' '] ={
  0,0,0,0,0,
  0,0,0,0,0,
  0,0,0,0,0,
  0,0,0,0,0,
  0,0,0,0,0,
}

sprites['*'] ={
  1,0,0,0,1,
  0,1,0,1,0,
  0,0,1,0,0,
  0,1,0,1,0,
  1,0,0,0,1,
}

sprites['skip'] = {
  0,0,1,0,0,
  0,0,1,1,0,
  1,1,1,0,1,
  0,0,1,1,0,
  0,0,1,0,0,
}

sprites['1'] = { 0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0 }
sprites['2'] = { 1,1,1,1,0,0,0,0,0,1,0,1,1,1,0,1,0,0,0,0,0,1,1,1,1 }
sprites['3'] = { 1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0 }
sprites['4'] = { 0,0,0,1,0,0,0,1,1,0,0,1,0,1,0,1,1,1,1,1,0,0,0,1,0 }
sprites['5'] = { 1,1,1,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,1,0 }
sprites['6'] = { 1,0,0,0,0,1,0,0,0,0,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1 }
sprites['7'] = { 1,1,1,1,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1 }
sprites['8'] = { 0,1,1,1,0,1,0,0,0,1,0,1,1,1,0,1,0,0,0,1,0,1,1,1,0 }
sprites['A'] = { 0,0,1,0,0,0,1,0,1,0,1,1,1,1,1,1,0,0,0,1,1,0,0,0,1 }
sprites['B'] = { 1,1,1,1,0,1,0,0,0,1,1,1,1,1,0,1,0,0,0,1,1,1,1,1,0 }
sprites['C'] = { 0,1,1,1,0,1,0,0,0,1,1,0,0,0,0,1,0,0,0,1,0,1,1,1,0 }
sprites['D'] = { 1,1,1,1,0,1,0,0,0,1,1,0,0,0,1,1,0,0,0,1,1,1,1,1,0 }
sprites['E'] = { 1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1 }
sprites['F'] = { 1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0 }
sprites['G'] = { 0,1,1,1,1,1,0,0,0,0,1,0,1,1,1,1,0,0,0,1,0,1,1,1,0 }
sprites['#'] = { 0,1,0,1,0,1,1,1,1,1,0,1,0,1,0,1,1,1,1,1,0,1,0,1,0 }
sprites['.'] = { 0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0 }

sprites['flip'] = { 1,0,0,0,1,0,1,0,0,1,0,0,1,0,1,0,1,0,0,1,1,0,0,0,1 }
sprites['mute'] = { 1,0,1,0,1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,1,0,1,0,1 }
sprites['incr'] = { 0,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,1 }
sprites['imaj'] = { 0,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0,0,0,0,0,1,1,1,1,1 }
sprites['ioct'] = { 0,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,0,1,0,0,0,0,1,0,0 }
sprites['decr'] = { 1,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,1,0,0 }
sprites['dmaj'] = { 1,0,0,0,1,0,1,0,1,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,1 }
sprites['doct'] = { 0,0,1,0,0,0,0,1,0,0,1,0,1,0,1,0,1,0,1,0,0,0,1,0,0 }
sprites['turn'] = { 0,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0,0 }

local counter
local is_playing = true
local viewport = { w = 128, h = 64 }
local template = { size = { w = 6, h = 6 }, bounds = {} }
local playhead = { x = 1, y = 1, o = 1, v = 60 }
local events = {}

local fns = {
  -- FLIP
  flip = {
    sprite = sprites.flip,
    next = 'turn',
    run = function() if playhead.o == 0 then playhead.o = 2 elseif playhead.o == 1 then playhead.o = 3 elseif playhead.o == 2 then playhead.o = 0 else playhead.o = 1 end
  end 
  },
  -- TURN
  turn = {
    sprite = sprites.turn,
    next = 'skip',
    run = function() playhead.o = (playhead.o + 1) % 4 end
  },
  -- SKIP
  skip = {
    sprite = sprites.skip,
    next = 'mute',
    run = function() move() end
  },
  -- MUTE
  mute = {
    sprite = sprites.mute,
    next = 'incr',
    run = function() if playhead.mute == true then playhead.mute = false else playhead.mute = true end end
  },
  -- INCR
  incr = {
    sprite = sprites.incr,
    next = 'imaj',
    run = function() playhead.v = (playhead.v + 1) % 127 end
  },
  -- INCR MAJ
  imaj = {
    sprite = sprites.imaj,
    next = 'ioct',
    run = function() playhead.v = get_next_maj(playhead.v) end
  },
  -- INCR OCT
  ioct = {
    sprite = sprites.ioct,
    next = 'decr',
    run = function() playhead.v = (playhead.v + 12) % 127 end
  },
  -- DECR
  decr = {
    sprite = sprites.decr,
    next = 'dmaj',
    run = function() playhead.v = (playhead.v - 1) % 127 end
  },
  -- DEC MAJ
  dmaj = {
    sprite = sprites.dmaj,
    next = 'doct',
    run = function() playhead.v = get_prev_maj(playhead.v) end
  },
  -- DECR OCT
  doct = {
    sprite = sprites.doct,
    next = nil,
    run = function() playhead.v = (playhead.v - 12) % 127 end
  },
}

function init()
  -- Make bounds
  template.bounds.x = math.floor(viewport.w/template.size.w)-1
  template.bounds.y = math.floor(viewport.h/template.size.h)-2
  print('Bounds '..template.bounds.x..','..template.bounds.y)
  -- Events
  move_to(3,3)
  add_event(5,3,fns.incr)
  add_event(4,3,fns.mute)
  add_event(7,3,fns.flip)
  add_event(1,3,fns.flip)
  add_event(7,4,fns.incr)
  add_event(1,4,fns.imaj)
  add_event(6,5,fns.decr)
  add_event(2,5,fns.dmaj)
  add_event(2,3,fns.turn)
  add_event(2,6,fns.turn)
  add_event(6,6,fns.turn)
  add_event(7,8,fns.ioct)
  add_event(3,2,fns.doct)
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
  send()
end

function add_event(x,y,e)
  print('Added event ',e)
  events[x..','..y] = e
end

function get_event(x,y)
  return events[x..','..y]
end

function toggle_play()
  if is_playing == true then
    stop()
  else
    play()
  end
end

function play()
  counter:start()
  is_playing = true
end

function stop()
  counter:stop()
  is_playing = false
  playhead.o = 1
end

function incr_fn()
  selection = get_event(playhead.x,playhead.y)
  if selection == nil then
    add_event(playhead.x,playhead.y,fns.flip)
  elseif selection.next == nil then
    print('clear')
    add_event(playhead.x,playhead.y,nil)
  else
    print('default',selection.next)
    add_event(playhead.x,playhead.y,fns[selection.next])  
  end
  redraw()
end

function send()
  
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
  if n == 3 then
    incr_fn()
    stop()
  end
  redraw()
end

-- Render

function is_selection(x,y)
  return x == playhead.x and y == playhead.y
end

function get_sprite(id)
  if sprites[id] == nil then
    return sprites['*']
  end
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
    draw_sprite(x,y,event.sprite,15,is_selection(x,y))
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

function draw_state()
  octave = get_octave()
  note = get_note()
  sharp = get_sharp()
  draw_sprite(1,10,get_sprite(octave..''),15,false)
  draw_sprite(2,10,get_sprite(note..''),15,false)
  if sharp == true then
    draw_sprite(3,10,get_sprite('#'),15,false)
  end
end

function redraw()
  screen.clear()
  draw_grid()
  draw_state()
  screen.update()
end

-- Playhead Utils

function get_octave()
  return math.floor(playhead.v/12)
end

function get_note()
  return notes[playhead.v % 12].name
end

function get_sharp()
  return notes[playhead.v % 12].sharp
end

-- Utils

function get_next_maj(v)
  note = v % 12
  if note == 4 or note == 11 then return v + 1 end
  if note == 0 or note == 1 or note == 2 or note == 5 or note == 6 or note == 7 or note == 8 or note == 9 then return v + 2 end
  if note == 3 or note == 10 then return v + 3 end
end

function get_prev_maj(v)
  note = v % 12
  if note == 0 or note == 5 then return v - 1 end
  if note == 2 or note == 3 or note == 4 or note == 7 or note == 8 or note == 9 or note == 10 or note == 11 then return v - 2 end
  if note == 1 or note == 6 then return v - 3 end
end

function midi_to_hz(note)
  return (440/32) * (2 ^ ((note - 9) / 12))
end

function clamp(val,min,max)
  return val < min and min or val > max and max or val
end
