ITEM.Name = "Upgrade - Speed Two"
ITEM.Enabled = true
ITEM.VIPOnly = true
ITEM.Description = "Gives you extra speed!"
ITEM.Cost = 2000
ITEM.Model = "models/weapons/w_toolgun.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		local oldWalk = ply.OldWalkSpeed or 275
		local oldRun = ply.OldRunSpeed or 275
		ply:SetWalkSpeed(oldWalk)
		ply:SetRunSpeed(oldRun)
	end,
	
	CanPlayerBuy = function(ply)
		if ply:PS_HasItem("speedboost1") then 
			return true, ""
		end
		return false, "Sorry, You must have Speed One"
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		if not ply.OldWalkSpeed and not ply.OldRunSpeed then
			ply.OldWalkSpeed = ply:GetWalkSpeed()
			ply.OldRunSpeed = ply:GetRunSpeed()
		end
		if ply:Team() == TEAM_RUN then
			ply:SetWalkSpeed(295)
			ply:SetRunSpeed(295)
		end
	end
}