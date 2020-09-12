---- Anvil

AddCSLuaFile()

if CLIENT then
	ENT.PrintName = "anvil"
	ENT.Icon = "vgui/ttt/icon_anvil"
end

ENT.Type = "anim"
ENT.Model = Model("models/ldtprops/anvil.mdl")

ENT.Projectile = true
ENT.CanHavePrints = false

ENT.Falling = true
ENT.DamageMin = 50
ENT.DamageMax = 300

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	
	if SERVER then
		self:SetGravity(0.8)
		self:SetFriction(1.0)
		self:SetElasticity(0.1)

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(20000)
		end
	end
	
	self.StartPos = self:GetPos()
end

function ENT:SetPlanter(ply)
	self.Planter = ply
end

ENT.klonkSound = Sound( "physics/metal/metal_grate_impact_hard2.wav" )
ENT.squishSound = Sound( "physics/flesh/flesh_squishy_impact_hard3.wav" )
function ENT:PlayCrushSounds()
	self:EmitSound( self.klonkSound,  200, 80, 1, CHAN_AUTO)
	self:EmitSound( self.squishSound, 200, 90, 1, CHAN_AUTO)
end