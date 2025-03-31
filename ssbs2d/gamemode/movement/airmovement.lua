AddCSLuaFile()

hook.Add("StartCommand", "AerialDrift", function(ply, cmd)

    if(ply:OnGround() or ply:IsInHitstun()) then return end --this function only concerns horizontal movement in the air

    local vec = ply:GetVelocity()
    local horSpd = vec.x 

    local fwdMove = cmd:GetForwardMove()

    local maxAir = ply:GetMaxAirSpeed()
    local airAcc = ply:GetAirAccel()

    local angle = ply:EyeAngles().y

    local newSpeed = Vector(0,0,0)

    if(fwdMove != 0) then 
        if(angle == 0) then 
            if(horSpd < maxAir) then
                newSpeed.x = airAcc
            end
        else  
            if(-maxAir < horSpd) then
                newSpeed.x = -airAcc 
            end 
        end
    end 

    ply:SetVelocity(newSpeed)
            
end)

local PLYR = FindMetaTable("Player")

function PLYR:IsFastFalling()
    return self.FastFalling 
end 

function PLYR:SetFastFalling(value)
    self.FastFalling = value --should be an integer
end 

hook.Add("PlayerSpawn", "InitializeFastFalling", function(ply)
    ply.FastFalling = false
end)

vector_zero = Vector(0,0,0)

hook.Add("StartCommand", "FastFalling", function(ply, cmd)
    if(ply:IsOnGround() or ply:IsInHitstun()) then return end 

    if(cmd:KeyDown(IN_BACK) and ply:IsFastFalling() == false) then
        local velocity = ply:GetVelocity().z
        if(velocity > 0) then return end --only allow fast falling after player is falling down and not vertically rising 
        ply:SetFastFalling(true) 
        local vec = Vector(0,0,-velocity)
        vec.z = vec.z - 600
        ply:SetVelocity(vec)
        print("player is fastfalling!")
    end
end)

hook.Add("Think", "RemoveFastFalling", function()
    for k,v in ipairs(player.GetAll()) do 
        if(v:IsOnGround()) then 
            v:SetFastFalling(false)
        end 

        -- if(v:IsAdmin()) then 
        --     print(v:GetPos())
        -- end
    end 
end)