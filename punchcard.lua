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
local instruct = include('lib/instruct')
local operator = include('lib/operator')

-- Main

function init()
  -- Setup
  navi:bind(stack,instruct,operator)
  stack:bind(instruct)
  instruct:bind()
  operator:bind(navi)
  -- Init
  stack:init()
  navi:init()
  instruct:init()
  -- Render Style
  screen.level(15)
  screen.aa(0)
  screen.line_width(1)
  -- Ready
  navi:start()
end