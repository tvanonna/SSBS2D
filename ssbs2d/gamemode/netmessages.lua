AddCSLuaFile()

--this file handles communication of network messages server side

util.AddNetworkString( "Round" )
util.AddNetworkString( "Stocks" )
util.AddNetworkString( "Timer" )

local load_queue = {}

hook.Add( "PlayerInitialSpawn", "NotifyPlayerSpawn", function( ply )
	load_queue[ ply ] = true
end )

hook.Add( "StartCommand", "NotifyPlayerSpawn", function( ply, cmd )
	if load_queue[ ply ] and not cmd:IsForced() then
		load_queue[ ply ] = nil

		net.Start( "Round" )
        net.WriteBool(round_started)
        net.Send(ply)
	end
end )

function NotifyPlayerDeath(ply)
    net.Start("Stocks")
    net.WriteUInt(ply:GetStocks(), 7)
    net.Send(ply)
    print(ply:Nick() .. " has " .. ply:GetStocks() .. " stocks left")
end 

function NotifyPlayerRound(value)
    net.Start("Round")
    net.WriteBool(value)
    net.Broadcast()
end 

-- function NotifyPlayerTimer(value)
--     net.Start("Timer")
--     net.WriteUInt(timer.TimeLeft("timer"), 12)
--     net.Broadcast()
-- end