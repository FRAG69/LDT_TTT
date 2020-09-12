ENT.Type = "anim"
ENT.PrintName = ""
ENT.Author = "my_hat_stinks"
ENT.Purpose	= "Spawns Hax"

function ENT:MakeHax(num,max,int)
	if SERVER then
		if (num >= max) then
			self:Finish()
			return
		end
		
		local NumCreated = num+1
		
		local Pos = self.Entity:GetPos()
		local HaxNPC = ents.Create("npc_manhack")
		HaxNPC:SetPos(Pos + Vector(0,0,5))
		HaxNPC:Spawn()
		HaxNPC:SetDamageOwner(self:GetOwner())
		
		timer.Simple(int,self.MakeHax,self,NumCreated,max,int)
	end
end

function ENT:Finish()
	util.EquipmentDestroyed(self:GetPos())
	
	self.Entity:Remove()
end