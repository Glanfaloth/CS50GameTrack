-- constant values (16 x 9 aspect ratio)
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size of virtual raster
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 -- 200 pixels per second

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

-- set up the initial state of our game
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')

    -- create fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    victoryFont = love.graphics.newFont('font.ttf', 24)

    -- table that stores key-value pairs of strings of audio names to audio objects
    sounds = {
        ['paddle_hit'] = love.audio.newSource('/sounds/paddle_hit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('/sounds/wall_hit.wav', 'static'),
        ['score'] = love.audio.newSource('/sounds/score.wav', 'static')
    }

    -- push is an object, calling a method inside itself
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        -- a set of key-value pairs to specify more details about the game window
        fullscreen = false,
        vsync = true, -- sync it to the monitor's refresh rate
        resizable = false
    })

    player1Score = 0
    player2Score = 0

    servingPlayer = math.random(2) == 1 and 1 or 2 -- coinflip to decide who serves (发球) 
    winningPlayer = 0

    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    if servingPlayer == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

    gameState = 'start'
end

function love.update(dt)
    --[[ After the ball reaches the left or the right side of the screen, the other player scores.
    So on the next turn, we want the ball to start by going towards that opposing player,
    as though the player was serving the ball.]]--
    if ball.x <= 0 then
        player2Score = player2Score + 1
        servingPlayer = 1
        ball:reset()
        ball.dx = 100 -- from player1 to 2

        sounds['score']:play()

        if player2Score >= 10 then
            gameState = 'victory'
            winningPlayer = 2
        else
            gameState = 'serve'
        end
    end
    if ball.x >= VIRTUAL_WIDTH - 4 then
        servingPlayer = 2
        player1Score = player1Score + 1
        ball:reset()
        ball.dx = -100 -- from player2 to 1

        sounds['score']:play()

        if player1Score >= 10 then
            gameState = 'victory'
            winningPlayer = 1
        else
            gameState = 'serve'
        end
    end
    if ball:collides(paddle1) then
        ball.dx = -ball.dx * 1.03 -- deflect ball when hit paddle
        ball.x = paddle1.x + 4

        sounds['paddle_hit']:play()

        if ball.dy < 0 then
            ball.dy = -math.random(10,150)
        else
            ball.dy = math.random(10,150)
        end
    end
    if ball:collides(paddle2) then
        ball.dx = -ball.dx * 1.03 -- deflect ball when hit paddle
        ball.x = paddle2.x - 4

        sounds['paddle_hit']:play()

        if ball.dy < 0 then
            ball.dy = -math.random(10,150)
        else
            ball.dy = math.random(10,150)
        end
    end

    if ball.y <= 0 then
        ball.dy = -ball.dy
        ball.y = 0

        sounds['wall_hit']:play()
    end
    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4

        sounds['wall_hit']:play()
    end
    paddle1:update(dt)
    paddle2:update(dt)
    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    if love.keyboard.isDown('up') then
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'victory' then
            gameState = 'start'
            player1Score = 0
            player2Score = 0
        end
    end
end

-- update the screen
function love.draw()
    push:apply('start')

    -- set background color before drawing anything else, clear the window to a color
    love.graphics.clear(40/255, 45/255, 52/255, 255/255) -- 40 45 52 255 to 0.0 - 1.0

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Play', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Player" .. tostring(servingPlayer) .. "'s turn", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Play', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player" .. tostring(winningPlayer) .. " wins", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to Play', 0, 42, VIRTUAL_WIDTH, 'center')
    end
    displayScore()
    -- draw paddles
    paddle1:render()
    paddle2:render()
    ball:render() -- draw the ball

    displayFPS()
  
    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20) -- .. concatenation
    love.graphics.setColor(1, 1, 1, 1) -- set default color back white
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end