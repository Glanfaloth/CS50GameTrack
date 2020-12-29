require 'Util'

Map = Class{}

TILE_BRICK = 1 -- the first tile of the spritesheet is the brick
TILE_EMPTY = 4 -- the fourth tile of the spritesheet is empty

local SCROLL_SPEED = 62

function Map:init()
    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 30 -- number of tiles
    self.mapHeight = 28
    self.tiles = {}

    self.camX = 0
    self.camY = 0

    self.tileSprites = generateQuads(self.spritesheet, 16, 16)

    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    -- filling the map with empty tiles
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_EMPTY)
        end
    end

    -- starts halfway down the map, populates with bricks
    for y = self.mapHeight / 2, self.mapHeight do
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_BRICK)
        end
    end
end

function Map:setTile(x, y, tile)
    self.tiles[(y - 1) * self.mapWidth + x] = tile
end

function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

function Map:update(dt)
    if love.keyboard.isDown('w') then
        self.camY = math.max(0, math.floor(self.camY + -SCROLL_SPEED * dt))
    elseif love.keyboard.isDown('a') then
        self.camX = math.max(0, math.floor(self.camX + -SCROLL_SPEED * dt))
    elseif love.keyboard.isDown('s') then
        self.camY = math.min(self.mapHeightPixels - VIRTUAL_HEIGHT, math.floor(self.camY + SCROLL_SPEED * dt))
    elseif love.keyboard.isDown('d') then
        self.camX = math.min(self.mapWidthPixels - VIRTUAL_WIDTH, math.floor(self.camX + SCROLL_SPEED * dt))
    end
end

function Map:render()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if self:getTile(x, y) ~= TILE_EMPTY then
                love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
                    (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
            end
        end
    end
end