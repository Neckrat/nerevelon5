require "lib.asset_bundle"
require "lib.player"


P = nil

function love.load()
    AssetBundle:load()
    P = Player('fox')
end

function love.update(dt)
    P:update(dt)
end

function love.draw()
    love.graphics.draw(P.entity.sprite:getTexture(), P.entity.sprite:getQuad(), P.entity.position.x, P.entity.position.y,
        P.entity.direction,
        2, 2, 48, 48)
end

function love.conf(t)
    t.console = true
end
