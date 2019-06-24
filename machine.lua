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

-- Main

function init()
  program:init()
  tracker:init()
  tracker:bind(program,instructions)
  connect()
  tracker:play()
end

function connect()
  g = grid.connect()
  g.key = on_grid_key
  g.add = on_grid_add
  g.remove = on_grid_remove
end

function is_connected()
  return g.device ~= nil
end

function on_grid_key(x,y,z)
  if z == 1 then
    program:swap(x,y)
    tracker:set_focus(x)
    redraw()
  end
end

function on_grid_add(g)
  print('on_add')
end

function on_grid_remove(g)
  print('on_remove')
end

-- Interactions

function key(id,state)
  if state ~= 1 then return end
  if id == 3 then
    tracker:toggle_play()
  end
end

function enc(id,delta)
  if id == 3 then
    tracker:mod_focus(delta)
    redraw()
  end
end

-- Render

function draw_function(x)
  for y=1,8 do
    bit = program:get(x,y)
    if bit == '1' then
      brightness = 10
    else
      brightness = 0
    end
    g:led(x,y,brightness)
  end
end

function draw_program()
  g:all(0)
  for x=1,#program.data do
    draw_function(x)
  end
  g:refresh()
end

function redraw()
  screen.clear()
  draw_program()
  tracker:redraw()
  screen.update()
end

-- Executed on script close/change/quit

function cleanup()

end