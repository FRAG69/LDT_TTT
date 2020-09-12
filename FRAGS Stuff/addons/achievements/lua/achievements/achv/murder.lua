local category = achievements.CreateCategory("Murder")
category.Icon = "gui/achievements/cat_murder.png"
category.DisplayOrder = 3
category.Active = function() return gmod.GetGamemode().Name == "Murder" end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Accumulate 100 pieces of loot overtime."
    ACH.Target = 100
    ACH.Rewards = { { ps_points = 1000 } }

    function ACH:Initialize()
    	hook.Add("PlayerPickupLoot", "AchvMurderLoot", function(ply)
    		self:AddPoint(ply)
    	end)
    end

    achievements.Register( category, "murderloot", "Horder", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Accumulate 100 kills as a murderer."
    ACH.Target = 100
    ACH.Rewards = { { ps_points = 1000 } }

    function ACH:Initialize()
    	hook.Add("PlayerDeath", "AchvMurderKills", function(victim, inflictor, attacker)
    		if not IsValid(attacker) or not attacker:IsPlayer() or not attacker:GetMurderer() then return end
    		self:AddPoint(attacker)
    	end)
    end

    achievements.Register( category, "murdererkills", "Mass Murderer", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Accumulate 100 kills as a bystandar."
    ACH.Target = 100
    ACH.Rewards = { { ps_points = 1000 } }

    function ACH:Initialize()
    	hook.Add("PlayerDeath", "AchvBystandarKills", function(victim, inflictor, attacker)
    		if not IsValid(attacker) or not attacker:IsPlayer() or attacker:GetMurderer() then return end
    		self:AddPoint(attacker)
    	end)
    end

    achievements.Register( category, "bystandarkills", "Not So Innocent", ACH )
end