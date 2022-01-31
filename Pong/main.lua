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

-- the "Class" library we're using will aloww us to represent anything in our game as code, 
-- rather than keeping of many disparate variables and methods
Class = require 'class'

-- our Paddle class, which stores position and dimenrions for each Paddle and the logic for 
-- rendering them
require 'Paddle'

-- our Ball class, which isn't much different than a Paddle strycture-wise but which will 
-- mechanically function very differently
require 'Ball'

-- 
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- spead at which we  will move our paddle; multiplied by dt in update
PADDLE_SPEED = 200

--[[
  Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
  -- set love's default filter to "nearest-neighbor", which essentially
  -- means there will be no filtering of pixels (blurriness), which is 
  -- important for a nice crisp, 2D look 
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- set the title of our application window
  love.window.setTitle('Pong')

  -- "seed" the RNG so that calls to random are always random use the current time,
  -- since that will vary on startup every time
  math.randomseed(os.time())

  -- more "retro-looking" font object we can use for any text
  smallFont = love.graphics.newFont('font.ttf', 8)
  largeFont = love.graphics.newFont('font.ttf', 16)
  scoreFont = love.graphics.newFont('font.ttf', 32)
  love.graphics.setFont(smallFont)

  --initalize our virtual resolution
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true,
    canvas = false
  })

  -- initialize our play paddles; make them global so that they can be detected by other
  -- functions and modules
  player1 = Paddle(10, 30, 5, 20)
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
  
    -- place a ball in the middle of the screen
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  -- initialize score variables, used for rendering on the screen and keeping
  -- track of the winner
  player1Score = 0
  player2Score = 0
  
  -- either going to be 1 or 2; whomever is scored on gets to serve the following turn
  servingPlayer = 1

  -- player who won the game; not set to a proper value until we reach that state in the game
  winningPlayer = 0

  -- game state variable used to trasition between different parts of the game (used for
  -- beginning, menus, main game, high score list, etc.)
  -- we will use this to determine behavior during render and update
  gameState = 'start'
end

--[[
  Calla=ed whenever we change the dimensions of our window, as by gragging out its bottom coner, for example. In this case, we only need to worry about calling out to `push` to handle the resizing. Takes in a `w` and `h` variable representing width and height, respectively.
]]
function love.resize(w, h)
  push:resize(w, h)
end

--[[
  Called every frame, passing in "dt" since the last frame. `dt` is short for `deltaTime` and is measured in seconds. multiplying this by any changes we wish to make in our game will allow our game to perform consistently across al hardware; otherwise, any changes we make will be apllied as fast as possible and will vary across system hardware.
]]
function love.update(dt)
  if gameState == 'serve' then
    -- before switching to play, initialize ball's velocity base on player who last scored
    ball.dy = math.random(-50, 50)
    if servingPlayer == 1 then
      ball.dx = math.random(140, 200)
    else
      ball.dx = -math.random(140, 200)
    end
  elseif gameState == 'play' then
    -- detect ball colision with paddles, reversing dx if true and
    -- slightly increasing it, then altering the dy based on the position at which it collided,
    -- then playing a sound effect
    if ball:collides(player1) then
      ball.dx = -ball.dx * 1.03
      ball.x = player1.x + 5

      -- keep velocity going in the same direction, but randomize it
      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end

      --sounds['paddle_hit']:play()
    end
    if ball:collides(player2) then
      ball.dx = -ball.dx * 1.03
      ball.x = player2.x - 4

      -- keep velocity going in the same direction, but randomize it
      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end

      --sounds['paddle_hit']:play()
    end

    -- detect upper and lower screen boundary collision, playing a sound effect and 
    -- reversing dy if true
    if ball.y <= 0 then
      ball.y = 0
      ball.dy = -ball.dy
      -- sounds['wall_hit']:play()
    end

    -- -4 to account for the ball's size
    if ball.y >= VIRTUAL_HEIGHT - 4 then
      ball.y = VIRTUAL_HEIGHT - 4
      ball.dy = -ball.dy
      -- sounds['wall_hit']:play()
    end

    -- if we reach the left or right edge of the screen, go back to serve and update the 
    -- score and serving player
    if ball.x < 0 then
      servingPlayer = 1
      player2Score = player2Score + 1
      --sounds['score']:play()

      -- if we've reached a score of 10, the game is over; set the state to done so we
      -- can show the victory message
      if player2Score == 10 then
        winningPlayer = 2
        gameState = 'done'
      else
        gameState = 'serve'
        -- places the ball in the middle of the screen, no velocity
        ball:reset()
      end
    end

    if ball.x > VIRTUAL_WIDTH then
      servingPlayer = 2
      player1Score = player1Score + 1
      -- sounds['score']:play()

      if player1Score == 10 then
        winningPlayer = 1
        gameState = 'done'
      else
        gameState = 'serve'
        ball:reset()
      end
    end
  end

  -- player 1 movement
  if love.Keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED
  elseif love.Keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED
  else
    player1.dy = 0
  end

  -- player 2 movement
  if love.Keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
  elseif love.Keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
  end

  -- update our ball based on its DX and DY only if we're in play state;
  -- scale the velocity by dt so movement is famerate-independent
  if gameState == 'play' then
    ball:update(dt)
  end

  player1:update(dt)
  player2:update(dt)
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
  
  -- if we press enter during the start state of the game, we'll go into play mode during play
  -- more, the ball will move in a random direction
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'serve'
    elseif gameState == 'serve' then
      gameState = 'play'
    elseif gameState == 'done' then
      -- game is simply in a restart phase here, but will set the serving player to the
      -- opponent of whomever won for fairness!
      gameState = 'serve'
      
      ball:reset()

      -- reset score to 0
      player1Score = 0
      player2Score = 0

      -- decide serving player as the opposite of who won
      if winningPlayer == 1 then
        servingPlayer = 2
      else
        servingPlayer = 1
      end
    end
  end
end

--[[
  Callded after update by LOVE2D, used to draw anything to the screen, update or otherwise.
]]
function love.draw()
  -- begin rendering at virtual resolution
  push:start()

  -- clear the scrren widt a specific color; in this case, a color smilar
  -- to some version of the original Pong
  love.graphics.clear(40/255, 45/255, 52/255, 255/255)

  -- render different things depending on which part of the game we're in
  if gameState == 'start' then
    -- UI messages
    love.graphics.setFont(smallFont)
    love.graphics.printf('Welcome to pong!', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'serve' then
    -- UI messages
    love.graphics.setFont(smallFont)
    love.graphics.printf('player' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'play' then
    -- no UI messagens to display
  elseif gameState == 'done' then
    -- UI messages
    love.graphics.setFont(largeFont)
    love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
  end

  -- show the score before ball is rendered so it can move over the text
  displayScore()

  -- render paddles, now using their class's render method
  player1:render()
  player2:render()
  -- render ball using its class's render method
  ball:render()

  -- display FPS for debugging; simply comment out to remove
  displayFPS()
  
  -- end rendering at virtual resolution
  push:finish()
end

--[[
  Simple function for rendering the scores.
]]
function displayScore()
  -- score display
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

--[[
  Renders the current FPS
]]
function displayFPS()
  -- simple FPS display across all states
  love.graphics.setFont(smallFont)
  love.graphics.setColor(0, 255/255, 0, 255/255)
  love.graphics.print('FPS: '.. tostring(love.timer.getFPS()), 10, 10)
  love.graphics.setColor(255, 255, 255, 255)
end