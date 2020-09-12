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
   SWEP.Icon = "materials/VGUI/ttt/icon_ttt_haxbox"
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
				
				local phys = HaxBox:GetPhysicsObject()
				phys:SetVelocity(ply:GetAimVector()*100)
				
				timer.Simple(2,HaxBox.MakeHax,HaxBox,0,15,0.5)
			end
			self:Remove()
		end
	end
end


-- Equipment menu information is only needed on the client
if CLIENT then
   -- Path to the icon material
   SWEP.Icon = "VGUI/ttt/icon_ttt_haxbox"

   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Drop a crate. Watch the manhacks.\n\nAlso attacks teammates."
   };
end

-- Tell the server that it should download our icon to clients.
if SERVER then
   -- It's important to give your icon a unique name. GMod does NOT check for
   -- file differences, it only looks at the name. This means that if you have
   -- an icon_ak47, and another server also has one, then players might see the
   -- other server's dumb icon. Avoid this by using a unique name.
   resource.AddFile("materials/VGUI/ttt/icon_ttt_haxbox.vmt")
end