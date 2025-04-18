__LightSource = {
    position = Vec3 {},
    power = 0,      -- in meters
    color = Vec3 {} --r, g, b
}

function LightSource(position, power, color)
    local l = {
        position = position,
        power = power,
        color = color
    }
    return setmetatable(l, { __index = __LightSource })
end
