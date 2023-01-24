if isClient() then return end


DMF_Walls = {}


local fancy_wooden_wall = {}
fancy_wooden_wall.start_north = "fencing_01_08"        -- NorthWall
fancy_wooden_wall.north = "fencing_01_09"        -- NorthWall
fancy_wooden_wall.west =  "fencing_01_10"        -- WestWall
fancy_wooden_wall.end_west = "fencing_01_11"       -- WestWall
fancy_wooden_wall.north_west_corner = "fencing_01_12"        -- NorthWestCorner
fancy_wooden_wall.south_east_corner =  "fencing_01_13"        -- SouthEastCorner
fancy_wooden_wall.is_transparent = false

table.insert(DMF_Walls, fancy_wooden_wall)


local fancy_metal_wall = {}
fancy_metal_wall.start_north = "fencing_01_64"        -- NorthWall
fancy_metal_wall.north = "fencing_01_65"        -- NorthWall
fancy_metal_wall.west =  "fencing_01_66"        -- WestWall
fancy_metal_wall.end_west = "fencing_01_67"       -- WestWall
fancy_metal_wall.north_west_corner = "fencing_01_68"        -- NorthWestCorner
fancy_metal_wall.is_transparent = true
table.insert(DMF_Walls, fancy_metal_wall)


















local function GetWallSprites(wall_def)
	local sprites = {}
	table.insert(sprites, wall_def.sprite)

	if wall_def.start_north then table.insert(sprites, wall_def.start_north) end
	if wall_def.north then table.insert(sprites, wall_def.north) end
    if wall_def.west then table.insert(sprites, wall_def.west) end
    if wall_def.end_west then table.insert(sprites, wall_def.end_west) end
    if wall_def.north_west_corner then table.insert(sprites, wall_def.north_west_corner) end
    if wall_def.south_east_corner then table.insert(sprites, wall_def.south_east_corner) end

	return sprites
end

local function removeExistingLuaObject(square)
	local luaObject = DMF_WallSystem.instance:getLuaObjectOnSquare(square)
	if luaObject then
		print("Lua Object found")
        --noise('removing luaObject at same location as newly-loaded isoObject')
		DMF_WallSystem.instance:removeLuaObject(luaObject)
	end
end

-- Returns def and if is north faced
local function GetWallDefFromSprite(spriteName)
	if not spriteName then return nil end
	for _, wall_def in pairs(DMF_Walls) do
		if wall_def.west == spriteName or 
			wall_def.end_west == spriteName or 
			wall_def.south_east_corner == spriteName then
			return wall_def, false
		end
		if wall_def.north == spriteName or
			wall_def.north_west_corner == spriteName or
			wall_def.start_north == spriteName then
			return wall_def, true
		end
	end
	return nil,false
end


local function CreateWall(sq, spriteName, north)
	local modData = {}
	
	local cell = getWorld():getCell()
	--local north = false
	local javaObject = IsoThumpable.new(cell, sq, spriteName, north, modData)

	javaObject:setCanPassThrough(false)
	javaObject:setCanBarricade(false)
	javaObject:setIsContainer(false)
	javaObject:setIsDoor(false)
	javaObject:setIsDoorFrame(false)
	javaObject:setCrossSpeed(1.0)
	javaObject:setBlockAllTheSquare(false)		-- Really important
	javaObject:setName("Wall")
	javaObject:setIsDismantable(true)
	javaObject:setCanBePlastered(false)

	-- FIXME if is hoppable it'll break thupmable... and it doesnt overwrite anyway so who cares
	javaObject:setIsHoppable(false)			-- TODO Make exception for barbed wire fences
	javaObject:setIsThumpable(true)
	javaObject:setModData(copyTable(modData))

	-- TODO set different healths for different fences
	-- if spritename == ....

	javaObject:setThumpDmg(1)
	javaObject:setMaxHealth(100000)			-- Stupidly high health, since it wouldn't make a lot of sense otherwise
	javaObject:setHealth(100000)			-- TODO make it a bit random
	javaObject:setBreakSound("BreakObject")
	javaObject:setSpecialTooltip(false)
	
    triggerEvent("OnObjectAdded", javaObject)

	return javaObject
end


local function NewWall(isoObject)
	local sprite_name = isoObject:getSprite():getName()

    local wall_def, north = GetWallDefFromSprite(sprite_name)


	--local trapDef,north = GetWallDefFromSprite(spriteName)
	if not wall_def then return end

	local sq = isoObject:getSquare()
	removeExistingLuaObject(sq)
	
	local javaObject = CreateWall(sq, isoObject:getSprite():getName(), north)
	local index = isoObject:getObjectIndex()
	sq:transmitRemoveItemFromSquare(isoObject)
	sq:AddSpecialObject(javaObject, index)
	
	--initObjectModData(javaObject, wall_def, north)

	javaObject:transmitCompleteItemToClients()
	return javaObject
end
local PRIORITY = 1

local function LoadWall(isoObject)
	local spriteName = isoObject:getSprite():getName()
	local wall_def = GetWallDefFromSprite(spriteName)
	if not wall_def then return end
	if not instanceof(isoObject, "IsoThumpable") then
		isoObject = NewWall(isoObject)
	end
	DMF_WallSystem.instance:loadIsoObject(isoObject)
end




for _, wall_def in pairs(DMF_Walls) do
	local sprites = GetWallSprites(wall_def)


	MapObjects.OnNewWithSprite(sprites, NewWall, PRIORITY)
	MapObjects.OnLoadWithSprite(sprites, LoadWall, PRIORITY)
end
--ObjectTypes
-- "normal", "jukebox", "wall", "stairsTW", "stairsTN", "stairsMW", "stairsMN", "stairsBW", "stairsBN", "UNUSED9", "UNUSED10",
-- "doorW", "doorN", "lightswitch", "radio", "curtainN", "curtainS", "curtainW", "curtainE", "doorFrW", "doorFrN", "tree",
-- "windowFN", "windowFW", "UNUSED24", "WestRoofB", "WestRoofM", "WestRoofT", "isMoveAbleObject",

--FlagTypes
--  "collideW", "collideN", "solidfloor", "noStart", "windowW", "windowN", "hidewalls", "exterior", "NoWallLighting",
-- "doorW", "doorN", "transparentW", "transparentN", "WallOverlay", "FloorOverlay", "vegitation", "burning", "burntOut",
-- "unflamable", "cutW", "cutN", "tableN", "tableNW", "tableW", "tableSW", "tableS", "tableSE", "tableE", "tableNE",
--  "halfheight", "HasRainSplashes", "HasRaindrop", "solid", "trans", "pushable", "solidtrans", "invisible", "floorS",
-- "floorE", "shelfS", "shelfE", "alwaysDraw", "ontable", "transparentFloor", "climbSheetW", "climbSheetN", "climbSheetTopN",
-- "climbSheetTopW", "attachtostairs", "sheetCurtains", "waterPiped", "HoppableN", "HoppableW", "bed", "blueprint",
-- "canPathW", "canPathN", "blocksight", "climbSheetE", "climbSheetS", "climbSheetTopE", "climbSheetTopS", "makeWindowInvincible",
-- "water", "canBeCut", "canBeRemoved", "taintedWater", "smoke", "attachedN", "attachedS", "attachedE", "attachedW",
-- "attachedFloor", "attachedSurface", "attachedCeiling", "attachedNW", "ForceAmbient", "WallSE", "WindowN", "WindowW",
-- "FloorHeightOneThird", "FloorHeightTwoThirds", "CantClimb", "diamondFloor", "attachedSE", "TallHoppableW", "WallWTrans",
-- "TallHoppableN", "WallNTrans", "container", "DoorWallW", "DoorWallN", "WallW", "WallN", "WallNW", "SpearOnlyAttackThrough", "forceRender"


local specialOverrideExceptions = {"IsoCurtain","IsoDoor","IsoWindow","IsoBarricade","IsoLightSwitch"}
---Vanilla has a getFloor but it causes layering issues if there's objects over the floor - like walls
---@param isoGridSquare IsoGridSquare
local function ifFlagTypeGetObject(isoGridSquare, isoFlagType)
    local isoObjects = isoGridSquare:getObjects()

    local objWithFlagFound
    local lastSpriteObject

    if isoFlagType == IsoFlagType.solidfloor and isoGridSquare:getProperties():Is("BlocksPlacement") then return end

    for i=0, isoObjects:size()-1 do
        ---@type IsoObject
        local isoObj = isoObjects:get(i)
        if isoObj then
            local isoObjSprite = isoObj:getSprite()
            local isoObjSpriteName = isoObjSprite:getName()
            if isoObjSprite and isoObjSpriteName then
                if isoObj:getType()==IsoObjectType.wall and string.find(isoObjSpriteName, "roofs") then
                else
                    if isoObjSprite:getProperties():Is(isoFlagType) then
                        objWithFlagFound = true
                        lastSpriteObject = i
                    end

                    if objWithFlagFound then
                        if (not isoGridSquare:getProperties():Is("IsMoveAble")) then
                            lastSpriteObject = i
                        end
                        for _,type in pairs(specialOverrideExceptions) do
                            if instanceof(isoObj, type) then
                                lastSpriteObject = i
                            end
                        end
                    end
                end
            end
        end
    end
    if objWithFlagFound and lastSpriteObject then
        return isoObjects:get(lastSpriteObject)
    end
end


