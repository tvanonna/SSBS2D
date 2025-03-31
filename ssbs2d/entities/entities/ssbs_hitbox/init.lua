AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	print("Hitbox spawned!")

	self:SetModel("models/hunter/plates/plate1x1.mdl") -- Placeholder model
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(Vector(-50, -50, 0), Vector(50, 50, 100)) -- Set its size
	--self:SetNoDraw(true)
    self:SetTrigger(true) -- Make it a trigger volume

end

function ENT:GetKnockbackGrowth()
	return 8
end 

function ENT:GetBaseKnockback()
	return 200
end 

function ENT:GetId()
	return id 
end

function ENT:GetKnockbackVector(victim, dmginfo)
	return Vector(0,0,-800)
end

function ENT:SetKnockbackVector(value)
	knockback = value 
end 

function ENT:StartTouch(ent)
    if ent:IsPlayer() and ent:Alive() and (ent != self:GetOwner()) then
        local damage = 10 -- Damage amount
        local dmgInfo = DamageInfo()
        dmgInfo:SetDamage(damage)
        dmgInfo:SetAttacker(self:GetOwner()) -- You can change this to a specific entity
        dmgInfo:SetInflictor(self)
        dmgInfo:SetDamageType(DMG_GENERIC) -- Change this to fire, acid, explosion, etc.

        ent:TakeDamageInfo(dmgInfo)

        print("You touched a deadly trap!") -- Optional message
    end
end

function ENT:Think()
    debugoverlay.Box(self:GetPos(), self:GetCollisionBounds(), 1, Color(255, 0, 0, 255), true)
end
	