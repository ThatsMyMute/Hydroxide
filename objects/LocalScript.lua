local LocalScript = {}

function LocalScript.new(instance)
    local localScript = {}
    local closure = getScriptClosure(instance)

    localScript.Instance = instance
    localScript.Environment = getsenv(instance)
    localScript.Constants = getConstants(closure)
    localScript.Protos = getProtos(closure)

    return localScript
end

return LocalScript
