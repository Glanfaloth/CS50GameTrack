Flag = Class{}

function Flag:init(map)
    self.map = map
    self.x = self.map.mapWidth * self.map.tileWidth - 72
    self.y = self.map.mapHeight * self.map.tileHeight / 2 - 160
    self.width = 16
    self.height = 16
    self.texture = love.graphics.newImage('graphics/spritesheet.png')
    self.sprites = generateQuads(self.texture, 16, 16)
    self.frames = {}
    self.currentFrame = nil
    self.animations = {
        ['flag'] = Animation({
            texture = self.texture,
            frames = {
                self.sprites[FLAG_1], self.sprites[FLAG_2], self.sprites[FLAG_3]
            },
            interval = 0.3
        })
    }
    self.animation = self.animations['flag']
    self.currentFrame = self.animation:getCurrentFrame()
end

function Flag:update(dt)
    if gameState == 'play' then
        self.animation:update(dt)
        self.currentFrame = self.animation:getCurrentFrame()
    end
end

function Flag:render()
    -- draw sprite with scale factor and offsets
    love.graphics.draw(self.texture, self.currentFrame, self.x, self.y)
end