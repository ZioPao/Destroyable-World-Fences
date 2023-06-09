if isClient() then return end

require "Map/SGlobalObjectSystem"

DWF_WallSystem = SGlobalObjectSystem:derive("DMF_WallSystem")
DWF_WallSystem.removedCache = nil

function DWF_WallSystem:new()
	local o = SGlobalObjectSystem.new(self, "wall")
	return o
end

function DWF_WallSystem:initSystem()
	SGlobalObjectSystem.initSystem(self)
end

function DWF_WallSystem:newLuaObject(globalObject)
	return DWF_WallGlobalObject:new(self, globalObject)
end

function DWF_WallSystem:isValidIsoObject(isoObject)
	return instanceof(isoObject, "IsoThumpable") and isoObject:getName() == "Trap"
end



function DWF_WallSystem:OnObjectAboutToBeRemoved(isoObject)
	-- This is called *before* self:OnDestroyIsoThumpable() due to
	-- ISBuildingObject.onDestroy() removing the object.
	-- SGlobalObjectSystem.OnObjectAboutToBeRemoved() will remove the STrapGlobalObject
	-- so it should not be accessed after this.


	DWF_WallSystem.removedCache = nil
	if self:isValidIsoObject(isoObject) then
		local luaObject = self:getLuaObjectOnSquare(isoObject:getSquare())
		if luaObject then
			DWF_WallSystem.removedCache = copyTable(luaObject)
			--luaObject:spawnDestroyItems(isoObject:getSquare())
		end
	end
	SGlobalObjectSystem.OnObjectAboutToBeRemoved(self, isoObject)
end

function DWF_WallSystem:OnDestroyIsoThumpable(isoObject, playerObj)
	if DWF_WallSystem.removedCache and isoObject then

		-- TODO should it spawn something?
		--STrapGlobalObject.SpawnDestroyItems(DWF_WallSystem.removedCache.trapType, isoObject:getSquare(), isoObject)
		DWF_WallSystem.removedCache = nil
	end
	SGlobalObjectSystem.OnDestroyIsoThumpable(self, isoObject, playerObj)
end

SGlobalObjectSystem.RegisterSystemClass(DWF_WallSystem)