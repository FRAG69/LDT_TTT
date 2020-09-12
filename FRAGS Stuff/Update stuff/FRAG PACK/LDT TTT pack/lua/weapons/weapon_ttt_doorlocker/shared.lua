//A door locking system, that should unlock after 30 seconds
//Created by my_hat_stinks
//Created 17 June 2011

//-----------------------------------------------------------
//Script
//-----------------------------------------------------------

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "melee"

if CLIENT then
   SWEP.PrintName = "Door Locker"
   SWEP.Slot      = 6 //Will be in slot 7

   SWEP.ViewModelFOV = 54
end

SWEP.Base				= "weapon_tttbase"
SWEP.ViewModel			= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"
SWEP.Weight			= 5
SWEP.DrawCrosshair		= false
SWEP.ViewModelFlip		= false

SWEP.Primary.Recoil	= 0.1
SWEP.Primary.Damage = 0
SWEP.Primary.Delay = 0.5
SWEP.Primary.Cone = 0.01
SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 12
SWEP.Primary.ClipMax = 12
SWEP.Primary.Ammo = "DoorlockerAmmo"
SWEP.AutoSpawnable = false
SWEP.AmmoEnt = ""

SWEP.Kind = WEAPON_EQUIP1

SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE}
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = false
SWEP.AllowDrop = true
SWEP.IsSilent = true
SWEP.NoSights = true

function SWEP:RemoveVariable(target) //Can't get a timer to set a value :P
	target.Locked = nil
end

local Target = nil
function SWEP:PrimaryAttack()
	if (self.Weapon:Clip1() >= 1) then
		//Crowbar Code (Slightly modified)
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		
		if self.Owner.LagCompensation then
			self.Owner:LagCompensation(true)
		end
		
		local spos = self.Owner:GetShootPos()
		local sdest = spos + (self.Owner:GetAimVector() * 70)

		local tr_main = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
		target = tr_main.Entity

		self.Weapon:EmitSound("Weapon_Crowbar.Single")

		if IsValid(target) or tr_main.HitWorld then
			self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
			self.Owner:LagCompensation(false)
			self.Owner:FireBullets({Num=1, Src=spos, Dir=self.Owner:GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=0})
		else
			self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
		end
		//End of Crowbar Code
		
		if (ValidEntity(target.Entity) and (target.Locked == nil)) then
			if ((target.Entity:GetClass() == "func_door_rotating") or (target.Entity:GetClass() == "prop_door_rotating") or (target.Entity:GetClass() == "func_door")) then
				target.Locked = 1
				self.Weapon:SetClip1(self.Weapon:Clip1() - 1)
				target.Entity:EmitSound("doors/door_latch1.wav")
				timer.Simple(30,target.Entity.EmitSound,target.Entity,"doors/door_latch3.wav")
				timer.Simple(30,self.RemoveVariable,self,target)
				if SERVER then
					target.Entity:Fire("lock","",0)
					target.Entity:Fire("unlock","",30)
				end
			end
		end

		if self.Owner.LagCompensation then
			self.Owner:LagCompensation(false)
		end
	end
end


//-----------------------------------------------------------
//Icon
//-----------------------------------------------------------

//I don't have an icon to add, leaving the default code here

-- Equipment menu information is only needed on the client
if CLIENT then
   -- Path to the icon material
   SWEP.Icon = "VGUI/ttt/icon_padlock"

   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Equipment",
      desc = "This will temporary lock doors, allowing \nyou to either trap people or slow them down."
   };
end

-- Tell the server that it should download our icon to clients.
if SERVER then
   -- It's important to give your icon a unique name. GMod does NOT check for
   -- file differences, it only looks at the name. This means that if you have
   -- an icon_ak47, and another server also has one, then players might see the
   -- other server's dumb icon. Avoid this by using a unique name.
   resource.AddFile("materials/VGUI/ttt/icon_padlock.vmt")
end