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

end

SWEP.Base				= "weapon_tttbase"
SWEP.UseHands = true
SWEP.ViewModel	= Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"
SWEP.Weight				= 5
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
SWEP.LimitedStock = false
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
		if IsValid(ply) then
			self.Weapon:SetClip1(self.Weapon:Clip1()-1)
			
			local HaxBox = ents.Create("ttt_haxbox")
			if IsValid(HaxBox) then
				HaxBox:SetPos(ply:GetShootPos())
				HaxBox:Spawn()
				HaxBox:SetOwner(self.Owner)
				
				local phys = HaxBox:GetPhysicsObject()
				local vvel = ply:GetVelocity()
				phys:SetVelocity(ply:GetAimVector()*300 + vvel)
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
      desc = "Drop the box. Watch the hax.\n\nHax attack innocents, traitors, and yourself!\nBox is destructible, disappears after 24 hax."
   };
end

//****************
//NOTE: NEEDS ICON
//****************
if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_haxbox.vmt")
end