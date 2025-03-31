AddCSLuaFile()


SWEP.Base              = "weapon_base"
SWEP.PrintName         = "ROCKET LAUNCHER"
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon  = false


SWEP.ViewModel      = "models/weapons/c_rpg.mdl"
SWEP.ViewModelFlip  = false
SWEP.UseHands       = true
SWEP.WorldModel     = "models/weapons/w_rocket_launcher.mdl"
SWEP.SetHoldType    = "rpg"
SWEP.Weight         = 5
SWEP.AutoSwitchTo   = true
SWEP.AutoSwitchFrom = true
SWEP.ViewModelFOV   = 70
SWEP.BobScale       = 0.3

SWEP.Slot         = 4
SWEP.SlotPos      = 0

SWEP.DrawAmmo      = true
SWEP.DrawCrosshair = true

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize    =  -1
SWEP.Primary.DefaultClip =  999
SWEP.Primary.Ammo        = "RPG_Round"
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

local ShootSound = Sound("Weapon_RPG.Single")
local NoAmmo     = Sound("Weapon_SMG1.Reload")

player_walkspeed = 0
player_runspeed = 0
player_slowwalkspeed = 0
player_jumppower = 0

rocket_active = false --stores the rocket created by this weapon 

function SWEP:NotifyWeaponRocketRemoved() --used by the rocket to notify that it has been removed
    rocket_active = false 

    if(CLIENT) then return end

    self:GetOwner():SetWalkSpeed(player_walkspeed)
    self:GetOwner():SetRunSpeed(player_runspeed)
    self:GetOwner():SetSlowWalkSpeed(player_slowwalkspeed)
    self:GetOwner():SetJumpPower(player_jumppower)
end 

function SWEP:Initialize()
    self:SetHoldType("rpg")

    if(CLIENT) then 
        self.ViewModelFOV = GetConVar("viewmodel_fov"):GetInt()
    end

end

function SWEP:CanSecondaryAttack()
    return false
end

function SWEP:Holster( weapon )
    return !rocket_active
end 

function SWEP:PrimaryAttack()

    if (self:HasAmmo() == false) then
        self:GetOwner():EmitSound( NoAmmo )
        return 
    end
 
    if(SERVER) then 

    local ply = self:GetOwner()

    player_walkspeed = self:GetOwner():GetWalkSpeed()
    player_runspeed = self:GetOwner():GetRunSpeed()
    player_slowwalkspeed = self:GetOwner():GetSlowWalkSpeed()
    player_jumppower = self:GetOwner():GetJumpPower()
 
    ply:LagCompensation( true )

    ply:EmitSound( ShootSound )

    ent = ents.Create( "ssbs_freeman_rocket" )

    if ( !IsValid(ent) ) then return end

    ent:SetOwner( ply )
    ent:SetPos( self.Owner:EyePos() + (self.Owner:GetAimVector() * 1) )
    ent:SetAngles( self.Owner:EyeAngles() )
    ent:Spawn()

    self:GetOwner():SetWalkSpeed(1)
    self:GetOwner():SetRunSpeed(1)
    self:GetOwner():SetSlowWalkSpeed(1)
    self:GetOwner():SetJumpPower(0.001)

    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

    local physobj = ent:GetPhysicsObject()
    physobj:EnableGravity( false )
    physobj:SetVelocity( ply:GetAimVector() * 50)

    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    self:TakePrimaryAmmo( 1 )

    ply:LagCompensation( false ) 
    
    end 

    rocket_active = true
 
end