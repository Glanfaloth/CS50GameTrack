-- constant values
-- 16 x 9 aspect ratio
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size of virtual raster
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- looking for push.lua
push = require 'push'

-- set up the initial state of our game
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- create a font object of size 8 pixels
    smallFont = love.graphics.newFont('font.ttf', 8)
    -- set the
    love.graphics.setFont(smallFont)
    -- push is an object, calling a method inside itself
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        -- a set of key-value pairs to specify more details about the game window
        fullscreen = false,
        vsync = true, -- sync it to the monitor's refresh rate
        resizable = false
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- update the screen
function love.draw()
    push:apply('start')

    -- set background color before drawing anything else, clear the window to a color
    -- 40 45 52 255
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    -- draw the ball (a rectangle)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    -- draw paddles
    love.graphics.rectangle('fill', 5, 20, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20)
    -- the words are 12 pixels so -6
    love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, "center")
    push:apply('end')
end