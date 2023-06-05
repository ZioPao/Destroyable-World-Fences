
local function TestZombie(zombie)
    -- check if near another zombie!

    local thumpTarget = zombie:getThumpTarget()
    

    if thumpTarget then
        local necessaryZombieAmount = thumpTarget:getModData()['zombieAmount']
        if necessaryZombieAmount == nil then
            print("Couldn't find zombieAmount")
            return
        end      -- For normal objects, we don't care, only our special ones

        print("ThumpTarget found! Checking near zombies!")

        local tempX = zombie:getX()
        local tempY = zombie:getY()
        local z = zombie:getZ()
        local cell = getCell()

        local dist = 4

        local thumpingZombiesAmount = 0
        for x = tempX - dist, tempX + dist do
            for y = tempY - dist, tempY + dist do
                local sq = cell:getGridSquare(x, y, z)
                for i=1,sq:getMovingObjects():size() do
                    local obj = sq:getMovingObjects():get(i - 1)
                    if instanceof(obj, "IsoZombie") then
                        if obj:getThumpTarget() ~= nil then
                            thumpingZombiesAmount = thumpingZombiesAmount + 1

                        end


                        -- if obj:getThumpTarget() == thumpTarget then
                        -- end
                    end
                end


            end
        end

        print("Amount of zombies: " .. tonumber(thumpingZombiesAmount))

        -- TODO check for thumpTarget so we have different stats
        if thumpingZombiesAmount < necessaryZombieAmount then
            zombie:setThumpTarget(nil)
            print("No more thump! Not enough zombies!")
        end
    end
    


    --print("Stop thumping!")
    --zombie:setThumpTarget(nil)
end



Events.OnZombieUpdate.Add(TestZombie)