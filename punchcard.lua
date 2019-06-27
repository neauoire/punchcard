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

engine.name = "PolyPerc"

-- Main

function init()
  engine.release(3)
  -- Setup
  navi:bind(stack,instructor,operator)
  stack:bind(instructor)
  operator:bind(navi,stack,instructor)
  -- Init
  stack:init()
  navi:init()
  instructor:init()
  -- Render Style
  screen.level(15)
  screen.aa(0)
  screen.line_width(1)
  -- Ready
  navi:start()
end