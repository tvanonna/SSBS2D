ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Rocket"

ENT.Spawnable = true

function ENT:OnRemove()

    local ply = self:GetOwner()

    if(SERVER) then 

		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( ply )
		dmginfo:SetInflictor( ply:GetActiveWeapon() )
		dmginfo:SetDamage( 110 )
		dmginfo:SetDamageForce( dmginfo:GetDamageForce() )

		util.BlastDamage( self, self:GetOwner(), self:GetPos() , 150 , 35)

		local effectData = EffectData()
 		effectData:SetOrigin( self:GetPos() )
 		util.Effect( "Explosion" , effectData )

		self:GetTrail():Remove()
		self:SetKnockbackVector(self:GetPos())

		self:StopLoopingSound(self:GetId())
    end 

	local weapon = self:GetOwner():GetWeapon("ssbs_freeman_rpg")
	if(!weapon:IsValid()) then print("rpg invalid!") return end 

	weapon:NotifyWeaponRocketRemoved()
end