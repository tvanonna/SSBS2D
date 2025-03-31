AddCSLuaFile()

local Player = FindMetaTable("Player")

local timer_enabled  = GetConVar("ssbs_timer_enabled"):GetBool()
local timer_length   = GetConVar("ssbs_timer_length"):GetInt()
local stocks_enabled = GetConVar("ssbs_stocks_enabled"):GetBool()
local stocks_amount  = GetConVar("ssbs_stocks_amount"):GetInt()

round_started = false --has the round started yet?
winner = nil --do not use this value, unless directly after OnePlayerRemaining returns true!!


hook.Add("PlayerInitialSpawn", "RoundInitialSpawn", function(ply)

    if(round_started and stocks_enabled) then
        ply.Stocks = 0
    else 
        ply.Stocks = stocks_amount --even if we don't need it, setting it is prolly better
    end

    print(ply:GetStocks())

    NotifyPlayerDeath(ply)
end)

hook.Add("PlayerSpawn", "RoundSpawn", function(ply)
    if(round_started and stocks_enabled and ply:NoStocksLeft()) then 
        print(ply:Nick() .. ": round started! Spectating...")
        ply:Kill()
        ply:Spectate(OBS_MODE_CHASE) --if stocks are enabled and the match is already going,`
    end
end )

function Player:GetStocks()
    return self.Stocks 
end

function Player:SetStocks(value)
    self.Stocks = value --should be an integer
end 

function Player:ReduceStocks()
    self.Stocks = self.Stocks - 1
end 

function Player:NoStocksLeft()
    if(self.Stocks == nil) then 
        self.Stocks = 0
        return true
    end 

    return (self.Stocks < 1)
end 

function RefreshVariables()
    timer_enabled  = GetConVar("ssbs_timer_enabled"):GetBool()
    timer_length   = GetConVar("ssbs_timer_length"):GetInt()
    stocks_enabled = GetConVar("ssbs_stocks_enabled"):GetBool()
    stocks_amount  = GetConVar("ssbs_stocks_amount"):GetInt()
end

function OnePlayerRemaining()

    if(!round_started or !stocks_enabled) then return false end 

    local player_left = nil

    for k, v in ipairs(player.GetAll()) do 
        if(!v:NoStocksLeft()) then 
            if(player_left == nil) then 
                player_left = v
            else 
                print("More than one player remaining!")
                return false 
            end
        end 
    end 

    winner = player_left

    print("One player remaining, namely" .. winner:Nick() .. "!")

    return true
end 

function FindPlayerWithMostStocks()

    max_player = nil 
    max_frags = 0

    for k,v in ipairs(player.GetAll()) do 
        frags = v:GetStocks()
        if(frags > max_frags) then 
            max_player = v 
            max_frags  = frags
        elseif (frags == max_frags and max_player:IsValid() and v:Health() > max_player:Health()) then 
            max_player = v 
            max_frags = frags
        end 
    end
    
    return max_player
end 

function StartRound()
    print("round started!")
    round_started = true

    RefreshVariables()

    for k, v in ipairs(player.GetAll()) do
        if(stocks_enabled) then 
            v:SetStocks(stocks_amount)
            NotifyPlayerDeath(v)
        end 
        v:Spawn()
    end 

    NotifyPlayerRound(true)

    if(timer_enabled) then 
        timer.Create("time", timer_length, 1, function()
            EndRound()
            local winning_player = FindPlayerWithMostStocks()
            if(!winning_player:IsValid()) then return end 
            for k,v in ipairs(player.GetAll()) do
                v:ChatPrint(winning_player:Nick() .. " has won the match!")
                if(v != winning_player) then 
                    v:Kill()
                    v:Spectate(OBS_MODE_CHASE)
                end 
            end
        end)

        -- timer.Create("BroadcastTime", 1, 0, function()
        --     NotifyPlayerTimer()
        -- end)
    end
end 

function EndRound()
    print("round ended!")

    if(!round_started) then print("round already over!") return end 

    timer.Pause("time")
    round_started = false
    NotifyPlayerRound(false)

    --timer.Pause("BroadcastTimer")
    
    timer.Simple(8, function()
        for k,v in ipairs(player.GetAll()) do
            v:SetObserverMode(OBS_MODE_NONE)
            v:Spawn()
            v:SetStocks(stocks_amount)
        end
        
    end)
end 

hook.Add("PlayerDeathThink", "PreventRespawning", function(ply)
    if(round_started and stocks_enabled and ply:NoStocksLeft()) then 
        return false --prevents respawning
    end 
end )

hook.Add("PlayerDeath", "ReduceStocks", function(victim, inflictor, attacker)
   
    if(!round_started or !stocks_enabled) then print("round not started or no stocks so death ignored.") return end 

    print("death hook run for " .. victim:Nick() .. "!")

    victim:ReduceStocks() 

    if(victim:NoStocksLeft()) then 
        victim:Spectate(OBS_MODE_CHASE)
        print(victim:Nick() .. " is now spectating!")
        if(OnePlayerRemaining() and round_started) then 

            local players = player.GetAll()

            for k, v in ipairs(players) do 
                v:ChatPrint(winner:Nick() .. " has won the match!")
            end 

            EndRound()
        end 
    end

    NotifyPlayerDeath(victim)

end)