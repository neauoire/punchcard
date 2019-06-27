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
  stack:bind(instructor)
  instructor:bind()
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