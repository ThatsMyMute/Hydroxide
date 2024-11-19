local Closure = {}
local closureCache = {}

function Closure.new(data)
    -- Check if the closure already exists in the cache
    if closureCache[data] then
        return closureCache[data]
    end

    -- Create a new closure object
    local closure = {}
    local name = debug.getinfo(data).name or ''  -- Use `debug.getinfo` for safer info fetching

    closure.Name = (name ~= '' and name) or "Unnamed function"
    closure.Data = data
    closure.Environment = getfenv(data) or {}  -- Fallback to an empty environment if getfenv fails

    -- Initialize upvalues and constants as empty tables
    closure.Upvalues = {}
    closure.Constants = {}

    -- Temporary tables for potential modifications
    closure.TemporaryUpvalues = {}
    closure.TemporaryConstants = {}

    -- Store the new closure in the cache
    closureCache[data] = closure

    return closure
end

return Closure
