
-- traitor equipment: dildo cannon

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "rpg"

if CLIENT then
   SWEP.PrintName			= "Dildo Cannon"
   SWEP.Slot				= 7

   SWEP.EquipMenuData = {
      type  = "item_weapon",
      name  = "Dildo Cannon",
      desc  = "Time for a Cock Slap!"
   };

   SWEP.Icon = "VGUI/ttt/dildo_cannon"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID = AMMO_C4

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel  = Model("models/weapons/v_RPG.mdl")
SWEP.WorldModel = Model("models/weapons/w_rocket_launcher.mdl")

SWEP.DrawCrosshair      = true
SWEP.ViewModelFlip      = false
SWEP.Primary.ClipSize       = 1
SWEP.Primary.DefaultClip    = 1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = 0.5

SWEP.NoSights = true

local throwsound = Sound( "weapons/crossbow/fire1.wav" )

function SWEP:FireProp(model)
	local tr = self.Owner:GetEyeTrace()
	
	self.Weapon:EmitSound( "weapons/crossbow/fire1.wav" )
	self.BaseClass.ShootEffects(self)
 
	if not SERVER then return end
 
	local ent = ents.Create("prop_physics")
	ent:SetModel(model)
 
	ent:SetPos(self.Owner:EyePos())
	ent:SetOwner(self.Owner)
	local ang = self.Owner:EyeAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	ent:SetAngles(ang)
	ent:Spawn()
	
	ent:SetColor(math.Rand(0, 1) * 255, math.Rand(0, 1) * 255, math.Rand(0, 1) * 255, 255)
 
	local phys = ent:GetPhysicsObject()
	
	phys:SetMass(200)
	phys:SetMaterial("gmod_bouncy")
 
	local shot_length = tr.HitPos:Length()
	phys:ApplyForceCenter(self.Owner:GetAimVector():GetNormalized() *  math.pow(shot_length, 3))
 
	cleanup.Add(self.Owner, "props", ent)
 
	undo.Create("Dildooo")
	undo.AddEntity(ent)
	undo.SetPlayer(self.Owner)
	undo.Finish()
end

function SWEP:PrimaryAttack()
if not (IsValid(self.Owner) and self.Owner:Alive()) then return end
	if (self.Weapon:Clip1() <= 0) then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:SendWeaponAnim( ACT_VM_THROW )
	
	self:FireProp( "models/weapons/dildo2.mdl" )
	self.Weapon:SetClip1( self.Weapon:Clip1() - 1)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end
