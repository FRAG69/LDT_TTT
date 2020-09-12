if SERVER then

   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "crossbow"


if CLIENT then

   SWEP.PrintName			= "Galil"

   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/icon_ldtgalil"

   SWEP.ViewModelFlip		= false
end


SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M16


SWEP.Primary.Damage = 16
SWEP.Primary.Delay = 0.09
SWEP.Primary.Cone = 0.12
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.AmmoEnt                = "item_ammo_smg1_ttt"
SWEP.AutoSpawnable      = true
SWEP.Primary.Recoil			= 1.0
SWEP.Primary.Sound			= Sound("Weapon_Galil.Single")
SWEP.ViewModel			= "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_galil.mdl"

SWEP.HeadshotMultiplier = 2.2

SWEP.IronSightsPos 		= Vector( -4.9, -4, 4 )
