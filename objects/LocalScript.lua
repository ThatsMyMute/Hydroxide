local LocalScript = {}

function LocalScript.new(instance)
    local localScript = {}
    local closure = getscriptclosure(instance)

    localScript.Instance = instance
    localScript.Environment = getsenv(instance)
    localScript.Constants = getconstants(closure)
    localScript.Protos = getprotos(closure)

    return localScript
end

return LocalScript
