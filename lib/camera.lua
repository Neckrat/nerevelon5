Camera = {
    target = Vec3 {},
    position = Vec3 {},
    lerp_speed = 5.0
}

function Camera:update(dt)
    if not self.target then return end

    -- Плавное движение камеры к цели
    local to_target = self.target - self.position
    self.position = self.position + to_target:scale(dt * self.lerp_speed)
end
