require "lib.vec3"
require "lib.math2"
require "lib.entity"
require "math"

local __SpatialGrid = {
    table = {},
    cell_size = 0
}

-- uncomment this for test
-- __Entity = {
--     position = Vec3 {},
--     some_other_shit = "this litteraly other shit"
-- }

-- local function Entity(pos)
--     local entity = {
--         position = pos
--     }

--     return setmetatable(entity, {__index = __Entity})
-- end

local function str_position(x, y)
    return tostring(x) .. " " .. tostring(y)
end

function SpatialGrid(center, side, cell_size, entities)
    local lu_side = Vec3 {center.x - math.ceil(side/2), center.y - math.ceil(side/2)}
    local rd_side = Vec3 {center.x + math.floor(side/2), center.y + math.floor(side/2)}

    local pos_entities = {}  -- таблица, где ключ это позиция объекта, а значение это сам объект
    for _, entity in ipairs(entities) do
        local pos = str_position(math.step_floor(entity.position.x, cell_size), math.step_floor(entity.position.y, cell_size))
        if pos_entities[pos] == nil then
            pos_entities[pos] = {}
        end
        table.insert(pos_entities[pos], entity)
    end

    local table = {}
    for x = lu_side.x, rd_side.x, cell_size do
        for y = lu_side.y, rd_side.y, cell_size do
            local pos = str_position(x, y)
            table[pos] = {position = Vec3 {x, y}, content = pos_entities[pos]}  -- содержимое таблицы table в таблице spatialgrid
        end
    end

    return setmetatable({table = table, cell_size = cell_size}, {__index = __SpatialGrid})  -- честно не уверен зачем это, но пусть будет
end

function __SpatialGrid:query(position)
    local entities = {}
    for extra_x = -1, 1 do
        for extra_y = -1, 1 do
            local entity_pos = str_position(position.x + extra_x*self.cell_size, position.y + extra_y*self.cell_size)
            entities[entity_pos] = self.table[entity_pos].content
        end
    end
    return entities
end

function __SpatialGrid:add(obj)
    local obj_x, obj_y = 0, 0

    if obj.position.x > 0 then
        obj_x = math.step_floor(obj.position.x, self.cell_size)
    else
        obj_x = math.step_ceil(obj.position.x, self.cell_size)
    end

    if obj.position.y > 0 then
        obj_y = math.step_floor(obj.position.y, self.cell_size)
    else
        obj_y = math.step_ceil(obj.position.y, self.cell_size)
    end

    local pos = str_position(obj_x, obj_y)
    table.insert(self.table[pos].content, obj)
end

-- uncomment this too for test
-- local my_table = SpatialGrid(Vec3 {0, 0}, 10, 0.5, {Entity(Vec3 {-1, -1, 0}), Entity(Vec3 {-1.5, -1, 0}), Entity(Vec3 {-2, -1, 0})})

-- my_table:add(Entity(Vec3 {-1.25, -1, 0}))

-- local query_table = my_table:query(Vec3 {-1, -1, 0})

-- for k, v in pairs(query_table) do
--     for i = 1, #v do
--         print(v[i].some_other_shit, v[i].position.x)
--     end
-- end

-- for i, v in ipairs(my_table.table["-1 -1"].content) do
--     print(i, v)
-- end
