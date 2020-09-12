AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.Entity:DrawShadow( false )
	self.Entity:SetModel( "models/props_junk/cardboard_box003a.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:SetTrigger( true )
	
	self:GetPhysicsObject():SetMass(200)
	
	self:SetMaxHealth(80)
	self:SetHealth(80)
	
	self.NumCreated = 0
	self.MaxCreated = 24
	self.MaxAlive = 12
	self.Hax = {}
	
	function self:MakeHax()
		local NumAlive = 0
		for k,v in pairs(self.Hax) do
			if v && IsValid(v) then
				NumAlive = NumAlive + 1
			end
		end
		
		//If enough are alive, wait a bit
		if NumAlive >= self.MaxAlive then
			timer.Simple( 10, function() if self and IsValid(self) then self:MakeHax() end end)
			return
		end
	
		//Increment
		self.NumCreated = self.NumCreated + 1
		
		//Spawn one
		local Pos = self.Entity:GetPos()
		local HaxNPC = ents.Create("npc_manhack")
		HaxNPC:SetPos(Pos + Vector(0,0,8))
		HaxNPC:Spawn()
		HaxNPC:SetDamageOwner(self:GetOwner())
		table.insert (self.Hax, HaxNPC)
		
		//Now we delete
		if (self.NumCreated >= self.MaxCreated) then
			self:Remove()
			return
		end
		
		//Spawn 5 fast, the rest slow
		if (self.NumCreated < 5) then
			timer.Simple( 0.5, function() if self and IsValid(self) then self:MakeHax() end end)
		else
			timer.Simple( 2, function() if self and IsValid(self) then self:MakeHax() end end)
		end
	end
	
	timer.Simple( 5, function() if self and IsValid(self) then self:MakeHax() end end)
end

