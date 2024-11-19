local ModuleScript = {}

function ModuleScript.new(instance)
    local moduleScript = {}
    local closure = getscriptclosure(instance)

    moduleScript.Instance = instance
    moduleScript.Constants = getconstants(closure)
    moduleScript.Protos = getprotos(closure)
    --moduleScript.ReturnValue = require(instance) // causes detection

    return moduleScript
end

return ModuleScript
