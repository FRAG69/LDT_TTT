//Running shoes, makes the user run faster
//Created by my_hat_stinks
//Created 15 July 2011

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "normal"

if CLIENT then
   SWEP.PrintName = "Running Shoes"
   SWEP.Slot      = 7 //Will be in slot 8
end

SWEP.Base				= "weapon_tttbase"
SWEP.UseHands 			= true
SWEP.ViewModel			= Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel         = "models/props_junk/shoe001a.mdl"
SWEP.Weight				= 5
SWEP.DrawCrosshair		= false
SWEP.ViewModelFlip		= false

SWEP.Primary.Delay       = -1
SWEP.Primary.Recoil      = -1
SWEP.Primary.Automatic   = false
SWEP.Primary.Damage      = -1
SWEP.Primary.Cone        = -1
SWEP.Primary.Ammo        = "none"
SWEP.Primary.ClipSize    = -1
SWEP.Primary.ClipMax     = -1
SWEP.Primary.DefaultClip = -1

SWEP.Kind = WEAPON_EQUIP2

SWEP.CanBuy = { ROLE_DETECTIVE }
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = true
SWEP.AllowDrop = true
SWEP.IsSilent = true
SWEP.NoSights = true

if SERVER then
	function SWEP:PrimaryAttack()
	end
	function SWEP:SecondaryAttack()
	end
	function SWEP:Reload()
	end

	--Taps into how TTT sets player speed
	hook.Add("TTTPlayerSpeed", "HOLD_UP", function(ply)
		if ply:HasWeapon("weapon_ttt_run") then
			return 1.2
		else 
			return 1
		end

	end)
end

//-----------------------------------------------------------
//Icon
//-----------------------------------------------------------

-- Equipment menu information is only needed on the client
if CLIENT then
   -- Path to the icon material
   SWEP.Icon = "VGUI/ttt/icon_shoes"

   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Shoes more fit for fast movement than \nthe standard issue heavy boots."
   };
end

if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_shoes.vmt")
end