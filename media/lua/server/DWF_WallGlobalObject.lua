if isClient() then return end

DWF_WallGlobalObject = SGlobalObject:derive("DWS_WallGlobalObject")


function DWF_WallGlobalObject:new(luaSystem, globalObject)
    local o = SGlobalObject.new(self, luaSystem, globalObject)
    return o
end