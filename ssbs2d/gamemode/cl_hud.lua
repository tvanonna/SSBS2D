AddCSLuaFile()

local shouldHide = {
    ["CHudDamageIndicator"] = true, --prevents the HUD from drawing coloring the screen a bright red whenever the player gets hit
    ["CHudHealth"] = true, 
    ["CHudCrosshair"] = true
}

function GM:HUDShouldDraw( name )

    if (shouldHide[ name ]) then 
        return false                        
    end
    return true

end

color_white = Color(255,255,255,255) --the color white 

function GM:HUDDrawTargetID()

	return false

end

hook.Add("HUDPaint", "DrawPercentage", function()

    local health = LocalPlayer():Health() 
    local percentage = "???"

    if(health != 0) then 
        percentage = (1000 - LocalPlayer():Health()) .. "%"
    else 
        percentage = "DEAD"
    end

    -- local color = Color(0,0,0,255) --TODO: use network strings to communicate hitstun  between client and server

    -- if(LocalPlayer():IsInHitstun()) then 
    --     color = color_red 
    -- else 
    --     color = color_white
    -- end

        if(stocks_enabled and round_started) then 
            draw.DrawText( "Stocks: " .. local_player_stocks .. "\n" .. percentage, "CloseCaption_Bold", (ScrW()/10) * 3 , (ScrH()/7) * 5, color_white, TEXT_ALIGN_CENTER )
        else 
            draw.DrawText(percentage, "CloseCaption_Bold", (ScrW()/10) * 3 , (ScrH()/7) * 5, color_white, TEXT_ALIGN_CENTER )
        end 

        if(timer_enabled and round_started) then 
            local minutes = math.floor(timer_length / 60)
            local seconds = timer_length - (minutes * 60)

            draw.DrawText(minutes .. ":" .. seconds, "CloseCaption_Bold", (ScrW()/2) , (ScrH()/7), color_white, TEXT_ALIGN_CENTER )
        end 

    

end)