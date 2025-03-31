AddCSLuaFile()

--contains damage and knockback related code

local plyTable = FindMetaTable("Player")

function plyTable:GetLastPlayer()
   return self.LastPlayer  
end

function plyTable:SetLastPlayer(ply)
    self.LastPlayer = ply 
end 

function plyTable:SetLastInflictor(ent)
    self.LastInflictor = ent 
end 

function plyTable:GetLastInflictor()
    return self.LastInflictor 
end

function plyTable:IsInHitstun()
    return self.Hitstun 
end 

function plyTable:SetHitstun(value)
    self.Hitstun = value --should be a boolean
end  

hook.Add("PlayerInitialSpawn", "InitalizeLastPlayer", function(ply)
    ply.LastPlayer = nil --refers to the last player to deal damage to this player
    ply.LastInflictor = nil --refers to the last inflictor (a weapon or projectile) to deal damage to this player 

    ply.Hitstun = false --refers to whether the player is in hitstun or not
end)

hook.Add("OnPlayerHitGround", "RemoveHitstun", function(ply, inWater, onFloater, speed)

    if(!inWater) then 
        ply:SetHitstun(false) --removes player hitstun upon touching the ground
        --print(ply:Nick() .. "no longer in hitstun!\n")
    end

end)

-- hook.Add("KeyPress", "RemoveHitstun", function(ply, key)
--     if(ply:IsOnGround()) then 
--         ply:SetHitstun(false)
--     end
-- end)

hook.Add("AcceptInput", "BlockInputDuringKnockback", function(ent, input, activator, caller, value)
    if(ent:IsValid() and ent:IsPlayer() and ent:IsInHitstun()) then 
        return true --players should not be able to move when they are under the influence of hitstun
    end 

end)

hook.Add("StartCommand", "HitstunBlockInputs", function(ply, cmd) --prevents players in hitstun from moving
    if(ply:IsValid() and ply:IsPlayer() and ply:IsInHitstun()) then 
        cmd:ClearMovement()
        cmd:ClearButtons()
    end 

    return
end)

function GM:GetFallDamage(ply, spd)
    return 0 --Players should not take any damage from falling
end

function CalculateKnockbackAndHitstun(target, dmginfo)
    --Also, knockback should in the final version not be applied from this hook, but from the code of the SWEPs themselves

    local percentage = (1000 - target:Health()) + dmginfo:GetDamage()
    local damage = dmginfo:GetDamage()
    local weight = target:GetWeight()
    local knockback_growth = 1.1
    local base_knockback = 5

    attacker = dmginfo:GetInflictor()

    local aimVec = dmginfo:GetAttacker():GetAimVector()

    local inflictor = dmginfo:GetInflictor():GetClass()

    if(inflictor == "rpg_missile") then 
        base_knockback = 40
        knockback_growth = 1.3

        local force = dmginfo:GetDamageForce():GetNormalized()
	    --force.z = force.z + 350

        aimVec = force
    elseif(inflictor == "npc_grenade_frag") then 
        base_knockback = 60
        knockback_growth = 1.5
        
        local force = dmginfo:GetDamageForce():GetNormalized()
        --force.z = force.z + 500

        aimVec = force
    elseif(inflictor == "weapon_crowbar") then 
        knockback_growth = 1.2
        base_knockback = 5

        aimVec = dmginfo:GetAttacker():GetAimVector()
    elseif(inflictor == "ssbs_hitbox") then 
        local hitbox = dmginfo:GetInflictor()
        knockback_growth = hitbox:GetKnockbackGrowth()
        base_knockback = hitbox:GetBaseKnockback()
        aimVec = hitbox:GetKnockbackVector()
    end

    aimVec.y = 0

    --knockback as calculated in SSBM (https://www.ssbwiki.com/Knockback)
    local knockback = (percentage / 10) + ((percentage * damage) / 20)
    knockback = (knockback * (200/(weight+100)) * 1.4) + 18
    knockback = (knockback * knockback_growth) + base_knockback

    local hitstun = knockback * 0.016

    knockback = knockback * 10
    print("Health = " .. percentage .. "Knockback = " .. knockback .. "\n")

    print("Launch Vector:" .. aimVec.x .. " " .. aimVec.y .. " " .. aimVec.z .. "\n")

    curr_gravity = aimVec.z --the target's gravity

    result = (aimVec * knockback) --apply knockback in the direction the user is aiming
    result.z = -curr_gravity + 250 --make sure that the target's gravity does not affect the knockback on the z axis

    return {result, hitstun} --first value is the knockback vector, second one is the hitstun
end

hook.Add("PlayerDeath", "RemoveHitstun", function(ply)
    ply:SetHitstun(false)
end)

hook.Add("EntityTakeDamage", "SmashBrosDamageSystem", function(target, dmginfo)
    if(not (target:IsPlayer() or target:IsNextBot() ) ) then return end --this only applies to players

    if ( dmginfo:GetDamage() >= target:Health() ) then
        dmginfo:SetDamage( target:Health() - 1 ) --We do not want players to die through "traditional means" (i.e. HP being reduced to zero)
    end

    --The following code implements SSB's Blast Zones, which are implemented using trigger_hurt entities in the map:

    local attacker = dmginfo:GetAttacker()

    if ( attacker:GetClass() == "trigger_hurt" or !attacker:IsValid()) then 

        local lastPly = target:GetLastPlayer() 

        if((lastPly != nil) and (lastPly != target)) then 
            dmginfo:SetAttacker(lastPly) --the last player to hit the target is labled as the one who killed the target
            dmginfo:SetInflictor(target:GetLastInflictor())
        end 

        dmginfo:SetDamageType(DMG_DISSOLVE) --causes players to dissolve
        dmginfo:SetDamage(2001) --trigger_hurt objects essentially function as the blast zone in this case
        return   
    end

    --The following code is used to set the last attacker and weapon to hurt an entity, which will be labeled
    --as the killer once the player touches a blast zone

    if(attacker:IsValid() and attacker:IsPlayer() and (attacker != target)) then 
        target:SetLastPlayer(attacker)

        local inflictor = attacker:GetActiveWeapon()

        if(inflictor != nil and inflictor:IsValid()) then 
            target:SetLastInflictor(inflictor)
        else 
            target:SetLastInflictor(nil)
        end 
    end 

    --The following code applies hitstun and knockback to players after they have been hit

    local inflictor = attacker:GetActiveWeapon()

    if(!inflictor:IsValid() or !dmginfo:GetInflictor():IsValid()) then return end 

    if(inflictor:GetClass() == "weapon_rpg") then 
        dmginfo:ScaleDamage(0.3)
    elseif(dmginfo:GetInflictor():GetClass() == "npc_grenade_frag") then 
        dmginfo:ScaleDamage(0.5)
    elseif(inflictor:GetClass() == "weapon_crowbar") then 
        dmginfo:ScaleDamage(0.8)
    end

    local table = CalculateKnockbackAndHitstun(target, dmginfo) 

    local vector = Vector(0,0,0)
    local plyVector = target:GetAimVector()

    vector.x = -plyVector.x + table[1].x
    vector.y = -plyVector.y + table[1].y 
    vector.z = -plyVector.z + table[1].z

    target:SetVelocity(table[1]) 
    print("Hitstun: " .. table[2] .. " seconds.")

    --print(target:Nick() .. " is now in hitstun!") --manages hitstun

    target:SetHitstun(true)

    timer.Create(target:Nick() .. "Knockback", table[2], 1, function() 
        target:SetHitstun(false) --disable hitstun
        print(target:Nick() .. " is no longer in hitstun!")
    end)
    
end)