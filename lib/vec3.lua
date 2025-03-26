require "lib.option"

__Vec3 = {
    _x = 0,
    _y = 0,
    _z = 0,
}

function Vec3(vec)
    return setmetatable({
        _x = vec[1] or 0,
        _y = vec[2] or 0,
        _z = vec[3] or 0,
    }, {
        __index = __Vec3,
        __tostring = __Vec3.__tostring,
        __add = __Vec3.add,
        __mul = __Vec3.scale,
        __unm = function(self)
            return __Vec3.scale(self, -1)
        end,
        __eq = function(self, other)
            return
                self._x == other._x
                and self._y == other._y
                and self._z == other._z
        end,
    })
end

function __Vec3:add(other)
    Vec3 { self._x + other._x, self._y + other._y, self._z + other._z }
end

function __Vec3:scale(factor)
    return Vec3 { self._x * factor, self._y * factor, self._z * factor }
end

function __Vec3:length()
    return math.sqrt(self._x ^ 2 + self._y ^ 2 + self._z ^ 2)
end

function __Vec3:normalize()
    local length = self:length()
    if not length then return None end
    return Some(Vec3 {
        self._x / length,
        self._y / length,
        self._z / length
    })
end

function __Vec3:dot(other)
    return self._x * other._x + self._y * other._y + self._z * other._z
end

function __Vec3:__tostring()
    return "Vec3{" .. self._x .. ", " .. self._y .. ", " .. self._z .. "}"
end
