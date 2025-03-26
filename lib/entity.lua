require 'lib.sprite'
require 'lib.vec3'

__Entity = {
    id = nil,
    sprite = __AnimatedSprite,
    position = Vec3 {},
    velocity = Vec3 {},
    direction = 0, -- clockwise radians
    friction = 0.98,
    speed = 1
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
    local lookup = {
        "e",
        "se",
        "s",
        "sw",
        "w",
        "nw",
        "n",
        "ne"
    }
    local idx = math.floor((4 * self.direction / math.pi) + math.pi / 8) % 8
    return lookup[idx + 1]
end

function __Entity:lookAt(vec)
    self.direction = (vec - self.position):direction()
end
