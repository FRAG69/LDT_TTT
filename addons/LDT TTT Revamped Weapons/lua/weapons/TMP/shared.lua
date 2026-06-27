if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "ar2"

if CLIENT then

   SWEP.PrintName			= "Steyr TMP"
   SWEP.Slot				= 2
   SWEP.Icon = "VGUI/ttt/icon_tmp"
end

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_HEAVY

SWEP.Primary.Damage      = 8
SWEP.Primary.Delay       = 0.077
SWEP.Primary.Cone        = 0.06
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 90
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 1.7
SWEP.Primary.Sound       = Sound( "Weapon_mac10.Single" )
SWEP.AutoSpawnable      = false


SWEP.AmmoEnt = "item_ammo_smg1_ttt"


SWEP.ViewModel			= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_tmp.mdl"

SWEP.Primary.Sound = Sound( "Weapon_tmp.Single" )
SWEP.Primary.SoundLevel = 75

SWEP.IronSightsPos = Vector( 5, -5, 2.2091 )
SWEP.IronSightsAng = Vector( 5, -1.5, 0 )

SWEP.HeadshotMultiplier = 1.6
