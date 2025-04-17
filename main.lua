require "lib.asset_bundle"
require "lib.player"
require "lib.math2"

PIXEL_PER_METER = 48

P = nil

function love.load()
    AssetBundle:load()
    love.window.setMode(1080, 720, { resizable = true, msaa = 4 })

    P = Player('fox')
    P.entity.position = Vec3 { 200, 200 }
    print('ready')
end

function love.update(dt)
    P:update(dt)
end

function love.draw()
    love.graphics.clear(1, 1, 1)
    local spriteCanvas = love.graphics.newCanvas()
    spriteCanvas:setFilter("linear", "linear")

    love.graphics.setCanvas(spriteCanvas)
    love.graphics.clear(1, 1, 1)

    drawShadow(P.entity, Vec3 { 200, 200 }, 200)
    drawShadow(P.entity, Vec3 { 300, 200 }, 200)
    drawShadow(P.entity, Vec3 { 400, 200 }, 200)

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.circle("fill", 200, 200, 10)
    love.graphics.circle("fill", 300, 200, 10)
    love.graphics.circle("fill", 400, 200, 10)
    love.graphics.setColor(1, 1, 1, 1)

    local tex, quad = P.entity:spriteFromAngle(math.pi / 2)
    love.graphics.draw(tex, quad, P.entity.position.x, P.entity.position.y,
        0,
        1, 1, tex:getHeight() / 2, tex:getHeight())

    love.graphics.setCanvas()

    local scale = math.min(love.graphics.getDimensions()) / (15 * PIXEL_PER_METER);
    love.graphics.draw(spriteCanvas, 0, 0, 0, scale, scale)


    love.graphics.setColor(1, 1, 1, 1)
end

function love.conf(t)
    t.console = true
end

function drawShadow(entity, light, radius)
    local shadow_vec = light - entity.position
    local dist = shadow_vec:length()
    if dist > radius then return end

    love.graphics.setColor(0, 0, 0, math.min(0.5, 1 - (dist / radius)))
    local tex, quad = P.entity:spriteFromAngle(shadow_vec:direction())
    love.graphics.draw(tex, quad, P.entity.position.x, P.entity.position.y - 10,
        shadow_vec:direction() - math.pi / 2,
        1, math.sin(20), tex:getHeight() / 2, tex:getHeight())

    -- love.graphics.push()
    -- love.graphics.setColor(0, 0, 0, 0.5)
    -- love.graphics.translate(entity.position.x, entity.position.y)
    -- love.graphics.scale(1, 0.342)
    -- love.graphics.circle("fill", 0, 0, 20)
    -- love.graphics.pop()

    love.graphics.setColor(1, 1, 1, 1) -- сброс цвета
end
