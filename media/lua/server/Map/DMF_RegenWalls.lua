if isClient() then return end

local function GetWallSprites(wall_def)
	local sprites = {}
	table.insert(sprites, wall_def.sprite)

	if wall_def.sprite_north then table.insert(sprites, wall_def.sprite_north) end
	if wall_def.sprite_corner then table.insert(sprites, wall_def.sprite_corner) end
	return sprites
end

-- Returns def and if is north faced
local function GetWallDefFromSprite(spriteName)
	if not spriteName then return nil end
	for _, wall_def in pairs(DMF_Walls) do
		if wall_def.sprite == spriteName then
			return wall_def, false
		end
		if wall_def.sprite_north == spriteName then
			return wall_def, true
		end
	end
	return nil,false
end

local function NewWall(isoObject)
	local spriteName = isoObject:getSprite():getName()
	local trapDef,north = GetWallDefFromSprite(spriteName)
	if not trapDef then return end

	local sq = isoObject:getSquare()
	removeExistingLuaObject(sq)
	
	local javaObject = CreateTrap(sq, isoObject:getSprite():getName())
	local index = isoObject:getObjectIndex()
	sq:transmitRemoveItemFromSquare(isoObject)
	sq:AddSpecialObject(javaObject, index)
	
	initObjectModData(javaObject, trapDef, north)

	javaObject:transmitCompleteItemToClients()
	return javaObject
end
local PRIORITY = 5

for _, wall_def in pairs(DMF_Walls) do
	--local sprites = GetWallSprites(wall_def)


	--MapObjects.OnNewWithSprite(sprites, NewWall, PRIORITY)
	--MapObjects.OnLoadWithSprite(sprites, LoadTrap, PRIORITY)
end



