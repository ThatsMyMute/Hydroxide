local UpvalueScanner = {}
local Closure = import("objects/Closure")
local Upvalue = import("objects/Upvalue")

-- Improved UpvalueScanner Scan
local function scan(query, deepSearch)
    local upvalues = {}
    print("[UpvalueScanner] Starting scan for query:", query)

    for _i, closure in pairs(getGc()) do
        if type(closure) == "function" and not isXClosure(closure) and not upvalues[closure] then
            -- Let's get the upvalues for this closure
            local upvalueList = getUpvalues(closure)
            if not upvalueList then
                print("[UpvalueScanner] Failed to get upvalues for closure:", closure)
                continue
            end

            for index, value in pairs(upvalueList) do
                local valueType = type(value)

                -- Check if the value matches the query
                if valueType ~= "table" and compareUpvalue(query, value) then
                    if not upvalues[closure] then
                        local newClosure = Closure.new(closure)
                        newClosure.Upvalues[index] = Upvalue.new(newClosure, index, value)
                        upvalues[closure] = newClosure
                    else
                        upvalues[closure].Upvalues[index] = Upvalue.new(upvalues[closure], index, value)
                    end
                    print("[UpvalueScanner] Match found in closure:", closure, "at index:", index)
                elseif deepSearch and valueType == "table" then
                    -- Deep searching into table values
                    for i, v in pairs(value) do
                        if (i ~= value and v ~= value) and (compareUpvalue(query, i, true) or compareUpvalue(query, v)) then
                            if not upvalues[closure] then
                                local newClosure = Closure.new(closure)
                                upvalues[closure] = newClosure
                            end

                            if not upvalues[closure].Upvalues[index] then
                                local newUpvalue = Upvalue.new(upvalues[closure], index, value)
                                newUpvalue.Scanned = {}
                                upvalues[closure].Upvalues[index] = newUpvalue
                            end

                            upvalues[closure].Upvalues[index].Scanned[i] = v
                            print("[UpvalueScanner] Deep search match found for closure:", closure, "in table index:", i)
                        end
                    end
                end
            end
        end
    end

    return upvalues
end

UpvalueScanner.Scan = scan

return UpvalueScanner
