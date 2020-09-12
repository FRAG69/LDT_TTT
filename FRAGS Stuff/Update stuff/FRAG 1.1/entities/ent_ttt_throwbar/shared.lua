ENT.Type = "anim"
ENT.PrintName = ""
ENT.Author = "my_hat_stinks"
ENT.Purpose	= "Throw at people"

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( "models/weapons/w_crowbar.mdl" )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:DrawShadow( false )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		//self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self.Entity:SetTrigger( true )
	end
end

function ENT:Use()
	self:StartTouch(nil)
end

function ENT:StartTouch(ent)
	if ent == self.Owner then return end
	
	local Pos = self.Entity:GetPos()
	local Vel = self.Entity:GetVelocity()
	
	if IsEntity(ent) then
		local dmg = math.Min(Vel:Length()/7,60)
		ent:TakeDamage(dmg,self.Owner,self.Entity)
		
		local ply = ent
		if SERVER and ply:IsPlayer() and (not ply:IsFrozen()) then
			ply.was_pushed = {att=owner, t=CurTime()}
			local pushvel = self.Entity:GetVelocity()*2

			pushvel.z = math.max(pushvel.z, 20)

			ply:SetGroundEntity(nil)
			ply:SetLocalVelocity(ply:GetVelocity() + pushvel)
		end
	end
	
	local Throwbar = ents.Create("weapon_ttt_throwbar")
	Throwbar:SetPos(Pos)
	Throwbar:SetLocalVelocity(Vel)
	Throwbar:SetAngles(self.Entity:GetAngles())
	Throwbar:Spawn()
	Throwbar.IsDropped = true
	
	self:Remove()
end