__LightSource = {
    position = Vec3 {},
    power = 0,       -- in meters
    color = Vec3 {}, --r, g, b
    seed = 0,        -- random float to make every light unique,
    shader = nil,
    mask = nil
}

function LightSource(position, power, color, shader, mask)
    local l = {
        position = position,
        power = power,
        color = color,
        seed = math.random() * math.pi * 2,
        shader = shader or AssetBundle.files.shaders.light,
        mask = mask or AssetBundle.files.masks.circle

    }
    return setmetatable(l, { __index = __LightSource })
end
