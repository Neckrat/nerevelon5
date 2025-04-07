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
    local speed = 10
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


Fox = nil

function love.load()
    AssetBundle:load()
    Player:init();

    Fox = Entity('fox')
    Fox.position = Vec3 { 200, 200, 0 }
    Fox.sprite.playing = "walk_ne"
end

local lastDir
function love.update(dt)
    Fox.rotation = Fox.velocity:direction()
    if (lastDir and lastDir ~= Fox:namedDirection()) then
        local t = Fox.sprite[Fox.sprite.playing].currentTime
        Fox.sprite.playing = "walk_" .. Fox:namedDirection()
        Fox.sprite[Fox.sprite.playing].currentTime = t
    end

    lastDir = Fox:namedDirection()
    Player:update(dt)
    Fox.velocity = Vec3 { Player.velocity().x, Player.velocity().y, 0 }

    if Fox.velocity:length() < 0.1 then
        Fox.sprite[Fox.sprite.playing].currentTime = 0
    end
    Fox:update(dt)
end

function love.draw()
    love.graphics.draw(Fox.sprite:getTexture(), Fox.sprite:getQuad(), Fox.position.x, Fox.position.y, Fox.direction,
        2, 2, 48, 48)
end

function love.conf(t)
    t.console = true
end
