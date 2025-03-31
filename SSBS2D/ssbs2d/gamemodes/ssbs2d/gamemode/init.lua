AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_settings.lua" )
AddCSLuaFile( "cl_netmessages.lua")
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "movement/cl_2dmovement.lua")

include( "shared.lua" )
include( "damage.lua" )
include( "concommand.lua" )
include( "round_manager.lua" )
include( "netmessages.lua")

include( "movement/double_jump.lua" )
include("movement/airmovement.lua")
include("movement/2dmovement.lua")
include("movement/attacksinput.lua")


hook.Add("PlayerInitialSpawn", "DoSomeStuff", function(ply)
	print( ply:Nick() .. " joined the server." )
    player_manager.SetPlayerClass(ply, "class_freeman")
end)

hook.Add("InitPostEntity", "PlacePointer", function()
    if(game.GetMap() == "gm_flatgrass") then 
        local ent = ents.Create("ssbs_map_center")
        if(!IsValid(ent)) then return end 
        ent:SetPos(Vector(-26.323879, -192.000000, -12287.968750))
        ent:Spawn()
    elseif(game.GetMap() == "gm_final_destination_v2") then 
        local ent = ents.Create("ssbs_map_center")
        if(!IsValid(ent)) then return end 
        ent:SetPos(Vector(-9.601398, 0.000011, 65.031250))
        ent:Spawn()
    end
end)

function GM:PlayerSay( ply, msg, teamchat) --i feel that this might need to be in its own file
    local text = string.lower(msg)

    if(string.StartsWith(text, "gg ez")) then
        local response = FunnyResponse()
        return response
    elseif(string.StartsWith(text, "!start")) then 
        ply:ConCommand("ssbs_start")
        return ""
    elseif(string.StartsWith(text, "!end")) then 
        ply:ConCommand("ssbs_end")
        return ""
    end 

end

function GM:OnDamagedByExplosion(ply, dmginfo) --overriding disables the god-awful sound effect whenever a player gets hit by an explosion
end 

function GM:PlayerDeathSound(ply)
    if(player_manager.GetPlayerClass( ply ) == "class_freeman") then 
        return true --play the death sound if playing as Gordon Freeman
    else 
        --TODO: player death sound for each class
        return false 
    end 
end

funnyresponses = {"Wow! You are so good at the game!"}

function FunnyResponse()

    local length = #funnyresponses

    if(length < 0) then return "" end

    return funnyresponses[math.random(1, length)]

end

hook.Add( "ShouldCollide", "CustomCollisions", function( ent1, ent2 ) --does not work for some reason
	-- If both entities are players then disable collisions!
	if ( ent1:IsPlayer() and ent2:IsPlayer() ) then return false end
end )

hook.Add("PlayerSpawn", "SetCoordinates", function(ply)
    if(game.GetMap() == "gm_flatgrass") then 
        local coord = ply:GetPos()
        coord.y = -192
        ply:SetPos(coord)
    end 

end)