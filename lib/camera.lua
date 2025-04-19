Camera = {
    target = Vec3 {},
    position = Vec3 {},
    lerp_speed = 5.0,
    max_offset = 1,         -- на сколько метров камера может отдалиться от целевой позиции
    max_offset_distance = 5 -- на сколько метров надо отвести мышь для максимального отдаления камеры
}

function Camera:update(dt)
    if not self.target then return end

    local mx, my = love.mouse.getPosition()
    local screen_center = Vec3 { love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0 }
    local mouse_offset = Vec3 { mx, my, 0 } - screen_center
    local offset_distance = mouse_offset:length() / PIXELS_PER_METER
    if offset_distance > self.max_offset_distance then offset_distance = self.max_offset_distance end

    local adjusted_target = self.target +
    mouse_offset:normalize() * (self.max_offset * offset_distance / self.max_offset_distance)

    local to_target = adjusted_target - self.position
    self.position = self.position + to_target * (dt * self.lerp_speed)
end
