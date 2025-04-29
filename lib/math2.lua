math.named_direction = function(rotation)
    local get_direction_index = function(rotation)
        local pi = math.pi
        rotation = rotation % (2 * pi)
        local shifted = (rotation + pi / 8) % (2 * pi)
        local index = math.floor(shifted / (pi / 4)) + 1
        return index
    end

    local lookup = {
        "s",
        "se",
        "e",
        "ne",
        "n",
        "nw",
        "w",
        "sw",
    }

    return lookup[get_direction_index(rotation)]
end

-- Округляет вниз n до самого большого k * step, большего или равного n
math.step_floor = function(n, step)
    return math.floor(n / step) * step
end

math.step_ceil = function(n, step)
    return math.ceil(n / step) * step
end