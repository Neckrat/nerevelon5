require 'lib.asset_bundle'
require 'lib.animation'


__AnimatedSprite = {
    t = 0,
}

function AnimatedSprite(id)
    local table = {}
    local bundle = AssetBundle.files.sprites[id]
    for key, value in pairs(bundle) do
        table[key] = Animation(value, value:getHeight(), value:getHeight())
    end

    return setmetatable(table, { __index = __AnimatedSprite })
end

function __AnimatedSprite:update(dt)
    self.t = (self.t + dt) % 1
end

function __AnimatedSprite:getQuad(key)
    if key then
        return self[key]:getQuad(self.t)
    end
    return love.graphics.newQuad(0, 0, 235, 235, AssetBundle.files.sprites.fallback)
end

function __AnimatedSprite:getTexture(key)
    if key then
        return self[key].spriteSheet
    end
    return AssetBundle.files.sprites.fallback
end
