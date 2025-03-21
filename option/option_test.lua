--- Tests
local none = None
local none1 = None
local some = Some(42)
local some1 = Some('foo')

assert(none:is_none())
assert(none1 == none)

assert(some:is_some())
assert(some ~= some1)

assert(some:unwrap(43) == 42)
assert(some:unwrap() == 42)
assert(none:unwrap(43) == 43)

assert(some:try(
    function(x)
        return x + 1
    end
) == 43)
assert(none:try(
    function(x)
        return x + 1
    end
) == None)

assert(tostring(some) == "Some(42)")
assert(tostring(none) == "None")

--- Usage
local function safe_div(a, b)
    if (b == 0) then return None end
    return Some(a / b)
end

local res = safe_div(10, 2)
assert(res:is_some())

local res1 = safe_div(10, 0)
assert(res1:is_none())

local chain = safe_div(10, 2):try(
    function(x)
        return safe_div(x, 5)
    end
)
assert(chain:unwrap(0) == 1)

local chain1 = safe_div(10, 0):try(
    function(x)
        return safe_div(x, 5)
    end
)
assert(chain1:unwrap(0) == 0)
