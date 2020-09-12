ENT.Type = "anim"
ENT.PrintName = ""
ENT.Author = "FRAG" -- Code based on trip mine from The Stalker made by Rambo_6 (aka Sechs)
ENT.Purpose	= ""

function ENT:OnTakeDamage(dmginfo)
	if (self.Laser.Tripped) then return end
	
   self:TakePhysicsDamage(dmginfo)

   self.EntHealth = self.EntHealth - dmginfo:GetDamage()


   if (self.EntHealth <= 0) then
	  local att = dmginfo:GetAttacker()
	  if IsPlayer(att) then
		 DamageLog(Format("%s destroyed a tripmine",
						  att:Nick()))
	  end
	  
      if SERVER then self:Disarm() end
   end
end