---- Example TTT custom weapon


-- First some standard GMod stuff
if SERVER then
AddCSLuaFile( "shared.lua" )
resource.AddFile("materials/VGUI/ttt/ttt_cannibalism.vmt")
resource.AddFile("materials/VGUI/ttt/ttt_cannibalism.vtf")
resource.AddFile("sound/ttt/TriggNOM.mp3")
end

if CLIENT then
SWEP.PrintName = "Cannibalism"
SWEP.Slot      = 7 -- add 1 to get the slot number key

SWEP.ViewModelFOV  = 72
SWEP.ViewModelFlip = true
end

-- Always derive from weapon_tttbase.
SWEP.Base				= "weapon_tttbase"

--- Standard GMod values

SWEP.HoldType			= "melee"

SWEP.Primary.Delay       = 10
SWEP.Primary.Recoil      = 0
SWEP.Primary.Automatic   = false
SWEP.Primary.Damage      = 0
SWEP.Primary.Cone        = 0.025
SWEP.Primary.Ammo        = ""
SWEP.Primary.ClipSize    = 1
SWEP.Primary.ClipMax     = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Sound       = Sound( "sound/ttt/TriggNOM.mp3" )

SWEP.IronSightsPos = Vector( 6.05, -5, 2.4 )
SWEP.IronSightsAng = Vector( 2.2, -0.1, 0 )

SWEP.ViewModel  = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

function SWEP:ShouldDropOnDie()
	self:Remove()
end

function SWEP:OnDrop()
self:Remove()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	local tracedata = {}
	tracedata.start = self.Owner:GetShootPos()
	tracedata.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 100)
	tracedata.filter = self.Owner
	tracedata.mins = Vector(1,1,1) * -10
	tracedata.maxs = Vector(1,1,1) * 10
	tracedata.mask = MASK_SHOT_HULL
	local tr = util.TraceHull( tracedata )

	local ply = self.Owner

		if IsValid(tr.Entity) then
		if tr.Entity.player_ragdoll then

		timer.Simple(0.1, function() 
    ply:Freeze(true) 
    ply:SetColor(Color(255,0,0,255))
		end)
          self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
					
          timer.Create("GivePlyHealth_"..self.Owner:UniqueID(),0.5,6,function() self.Owner:SetHealth(self.Owner:Health()+5) end)
					
					timer.Simple(3.1, function() 
					ply:Freeze(false)
					ply:SetColor(Color(255,255,255,255))
          tr.Entity:Remove()
          self:Remove()
					end )
				
					
				end
		end
          self.Weapon:EmitSound("sound/ttt/TriggNOM.mp3")
					self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
				
end

--- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_EQUIP2

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon. Of course this AK is special equipment so it won't,
-- but for the sake of example this is explicitly set to false anyway.
SWEP.AutoSpawnable = false

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = ""

-- CanBuy is a table of ROLE_* entries like ROLE_TRAITOR and ROLE_DETECTIVE. If
-- a role is in this table, those players can buy this.
SWEP.CanBuy = {ROLE_TRAITOR}

-- InLoadoutFor is a table of ROLE_* entries that specifies which roles should
-- receive this weapon as soon as the round starts. In this case, none.
SWEP.InLoadoutFor = nil

-- If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock = true

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = true

-- Equipment menu information is only needed on the client
if CLIENT then
-- Path to the icon material
SWEP.Icon = "VGUI/ttt/ttt_cannibalism"

-- Text shown in the equip menu
SWEP.EquipMenuData = {
	type = "Weapon",
	desc = "Eat dead bodies to remove evidence and gain HP/n this will remove your player colour!"
};
end