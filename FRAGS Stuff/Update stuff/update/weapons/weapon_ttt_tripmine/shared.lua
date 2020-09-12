// FRAG's Tripmine
// created 20 June 2011
//Editted by my_hat_stinks, 16 July 2011

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "normal"

if CLIENT then
   SWEP.PrintName			= "Tripmine"
   SWEP.Slot				= 6
   SWEP.SlotPos			= 0
   SWEP.ViewModelFOV = 10

   SWEP.EquipMenuData = {
      type="item_weapon",
      model="models/weapons/w_eq_smokegrenade.mdl",
      desc="A laser triggered mine. \n \n Emits a bleep when triggered."
   };

   SWEP.Icon = "VGUI/ttt/ttt_tripmine"
end


SWEP.Base = "weapon_tttbase"
SWEP.Spawnable          = true
SWEP.AdminSpawnable     = false
SWEP.ViewModel          = "models/weapons/v_eq_smokegrenade.mdl"
SWEP.WorldModel         = "models/weapons/w_eq_smokegrenade.mdl"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false
SWEP.DrawCrosshair      = true
SWEP.ViewModelFlip      = false
SWEP.Primary.ClipSize       = 1
SWEP.Primary.DefaultClip    = 1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo       = "slam"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize     = 1
SWEP.Secondary.DefaultClip  = 1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.0

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} 
SWEP.LimitedStock = false -- multibuy #TEST#
SWEP.WeaponID = AMMO_SLAM

SWEP.AllowDrop = true
SWEP.NoSights = true

//Preload
util.PrecacheSound("weapons/slam/mine_mode.wav")

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Precache()
end

SWEP.AddedUpgradeAmmo = false
function SWEP:Deploy()
	if self.Weapon:Clip1() <= 0 then
		if (IsValid(self) and IsEntity(self)) then
			self:Remove()
		elseif SERVER then
			MsgN("Tripmine: Failed to remove on Deploy - Already removed?")
		end
		return
	end
	if SERVER then
		if self.Owner:HasBought("detecttodestroy") and not self.AddedUpgradeAmmo then
			self.AddedUpgradeAmmo = true
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
		end
	end
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end

function SWEP:PrimaryAttack()
	if (self.Weapon:Clip1() <= 0) then return end
	
	/*if( CurTime() < self.NextPlant ) or not self:CanPrimaryAttack() then return end
		self.NextPlant = ( CurTime() + .8 ); */
	//
	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64
	trace.mask = MASK_NPCWORLDSTATIC
	trace.filter = self.Owner
	local tr = util.TraceLine( trace )
	//

	if ( tr.Hit ) then
		local ent = ents.Create ("ent_tripmine")
		if ( ent ~= nil and ent:IsValid() ) then
			ent:SetPos(tr.HitPos)
			//ent:SetOwner(self.Owner)
			ent.User = self.Owner
			ent:Spawn()
			ent:Activate()
			ent.EntHealth = 300
			self.Owner:EmitSound( "weapons/slam/mine_mode.wav" )
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			timer.Create("trippulltimer",0.8,1,function()
				if (IsValid(self) and IsEntity(self)) then
					self:Remove()
				elseif SERVER then
					MsgN("Tripmine: Failed to remove on Placement - Already removed?")
				end
			end,self)
			ent:GetTable():StartTripmineMode( tr.HitPos + tr.HitNormal, tr.HitNormal )
			
			self:TakePrimaryAmmo( 1 )
		end
	end
end

 function SWEP:Reload() 
	return false
 end  

function SWEP:SecondaryAttack()
end 

function SWEP:OnDrop()
	if self.Weapon:Clip1() <= 0 then
		if (IsValid(self) and IsEntity(self)) then
			self:Remove()
		elseif SERVER then
			MsgN("Tripmine: Failed to remove on Drop - Already removed?")
		end
		return
	end
end

if CLIENT then
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( "4", "HL2MPTypeDeath", x + wide/2, y + tall*0.3, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
		// Draw weapon info box
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end
end
