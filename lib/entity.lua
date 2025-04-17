require 'lib.sprite'
require 'lib.vec3'

__Entity = {
    id = nil,
    sprite = __AnimatedSprite,
    position = Vec3 {},
    velocity = Vec3 {},
    rotation = 0,       -- clockwise radians
    friction = 0.98,
    speed = 3,          -- m/s
    rotation_speed = 1, --rad/sec
    state = "walk"
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
    self.rotation = self.velocity:direction()
end

function __Entity:lookAt(vec)
    self.rotation = self.position:angle_to(vec)
end

function __Entity:spriteFromAngle(angle)
    local dir = math.named_direction(angle - self.rotation)
    local key = self.state .. "_" .. dir
    return self.sprite:getTexture(key), self.sprite:getQuad(key)
end
