
include( "shared.lua" )
include( "cl_hud.lua" )
include( "cl_settings.lua" )
include("cl_netmessages.lua")
include("movement/cl_2dmovement.lua")

killicon.AddAlias("weapon_rpg", "rpg_missile")

local camera_angle = Angle(0,90,0)

local camera_deviation_x = 400 --describes how much the x coordinate of the  camera is allowed to deviate from the x position of ssbs_map_center
local camera_deviation_z_down = 20  --idem but for the z coordinate upwards
local camera_deviation_z_up = 200 --idem but for the z coordinate upwards

local min_zoom = 400 --describes how much the camera is allowed to zoom in
local max_zoom = 800 --like min_zoom but for zooming out

local pointer = nil --stores the map center pointer entity 
local pointer_pos = nil --stores location of this entity

hook.Add("InitPostEntity", "FindPointer", function() --finds the map center entity
	local i = 0
	while(pointer == nil) do
		pointer = ents.FindByClass("ssbs_map_center")[1] --returns position of entity that points to center of the stage
		i = i + 1
		if(i == 60) then 
			print("ERROR! Map Center Pointer Entity not found!")
			return 
		end 
	end

	point_pos = pointer:GetPos() --since position is constant, we only need to call this once

	print("Map center pointer found!")
end)

hook.Add( "CalcView", "ForceSideView", function( ply, pos, angles, fov ) 

	local players = player.GetAll()

	local ply_count = #players

	if(pointer != nil) then ply_count = ply_count + 1 end 
	
	local x_avg = 0
	local z_avg = 0

	local dist = 0

	--find the average x and z coordinates in order to find the ideal camera position

	for k, v in ipairs(players) do 

		local pos = v:GetPos()
		x_avg = x_avg + pos.x
		z_avg = z_avg + pos.z

	end 

	if(pointer != nil) then 
		x_avg = x_avg + point_pos.x 
		z_avg = z_avg + point_pos.z 
	end 

	x_avg = x_avg / ply_count 
	z_avg = z_avg / ply_count 

	--find the max distance between two players in order to find the ideal camera zoom

	if(ply_count == 1) then 
		dist = 180000 --300 * 300 * 2; means that distance between player and camera will be 300 in singleplayer
	else 

		for k,v in ipairs(players) do 
			for a,b in ipairs(players) do
				if(v != b) then  
					local pos1 = v:GetPos()
					local pos2 = b:GetPos()

					local pos_dist = pos1:DistToSqr( pos2 )

					if(pos_dist > dist) then 
						dist = pos_dist 
					end 
				end
			end

			local pos1 = v:GetPos()
			
			local pos_dist = pos1:DistToSqr( point_pos )

			if(pos_dist > dist) then 
				dist = pos_dist 
			end 
		end

	end

	dist = math.Clamp(math.sqrt(dist) / 2, min_zoom, max_zoom)

    local newPos = Vector(x_avg, LocalPlayer():GetPos().y, z_avg) - Vector(0,dist,-50)
    local newAng = camera_angle

	--clamp the x and z coordinates of the camera to ensure camera does not move too far away from the stage

	if(pointer != nil and pointer:IsValid()) then 
		newPos.x = math.Clamp(newPos.x, point_pos.x - camera_deviation_x, point_pos.x + camera_deviation_x)
		newPos.z = math.Clamp(newPos.z, point_pos.z - camera_deviation_z_down, point_pos.z + camera_deviation_z_up)
	else 
		--print("ERROR! Map Center Entity not found!")
	end 

	local view = {
		origin = newPos,
		angles = newAng,
		fov = fov,
		drawviewer = true --thirdperson
	}

	return view
end )

local color_red = Color(255, 0, 0)

hook.Add( "PostDrawTranslucentRenderables", "DrawEyetrace", function()
	local eyePos = LocalPlayer():EyePos()
	local aimVec = LocalPlayer():GetAimVector()

    render.DrawLine( eyePos, eyePos + aimVec * 1000, color_red )
end )

-- hook.Add("AdjustMouseSensitivity", "IncreaseSensitivity", function(def)
-- 	return def 
-- end)