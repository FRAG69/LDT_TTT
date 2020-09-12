if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "ar2"

if CLIENT then

   SWEP.PrintName = "P90"
   SWEP.Slot = 2

   SWEP.Icon = "VGUI/ttt/icon_mac"
end


SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_MAC10

SWEP.Primary.Damage      = 12
SWEP.Primary.Delay       = 0.065
SWEP.Primary.Cone        = 0.03
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 1.15
SWEP.Primary.Sound       = Sound( "Weapon_P90.Single" )

SWEP.AutoSpawnable = true

SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.ViewModel  = "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"

SWEP.IronSightsPos = Vector(4.4, -3, 2.3)
SWEP.IronSightsAng = Vector(9, -1, 0)
SWEP.SightsPos = Vector(1.279, 0, 0.6)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-2.296, -1.968, -0.657)
SWEP.RunSightsAng = Vector(0, -46.475, -5.738)

SWEP.DeploySpeed = 3

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 2 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 150)

   -- decay from 3.2 to 1.7
   return 1.7 + math.max(0, (1.5 - 0.002 * (d ^ 1.25)))
end
