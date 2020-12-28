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
    -- the words are 12 pixels so -6
    love.graphics.printf("Hello Pong!", 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, "center")
    push:apply('end')
end