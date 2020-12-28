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

    -- create a font object of size 8 pixels
    smallFont = love.graphics.newFont('font.ttf', 8)
    -- create font for score, larger
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- push is an object, calling a method inside itself
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        -- a set of key-value pairs to specify more details about the game window
        fullscreen = false,
        vsync = true, -- sync it to the monitor's refresh rate
        resizable = false
    })

    player1Score = 0
    player2Score = 0

    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'
end

function love.update(dt)
    if ball:collides(paddle1) or ball:collides(paddle2) then
        ball.dx = -ball.dx -- deflect ball when hit paddle
    end

    if ball.y <= 0 then
        ball.dy = -ball.dy
        ball.y = 0
    end
    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4
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
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()
        end
    end
end

-- update the screen
function love.draw()
    push:apply('start')

    -- set background color before drawing anything else, clear the window to a color
    love.graphics.clear(40/255, 45/255, 52/255, 255/255) -- 40 45 52 255 to 0.0 - 1.0

    love.graphics.setFont(smallFont) -- set the font
    if gameState == 'start' then
        love.graphics.printf("Hello Start State!", 0, 20, VIRTUAL_WIDTH, "center")
    else
        love.graphics.printf("Hello Play State!", 0, 20, VIRTUAL_WIDTH, "center")
    end
    love.graphics.setFont(scoreFont) -- set the font
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
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