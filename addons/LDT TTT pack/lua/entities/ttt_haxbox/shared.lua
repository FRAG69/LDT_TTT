ENT.Type = "anim"
ENT.PrintName = ""
ENT.Author = "my_hat_stinks"
ENT.Purpose	= "Spawns Hax"

function ENT:Finish()
	util.EquipmentDestroyed(self:GetPos())
	
	self.Entity:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	//if dmginfo:GetAttacker() == self:GetOwner() then return end

	self:TakePhysicsDamage(dmginfo)

	self:SetHealth(self:Health() - dmginfo:GetDamage())

	if self:Health() < 0 then
		self:Remove()
		util.EquipmentDestroyed(self:GetPos())
	end
end