 if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile( "materials/VGUI/ttt/ldttttgodeagle.vtf" )
   resource.AddFile( "materials/VGUI/ttt/ldttttgodeagle.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/Havoc Deagle/bullet.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/Havoc Deagle/bullet.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/Havoc Deagle/Golden 2 toned norm.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/Havoc Deagle/Golden 2 toned.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/Havoc Deagle/grip.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/Havoc Deagle/grip.vmt" )
   resource.AddFile( "materials/models/weapons/v_models/Havoc Deagle/grip_normal.vtf" )
   resource.AddFile( "materials/models/weapons/v_models/Havoc Deagle/main.vmt" )
   resource.AddFile( "models/weapons/v_pist_geagle.dx80.vtx" )
   resource.AddFile( "models/weapons/v_pist_geagle.dx90.vtx" )
   resource.AddFile( "models/weapons/v_pist_geagle.mdl" )
   resource.AddFile( "models/weapons/v_pist_geagle.sw.vtx" )
   resource.AddFile( "models/weapons/v_pist_geagle.vvd" )
   resource.AddFile( "sound/gdeagle/gdeagle-1.wav" )
   resource.AddFile( "sound/gdeagle/gdeagledeploy.wav" )
   resource.AddFile( "sound/gdeagle/gdeaglereload.wav" )
end

if CLIENT then
   SWEP.PrintName= "Brain Buster"
   SWEP.Author= "Kazaki"

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = [[
		A Badass Deagle.
		Deals more damage.
		Has bigger Clip size.
		Bullets Have a Burn Effect!]]
   };
   
   SWEP.Slot= 1

   SWEP.Icon = "VGUI/ttt/ldttttgodeagle"
end

SWEP.HoldType = "pistol"

SWEP.Base= "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_PISTOL


SWEP.Primary.Ammo       = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil= 5
SWEP.Primary.Damage = 40
SWEP.Primary.Delay = 0.6
SWEP.Primary.Cone = 0.01
SWEP.Primary.ClipSize = 10
SWEP.Primary.ClipMax = 40
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Automatic = true

SWEP.HeadshotMultiplier = 4

SWEP.AutoSpawnable      = false
SWEP.AmmoEnt = "item_ammo_revolver_ttt"
SWEP.Primary.Sound= Sound( "gdeagle/gdeagle-1.wav" )
SWEP.ViewModel= "models/weapons/v_pist_geagle.mdl"
SWEP.WorldModel= "models/weapons/w_pist_deagle.mdl"

SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.LimitedStock = true
SWEP.InLoadoutFor = nil
SWEP.AllowDrop = true

SWEP.IronSightsPos 	= Vector( 3.8, -1, 2.6 )

function SWEP:Deploy()
   self.Weapon:EmitSound("gdeagle/gdeagledeploy.wav")
end

function SWEP:Reload()
 
	if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
	self:SetIronsights( false )
	if ( self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
 
	self:DefaultReload( ACT_VM_RELOAD )
	local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
	self.ReloadingTime = CurTime() + AnimationTime
	self:SetNextPrimaryFire(CurTime() + AnimationTime)
	self:SetNextSecondaryFire(CurTime() + AnimationTime)
	self.Weapon:EmitSound("gdeagle/gdeaglereload.wav")
 
	end
 
end

function SWEP:PrimaryAttack(worldsnd)

   self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      WorldSound(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
   
	local tr = self.Owner:GetEyeTrace()
   	local effectdata = EffectData()
	effectdata:SetOrigin(tr.HitPos)
	effectdata:SetNormal(tr.HitNormal)
	effectdata:SetScale(1)
	util.Effect("effect_mad_ignition", effectdata)

	util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	
			local tracedata = {}
			tracedata.start = tr.HitPos
			tracedata.endpos = Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z - 10)
			tracedata.filter = tr.HitPos
			local tracedata = util.TraceLine(tracedata)
			if SERVER then
			if tracedata.HitWorld then
				local flame = ents.Create("env_fire");
				flame:SetPos(tr.HitPos + Vector( 0, 0, 1 ));
				flame:SetKeyValue("firesize", "10");
				flame:SetKeyValue("fireattack", "10");
				flame:SetKeyValue("StartDisabled", "0");
				flame:SetKeyValue("health", "10");
				flame:SetKeyValue("firetype", "0");
				flame:SetKeyValue("damagescale", "5");
				flame:SetKeyValue("spawnflags", "128");
				flame:Spawn();
				flame:Fire("StartFire",0);
			end
			end
   self:TakePrimaryAmmo( 1 )

   local owner = self.Owner   
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
   
   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
end