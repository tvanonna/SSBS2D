AddCSLuaFile()

CreateConVar("ssbs_timer_enabled", 1, {FCVAR_NOTIFY, FCVAR_REPLICATED}, 
    "Determines whether the timer is enabled during matches. 1 means enabled, 0 means disabled.\n", 
    0, 1)

CreateConVar("ssbs_timer_length", 900, {FCVAR_NOTIFY, FCVAR_REPLICATED},
    "Determines the maximum length of matches in seconds.\n", 1, nil)

CreateConVar("ssbs_stocks_enabled", 1, {FCVAR_NOTIFY, FCVAR_REPLICATED},
    "Determines whether stocks (limited lives) are enabled during matches. 1 means enabled, 0 means disabled.\n",
    0, 1)

CreateConVar("ssbs_stocks_amount", 4, FCVAR_NOTIFY, 
    "Determines the amount of stockes (lives) given to each player at the start of a round.\n",
    1, 127)

-- concommand.Add( "dcl_newmodel" , function(ply , cmd , arg , str)
--         mdl = plymodels[math.random(0,8)]
--         ply:SetModel(mdl)
--         ply:PrintMessage( HUD_PRINTTALK , "Your model has been changed to "..mdl)
--         ply:SetupHands( ply )
       
--        end , "Gives the player  new, random playermodel")

--todo: concommand to start or restart match

concommand.Add("ssbs_start", function(ply, cmd, arg, str)

    if(!ply:IsAdmin()) then ply:ChatPrint("You are not authorised to perform this function!") return end 

    local players = player.GetAll()
    local player_count = #players 

    if(player_count <= 1) then ply:ChatPrint("Not enough players!") return end 


    timer.Create("countdown", 1, 10, function()
        local countdown = timer.RepsLeft("countdown")

        if(countdown == 0) then 
            StartRound()
        else 
            for k, v in ipairs(players) do 
                v:ChatPrint("Match begins in " .. countdown .. " seconds!")
            end 
        end
    end)

    
end)

concommand.Add("ssbs_end", function(ply, cmd, arg, str)

    if(!ply:IsAdmin()) then ply:ChatPrint("You are not authorised to perform this function!") return end 

    if(!round_started) then ply:ChatPrint("The round is already over!") return end 

    timer.Pause("time")
    round_started = false
    NotifyPlayerRound(false)

    for k, v in ipairs(player.GetAll()) do 
        v:ChatPrint("The match has been aborted by an admin!")
        v:SetObserverMode(OBS_MODE_NONE)
        v:Spawn()
        v:SetStocks(stocks_amount)
    end

    EndRound()
end)
