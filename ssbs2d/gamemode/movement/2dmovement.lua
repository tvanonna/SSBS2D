AddCSLuaFile()

hook.Add("Move", "No3DMovement", function()

    for k,v in ipairs(player.GetAll()) do --prevents the player from moving in the y-axis (since the player
        local vec = v:GetVelocity() --should only move in 2 directions)
        local badSpd = vec.y

        local newVec = Vector(0,-badSpd,0)
        v:SetVelocity(newVec)

        -- if(v:IsOnGround()) then 
        --     v:SetHitstun(false)
        -- end
    end 

    return false
end)