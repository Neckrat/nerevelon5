require 'lib.asset_bundle'
require 'lib.animation'


__AnimatedSprite = {}

function AnimatedSprite(id)
    local table = {}
    local bundle = AssetBundle.files.sprites[id]
    for key, value in pairs(bundle) do
        table[key] = Animation(value, 96, 96)
    end

    return setmetatable(table, { __index = __AnimatedSprite })
end

function __AnimatedSprite:update(dt)
    if self.playing then
        self[self.playing]:update(dt)
    end
end

function __AnimatedSprite:getQuad()
    if self.playing then
        return self[self.playing]:getQuad()
    end
    return love.graphics.newQuad(0, 0, 235, 235, AssetBundle.files.sprites.fallback)
end

function __AnimatedSprite:getTexture()
    if self.playing then
        return self[self.playing].spriteSheet
    end
    return AssetBundle.files.sprites.fallback
end
