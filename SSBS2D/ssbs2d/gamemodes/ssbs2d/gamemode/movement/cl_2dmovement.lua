--This function contains hooks for restricting the player movement
--to conform to 2 axes instead of 3
--This is handled clientside

last_y_angle = 0

hook.Add("StartCommand", "2DMovement", function(ply, cmd)

    local fwdMove = cmd:GetForwardMove() / -10000 --whether the player has pressed W or S
    local sMove = math.abs(cmd:GetSideMove()) 
    local sMove2 = cmd:GetSideMove() --whether the player has pressed A or D

    cmd:SetForwardMove(sMove) --makes it so the player can move forward/backward with A/D keys
    cmd:SetSideMove(0) --prevents the player from moving sideways

    local xAngles = 0

    -- if(fwdMove > 0 and ply:IsOnGround()) then 
    --     cmd:AddKey(IN_DUCK)
    --     xAngles = 0 --cmd:SetViewAngles(Angle(0,0,0))
    -- else 
    --     cmd:RemoveKey(IN_DUCK)
    --     xAngles = fwdMove * 90 --forces players to look around with movement keys
    -- end  

    if(ply:IsOnGround() == false) then 
        cmd:RemoveKey(IN_DUCK)
    end

    local angles = ply:EyeAngles()
    --angles = angles:Angle()
    --angles.x = xAngles
    angles.z = 0

    if(sMove2 > 0) then 
        angles.y = 0
        last_y_angle = 0
    elseif(sMove2 < 0) then 
        angles.y = -180
        last_y_angle = 180
    else 
        angles.y = last_y_angle
    end

    cmd:SetViewAngles(angles)


end)

-- hook.Add("StartCommand", "Sex", function(ply, cmd)
--     local angles = cmd:GetViewAngles()
--     angles.p = math.Clamp(angles.p, -180, 180) -- Modify limits here
--     cmd:SetViewAngles(angles)
-- end)

hook.Add( "InputMouseApply", "FreezeTurning", function( cmd )
	cmd:SetMouseX( 0 )
	cmd:SetMouseY( 0 )

	return false
end )

-- hook.Add("HUDPaint", "DrawCrosshair", function() --TODO: Fix this!
--     local x,y = input.GetCursorPos()

--     surface.SetDrawColor(255, 0, 0, 255) -- Red color
--     surface.DrawLine(x - 5, y, x + 5, y) -- Horizontal line
--     surface.DrawLine(x, y - 5, x, y + 5) -- Vertical line
-- end)