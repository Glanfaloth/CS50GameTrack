-- constant values
-- 16 x 9 aspect ratio
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- set up the initial state of our game
function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        -- a set of key-value pairs to specify more details about the game window
        fullscreen = false,
        vsync = true, -- sync it to the monitor's refresh rate
        resizable = false
    })
end

-- update the screen
function love.draw()
    -- the words are 12 pixels so -6
    love.graphics.printf("Hello Pong!", 0, WINDOW_HEIGHT / 2 - 6, WINDOW_WIDTH, "center")
end