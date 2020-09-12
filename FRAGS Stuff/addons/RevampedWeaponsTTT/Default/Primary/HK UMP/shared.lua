if SERVER then
   AddCSLuaFile( "shared.lua" )
end


SWEP.HoldType = "ar2"


if CLIENT then
   SWEP.PrintName = "HK UMP"
   SWEP.Slot      = 2


   SWEP.Icon = "VGUI/ttt/icon_ump"


   SWEP.ViewModelFOV = 72


end




SWEP.Base = "weapon_tttbase"


SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_STUN

SWEP.Primary.Damage = 18
SWEP.Primary.Delay = 0.075
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 25
SWEP.Primary.ClipMax = 75
SWEP.Primary.DefaultClip	= 25
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.AutoSpawnable      = false
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Primary.Recoil		= 1.2
SWEP.Primary.Sound		= Sound( "Weapon_UMP45.Single" )
SWEP.ViewModel			= "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"


SWEP.HeadshotMultiplier = 1.7


SWEP.IronSightsPos = Vector( 7.3, -5.5, 3.2 )
SWEP.IronSightsAng = Vector( -1.5, 0.35, 2 )
