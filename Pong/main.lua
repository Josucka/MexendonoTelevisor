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

  -- more "retro-looking" font object we can use for any text
  smallFont = love.graphics.newFont('font.ttf', 8)

  -- set LOVE2d's active font to the smallFont objet
  love.graphics.setFont(smallFont)

  --initalize our virtual resolution
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
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

  -- clear the scrren widt a specific color; in this case, a color smilar
  -- to some version of the original Pong
  love.graphics.clear(40/255, 45/255, 52/255, 255/255)

  -- draww welcome text toward the top of the screen
  love.graphics.printf('Hello Pong!', 0, VIRTUAL_HEIGHT, 'center')

  -- 
  -- paddles are simply rectangles ew draw on the screen at certain points, as is the ball
  --

  -- render first paddle (left side)
  love.graphics.rectangle('fill', 10, 30, 5, 20)

  -- render second paddle (right side)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

  --render ball (center)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  -- end rendering at virtual resolution
  push:apply('end')
end