--
-- Created by IntelliJ IDEA.
-- User: RJ
-- Date: 30/04/14
-- Time: 09:57
-- To change this template use File | Settings | File Templates.
--

if isClient() then return end

require "Map/SGlobalObjectSystem"

DMF_WallSystem = SGlobalObjectSystem:derive("DMF_WallSystem")
DMF_WallSystem.removedCache = nil;

function DMF_WallSystem:new()
	local o = SGlobalObjectSystem.new(self, "wall")
	return o
end

function DMF_WallSystem:initSystem()
	SGlobalObjectSystem.initSystem(self)

	-- Specify GlobalObjectSystem fields that should be saved.
	self.system:setModDataKeys({})
	
	-- Specify GlobalObject fields that should be saved.
	self.system:setObjectModDataKeys({
		'trapType', 'trapBait', 'trapBaitDay', 'lastUpdate', 'baitAmountMulti', 'animal', 'animalHour',
		'openSprite', 'closedSprite', 'zone', 'player', 'trappingSkill', 'destroyed'})

	self:convertOldModData()
end

function DMF_WallSystem:convertOldModData()
	-- If the gos_xxx.bin file existed, don't touch GameTime modData in case mods are using it.
	if self.system:loadedWorldVersion() ~= -1 then return end
	
	local modData = GameTime:getInstance():getModData()
	if not modData.trapping or not modData.trapping.traps then return end
	self:noise('converting old-style GameTime modData')
	for _,trap in pairs(modData.trapping.traps) do
		local globalObject = self.system:newObject(trap.x, trap.y, trap.z)
		-- FIXME: IsoObject:getModData().animal is a string (the type of animal)
		--        but STrapGlobalObject.animal is a table.
		globalObject:getModData().animal = {}
		for k,v in pairs(trap) do
			if k == "animal" then
				for _,animal in ipairs(Animals) do
					if animal.type == v then
						globalObject:getModData().animal = animal
						break
					end
				end
			else
				globalObject:getModData()[k] = v
			end
		end
	end
	modData.trapping.traps = nil
	for k,v in pairs(modData.trapping) do
		self[k] = v
	end
	modData.trapping = nil
	self:noise('converted '..self.system:getObjectCount()..' traps')
end

function DMF_WallSystem:newLuaObject(globalObject)
	return STrapGlobalObject:new(self, globalObject)
end

function DMF_WallSystem:isValidIsoObject(isoObject)
	return instanceof(isoObject, "IsoThumpable") and isoObject:getName() == "Trap"
end

function DMF_WallSystem:OnClientCommand(command, playerObj, args)
	STrapSystemCommands[command](playerObj, args)
end


















-- Change age of bait each day
DMF_WallSystem.EveryDays = function()
	for i=1,STrapSystem.instance.system:getObjectCount() do
		local luaObject = STrapSystem.instance.system:getObjectByIndex(i-1):getModData()
		if luaObject.bait then
			luaObject.lastUpdate = getGameTime():getWorldAgeHours() / 24;
			luaObject.trapBaitDay = luaObject.trapBaitDay + 1;
			local isoObject = luaObject:getIsoObject()
			luaObject:toObject(isoObject, true)
		end
	end
end

-- every hour, calcul the chance of getting something
function DMF_WallSystem.checkTrap()
	for i=1,DMF_WallSystem.instance.system:getObjectCount() do
		local luaObject = DMF_WallSystem.instance.system:getObjectByIndex(i-1):getModData()
		local square = getWorld():getCell():getGridSquare(luaObject.x, luaObject.y, luaObject.z)
		luaObject:calculTrap(square)
	end
end

function DMF_WallSystem.isValidModData(modData)
	return modData.trapType ~= nil
end

function DMF_WallSystem.addSound()
	for i=1,STrapSystem.instance.system:getObjectCount() do
		local vB = STrapSystem.instance.system:getObjectByIndex(i-1):getModData()
		local square = getWorld():getCell():getGridSquare(vB.x, vB.y, vB.z);
		vB:addSound(square);
	end
end

function DMF_WallSystem:OnObjectAboutToBeRemoved(isoObject)
	-- This is called *before* self:OnDestroyIsoThumpable() due to
	-- ISBuildingObject.onDestroy() removing the object.
	-- SGlobalObjectSystem.OnObjectAboutToBeRemoved() will remove the STrapGlobalObject
	-- so it should not be accessed after this.
	DMF_WallSystem.removedCache = nil;
	if self:isValidIsoObject(isoObject) then
		local luaObject = self:getLuaObjectOnSquare(isoObject:getSquare())
		if luaObject then
			DMF_WallSystem.removedCache = copyTable(luaObject);
			--luaObject:spawnDestroyItems(isoObject:getSquare());
		end
	end
	SGlobalObjectSystem.OnObjectAboutToBeRemoved(self, isoObject)
end

function DMF_WallSystem:OnDestroyIsoThumpable(isoObject, playerObj)
	if DMF_WallSystem.removedCache and isoObject then
		STrapGlobalObject.SpawnDestroyItems(DMF_WallSystem.removedCache.trapType, isoObject:getSquare(), isoObject)
		DMF_WallSystem.removedCache = nil;
	end
	SGlobalObjectSystem.OnDestroyIsoThumpable(self, isoObject, playerObj)
end

SGlobalObjectSystem.RegisterSystemClass(DMF_WallSystem)

-- Events.EveryDays.Add(DMF_WallSystem.EveryDays);
-- Events.EveryHours.Add(DMF_WallSystem.checkTrap);
-- Events.EveryTenMinutes.Add(DMF_WallSystem.addSound);
