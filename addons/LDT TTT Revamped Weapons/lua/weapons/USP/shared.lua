if SERVER then
   AddCSLuaFile( "shared.lua" )
end


SWEP.HoldType			= "pistol"


if CLIENT then
   SWEP.PrintName = "HK USP"
   SWEP.Slot = 2
   SWEP.Icon = "VGUI/ttt/icon_silenced"
end


SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil	= 1.35
SWEP.Primary.Damage = 24
SWEP.Primary.Delay = 0.21
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 12
SWEP.Primary.ClipMax = 36
SWEP.Primary.Ammo = "Pistol"


SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_SIPISTOL


SWEP.AmmoEnt = "item_ammo_pistol_ttt"


SWEP.IsSilent = false


SWEP.ViewModel			= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"


SWEP.Primary.Sound = Sound( "weapons/usp/usp1.wav" )



SWEP.IronSightsPos = Vector( 4.48, -4.34, 2.75)
SWEP.IronSightsAng = Vector(-0.5, 0, 0)


SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED


function SWEP:Deploy()
   self.Weapon:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
   return true
end


-- We were bought as special equipment, and we have an extra to give
function SWEP:WasBought(buyer)
   if IsValid(buyer) then -- probably already self.Owner
      buyer:GiveAmmo( 20, "Pistol" )
   end
end
