if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "ar2"

if CLIENT then

   SWEP.PrintName = "Famas"
   SWEP.Slot = 2

   SWEP.Icon = "VGUI/ttt/icon_mac"
   
   SWEP.ViewModelFlip   = false
end


SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_MAC10

SWEP.Primary.Damage      = 12
SWEP.Primary.Delay       = 0.065
SWEP.Primary.Cone        = 0.1
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 1.05
SWEP.Primary.Sound       = Sound( "Weapon_Famas.Single" )

SWEP.AutoSpawnable = true

SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.ViewModel  = "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"

SWEP.IronSightsPos = Vector( -3, -3, 4 )
SWEP.IronSightsAng = Vector( 1.5, 0, 9.0 )

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 2 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 150)
 

    -- decay from 3.2 to 1.7
   return 1.5 + math.max(0, (1.5 - 0.002 * (d ^ 1.25)))
end