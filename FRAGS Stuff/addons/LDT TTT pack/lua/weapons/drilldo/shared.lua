if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

if( CLIENT ) then
	SWEP.PrintName = "Drilldo";
	SWEP.Slot = 3;
	SWEP.SlotPos = 3;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	killicon.Add( "drilldoicon", "drilldo/deathicon", Color( 255, 170, 181, 255 ) );
	killicon.AddAlias( "drilldo", "drilldoicon" );
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.NextStrike = 0;
  
SWEP.ViewModel      = "models/jaanus/v_drilldo.mdl"
SWEP.WorldModel   = "models/jaanus/w_drilldo.mdl"
 resource.AddFile("VGUI/entities/drilldo")
 SWEP.Icon = "VGUI/entities/drilldo"
  
-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay			= 0.001 	--In seconds
SWEP.Primary.Recoil			= 0		--Gun Kick
SWEP.Primary.Damage			= 30	--Damage per Bullet
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= true	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "none"	--Ammo Type
SWEP.CanBuy = {ROLE_DETECTIVE}  --What kind of team mate can buy it
 
-------------Secondary Fire Attributes-------------------------------------
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"

util.PrecacheSound("vo/npc/male01/yeah02.wav")
util.PrecacheSound("physics/rubber/rubber_tire_impact_hard1.wav")
util.PrecacheSound("physics/rubber/rubber_tire_impact_hard2.wav")
util.PrecacheSound("physics/rubber/rubber_tire_impact_hard3.wav")
util.PrecacheSound("physics/flesh/flesh_strider_impact_bullet1.wav")
util.PrecacheSound("physics/flesh/flesh_strider_impact_bullet2.wav")
util.PrecacheSound("physics/flesh/flesh_strider_impact_bullet3.wav")
util.PrecacheSound("weapons/crossbow/hitbod1.wav")
util.PrecacheSound("weapons/crossbow/hitbod2.wav")
util.PrecacheSound("weapons/drilldo/rev.wav")


function SWEP:Initialize()
	if( SERVER ) then
		self:SetWeaponHoldType( "pistol" );
	end
	self.Hit = { 
	Sound( "physics/rubber/rubber_tire_impact_hard1.wav" ),
	Sound( "physics/rubber/rubber_tire_impact_hard2.wav" ),
	Sound( "physics/rubber/rubber_tire_impact_hard3.wav" ) };
	self.FleshHit = {
  	Sound( "physics/flesh/flesh_strider_impact_bullet1.wav" ),
	Sound( "physics/flesh/flesh_strider_impact_bullet2.wav" ),
	Sound( "physics/flesh/flesh_strider_impact_bullet3.wav" ),
	util.PrecacheSound("weapons/crossbow/hitbod1.wav"),
	util.PrecacheSound("weapons/crossbow/hitbod2.wav"),
	util.PrecacheSound("weapons/crossbow/hitbod3.wav"), };

end

function SWEP:Precache()
end

function SWEP:Deploy()
	self.Owner:EmitSound( "vo/npc/male01/yeah02.wav" );
	return true;
end

function SWEP:PrimaryAttack()
	if( CurTime() < self.NextStrike ) then return; end
	self.NextStrike = ( CurTime() + .2 );
 	local trace = self.Owner:GetEyeTrace();
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 70 then
		if( trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass()=="prop_ragdoll" ) then
			self.Owner:EmitSound( self.FleshHit[math.random(1,#self.FleshHit)] );
			self.Weapon:EmitSound("weapons/drilldo/rev.wav")
		else
			self.Owner:EmitSound( self.Hit[math.random(1,#self.Hit)] );
			self.Weapon:EmitSound("weapons/drilldo/rev.wav")
		end
			self.Owner:SetAnimation( PLAYER_ATTACK1 );
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
				bullet = {}
				bullet.Num    = 1
				bullet.Src    = self.Owner:GetShootPos()
				bullet.Dir    = self.Owner:GetAimVector()
				bullet.Spread = Vector(0, 0, 0)
				bullet.Tracer = 0
				bullet.Force  = 1
				bullet.Damage = 10
			self.Owner:FireBullets(bullet) 
	else
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
		self.Weapon:EmitSound("weapons/drilldo/rev.wav")
	end
end

if (SERVER) then
	resource.AddFile( "sound/weapons/drilldo/rev.wav" )
	resource.AddFile( "models/jaanus/dildo.mdl" )
	resource.AddFile( "models/jaanus/v_drilldo.mdl" )
	resource.AddFile( "models/jaanus/w_drill.mdl" )
	resource.AddFile( "models/jaanus/w_drilldo.mdl" )
	resource.AddFile( "materials/VGUI/entities/drilldo.vmt" )
	resource.AddFile( "materials/VGUI/entities/drilldo.vtf" )
	resource.AddFile( "materials/jaanus/dildo.vmt" )
	resource.AddFile( "materials/jaanus/dildo.vtf" )
	resource.AddFile( "materials/jaanus/dildo_n.vtf" )
	resource.AddFile( "materials/jaanus/drill.vmt" )
	resource.AddFile( "materials/jaanus/drill.vtf" )
	resource.AddFile( "materials/jaanus/drill_n.vtf" )
	resource.AddFile( "materials/drilldo/deathicon.vmt" )
	resource.AddFile( "materials/drilldo/deathicon.vtf" )
end