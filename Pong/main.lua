--[[
  Pong Remake 2022

  --main program --

  Autor: Josue Barros
  frajolla27@gmail.com

  Originally programmed by Atari in 1972. Features two paddles, controlled by players, with the goal of getting the ball past your opponent's edgs. First to 10 points wins.

  This version is built to more closely resemble the NES than the original Pong machines or the Atari 2600 in terms of resolution, thouh in widescreen (16:9) so it looks nicer on modern systems.

]]

-- push is a library that will allow us to draw us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
------------
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


--[[
  Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
  -- use nearest-neighbor filtering on upscaling and downscling to prevent blurring of text and graphics;
  -- try removing this function to see the difference!
  love.graphics.setDefaultFilter('nearest', 'nearest')

  --initalize our virtual resolution, which will be rendered within our actual window no matter its dimension;
  -- replaces our love.window.setMode call from tho last example

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

--[[
  Keyboard handling, called by LOVE2D each frame;
  passes in the key we pressed so we can access.
]]
function love.keypressed(key)
  -- key can be accessed by string name
  if key == 'escape' then
    -- function LOVE gives us to terminate application
    love.event.quit()
  end
end

--[[
  Callde after update by LOVE2D, used to draw anything to the screen, update or otherwise.
]]
function love.draw()
  -- begin rendering at virtual resolution
  push:apply('start')

  -- condensed onto one line fron last example
  -- note we are now using virtual width and height now for text placement
  love.graphics.printf(
    'Hello Pong!',         -- text to render
    0,                     -- starting X (0 since we're going to center it based on width)
    VIRTUAL_HEIGHT / 2 - 6, -- starting Y (halfway down the screen)
    VIRTUAL_WIDTH,          -- number of pixels to center withing (the entire screen here)
    'center'               -- alignment mode, can be 'center', 'left' or 'right'
  )

  -- end rendering at virtual resolution
  push:apply('end')
end