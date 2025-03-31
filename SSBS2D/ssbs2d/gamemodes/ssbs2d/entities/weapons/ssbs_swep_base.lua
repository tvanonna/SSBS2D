AddCSLuaFile()


SWEP.Base              = "weapon_base"
SWEP.PrintName         = "BASE MOVESET"
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon  = false


SWEP.ViewModel      = ""
SWEP.ViewModelFlip  = false
SWEP.UseHands       = false
SWEP.WorldModel     = ""
SWEP.SetHoldType    = "normal"
SWEP.Weight         = 5
SWEP.AutoSwitchTo   = true
SWEP.AutoSwitchFrom = true
SWEP.ViewModelFOV   = 70
SWEP.BobScale       = 0.3

SWEP.Slot         = 1
SWEP.SlotPos      = 1

SWEP.DrawAmmo      = true
SWEP.DrawCrosshair = true

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize    =  -1
SWEP.Primary.DefaultClip =  -1
SWEP.Primary.Ammo        = "none"
SWEP.Primary.Automatic   = false
SWEP.Primary.Recoil      = 0
SWEP.Primary.Damage      = 0
SWEP.Primary.NumShots    = 0
SWEP.Primary.Spread      = 0
SWEP.Primary.Cone        = 0
SWEP.Primary.Delay       = 2

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo        = "none"
SWEP.Secondary.Automatic   = false

SWEP.ShouldDropOnDie    = false

function SWEP:CanPrimaryAttack()
    return false 
end 

function SWEP:CanSecondaryAttack()
    return false 
end 

function SWEP:Holster( wep )
    return false --do not allow switching by the player
end  

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:NeutralNormalAttack()
    if(self:GetOwner():IsOnGround()) then 
        print("neutral normal attack ground")
    else 
        print("neutral normal attack air")
    end
end 

function SWEP:SideNormalAttack()
    if(self:GetOwner():IsOnGround()) then 
        print("side normal attack ground")
    else 
        print("side normal attack air")
    end
end 

function SWEP:UpNormalAttack()
    if(self:GetOwner():IsOnGround()) then 
        print("up normal attack ground")
    else 
        print("up normal attack air")
    end
end 

function SWEP:DownNormalAttack()
    if(self:GetOwner():IsOnGround()) then 
        print("down normal attack ground")
    else 
        print("down normal attack air")
    end
end 

function SWEP:NeutralSpecialAttack()
    if(self:GetOwner():IsOnGround()) then 
        print("neutral special attack ground")
    else 
        print("neutral special attack air")
    end
end 

function SWEP:SideSpecialAttack()
    if(self:GetOwner():IsOnGround()) then 
        print("side special attack ground")
    else 
        print("side special attack air")
    end
end 

function SWEP:UpSpecialAttack()
    if(self:GetOwner():IsOnGround()) then 
        print("up special attack ground")
    else 
        print("up special attack air")
    end
end 

function SWEP:DownSpecialAttack()
    if(self:GetOwner():IsOnGround()) then 
        print("down special attack ground")
    else 
        print("down special attack air")
    end
end 

function SWEP:GetKnockbackGrowth()
	return 2
end 

function SWEP:GetBaseKnockback()
	return 200
end 
