AddCSLuaFile()

--this file handles communication of network messages client side

round_started = false 
local_player_stocks = 0
stocks_enabled = GetConVar("ssbs_stocks_enabled"):GetBool()
timer_enabled =  GetConVar("ssbs_timer_enabled"):GetBool()
timer_length = 0

net.Receive("Stocks", function()
    local_player_stocks = net.ReadUInt(7)
    print("local player has " .. local_player_stocks .. " left!")
end)

net.Receive("Round", function()
    round_started = net.ReadBool()
    if(round_started) then 
        print("round has (already) started!")
        if(!timer.Exists("timer")) then 
            timer.Create("timer", 1, 0, function()
                timer_length = timer_length - 1
            end)
        else 
            timer.UnPause("timer")
        end
    else 
        print("round has not yet started.")
        timer.Pause("timer")
    end 

    stocks_enabled = GetConVar("ssbs_stocks_enabled"):GetBool()
    timer_enabled =  GetConVar("ssbs_timer_enabled"):GetBool()
    timer_length = GetConVar("ssbs_timer_length"):GetInt()

end)

net.Receive("Timer", function()
    timer = net.ReadUInt(12)
end)