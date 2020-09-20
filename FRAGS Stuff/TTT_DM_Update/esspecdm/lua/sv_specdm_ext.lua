hook.Add("PlayerSpawn", "ESPlayerSpawn", function(ply)
   if ply:IsGhost() and ply:IsSpec() then
      ply:UnSpectate()

      hook.Call("PlayerLoadout", GAMEMODE, ply)
      hook.Call("PlayerSetModel", GAMEMODE, ply)

      if not ply:IsSpec() then
         ply:SetMaterial("")
         ply:SetGhost(false)
         ply:SetBloodColor(0)
         ply:DrawShadow(true)
      else
         if ESConfig.UseMaterial then
            ply:SetMaterial(ESConfig.GhostMat)
         end
         ply:SetBloodColor(-1)
         ply:DrawShadow(false)
      end

      return true
	elseif ply:IsGhost() and not ply:IsSpec() then
			 ply:SetGhost(false)
			 ply:SetMaterial("")
   end   
end)

hook.Add("Initialize", "ESInit", function()
   hook.Add("OnPlayerHitGround", "ESOnPlayerHitGround", function(ply, in_water, on_floater, speed)
      if ply:IsGhost() and not ESConfig.GhostFallDamage then return false end
   end)
   
   local OriginalKeyPress = GAMEMODE.KeyPress
   function GAMEMODE:KeyPress(ply, key)
      if IsValid(ply) and ply:IsGhost() then
         if not ply:Alive() and key == IN_ATTACK then
            ply:SetGhost(true)
            if ESConfig.UseMaterial then
               ply:SetMaterial(ESConfig.GhostMat)
            end
            ply:Spawn()
            return
         elseif ply:Alive() and key == IN_JUMP then
            if ply:IsOnGround() or ESConfig.GhostJump then
               ply:SetVelocity(Vector(0,0,ESConfig.JumpVelocity))
            end
            return
         elseif ply:Alive() then
            return
         end
      end

      return OriginalKeyPress(self, ply, key)
   end

   local OriginalSpectatorThink = GAMEMODE.SpectatorThink
   function GAMEMODE:SpectatorThink(ply)
      if IsValid(ply) and ply:IsGhost() then return true end

      OriginalSpectatorThink(self, ply)
   end

   local plymeta = FindMetaTable("Player");

   local OriginalResetRoundFlags = plymeta.ResetRoundFlags
   function plymeta:ResetRoundFlags()
      if self:IsGhost() then return end
      OriginalResetRoundFlags(self)
   end

   local OriginalSpectate = plymeta.Spectate
   function plymeta:Spectate(spectateMode)
      if self:IsGhost() then return end

      return OriginalSpectate(self, spectateMode)
   end

   local OriginalKarmaHurt = KARMA.Hurt
   function KARMA.Hurt(attacker, victim, dmginfo)
      if (IsValid(attacker) and attacker:IsGhost()) or (IsValid(victim) and victim:IsGhost()) then return end
      return OriginalKarmaHurt(attacker, victim, dmginfo)
   end
   
   local OriginalHasteMode = HasteMode
   local OriginalPlayerDeath = GAMEMODE.PlayerDeath
   function GAMEMODE:PlayerDeath(ply, infl, attacker)
      if ply:IsGhost() then HasteMode = function() return false end end

      OriginalPlayerDeath(self, ply, infl, attacker)
      HasteMode = OriginalHasteMode
   end
end)