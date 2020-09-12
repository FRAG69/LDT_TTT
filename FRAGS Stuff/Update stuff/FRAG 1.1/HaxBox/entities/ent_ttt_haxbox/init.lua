AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.Entity:DrawShadow( false )
	self.Entity:SetModel( "models/props_junk/cardboard_box003a.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self.Entity:SetTrigger( true )
end