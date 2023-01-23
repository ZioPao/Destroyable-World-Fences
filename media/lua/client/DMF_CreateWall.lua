


--ISGeneratingWall = ISBuildingObject:derive("ISGeneratingWall")

-- function ISGeneratingWall:CreateWall(square)

-- 	local x = square:getX()
-- 	local y = square:getY()

--     wall.player = self.player
-- 	wall.noNeedHammer = true
-- 	wall.canBarricade = false
-- 	wall.name = "Log Wall"
-- 	wall.craftingBank = "BuildingGeneric"
-- 	wall.completionSound = "BuildWoodenStructureLarge"
-- 	print("Creating new wall")


-- end

-- function ISGeneratingWall:new(sprite, northSprite, character)
-- 	local o = {}
-- 	setmetatable(o, self)
-- 	self.__index = self
-- 	o:init()
-- 	o:setSprite(sprite)
-- 	o:setNorthSprite(northSprite)
-- 	o.character = character
-- 	o.player = character:getPlayerNum()
-- 	o.noNeedHammer = true
-- 	o.skipBuildAction = true
-- 	return o
-- end



-- function ISGeneratingWall:create(x, y, z, north, sprite)


--     local wall = ISWoodenWall:new("carpentry_02_80", "carpentry_02_81", nil)

--     local square = getCell():getGridSquare(x, y, z)
--     local objs = square:getObjects()

--     local tileAlreadyOnSquare = false
--     for i=0, objs:size() - 1 do
--         if objs:get(i):getSprite() ~= nil and objs:get(i):getSprite():getName() == sprite then
--             tileAlreadyOnSquare = true
--         end
--     end
--     if not tileAlreadyOnSquare then
--         local props = ISMoveableSpriteProps.new(IsoObject.new(square, sprite):getSprite())
--         props.rawWeight = 10
--         props:placeMoveableInternal(square, InventoryItemFactory.CreateItem("Base.Plank"), sprite)
--     end
-- end

-- function ISGeneratingWall:render(x, y, z, square)
--     ISBuildingObject.render(self, x, y, z, square)
-- end

-- function ISGeneratingWall:new(sprite, northSprite, character)
--     local o = {}
--     setmetatable(o, self)
--     self.__index = self
--     o:init()
--     o:setSprite(sprite)
--     o:setNorthSprite(northSprite)
--     o.character = character
--     o.player = character:getPlayerNum()
--     o.isTileCursor = true
--     o.spriteName = sprite
--     o.noNeedHammer = true
--     o.skipBuildAction = true
--     o.skipWalk2 = true
--     o.canBeAlwaysPlaced = true
--     return o
-- end

