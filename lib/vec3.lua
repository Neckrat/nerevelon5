__Vec3 = {
    x = 0,
    y = 0,
    z = 0,
}

function Vec3(vec)
    return setmetatable({
        x = vec[1] or 0,
        y = vec[2] or 0,
        z = vec[3] or 0,
    }, {
        __index = __Vec3,
        __tostring = __Vec3.__tostring,
        __add = __Vec3.add,
        __mul = __Vec3.scale,
        __unm = function(self)
            return __Vec3.scale(self, -1)
        end,
        __sub = function(self, other)
            return self + -other
        end,
        __eq = function(self, other)
            return
                self.x == other.x
                and self.y == other.y
                and self.z == other.z
        end,
    })
end

function __Vec3:add(other)
    return Vec3 { self.x + other.x, self.y + other.y, self.z + other.z }
end

function __Vec3:scale(factor)
    return Vec3 { self.x * factor, self.y * factor, self.z * factor }
end

function __Vec3:length()
    return math.sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
end

function __Vec3:normalize()
    local length = self:length()
    if length == 0 then return nil end
    return Vec3 {
        self.x / length,
        self.y / length,
        self.z / length
    }
end

function __Vec3:direction()
    return math.atan2(self.y, self.x)
end

function __Vec3:dot(other)
    return self.x * other.x + self.y * other.y + self.z * other.z
end

function __Vec3:__tostring()
    return "Vec3{" .. self.x .. ", " .. self.y .. ", " .. self.z .. "}"
end

function __Vec3:angle_to(other)
    return (other - self):direction()
end
