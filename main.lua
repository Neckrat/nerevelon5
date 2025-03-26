local Player = {}

local function vec2(x, y)
    return function()
        return { x = x, y = y }
    end
end

local function vec2_length(v)
    return math.sqrt(v().x * v().x + v().y * v().y)
end

local function vec2_add(v1, v2)
    return vec2(v1().x + v2().x, v1().y + v2().y)
end

local function vec2_normalize(v)
    local length = vec2_length(v)
    if (length == 0) then return vec2(0, 0) end
    return vec2(v().x / length, v().y / length)
end

local function vec2_scale(v, factor)
    return vec2(v().x * factor, v().y * factor)
end

local function vec2_to_string(v)
    return "{" .. v().x .. ", " .. v().y .. "}"
end

function Player:init()
    self.position = vec2(0, 0)
    self.velocity = vec2(0, 0)
end

function Player:update(dt)
    local speed = 30
    local friction = 0.05
    local acc = vec2(0, 0)

    if (love.keyboard.isDown('w')) then
        acc = vec2_add(acc, vec2(0, -1))
    end
    if (love.keyboard.isDown('a')) then
        acc = vec2_add(acc, vec2(-1, 0))
    end
    if (love.keyboard.isDown('d')) then
        acc = vec2_add(acc, vec2(1, 0))
    end
    if (love.keyboard.isDown('s')) then
        acc = vec2_add(acc, vec2(0, 1))
    end

    acc = vec2_scale(vec2_normalize(acc), speed * dt)
    self.velocity = vec2_add(self.velocity, acc)
    self.position = vec2_add(self.position, self.velocity)


    self.velocity = vec2_scale(self.velocity, 1 - friction)

    -- print(vec2_length(self.velocity))
end

require "lib.asset_bundle"
require "lib.entity"
require "lib.vec3"


Deer = nil

function love.load()
    AssetBundle:load()
    Deer = Entity('deer')
    Deer.position = Vec3 { 200, 200, 0 }
    Deer.sprite.playing = "walk_e"
end

local lastDir
function love.update(dt)
    local mouse = Vec3 { love.mouse.getPosition() }
    if (mouse) then Deer:lookAt(mouse) end

    if (lastDir and lastDir ~= Deer:namedDirection()) then
        print(Deer:namedDirection())
    end

    lastDir = Deer:namedDirection()
    Deer:update(dt)
end

function love.draw()
    love.graphics.draw(Deer.sprite:getTexture(), Deer.sprite:getQuad(), Deer.position.x, Deer.position.y, Deer.direction,
        4, 4, 32, 32)
end

function love.conf(t)
    t.console = true
end
