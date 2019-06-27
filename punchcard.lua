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
  -- Params
  params:add{type = "number", id = "bpm", name = "BPM", min = 40, max = 400, default = 120, action=function(val) navi:set_bpm(val) end}
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

function redraw()
  navi.grid:all(0)
  screen.clear()
  if navi:is_connected() ~= true then
    navi:view_error()
  elseif navi:in_card() then
    navi:grid_card()
    navi:view_card()
  else
    navi:grid_home()
    navi:view_home()
  end
  navi.grid:refresh()
  screen.update()
end
