AddCSLuaFile()

ply = FindMetaTable("Player")

--define functions to retieve/edit values for player attributes 
--we have added in this gamemode

function ply:SetJumps(value)
    self.Jumps = value  
end 

function ply:GetJumps()
    return self.Jumps 
end 

--This code relates to how double jumping is handled in the gamemode

--angle_default = Angle(0,1,0) --This way, we do not need to create an Angle object each time getMovementAxisVector is called.

vector_zero = Vector(0,0,0)

hook.Add("PlayerInitialSpawn", "SetJumps", function(ply)
    ply.Jumps = 0 --variable used for double jumping
end)

hook.Add("KeyPress", "DoubleJump", function(ply, key)
    --hook that is used to determine whether the player should double jump whenever a key is pressed
    --Credits: https://github.com/KojoTort/Double-Jump/blob/main/db.lua for the base code

    if (not (key == IN_JUMP) ) then return end

    if ply:IsOnGround() then
        ply:SetJumps(0)
        return
    end 

    if(ply:IsInHitstun()) then 
        print(ply:Nick() .. " tried to jump while in hitstun!")
        return 
    end 

    ply:SetJumps( ply:GetJumps() + 1)
    if (ply.Jumps <= ply:GetMaxJumps()) then

        --local aimVec = getMovementAxisVector(ply)
        local jumpPower = ply:GetJumpPower()

        local velocity = ply:GetVelocity()

        local vel = Vector( 0, 0, 0 )

        -- if(!aimVec:IsZero()) then 
        --     vel.z = -velocity.z + jumpPower
        --     vel.x = -velocity.x 
        --     vel.y = -velocity.y
        -- else 
            vel.z = -velocity.z + jumpPower
        -- end 

        --vel:Add(aimVec * jumpPower)

        ply:SetVelocity( vel )

        ply:SetJumps( ply:GetJumps() + 1)

        ply:SetFastFalling(false)
    end
end)

hook.Add("Think", "ResetJumps", function()
    for k,v in ipairs(player.GetAll()) do
        if v:IsOnGround() then
            v:SetJumps(0)
        end 
    end
end)

-- function getMovementAxisVector(ply)
--     --This function converts the WASD input of the player and the direction the player is aiming in
--     --into the direction in which the player will double jump

--     local x_axis = 0
--     local y_axis = 0

--     local vec = ply:GetAimVector()
--     vec.z = 0 --we are not interested in the height dimension in this case

--     -- if(ply:KeyDown( IN_FORWARD )) then x_axis = x_axis + 1 end --if only Lua had case matching...
--     -- if(ply:KeyDown( IN_BACK )) then x_axis = x_axis - 1 end 
--     -- if(ply:KeyDown( IN_MOVERIGHT )) then y_axis = y_axis - 1 end 
--     -- if(ply:KeyDown( IN_MOVELEFT )) then y_axis = y_axis + 1 end

--     if(ply:KeyDown( IN_MOVERIGHT )) then x_axis = x_axis + 1 end 
--     if(ply:KeyDown( IN_MOVELEFT )) then x_axis = x_axis - 1 end

--     if(x_axis == 0 and y_axis == 0) then 
--         return vector_zero --if no keys are held down, the player should not be launched in any direction except upwards
--     end

--     local temp = math.deg( math.atan2(y_axis, x_axis) ) --used to get the angle created by the two axes
    
--     vec:Rotate( angle_default * temp ) --rotate the player's direction based on the angle stored in temp

--     return (vec * ply:GetDoubleJumpConst())
    
-- end
