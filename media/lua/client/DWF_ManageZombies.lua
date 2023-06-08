
local function ManageZombieThump(zombie)
    local thumpTarget = zombie:getThumpTarget()
    if thumpTarget then
        local necessaryZombieAmount = thumpTarget:getModData()['zombieAmount']
        if necessaryZombieAmount == nil then
            if SandboxVars.DWF.EnableDebugMessages then print("Couldn't find zombieAmount") end
            return
        end

        -- For normal objects, we don't care, only our special ones
        if SandboxVars.DWF.EnableDebugMessages then print("ThumpTarget found! Checking near zombies!") end

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
                        thumpingZombiesAmount = thumpingZombiesAmount + 1
                    end
                end


            end
        end

        if SandboxVars.DWF.EnableDebugMessages then
            print("Amount of zombies: " .. tonumber(thumpingZombiesAmount))
            print("Necessary amount: " .. tonumber(necessaryZombieAmount))
        end

        if thumpingZombiesAmount < necessaryZombieAmount then
            zombie:setThumpTarget(nil)
            zombie:setTarget(nil)
        end
    end
    
end

Events.OnZombieUpdate.Add(ManageZombieThump)