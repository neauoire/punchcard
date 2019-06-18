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

note = 40
position = { x = 1, y = 1 }
step = {1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1}
STEPS = 16
edit = 1

function inc() note = util.clamp(note + 5, 40, 120) end
function dec() note = util.clamp(note - 5, 40, 120) end
function bottom() note = 40 end
function top() note = 120 end
function rand() note = math.random(80) + 40 end
function metrofast() counter.time = 0.125 end
function metroslow() counter.time = 0.25 end
function positionrand() position.x = math.random(STEPS) end

act = {inc, dec, bottom, top, rand, metrofast, metroslow, positionrand}
COMMANDS = 8
label = {"+", "-", "<", ">", "*", "M", "m", "#"}

function init()
  params:add_control("cutoff", "cutoff", controlspec.new(50, 5000, 'exp', 0, 555, 'hz'))
  params:set_action("cutoff", function(x) engine.cutoff(x) end)
  counter = metro.init(count, 0.125, -1)
  counter:start()
end

function count()
  position.x = (position.x % STEPS) + 1
  act[step[position.x]]()
  engine.hz(midi_to_hz(note))
  redraw()
end

function redraw()
  screen.clear()
  
  for i = 1,16 do
    screen.level((i == edit) and 15 or 2)
    screen.move(i*8-8,40)
    screen.text(label[step[i]])
    if i == position.x then
      screen.move(i*8-8, 45)
      screen.line_rel(6,0)
      screen.stroke()
    end
  end
  
  screen.update()
end

function enc(n,d)
  if n == 1 then
    params:delta("cutoff", d)
  elseif n == 2 then
    edit = util.clamp(edit + d, 1, STEPS)
  elseif n ==3 then
    step[edit] = util.clamp(step[edit]+d, 1, COMMANDS)
  end
  redraw()
end

function key(n,z)
  if z ~= 1 then return end

  if n == 2 then
    toggle_play()
  end
  if n == 3 then
    randomize_steps()
  end
  redraw()
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

function midi_to_hz(note)
  return (440/32) * (2 ^ ((note - 9) / 12))
end

function randomize_steps()
  for i= 1,16 do
    step[i] = math.random(COMMANDS)
  end
end
