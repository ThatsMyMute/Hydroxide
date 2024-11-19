local ModuleScanner = {}
local ModuleScript = import("objects/ModuleScript")

-- Updated requiredMethods without 'getMenv'
local requiredMethods = {
    ["getProtos"] = true,
    ["getConstants"] = true,
    ["getScriptClosure"] = true,
    ["getLoadedModules"] = true
}

local function scan(query)
    local modules = {}
    query = query or ""

    -- Ensure getLoadedModules exists before using it
    if not getLoadedModules then
        warn("getLoadedModules function is required but not available.")
    end

    for _, module in pairs(getLoadedModules()) do
        if module.Name:lower():find(query) then
            -- Ensure ModuleScript.new doesn't rely on getMenv
            local success, moduleScript = pcall(ModuleScript.new, ModuleScript, module)
            if success then
                modules[module] = moduleScript
            else
                warn("Failed to create ModuleScript for module:", module.Name, moduleScript)
            end
        end
    end

    return modules
end

ModuleScanner.Scan = scan
ModuleScanner.RequiredMethods = requiredMethods

return ModuleScanner
