Head = Class{}

require 'Util'

local WALKING_SPEED = 40
function Head:init(map)
    self.width = 22
    self.height = 32
    self.x = 0
    self.y = map.tileHeight * ((map.mapHeight - 2) / 2) - self.height
    self.map = map
    self.texture = love.graphics.newImage('graphics/head.png')
    self.frames = generateQuads(self.texture, self.width, self.height)
    self.dx = 100
end

function Head:update(dt)
    if gameState == 'play' then
        self.x = (self.x + self.dx * dt) % self.map.mapWidthPixels -- one after another
    end
end

function Head:render()
    if self.x < self.map.mapWidthPixels then
        love.graphics.draw(self.texture, self.frames[1], math.floor(self.x + self.width / 2),
            math.floor(self.y + self.height / 2), 0, -0.6, 0.6, self.width / 2, self.height / 2)
    end
end