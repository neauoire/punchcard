--  
--   ////\\\\
--   ////\\\\  MACHINE
--   ////\\\\  BY NEAUOIRE
--   \\\\////
--   \\\\////  255 INSTRUCTIONS
--   \\\\////
--

local program = include('lib/program')
local instructions = include('lib/instructions')
local tracker = include('lib/tracker')
local control = include('lib/control')

-- Main

function init()
  program:init()
  instructions:init()
  tracker:init()
  control:init()
  
  tracker:bind(program,instructions,control)
  control:bind(program,instructions,tracker)
  tracker:play()
end

-- Interactions

function key(id,state)
  if state ~= 1 then return end
  if id == 3 then
    tracker:toggle_play()
  end
  redraw()
end

function enc(id,delta)
  if id == 1 then
    tracker:mod_length(delta)
    redraw()
  end
  if id == 3 then
    tracker:mod_focus(delta)
    redraw()
  end
end

-- Render

function redraw()
  screen.clear()
  tracker:redraw()
  control:redraw()
  screen.update()
end

-- Executed on script close/change/quit

function cleanup()

end
