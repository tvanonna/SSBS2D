AddCSLuaFile()

hook.Add("StartCommand", "AttacksInput", function(ply, cmd)

    if(ply:Alive() == false) then return end

    local attack = cmd:KeyDown(IN_ATTACK)
    local attack2 = cmd:KeyDown(IN_ATTACK2)

    local leftDown = cmd:KeyDown(IN_MOVELEFT)
    local rightDown = cmd:KeyDown(IN_MOVERIGHT)
    local upDown = cmd:KeyDown(IN_FORWARD)
    local downDown = cmd:KeyDown(IN_BACK)

    local weapon = ply:GetActiveWeapon()

    if(!attack and !attack2) then return end
    if(weapon:GetClass().Base != "ssbs_swep_base") then return end

    if(attack) then 
        if(leftDown or rightDown) then --player is looking down/ducking
            weapon:SideNormalAttack()
            return
        elseif (upDown) then 
            weapon:UpNormalAttack()
            return
        elseif(downDown) then
            weapon:DownNormalAttack()
            return
        else 
            weapon:NeutralNormalAttack()
            return
        end 
    elseif(attack2) then 
        if(leftDown or rightDown) then --player is looking down/ducking
            weapon:SideSpecialAttack()
            return
        elseif (upDown) then 
            weapon:UpSpecialAttack()
            return
        elseif(downDown) then
            weapon:DownSpecialAttack()
            return
        else 
            weapon:NeutralSpecialAttack()
            return
        end 
    end 

end)