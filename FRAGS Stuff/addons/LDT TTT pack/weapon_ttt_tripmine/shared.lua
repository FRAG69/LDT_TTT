if SERVER then
       AddCSLuaFile( "shared.lua" )
       resource.AddFile("materials/VGUI/ttt/icon_tripmine.vmt")
    end
     
    SWEP.HoldType                           = "normal"
     
    if CLIENT then
     
       SWEP.PrintName    = "Tripmine"
       SWEP.Slot         = 6
     
       SWEP.ViewModelFlip = true
       SWEP.ViewModelFOV                    = 10
       
       SWEP.EquipMenuData = {
          type = "item_weapon",
		  model="models/weapons/w_eq_smokegrenade.mdl",
          desc = [[A mine, with a red laster, placeable on walls.
                  Can be shot and destroyed 
				  by innocents and detectives.]]
       };
	   
	   
       SWEP.Icon = "VGUI/ttt/icon_tripmine"
    end
SWEP.Base = "weapon_tttbase"
         
    SWEP.ViewModel                          = "models/weapons/v_eq_smokegrenade.mdl"   -- Weapon view model
    SWEP.WorldModel                         = "models/weapons/w_eq_smokegrenade.mdl"   -- Weapon world model
    SWEP.FiresUnderwater = false
     
    SWEP.Primary.Sound                      = Sound("") 
    SWEP.Primary.Delay                      = .5 
    SWEP.Primary.ClipSize                   = 1 
    SWEP.Primary.DefaultClip                = 1
    SWEP.Primary.Automatic                  = false 
    SWEP.Primary.Ammo                       = "slam"
        SWEP.LimitedStock = false
       
        SWEP.NoSights = true
     
    SWEP.AllowDrop = true
    SWEP.Kind = WEAPON_EQUIP
    SWEP.CanBuy = {ROLE_TRAITOR}
     
    function SWEP:Deploy()
            self:SendWeaponAnim( ACT_SLAM_TRIPMINE_DRAW )
            return true
    end
     
    function SWEP:SecondaryAttack()
            return false
    end    
     
    function SWEP:OnRemove()
       if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
          RunConsoleCommand("lastinv")
       end
    end
     
function SWEP:PrimaryAttack()
        self:TripMineStick()
        self.Weapon:EmitSound( Sound( "Weapon_SLAM.SatchelThrow" ) )
        self.Weapon:SetNextPrimaryFire(CurTime()+(self.Primary.Delay))
end
     
function SWEP:TripMineStick()
 if SERVER then
      local ply = self.Owner
      if not IsValid(ply) then return end
 
 
      local ignore = {ply, self.Weapon}
      local spos = ply:GetShootPos()
      local epos = spos + ply:GetAimVector() * 80
      local tr = util.TraceLine({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID})
 
      if tr.HitWorld then
         local mine = ents.Create("npc_tripmine")
         if IsValid(mine) then
 
            local tr_ent = util.TraceEntity({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID}, mine)
 
            if tr_ent.HitWorld then
 
               local ang = tr_ent.HitNormal:Angle()
               ang.p = ang.p + 90
 
               mine:SetPos(tr_ent.HitPos + (tr_ent.HitNormal * 3))
               mine:SetAngles(ang)
               mine:SetOwner(ply)
			   mine:SetMaterial( "models/weapons/w_eq_smokegrenade.mdl")
               mine:Spawn()
			   mine:SetDamageOwner(ply)
			   
			   
			   for k, v in pairs(player.GetAll()) do
                   if v:IsActiveTraitor() or v:IsSpec() then
                   table.insert(ignore, v)
                   end
                end
 
                                mine.fingerprints = self.fingerprints
                                                               
                                self:SendWeaponAnim( ACT_SLAM_TRIPMINE_ATTACH )
                               
                                local holdup = self.Owner:GetViewModel():SequenceDuration()
                               
                                timer.Simple(holdup,
                                function()
                                if SERVER then
                                        self:SendWeaponAnim( ACT_SLAM_TRIPMINE_ATTACH2 )
                                end    
                                end)
                                       
                                timer.Simple(holdup + .1,
                                function()
                                        if SERVER then
                                                if self.Owner == nil then return end
                                                if self.Weapon:Clip1() == 0 && self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) == 0 then
                                                --self.Owner:StripWeapon(self.Gun)
                                                --RunConsoleCommand("lastinv")
                                                                                                self:Remove()
                                                else
                                                self:Deploy()
                                                end
                                        end
                                end)
                       
 
                               --self:Remove()
                                self.Planted = true
                                                               
        self:TakePrimaryAmmo( 1 )
                               
                        end
            end
         end
      end
end
 
function SWEP:Reload()
   return false
end