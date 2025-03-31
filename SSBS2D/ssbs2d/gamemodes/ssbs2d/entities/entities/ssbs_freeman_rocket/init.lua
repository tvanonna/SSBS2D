AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

trail = nil
knockback = Vector(0,0,0)
id = 0

function ENT:Initialize()

	self:SetModel("models/weapons/w_missile_closed.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	 
	if (phys:IsValid()) then
	 	phys:Wake()
	end

	trail = ents.Create("env_smoketrail")
	if(!trail:IsValid()) then return end 
	trail:SetPos(self:GetPos())
	trail:SetKeyValue("startsize", "8.0")         -- Size of the smoke at the start
	trail:SetKeyValue("endsize", "16.0")          -- Size of the smoke at the end
	trail:SetKeyValue("spawnrate", "300.0")        -- How many particles spawn per second
	trail:SetKeyValue("lifetime", "5")          -- Lifetime of each smoke particle
	trail:SetKeyValue("opacity", "0.9")         -- Smoke opacity (0 to 1)
	trail:SetKeyValue("rendermode", "5")        -- Render mode (5 = additive)
	trail:SetKeyValue("startcolor", "255 255 255") -- RGB color of the smoke at start
	trail:SetKeyValue("endcolor", "255 255 255")   -- RGB color of the smoke at end
	trail:Spawn()
	trail:Activate()

	hook.Add("OnRemove", "DeleteTrail", function()
		trail:Remove()
	end)

	id = self:StartLoopingSound("weapons/rpg/rocket1.wav")

	timer.Create("DeathTimer", 3, 1, function()
		if(!self:IsValid()) then return end
		self:Remove()
	end)

end

function ENT:GetKnockbackGrowth()
	return 2
end 

function ENT:GetBaseKnockback()
	return 200
end 

function ENT:GetId()
	return id 
end

function ENT:GetKnockbackVector(victim, dmginfo)
	local force = dmginfo:GetDamageForce():GetNormalized()
	force.z = force.z + 0.2

	return force
end

function ENT:GetTrail()
	return trail 
end

function ENT:SetKnockbackVector(value)
	knockback = value 
end 
	
function ENT:PhysicsCollide( colData , physObj )
	self:Remove()
end

function ENT:Think()
	
	local trace = self:GetOwner():GetEyeTraceNoCursor()
	local destination = nil --stores the location the player is looking at

	if(trace.Hit == true and trace.Entity:IsValid()) then 
		destination = trace.Entity:GetPos()
	else 
		destination = trace.HitPos
	end 

	local pos = self:GetPos()
	destination:Sub(pos)
	destination:Normalize()

	local phys = self:GetPhysicsObject()

	local velocity = phys:GetVelocity()
	velocity:Add(destination * 1000)

	phys:SetVelocity(velocity)

	trail:SetPos(pos)
end



-- function AngleBetweenTwoVectors(vector1, vector2)
-- 	local fCrossX = vector1.y * vector2.z - vector1.z * vector2.y;
-- 	local fCrossY = vector1.z * vector2.x - vector1.x * vector2.z;
-- 	local fCrossZ = vector1.x * vector2.y - vector1.y * vector2.x;
-- 	local fCross = math.sqrt(fCrossX * fCrossX +
-- 		fCrossY * fCrossY + fCrossZ * fCrossZ);
-- 	local fDot = vector1.x * vector2.x + vector1.y * vector2.y + vector1.z + vector2.z;
-- 	return math.deg(math.atan2(fCross, fDot));
-- end
