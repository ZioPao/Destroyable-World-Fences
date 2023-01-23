function DMF_MakeDestroyable()

    local player = getPlayer()

    local square = player:getSquare()
    if square then
        for i=1,square:getObjects():size() do
            local obj = square:getObjects():get(i-1)
			local sprite = obj:getSprite()
            if BrokenFences.getInstance():isBreakableObject(obj) then
				--square:transmitRemoveItemFromSquare(obj)
				obj:setMovedThumpable(true)

			
				print(obj:getThumpCondition())

				
				print(sprite:getName())
				--print("Found fence!!")
				--local test = obj:getModData()
				--print(test)
				--DMF_CreateNewWall(player, square, sprite)
            end
        end
    end


end


function DMF_CreateNewWall(player, square, sprite)
	local x = square:getX()
	local y = square:getY()


	local wall = ISWoodenWall:new("carpentry_02_80", "carpentry_02_81", nil);
    wall.player = player
	wall.noNeedHammer = true
	wall.canBarricade = false
	wall.health = 100
	wall.name = "Log Wall"
	wall.craftingBank = "BuildingGeneric"
	wall.completionSound = "BuildWoodenStructureLarge"
	print("Creating new wall")
	wall.skipBuildAction = true

	wall:create(x, y, 0, true, sprite)

    --getCell():setDrag(wall, player)
end

function DMF_DestroyObject(player, fence)

	local playerObj = player
	local props = fence:getProperties()
	local dir = nil
	if props:Is(IsoFlagType.collideN) and props:Is(IsoFlagType.collideW) then
		dir = (playerObj:getY() >= fence:getY()) and IsoDirections.N or IsoDirections.S
	elseif props:Is(IsoFlagType.collideN) then
		dir = (playerObj:getY() >= fence:getY()) and IsoDirections.N or IsoDirections.S
	else
		dir = (playerObj:getX() >= fence:getX()) and IsoDirections.W or IsoDirections.E
	end
	fence:destroyFence(dir)

end


Events.OnTick.Add(DMF_MakeDestroyable)