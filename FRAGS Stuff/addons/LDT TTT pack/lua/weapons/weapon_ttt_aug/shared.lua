if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile( "materials/VGUI/ttt/icon_ldtaug.vtf" )
   resource.AddFile( "materials/VGUI/ttt/icon_ldtaug.vmt" )
end


if CLIENT then

   SWEP.PrintName = "AUG"
   SWEP.Slot      = 2 
   SWEP.Author = "FRAG"
   SWEP.ViewModelFOV  = 72
   SWEP.ViewModelFlip = true
   
      SWEP.Icon = "VGUI/ttt/icon_ldtaug"
end

SWEP.Base				= "weapon_tttbase"

SWEP.HoldType			= "ar2"

SWEP.Primary.Delay       = 0.1

SWEP.Primary.Recoil      = 1

SWEP.Primary.Automatic   = true

SWEP.Primary.Damage      = 18

SWEP.Primary.Cone        = 0.04

SWEP.Primary.Ammo        = "Pistol"

SWEP.Primary.ClipSize    = 30

SWEP.Primary.ClipMax     = 90

SWEP.Primary.DefaultClip = 30

SWEP.Primary.Sound       = Sound( "Weapon_AUG.Single" )

SWEP.IronSightsPos      = Vector( 5, -15, -2 )
SWEP.IronSightsAng 		= Vector( 2.6, 1.37, 3.5 )

SWEP.ViewModel  = "models/weapons/v_rif_aug.mdl"

SWEP.WorldModel = "models/weapons/w_rif_aug.mdl"

function SWEP:SetZoom(state)
   if CLIENT then return end
   if state then
      self.Owner:SetFOV(40, 0.3)
   else
      self.Owner:SetFOV(0, 0.2)
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

		self.Primary.Cone = 0.04

	elseif self:GetIronsights() == true then

		self.Primary.Cone = 0

	end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

   

   self:TakePrimaryAmmo( 1 )



   local owner = self.Owner   

   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   

   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )

   self.Primary.Cone = 0.04

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

        //self:EmitSound(self.Secondary.Sound)

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

         local gap = 0

         local length = scope_size

         surface.DrawLine( x - length, y, x - gap, y )

         surface.DrawLine( x + length, y, x + gap, y )

         surface.DrawLine( x, y - length, x, y - gap )

         surface.DrawLine( x, y + length, x, y + gap )



         gap = 0

         length = 10

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

SWEP.Kind = WEAPON_HEAVY

SWEP.AutoSpawnable = true

SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.InLoadoutFor = nil

SWEP.LimitedStock = false

SWEP.AllowDrop = true

SWEP.IsSilent = false

SWEP.NoSights = false

if CLIENT then

   SWEP.EquipMenuData = {

      type = "Weapon",

      desc = "Example custom weapon."

   };

end