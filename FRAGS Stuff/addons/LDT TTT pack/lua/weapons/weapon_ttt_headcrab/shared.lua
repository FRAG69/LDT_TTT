if SERVER then
    AddCSLuaFile("shared.lua")
     
	 SWEP.HoldType           = "pistol"
	 
elseif CLIENT then
    SWEP.PrintName          = "Headcrab Launcher"
    SWEP.Slot               = 6
    SWEP.SlotPos            = 3
    SWEP.DrawCrosshair = false
     
    SWEP.EquipMenuData = {
      type = "EXTREME WEAPON",
      desc = "Makes 4-10 headcrabs."
   }
    
   SWEP.Icon = "VGUI/ttt/icon_silenced"
end
 
SWEP.Base                      = "weapon_tttbase"
SWEP.Spawnable                 = false
SWEP.AdminSpawnable            = true
SWEP.ViewModel                 = "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel             = "models/weapons/w_pist_usp.mdl"
 
SWEP.NoSights = true
SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true
--SWEP.WeaponID = RPG

SWEP.Primary.ClipSize        = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic        = true
SWEP.Primary.Ammo            = nil
SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo            = "none"
  
local ShootSoundFire = Sound("Airboat.FireGunHeavy")
local ShootSoundFail = Sound("WallHealth.Deny")
local YawIncrement = 20
local PitchIncrement = 10
 
if CLIENT then language.Add("Undone_CrabLaunch", "Undone Headcrab Canister.") end
  
function SWEP:Initialize() if SERVER then self:SetWeaponHoldType(self.HoldType) end self:SetNWBool("Used", false) end
  
function SWEP:PrimaryAttack(bSecondary)
    if self:GetNWBool("Used", false) then return false end
     
    local tr = self.Owner:GetEyeTrace()
    local aBaseAngle = tr.HitNormal:Angle()
    local aBasePos = tr.HitPos
    local bScanning = true
    local iPitch = 10
    local iYaw = -180
    local iLoopLimit = 0
    local iProcessedTotal = 0
    local tValidHits = {}
     
    while (bScanning && iLoopLimit < 500) do
        iYaw = iYaw + YawIncrement
        iProcessedTotal = iProcessedTotal + 1       
        if (iYaw >= 180) then
            iYaw = -180
            iPitch = iPitch - PitchIncrement
        end
         
        local tLoop = util.QuickTrace(aBasePos, (aBaseAngle+Angle(iPitch,iYaw,0)):Forward()*40000)
        if (tLoop.HitSky || bSecondary) then
            table.insert(tValidHits,tLoop)
        end
         
        if (iPitch <= -80) then
            bScanning = false
        end
        iLoopLimit = iLoopLimit + 1
    end
     
    local iHits = table.Count(tValidHits)
    if (iHits > 0) then
        self:SetNWBool("Used", true)
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        if SERVER then
            self.Owner:SetAnimation(PLAYER_ATTACK1)
            local iRand = math.random(1,iHits)
            local tRand = tValidHits[iRand]       
             
            local ent = ents.Create("env_headcrabcanister")
            ent:SetPos(aBasePos)
            ent:SetAngles((tRand.HitPos-tRand.StartPos):Angle())
            ent:SetKeyValue("HeadcrabType", math.random(0,2))
            ent:SetKeyValue("HeadcrabCount", math.random(4,10))
            //ent:SetKeyValue("HeadcrabCount", 0)
            ent:SetKeyValue("FlightSpeed", math.random(2500,6000))
            ent:SetKeyValue("FlightTime", math.random(2,5))
            ent:SetKeyValue("Damage", math.random(50,90))
            ent:SetKeyValue("DamageRadius", math.random(300,512))
            ent:SetKeyValue("SmokeLifetime", math.random(5,10))
            ent:SetKeyValue("StartingHeight",  1000)
            local iSpawnFlags = 8192
            if (bSecondary) then iSpawnFlags = iSpawnFlags + 4096 end //If Secondary, spawn impacted.
            ent:SetKeyValue("spawnflags", iSpawnFlags)
             
            ent:Spawn()
             
            ent:Input("FireCanister", self.Owner, self.Owner)
             
            undo.Create("CrabLaunch")
                undo.AddEntity(ent)
                undo.SetPlayer(self.Owner)
                undo.AddFunction(function(undo)
                    for k, v in pairs(ents.FindByClass("npc_headcrab*"))do
                        if (v:GetOwner() == ent) then v:Remove() end
                    end
                end)
            undo.Finish()
            self:EmitSound(ShootSoundFire)
        end
    else
        self:EmitSound(ShootSoundFail)
    end
    tLoop = nil
    tValidHits = nil
    return true
end
 
function SWEP:ShouldDropOnDie()
    return false
end