ITEM.Name = "Jump Power"
ITEM.Enabled = true
ITEM.Description = "Lets you jump a little higher!"
ITEM.Cost = 600
ITEM.Model = "models/weapons/w_toolgun.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		local oldJump = ply.OldJumpPower or 200
		ply:SetJumpPower(oldJump)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		if not ply.OldJumpPower then
			ply.OldJumpPower = ply:GetJumpPower()
		end
		if ply:Team() == TEAM_RUN then
			ply:SetJumpPower(215)
		end
	end
}