//Crate of Hax (manhacks)
//Created by my_hat_stinks
//Created 08 September 2011

//-----------------------------------------------------------
//Script
//-----------------------------------------------------------

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "normal"

if CLIENT then
   SWEP.PrintName = "Crate of Hax"
   SWEP.Slot      = 6 //Will be in slot 7

   SWEP.ViewModelFOV = 10
end

SWEP.Base				= "weapon_tttbase"
SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"
SWEP.Weight			= 5
SWEP.DrawCrosshair		= false
SWEP.ViewModelFlip		= false

SWEP.Primary.Delay       = -1
SWEP.Primary.Recoil      = -1
SWEP.Primary.Automatic   = false
SWEP.Primary.Damage      = -1
SWEP.Primary.Cone        = -1
SWEP.Primary.Ammo        = "HaxCrates"
SWEP.Primary.ClipSize    = 1
SWEP.Primary.ClipMax     = 1
SWEP.Primary.DefaultClip = 1

SWEP.Kind = WEAPON_EQUIP1

SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = true
SWEP.AllowDrop = false
SWEP.IsSilent = true
SWEP.NoSights = true


function SWEP:PrimaryAttack()
	if (self.Weapon:Clip1() < 1) then
		self:Remove()
		return
	end
	
	if SERVER then
		local ply = self.Owner
		if ValidEntity(ply) then
			self.Weapon:SetClip1(self.Weapon:Clip1()-1)
			
			local HaxBox = ents.Create("ent_ttt_haxbox")
			if IsValid(HaxBox) then
				HaxBox:SetPos(ply:GetShootPos())
				HaxBox:Spawn()
				HaxBox:SetOwner(self.Owner)
				
				local phys = HaxBox:GetPhysicsObject()
				phys:SetVelocity(ply:GetAimVector()*100)
				
				timer.Simple(4,HaxBox.MakeHax,HaxBox,0,15,0.5)
			end
			self:Remove()
		end
	end
end


//-----------------------------------------------------------
//Equipment Menu
//-----------------------------------------------------------

if CLIENT then
   SWEP.Icon = "materials/VGUI/ttt/icon_haxbox"

   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Drop a crate. Watch the manhacks.\n\nAlso attacks teammates"
   };
end

//****************
//NOTE: NEEDS ICON
//****************
if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_haxbox.vmt")
end