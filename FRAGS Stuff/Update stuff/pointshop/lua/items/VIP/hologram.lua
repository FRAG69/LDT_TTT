ITEM.Name = "Skin - Hologram"
ITEM.Enabled = true
ITEM.VIPOnly = true
ITEM.Description = "Be a hologram!"
ITEM.Cost = 600
ITEM.Model = "models/weapons/w_toolgun.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		ply:SetMaterial("")
		ply:SetColor(255, 255, 255, 255) 
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		local r,g,b,a = ply:GetColor();
		ply:SetColor(r, g, b, 170)
		ply:SetMaterial("models/props_combine/masterinterface01c")
	end
}