local lessPreciseTimerHack = false
local timerDelay
local delay = 1

local lessPreciseObjectsCheckHack = true

local chanceOfSkip = 80
local skipZombieUpdateHack = true

local function ManageZombieThump(zombie)
    if SandboxVars.DWF.EnableDebugMessages then print("Running ManageZombieThump") end

    if skipZombieUpdateHack then
        if ZombRand(0,100) < chanceOfSkip then return end
    end

    if lessPreciseTimerHack then
        if timerDelay == nil then
            timerDelay = getTimeInMillis()
        end
        if timerDelay > getTimeInMillis() then return end
        timerDelay = getTimeInMillis() + delay

    end


    local thumpTarget = zombie:getThumpTarget()
    if thumpTarget then
        local necessaryZombieAmount = thumpTarget:getModData()['zombieAmount']
        if necessaryZombieAmount == nil then
            if SandboxVars.DWF.EnableDebugMessages then print("Couldn't find zombieAmount, not a compatible thumpable") end
            return
        end

        -- For normal objects, we don't care, only our special ones
        if SandboxVars.DWF.EnableDebugMessages then print("ThumpTarget found! Checking near zombies!") end

        local tempX = zombie:getX()
        local tempY = zombie:getY()
        local z = zombie:getZ()
        local cell = getCell()

        local dist = 3
        local thumpingZombiesAmount = 0
        for x = tempX - dist, tempX + dist do
            for y = tempY - dist, tempY + dist do
                local sq = cell:getGridSquare(x, y, z)
                
                if lessPreciseObjectsCheckHack then
                    -- Performance tweak.. Generally, moving objects would be zombies, vehicles, characters, and whatever.. Less precise, but should be a lot faster
                    thumpingZombiesAmount = thumpingZombiesAmount + sq:getMovingObjects():size()
                else
                    for i=1,sq:getMovingObjects():size() do
                        local obj = sq:getMovingObjects():get(i - 1)
                        if instanceof(obj, "IsoZombie") then
                            thumpingZombiesAmount = thumpingZombiesAmount + 1
                        end
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
            zombie:setUseless(true)


            timer:Simple(ZombRand(1,3), function()
                zombie:setUseless(false)
            end)

        end
        if SandboxVars.DWF.EnableDebugMessages then print(thumpTarget:getThumpCondition()) end
    end
end

Events.OnZombieUpdate.Add(ManageZombieThump)