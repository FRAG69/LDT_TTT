include("cfg_specdm.lua")

local plymeta = FindMetaTable("Player");

function plymeta:IsGhost()
	return self:GetNWBool("ESGhost", false);
end

function plymeta:IsPickingUp()
   return self:GetNWBool("ESWeaponPickUp", false);
end

hook.Add( "PrePlayerDraw", "ESPrePlayerDraw", function(ply)
   local client = LocalPlayer()
   if (not IsValid(client) or not IsValid(ply)) then return false end
   if (client == nil or ply == nil) then return false end

   if (client:IsPlayer() and not client:IsGhost() and ply:IsGhost()) then
      return true
   end
   return false
end)

hook.Add("PlayerFootstep", "ESPlayerFootstep", function(ply, pos, foot, sound, volume, rf)
   if ply:IsGhost() then return true end
end)

hook.Add("OnEntityCreated", "ESOnEntityCreated", function(ent)
	if ent:IsPlayer() then ent:SetCustomCollisionCheck(true) end
end)

function IsDoor(entDoor)
   if not IsValid(entDoor) then return false end
   local class = entDoor:GetClass()

   if class == "func_door" or class == "func_door_rotating" or class == "prop_door_rotating" or class == "prop_dynamic" then return true end
   
   return false
end
local entmeta = FindMetaTable("Entity")

hook.Add("ShouldCollide", "ESShouldCollide", function(ent1, ent2)
      --If two ghosts collide have them not pass through.
      if IsPlayer(ent1) and ent1:IsGhost() and IsPlayer(ent2) and ent2:IsGhost() then return true
      --If two non-ghosts collide have them not pass through.
      elseif IsPlayer(ent1) and not ent1:IsGhost() and IsPlayer(ent2) and not ent2:IsGhost() then return true
      --If 1 ghost and 1 non-ghost collides, check for door...
      --allow passing through if it's a door, otherwise check for player...
      --allow passing through if it's a live player.
      elseif (IsPlayer(ent1) and ent1:IsGhost() and not IsPlayer(ent2)) or (IsPlayer(ent1) and ent1:IsGhost() and ent2:IsPlayer() and not ent2:IsGhost()) or (not ent1:IsPlayer() and IsPlayer(ent2) and ent2:IsGhost()) or (ent1:IsPlayer() and not ent1:IsGhost() and IsPlayer(ent2) and ent2:IsGhost()) then
         --Allow passing through if it's a door
         if not IsPlayer(ent1) and IsDoor(ent1) and IsPlayer(ent2) and ent2:IsGhost() then
            return false
         elseif not IsPlayer(ent2) and IsDoor(ent2) and IsPlayer(ent1) and ent1:IsGhost() then
            return false
         end

         --Allow passing through if it's a player
         if (IsPlayer(ent1) and not ent1:IsGhost() and ent2:IsPlayer() and ent2:IsGhost()) or (IsPlayer(ent2) and not ent2:IsGhost() and IsPlayer(ent1) and ent1:IsGhost()) then return false end
		 if (IsPlayer(ent1) and ent1:IsGhost() and !ent2:IsPlayer()) or (IsPlayer(ent2) and ent2:IsGhost() and !ent1:IsPlayer()) then
			return false
		 end
      end

      return true
end)

local OriginalEmitSound = entmeta.EmitSound
function entmeta:EmitSound(soundName, soundLevel, pitchPercent)
   if (self:IsWeapon()) and (self:GetParent():IsPlayer() and self:GetParent():IsGhost()) then return end

   return OriginalEmitSound(self, soundName, soundLevel, pitchPercent)
end

local OriginalMuzzleFlash = entmeta.MuzzleFlash
function entmeta:MuzzleFlash()
   if (self:IsPlayer() and self:IsGhost()) then return end

   OriginalMuzzleFlash(self)
end

local wepmeta = FindMetaTable("Weapon")
local OriginalSendWeaponAnim = wepmeta.SendWeaponAnim
function wepmeta:SendWeaponAnim(arg)
   if (self:GetParent():IsPlayer() and self:GetParent():IsGhost() and arg == ACT_VM_PRIMARYATTACK) then return end

   OriginalSendWeaponAnim(self, arg)
end