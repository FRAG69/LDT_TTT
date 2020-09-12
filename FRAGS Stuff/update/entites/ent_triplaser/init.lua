
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local sndOnline = Sound( "weapons/tripwire/mine_activate.wav" )
local sndPass = Sound( "buttons/blip2.wav" )
local sndFail = Sound( "buttons/weapon_cant_buy.wav" )

function ENT:Think()
	if ( self:GetActiveTime() == 0 || self:GetActiveTime() > CurTime() ) then return end
	if ( self.Activated ) then return end
	
	self.Activated = true
	self.Entity:GetOwner():EmitSound( sndOnline )
end


function ENT:StartTouch( ent )
	if ( self:GetActiveTime() == 0 || self:GetActiveTime() > CurTime() ) then return end
	if (self.Tripped) then return end
	if (GetRoundState() == ROUND_POST) then return end

	if ent:IsPlayer() then
		if (self.User:GetTraitor()) then
			if (ent:GetTraitor()) then
				self.Entity:EmitSound(sndPass,35)
			else
				self.Entity:EmitSound(sndFail,70)
				self.Tripped = true
				timer.Simple(0.4,self.Explode,self)
			end		
		else
			if (ent == self.User) then
				self.Entity:EmitSound(sndPass,35)
			else
				self.Entity:EmitSound(sndFail,70)
				self.Tripped = true
				timer.Simple(0.4,self.Explode,self)
			end
		end
	end

end


