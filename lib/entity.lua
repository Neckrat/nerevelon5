require 'lib.sprite'
require 'lib.vec3'

__Entity = {
    id = nil,
    sprite = __AnimatedSprite,
    position = Vec3 {},
    velocity = Vec3 {},
}

function Entity(id)
    local t = {
        id = id,
        sprite = AnimatedSprite(id),
    }
    return setmetatable(t, { __index = __Entity })
end

function __Entity:update(dt)
    if self.sprite then
        self.sprite:update(dt)
    end
end
