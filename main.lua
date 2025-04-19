require "lib.asset_bundle"
require "lib.player"
require "lib.math2"
require "lib.light_source"
require "lib.camera"

PIXELS_PER_METER = 48

P = nil

Entities = {}
Lights = nil

function love.conf(t)
    t.console = true
end

function love.load()
    AssetBundle:load()
    love.window.setMode(1080, 720, { resizable = true, msaa = 4, vsync = true })

    Lights = { LightSource(Vec3 { 1, 1 }, 3, Vec3 { 0.5, 0.2, 1.0 }),
        LightSource(Vec3 { 4, 1 }, 10, Vec3 { 0.3, 0.7, 1.0 }, nil, AssetBundle.files.masks.noise),
        LightSource(Vec3 { 7, 1 }, 3, Vec3 { 0.8, 0.3, 1.0 }), }

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


local function drawShadow(entity, light)
    local shadow_vec = light.position - entity.position
    local dist = shadow_vec:length()
    if dist > light.power then return end


    love.graphics.setColor(0, 0, 0, math.min(0.5, 1 - (dist / light.power)))
    local tex, quad = entity:spriteFromAngle(shadow_vec:direction())

    love.graphics.draw(tex, quad,
        worldToScreen(entity.position).x,
        worldToScreen(entity.position).y - 10,
        shadow_vec:direction() - math.pi / 2,
        1, math.sin(20), tex:getHeight() / 2, tex:getHeight())

    love.graphics.setColor(1, 1, 1, 1)
end

local function drawLight(light)
    local shader = light.shader

    local pos = worldToScreen(light.position)
    shader:send("color", { light.color.x, light.color.y, light.color.z })
    shader:send("time", love.timer.getTime() + light.seed)

    local scale = light.power * PIXELS_PER_METER / 64
    love.graphics.setShader(shader)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(light.mask,
        pos.x - light.power * PIXELS_PER_METER,
        pos.y - light.power * PIXELS_PER_METER,
        0,
        scale,
        scale)
    love.graphics.setShader()
end


local function applyBlur(input, output, radius)
    local blurShader = AssetBundle.files.shaders.blur

    -- Горизонтальный проход
    blurShader:send("direction", { 1.0, 0.0 })
    blurShader:send("radius", radius)

    output:renderTo(function()
        love.graphics.setShader(blurShader)
        love.graphics.draw(input)
        love.graphics.setShader()
    end)

    -- Вертикальный проход
    input:renderTo(function()
        love.graphics.setShader(blurShader)
        blurShader:send("direction", { 0.0, 1.0 })
        love.graphics.draw(output)
        love.graphics.setShader()
    end)
end

function love.draw()
    local width, height = love.graphics.getDimensions()
    love.graphics.clear(0.1, 0.1, 0.1, 1.0)

    local spriteCanvas = love.graphics.newCanvas()
    local shadowCanvas = love.graphics.newCanvas()
    local lightCanvas = love.graphics.newCanvas()

    love.graphics.clear(0.1, 0.1, 0.1, 1.0)

    love.graphics.push()
    love.graphics.translate(width / 2, height / 2) -- теперь экранный ноль координат будет в центре экрана
    for _, e in pairs(Entities) do
        for _, l in pairs(Lights) do
            love.graphics.setCanvas(shadowCanvas)
            drawShadow(e, l)
        end

        love.graphics.setCanvas(spriteCanvas)
        local tex, quad = e:spriteFromAngle(math.pi / 2)
        love.graphics.draw(tex, quad,
            worldToScreen(e.position).x,
            worldToScreen(e.position).y,
            0,
            1, 1, tex:getHeight() / 2, tex:getHeight())
    end


    love.graphics.setCanvas(lightCanvas)
    love.graphics.clear(0, 0, 0, 1)

    for _, light in ipairs(Lights) do
        drawLight(light)
    end

    love.graphics.setCanvas()



    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setCanvas()

    applyBlur(shadowCanvas, love.graphics.newCanvas(), 10.0) -- тени мягче
    love.graphics.draw(shadowCanvas)
    love.graphics.draw(spriteCanvas)

    love.graphics.setBlendMode("add", "premultiplied")
    love.graphics.draw(lightCanvas)
    love.graphics.setBlendMode("alpha")

    love.graphics.setColor(1, 1, 1, 1)
end
