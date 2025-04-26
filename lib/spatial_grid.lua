require "lib.vec3"
require "lib.math2"
require "lib.entity"
require "math"

local __SpatialGrid = {
    table = {}
}

---- uncomment this for test
-- __Entity = {
--     position = Vec3 {},
--     some_other_shit = "this litteraly other shit"
-- }

-- function Entity(pos)
--     local entity = {
--         position = pos
--     }

--     return setmetatable(entity, {__index = __Entity})
-- end


function SpatialGrid(center, side, cell_size, entities)
    local lu_side = Vec3 {center.x - math.ceil(side/2), center.y - math.ceil(side/2)}
    local rd_side = Vec3 {center.x + math.floor(side/2), center.y + math.floor(side/2)}

    local pos_entities = {}
    for _, entity in ipairs(entities) do
        local pos = tostring(math.step_floor(entity.position.x, cell_size)) .. " " .. tostring(math.step_floor(entity.position.y, cell_size))
        if pos_entities[pos] == nil then
            pos_entities[pos] = {}
        end
        table.insert(pos_entities[pos], entity)
    end

    table = {}
    for x = lu_side.x, rd_side.x, cell_size do
        for y = lu_side.y, rd_side.y, cell_size do
            local pos = tostring(x) .. " " .. tostring(y)
            table[pos] = {position = Vec3 {x, y}, content = pos_entities[pos]}
        end
    end

    return setmetatable({table = table}, {__index = __SpatialGrid})  -- честно не уверен зачем это, но пусть будет
end

function __SpatialGrid:query(position)
    local entities = {}
    for extra_x = -1, 1 do
        for extra_y = -1, 1 do
            local entity_pos = tostring(position.x + extra_x) .. " " .. tostring(position.y + extra_y)
            entities[entity_pos] = self.table[entity_pos].content
        end
    end
    return entities
end

---- uncomment this too for test
-- local table = SpatialGrid(Vec3 {0, 0}, 10, 0.5, {Entity(Vec3 {-1, -1, 0}), Entity(Vec3 {-1.5, -1, 0}), Entity(Vec3 {-2, -1, 0})})

-- local query_table = table:query(Vec3 {-1, -1, 0})

-- for k, v in pairs(query_table) do
--     for i = 1, #v do
--         print(v[i].some_other_shit, v[i].position.y)
--     end
-- end
