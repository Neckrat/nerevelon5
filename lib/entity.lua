require 'lib.sprite'
require 'lib.vec3'

__Entity = {
    id = nil,
    sprite = __AnimatedSprite,
    position = Vec3 {},
    velocity = Vec3 {},
    rotation = 0, -- clockwise radians
    friction = 0.98,
    speed = 1     -- m/s
}

function Entity(id)
    local t = {
        id = id,
        sprite = AnimatedSprite(id),
    }
    return setmetatable(t, { __index = __Entity })
end

function __Entity:update(dt)
    self:processMovement()
    if self.sprite then
        self.sprite:update(dt)
    end
end

function __Entity:processMovement()
    self.position = self.position + self.velocity
    self.velocity = self.velocity * self.friction
end

function __Entity:namedDirection()
    local get_direction_index = function(rotation)
        local pi = math.pi
        rotation = rotation % (2 * pi)
        local shifted = (rotation + pi / 8) % (2 * pi)
        local index = math.floor(shifted / (pi / 4)) + 1
        return index
    end

    local lookup = {
        "e",
        "ne",
        "n",
        "nw",
        "w",
        "sw",
        "s",
        "se",
    }

    return lookup[get_direction_index(self.rotation)]
end

function __Entity:lookAt(vec)
    self.rotation = (vec - self.position):direction()
end
