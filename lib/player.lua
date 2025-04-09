require "lib.entity"
require 'lib.vec3'

__Player = {}

function Player(sprite_id)
    local e = Entity(sprite_id)
    e.sprite.playing = "walk_e"
    return setmetatable({ entity = e }, { __index = __Player })
end

function __Player:update(dt)
    local acc = Vec3 {}

    if (love.keyboard.isDown('w')) then
        acc = acc + Vec3 { 0, -1 }
    end
    if (love.keyboard.isDown('a')) then
        acc = acc + Vec3 { -1, 0 }
    end
    if (love.keyboard.isDown('d')) then
        acc = acc + Vec3 { 1, 0 }
    end
    if (love.keyboard.isDown('s')) then
        acc = acc + Vec3 { 0, 1 }
    end

    self.entity.velocity = self.entity.velocity
        + ((acc:normalize() or Vec3 {})
            * self.entity.speed
            * dt)


    self.entity:update(dt)
end
