__Vec3 = {
    x = 0,
    y = 0,
    z = 0
}

function Vec3(vec)
    return setmetatable({
        x = vec[1] or 0,
        y = vec[2] or 0,
        z = vec[3] or 0,
    }, {__index = __Vec3,
        })
end

function __Vec3:add(v1, v2)
    return Vec3 { v1.x + v2.x, v1.y + v2.y, v1.z + v2.z }
end

function __Vec3:length()
   return math.sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
end

function __Vec3:to_string()
    return "{".. self.x .. ", " .. self.y .. ", " .. self.z .. "}"
end

local v = Vec3 {1, 2, 3}

print(v:to_string())