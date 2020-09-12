//Running shoes, makes the user run faster
//Created by my_hat_stinks
//Created 15 July 2011

//-----------------------------------------------------------
//Script
//-----------------------------------------------------------

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "normal"

if CLIENT then
   SWEP.PrintName = "Running Shoes"
   SWEP.Slot      = 7 //Will be in slot 8

   SWEP.ViewModelFOV = 10
end

SWEP.Base				= "weapon_tttbase"
SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/props_junk/shoe001a.mdl"
SWEP.Weight			= 5
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
SWEP.LimitedStock = false
SWEP.AllowDrop = true
SWEP.IsSilent = true
SWEP.NoSights = true

function SWEP:Equip(NewOwner)
	if (NewOwner:IsPlayer()) then
		self.Wearer = NewOwner
		if (self.Wearer.Shoe == nil) then
			self.Wearer.Shoe = self.Weapon
			local CurSpeed = self.Wearer:GetMaxSpeed()
			local NewSpeed = CurSpeed + 100
			if (self.Wearer:IsValid()) then
				self.Wearer:SetMaxSpeed(NewSpeed)
			end
		else
			Msg("Lua Error: Shoes equipped while user is wearing shoes!\n")
		end
	end
end

function SWEP:OnDrop()
	if (self.Wearer:IsPlayer()) then
		local CurSpeed = self.Wearer:GetMaxSpeed()
		local NewSpeed = CurSpeed - 100
		
		self.Wearer:SetMaxSpeed(NewSpeed)
		
		self.Wearer.Shoe = nil
	end
	self.Wearer = nil
end

//Making sure you can't attack (Throwing boots is silly)
function SWEP:PrimaryAttack()
end
function SWEP:SecondaryAttack()
end
function SWEP:Reload()
end

//-----------------------------------------------------------
//Icon
//-----------------------------------------------------------

//I don't have an icon to add, leaving the default code here

//************************************************************
//****FRAG - Remember to edit this bit, you silly person!*****
//************************************************************

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

-- Tell the server that it should download our icon to clients.
if SERVER then
   -- It's important to give your icon a unique name. GMod does NOT check for
   -- file differences, it only looks at the name. This means that if you have
   -- an icon_ak47, and another server also has one, then players might see the
   -- other server's dumb icon. Avoid this by using a unique name.
   resource.AddFile("materials/VGUI/ttt/icon_shoes.vmt")
end