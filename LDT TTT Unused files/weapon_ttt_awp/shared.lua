if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile( "materials/VGUI/ttt/icon_ldttttawp.vtf" )
   resource.AddFile( "materials/VGUI/ttt/icon_ldttttawp.vmt" )
end

SWEP.HoldType           = "ar2"

if CLIENT then
   SWEP.PrintName          = "AWP"

   SWEP.Slot               = 2
   SWEP.Icon = "VGUI/ttt/icon_ldttttawp"
end

SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.InLoadoutFor = nil


SWEP.Base               = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.LimitedStock = true
SWEP.EquipMenuData = {
   type = "item_weapon",
   desc = [[
		Very Powerful Sniper Rifle.
		Only 1 Bullet Available.
	  
		Use scope to gain better
		accuracy.]]
};
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false


SWEP.Kind = WEAPON_HEAVY

SWEP.Primary.NumberofShots = 4
SWEP.Primary.Delay          = 1.5
SWEP.Primary.Recoil         = 7
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 1000
SWEP.Primary.Cone = 0.5
SWEP.Primary.ClipSize = 2
SWEP.Primary.ClipMax = 2 -- keep mirrored to ammo
SWEP.Primary.DefaultClip = 2

--- EXTRA STUFF ---

SWEP.DrawCrosshair		= false


--- /EXTRA STUFF ---

SWEP.HeadshotMultiplier = 4

SWEP.AutoSpawnable      = false
SWEP.ViewModel          = Model("models/weapons/v_snip_awp.mdl")
SWEP.WorldModel         = Model("models/weapons/w_snip_awp.mdl")

SWEP.Primary.Sound			= Sound( "Weapon_AWP.Single" )

SWEP.Secondary.Sound = Sound("Default.Zoom")

SWEP.IronSightsPos      = Vector( 5, -15, -2 )
SWEP.IronSightsAng      = Vector( 2.6, 1.37, 3.5 )

function SWEP:SetZoom(state)
    if CLIENT then 
       return
    else
       if state then
          self.Owner:SetFOV(20, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end


function SWEP:PrimaryAttack(worldsnd)

   self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      WorldSound(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end
	
	if self:GetIronsights() == false then
		self.Primary.Cone = 0.3
	elseif self:GetIronsights() == true then
		self.Primary.Cone = 0
	end
   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
   
   self:TakePrimaryAmmo( 1 )

   local owner = self.Owner   
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
   
   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
   self.Primary.Cone = 0.3
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end
    
    bIronsights = not self:GetIronsights()
    
    self:SetIronsights( bIronsights )
    
    if SERVER then
        self:SetZoom(bIronsights)
     else
        self:EmitSound(self.Secondary.Sound)
    end
    
    self.Weapon:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
    self:SetZoom(false)
    self:SetIronsights(false)
    return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
    self.Weapon:DefaultReload( ACT_VM_RELOAD );
    self:SetIronsights( false )
    self:SetZoom(false)
end


function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)
    return true
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local x = ScrW() / 2.0
         local y = ScrH() / 2.0
         local scope_size = ScrH()

         -- crosshair
         local gap = 80
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 0
         length = 50
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)

         surface.SetDrawColor(255, 0, 0, 255)
         surface.DrawLine(x, y, x + 1, y + 1)

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)

      else
         return self.BaseClass.DrawHUD(self)
      end
   end
end

function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end