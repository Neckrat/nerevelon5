local __Animation = {
    spriteSheet = nil,
    quads = nil,
    fps = 12,
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

function __Animation:getQuad(t)
    local duration = #self.quads / self.fps
    local frame = math.floor(t * duration * #self.quads)
    return self.quads[frame + 1]
end
