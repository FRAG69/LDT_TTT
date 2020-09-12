if SERVER then
   AddCSLuaFile("shared.lua")
end
   
SWEP.HoldType = "rpg"

if CLIENT then
   SWEP.PrintName = "Barrel Launcher"
   SWEP.Slot = 7

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Spawns explosive barrels"
   };

   SWEP.Icon = "VGUI/ttt/icon_balaunch"

   SWEP.ViewModelFlip = false
   SWEP.ViewModelFOV = 54
end

SWEP.Base				= "weapon_tttbase"

SWEP.Primary.Ammo   = "Barrels"
SWEP.Primary.ClipSize		= 3
SWEP.Primary.DefaultClip	= 3
SWEP.Primary.Automatic		= true
SWEP.Primary.Delay = 3
SWEP.Primary.Cone  = 0
//SWEP.Primary.Recoil         = 50
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo  = "none"
SWEP.Secondary.Delay = 0.5

SWEP.AutoSpawnable = false
SWEP.NoSights = true

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR}

SWEP.Primary.Sound = Sound( "Weapon_RPG.Single" )
SWEP.Primary.SoundLevel = 54

SWEP.ViewModel = "models/weapons/v_RPG.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
AccessorFuncDT(SWEP, "charge", "Charge")

SWEP.IsCharging = false
SWEP.NextCharge = 0

SWEP.EmptySound = Sound( "Weapon_Pistol.Empty" )

local CHARGE_AMOUNT = 0.02
local CHARGE_DELAY = 0.025

local math = math

function SWEP:SetupDataTables()
   self:DTVar("Float", 0, "charge")
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	if (self.Weapon:Clip1() < 1) then
		if SERVER then
			WorldSound(self.EmptySound, self.Weapon:GetPos(), self.Primary.SoundLevel)
		end
		return
	end
	self.Weapon:SetClip1(self.Weapon:Clip1() - 1)
	
	self:FireBarrel(200)
end

function SWEP:SecondaryAttack()
	if self.IsCharging then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	if (self.Weapon:Clip1() < 1) then
		if SERVER then
			WorldSound(self.EmptySound, self.Weapon:GetPos(), self.Primary.SoundLevel)
		end
		return
	end
	self.Weapon:SetClip1(self.Weapon:Clip1() - 1)
	
	self.IsCharging = true
end

function SWEP:FireBarrel(force)
	if not IsValid(self.Owner) then return end
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * (force/10), math.Rand(-0.1,0.1) *(force/10), 0 ) )
	
	if SERVER then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		WorldSound(self.Primary.Sound, self.Weapon:GetPos(), self.Primary.SoundLevel)
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		
		local vel = self.Owner:GetAimVector() * force
		local spawn = self.Owner:GetAimVector() * 10
		
		local barrel = ents.Create("prop_physics")
		barrel:SetModel("models/props_c17/oildrum001_explosive.mdl")
		barrel:SetPos(self.Weapon:GetPos())
		
		barrel:Spawn()
		local barrelphys = barrel:GetPhysicsObject()
		if barrelphys then barrelphys:SetVelocity(vel) end
	end
end

local CHARGE_FORCE_MIN = 200
local CHARGE_FORCE_MAX = 2000
function SWEP:ChargedAttack()
   local charge = math.Clamp(self:GetCharge(), 0, 1)
   
   self.IsCharging = false
   self:SetCharge(0)

   if charge <= 0 then return end

   local max = CHARGE_FORCE_MAX
   local diff = max - CHARGE_FORCE_MIN

   local force = ((charge * diff) - diff) + max

   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )

   self:FireBarrel(force)
end

function SWEP:PreDrop(death_drop)
   self.IsCharging = false
   self:SetCharge(0)
end

function SWEP:OnRemove()
   self.IsCharging = false
   self:SetCharge(0)
end

function SWEP:Deploy()
   self.IsCharging = false
   self:SetCharge(0)
   return true
end

function SWEP:Holster()
   return not self.IsCharging
end

function SWEP:Think()
   if self.IsCharging and IsValid(self.Owner) and self.Owner:IsTerror() then
      -- on client this is prediction
      if not self.Owner:KeyDown(IN_ATTACK2) then
         self:ChargedAttack()
         return true
      end

      
      if SERVER and self:GetCharge() < 1 and self.NextCharge < CurTime() then
         self:SetCharge(math.min(1, self:GetCharge() + CHARGE_AMOUNT))

         self.NextCharge = CurTime() + CHARGE_DELAY
      end
   end
end

if CLIENT then
   local surface = surface
   function SWEP:DrawHUD()
      local x = ScrW() / 2.0
      local y = ScrH() / 2.0

      local nxt = self.Weapon:GetNextPrimaryFire()
      local charge = self.dt.charge

      if LocalPlayer():IsTraitor() then
         surface.SetDrawColor(255, 0, 0, 255)
      else
         surface.SetDrawColor(0, 255, 0, 255)
      end

      if nxt < CurTime() or CurTime() % 0.5 < 0.2 or charge > 0 then
         local length = 10
         local gap = 5

         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )
      end

      if nxt > CurTime() and charge == 0 then
         local w = 40

         w = (w * ( math.max(0, nxt - CurTime()) /  self.Primary.Delay )) / 2

         local bx = x + 30
         surface.DrawLine(bx, y - w, bx, y + w)

         bx = x - 30
         surface.DrawLine(bx, y - w, bx, y + w) 
      end

      if charge > 0 then
         y = y + (y / 3)

         local w, h = 100, 20

         surface.DrawOutlinedRect(x - w/2, y - h, w, h)

         if LocalPlayer():IsTraitor() then
            surface.SetDrawColor(255, 0, 0, 155)
         else
            surface.SetDrawColor(0, 255, 0, 155)
         end

         surface.DrawRect(x - w/2, y - h, w * charge, h)

         surface.SetFont("TabLarge")
         surface.SetTextColor(255, 255, 255, 180)
         surface.SetTextPos( (x - w / 2) + 3, y - h - 15)
         surface.DrawText("FORCE")
      end
   end
end

//-----------------------------------------------------------
//Equipment Menu
//-----------------------------------------------------------

if CLIENT then
   SWEP.Icon = "materials/VGUI/ttt/icon_balaunch.vft"

   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Spawns explosive barrels"
   };
end

//****************
//NOTE: NEEDS ICON
//****************
if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_balaunch.vmt")
end