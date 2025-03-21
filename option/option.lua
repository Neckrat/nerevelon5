Option = {
    some = nil,
    none = nil,

    __tostring = function()
        return "Option"
    end
}
None = setmetatable({}, {
    __index = Option,
    __tostring = function()
        return "None"
    end
})

function Some(value)
    local opt = {
        some = function()
            return value
        end
    }
    setmetatable(opt, {
        __index = Option,
        __tostring = function()
            return "Some(" .. value .. ")"
        end
    })

    return opt
end

function Option:is_none()
    return self.some == nil
end

function Option:is_some()
    return self.some ~= nil
end

function Option:unwrap(default)
    if self.some then return self.some() end
    return default
end

function Option:try(fn)
    if self:is_none() then return self end
    return fn(self.some())
end
