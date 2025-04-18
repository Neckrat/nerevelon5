require "lib.asset_bundle"
require "lib.player"
require "lib.math2"
require "lib.light_source"
require "lib.camera"

PIXELS_PER_METER = 48

P = nil

Entities = {}
Lights = {
    LightSource(Vec3 { 1, 1 }, 5),
    -- LightSource(Vec3 { 300, 200 }, 5),
    -- LightSource(Vec3 { 400, 200 }, 5)
}

function love.conf(t)
    t.console = true
end

function love.load()
    AssetBundle:load()
    love.window.setMode(1080, 720, { resizable = true, msaa = 4 })

    P = Player('fox')
    P.entity.position = Vec3 { 7, 7 }
    Entities.player = P.entity

    Camera.position = Vec3 { 0, 0 }
    print('ready')
end

function love.update(dt)
    P:update(dt)

    Camera.target = P.entity.position
    Camera:update(dt)
end

-- Преобразует вектор мировых координат (в метрах) в вектор экранных координат (в пикселях)
local function worldToScreen(worldPos)
    return (worldPos - Camera.position) * PIXELS_PER_METER
end


local function drawShadow(entity, light, radius)
    local shadow_vec = light - entity.position
    local dist = shadow_vec:length()
    if dist > radius then return end


    love.graphics.setColor(0, 0, 0, math.min(0.5, 1 - (dist / radius)))
    local tex, quad = entity:spriteFromAngle(shadow_vec:direction())

    love.graphics.draw(tex, quad,
        worldToScreen(entity.position).x,
        worldToScreen(entity.position).y - 10,
        math.step_floor(shadow_vec:direction() - math.pi / 2, math.pi / 4),
        1, math.sin(20), tex:getHeight() / 2, tex:getHeight())

    love.graphics.setColor(1, 1, 1, 1)
end


function love.draw()
    love.graphics.clear(1, 1, 1)
    local spriteCanvas = love.graphics.newCanvas()
    local width, height = spriteCanvas:getDimensions()
    spriteCanvas:setFilter("linear", "linear")

    love.graphics.setCanvas(spriteCanvas)
    love.graphics.clear(1, 1, 1)

    love.graphics.push()
    love.graphics.translate(width / 2, height / 2) -- теперь экранный ноль координат будет в центре экрана
    for _, e in pairs(Entities) do
        for _, l in pairs(Lights) do
            drawShadow(e, l.position, l.power)
        end

        local tex, quad = e:spriteFromAngle(math.pi / 2)
        love.graphics.draw(tex, quad,
            worldToScreen(e.position).x,
            worldToScreen(e.position).y,
            0,
            1, 1, tex:getHeight() / 2, tex:getHeight())
    end


    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.push()
    love.graphics.translate(worldToScreen(Lights[1].position).x, worldToScreen(Lights[1].position).y)
    love.graphics.circle("fill", 0, 0, 0.1 * PIXELS_PER_METER)
    love.graphics.pop()
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setCanvas()

    local scale = math.min(love.graphics.getDimensions()) / (15 * PIXELS_PER_METER);
    love.graphics.draw(spriteCanvas, 0, 0, 0, scale, scale)

    love.graphics.setColor(1, 1, 1, 1)
end
