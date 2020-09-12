if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "ar2"

if CLIENT then

   SWEP.PrintName = "HK MP-5A2"			
   SWEP.Slot      = 2
  
   SWEP.Icon = "VGUI/ttt/icon_mp5"
end


SWEP.Base	= "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_MP5

SWEP.Primary.Damage      = 17
SWEP.Primary.Delay       = 0.12
SWEP.Primary.Cone        = 0.022
SWEP.Primary.ClipSize    = 15
SWEP.Primary.ClipMax     = 45
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 0.5
SWEP.Primary.Sound       = Sound( "Weapon_MP5Navy.Single" )
SWEP.AutoSpawnable      = false

SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.ViewModel = "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"

SWEP.Primary.Sound = Sound("Weapon_MP5Navy.Single")

SWEP.IronSightsPos = Vector(4.7659, -3.0823, 1.8818)
SWEP.IronSightsAng = Vector(0.9641, 0.0252, 0)

SWEP.HeadshotMultiplier = 1.6





