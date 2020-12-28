-- constant values (16 x 9 aspect ratio)
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size of virtual raster
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 -- 200 pixels per second

-- looking for push.lua
push = require 'push'

-- set up the initial state of our game
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

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

    player1Y = 20
    player2Y = VIRTUAL_HEIGHT - 40

    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(50, -50)

    gameState = 'start'
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
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

            -- reset ball state
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(50, -50)
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
    -- draw the ball (a rectangle)
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)
    -- draw paddles
    love.graphics.rectangle('fill', 5, player1Y, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
    -- the words are 12 pixels so -6
    
    push:apply('end')
end
