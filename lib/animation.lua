local __Animation = {
    spriteSheet = nil,
    quads = nil,
    fps = 12,
    currentTime = 0
}

function Animation(image, width, height)
    local animation = {}
    local width = width or 0
    local height = height or 0
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    return setmetatable(animation, { __index = __Animation })
end

function __Animation:getQuad()
    local frametime = 1 / self.fps
    local frame = math.floor(self.currentTime / frametime)
    return self.quads[frame + 1]
end

function __Animation:update(dt)
    self.currentTime = (self.currentTime + dt) % (#self.quads / self.fps)
end

function __Animation:reset()
    self.currentTime = 0
end
