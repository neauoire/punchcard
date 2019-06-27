--  
--   ////\\\\
--   ////\\\\  PUNCHCARD
--   ////\\\\  BY NEAUOIRE
--   \\\\////
--   \\\\////  255 SEQUENCER
--   \\\\////
--

local navi = include('lib/navi')
local stack = include('lib/stack')
local instructor = include('lib/instructor')
local operator = include('lib/operator')

-- Main

function init()
  -- Setup
  navi:bind(stack,instructor,operator)
  stack:bind(navi,instructor)
  operator:bind(navi,stack,instructor)
  -- Init
  stack:init()
  navi:init()
  instructor:init()
  operator:init()
  -- Render Style
  screen.level(15)
  screen.aa(0)
  screen.line_width(1)
  -- Ready
  navi:start()
end

-- Interactions

function key(id,state)
  if id == 2 and state == 1 then
    stack:erase_card()
  end
  if id == 3 and state == 1 then
    navi:toggle_play()
  end
end

function enc(id,delta)
end
