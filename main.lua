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

require "animation"
require "asset_bundle"

AssetBundle:load()


function love.load()
    Player:init()
    local sheet_r = AssetBundle.files.sprites.deer.walk_e
    local sheet_l = AssetBundle.files.sprites.deer.walk_w

    animation_r = Animation(sheet_r, 64, 64)
    animation_l = Animation(sheet_l, 64, 64)
end

function love.update(dt)
    Player:update(dt)
    animation_r:update(dt)
    animation_l:update(dt)
end

function love.draw()
    local animation = Player.velocity().x > 0 and animation_r or animation_l
    love.graphics.draw(animation.spriteSheet, animation:getFrame(), Player.position().x, Player.position().y, 0, 4, 4)
end

function love.conf(t)
    t.console = true
end
