--[[
    Super Mario Bros. Demo
    Author: Colton Ogden
    Original Credit: Nintendo

    Demonstrates rendering a screen of tiles.
]]

Class = require 'class'
push = require 'push'

require 'Animation'
require 'Map'
require 'Player'
require 'Head'
require 'Flag'

-- close resolution to NES but 16:9
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- actual window resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- seed RNG
math.randomseed(os.time())

-- makes upscaling look pixel-y instead of blurry
love.graphics.setDefaultFilter('nearest', 'nearest')

-- an object to contain our map data
map = Map()

-- performs initialization of all objects and data needed by program
function love.load()

    -- sets up a different, better-looking retro font as our default
    titleFont = love.graphics.newFont('fonts/font.ttf', 32)
    smallFont = love.graphics.newFont('fonts/font.ttf', 16)

    -- sets up virtual screen resolution for an authentic retro feel
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true
    })

    love.window.setTitle('Super Mario 50')

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}

    gameState = 'start'
end

-- called whenever window is resized
function love.resize(w, h)
    push:resize(w, h)
end

-- global key pressed function
function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

-- global key released function
function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

-- called whenever a key is pressed
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'lose' or gameState == 'win' then
            -- stop bgm and reload map
            map.music:stop()
            map = Map()
            gameState = 'play'
        end
    end

    love.keyboard.keysPressed[key] = true
end

-- called whenever a key is released
function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
    if gameState == 'play' then
        map:update(dt)
        -- reset all keys pressed and released this frame
        love.keyboard.keysPressed = {}
        love.keyboard.keysReleased = {}
    end
end

-- called each frame, used to render to the screen
function love.draw()
    -- begin virtual resolution drawing
    push:apply('start')

    -- clear screen using Mario background blue
    love.graphics.clear(108/255, 140/255, 255/255, 255/255)

    -- renders our map object onto the screen
    love.graphics.translate(math.floor(-map.camX + 0.5), math.floor(-map.camY + 0.5))

    if gameState == 'start' then
        love.graphics.setFont(titleFont)
        love.graphics.printf('Welcome to Fake Mario!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press LEFT <- and RIGHT -> to move', map.camX, 50, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press SPACE to jump', map.camX, 70, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Touching the Head dies, jumping onto it kills", map.camX, 90, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Reach the flag to win', map.camX, 110, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press ENTER to start', map.camX, 150, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        map:render()
    elseif gameState == 'lose' then
        love.graphics.setFont(titleFont)
        love.graphics.printf('Game Over!', map.camX, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to Restart', map.camX, 50, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'win' then
        love.graphics.setFont(titleFont)
        love.graphics.printf('Victory!', map.camX, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to Restart', map.camX, 50, VIRTUAL_WIDTH, 'center')
    end

    -- end virtual resolution
    push:apply('end')
end
