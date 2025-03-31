AddCSLuaFile()

--All player class related information should go inside of this file.

DEFINE_BASECLASS( "class_test" )

--define functions to retieve/edit values for player attributes 
--we have added in this gamemode

local ply = FindMetaTable("Player")

function ply:SetWeight(value)
    self.Weight = value 
end

function ply:GetWeight()
    return self.Weight 
end 

function ply:SetMaxJumps(value)
    self.MaxJumps = value 
end 

function ply:GetMaxJumps()
    return self.MaxJumps 
end 

function ply:SetDoubleJumpConst(value)
    self.DoubleJumpConst = value 
end 

function ply:GetDoubleJumpConst()
    return self.DoubleJumpConst 
end 

function ply:GetMaxAirSpeed()
    return self.MaxAirSpeed 
end 

function ply:SetMaxAirSpeed(value)
    self.MaxAirSpeed = value 
end 

function ply:GetAirAccel()
    return self.AirAccel 
end 

function ply:SetAirAccel(value)
    self.AirAccel = value 
end 

--The following code relates to a class we use to test the game.

local C_TEST = {}

C_TEST.SlowWalkSpeed           = 400
C_TEST.WalkSpeed               = 400
C_TEST.RunSpeed                = 400
C_TEST.CrouchedWalkSpeed       = 0.3
C_TEST.JumpPower               = 600

C_TEST.MaxHealth               = 1000
C_TEST.StartHealth             = 1000

C_TEST.UseVMHands              = true
C_TEST.DropWeaponOnDie         = false

C_TEST.Weight                  = 100 --weight used in knockback calculations

C_TEST.DoubleJumpConst         = 0.5 --multiplier that influences the horizontal velocity a double jump provides 
C_TEST.MaxJumps                = 2 --maximum number of jumps, including initial (non mid-air) jump

C_TEST.AirAccel                = 50
C_TEST.MaxAirSpeed             = 500

C_TEST.GravityMultiplier       = 1

function C_TEST:Spawn()

    --Assign some class variables to the player that are not configured automatically,
    --because they are not provided by the base gamemode.

    self.Player:SetWeight(self.Weight) 
    self.Player:SetDoubleJumpConst(self.DoubleJumpConst)
    self.Player:SetMaxJumps(self.MaxJumps)
    self.Player:SetAirAccel(self.AirAccel)
    self.Player:SetMaxAirSpeed(self.MaxAirSpeed)

    self.Player:SetGravity(self.GravityMultiplier)

end

function C_TEST:Loadout()

    self.Player:Give( "ssbs_swep_base" )
    
end

--function C_TEST:SetModel()
--end

--function C_TEST:Death(inflictor, attacker)
--end

player_manager.RegisterClass( "class_test", C_TEST, "player_default")

local C_FREEMAN = {}

C_FREEMAN.SlowWalkSpeed           = 350
C_FREEMAN.WalkSpeed               = 350
C_FREEMAN.RunSpeed                = 350
C_FREEMAN.CrouchedWalkSpeed       = 0.3
C_FREEMAN.JumpPower               = 380

C_FREEMAN.MaxHealth               = 1000
C_FREEMAN.StartHealth             = 1000

C_FREEMAN.UseVMHands              = true
C_FREEMAN.DropWeaponOnDie         = false

C_FREEMAN.Weight                  = 130 --weight used in knockback calculations

C_FREEMAN.DoubleJumpConst         = 0.7 --multiplier that influences the horizontal velocity a double jump provides 
C_FREEMAN.MaxJumps                = 3 --maximum number of jumps, including initial (non mid-air) jump

C_FREEMAN.Gravity = 0.85

function C_FREEMAN:Loadout()

    self.Player:Give( "weapon_crowbar")
    self.Player:Give( "weapon_shotgun")
    self.Player:Give( "ssbs_freeman_rpg")

end

player_manager.RegisterClass( "class_freeman", C_FREEMAN, "class_test")