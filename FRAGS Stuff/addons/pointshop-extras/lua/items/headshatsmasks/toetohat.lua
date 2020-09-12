ITEM.Name = 'Toeto Hat'
ITEM.Price = 8000
ITEM.Model = 'models/gmod_tower/toetohat.mdl'
ITEM.Attachment = 'eyes'
ITEM.AdminOnly = true

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(1.05, 0)
	pos = pos + (ang:Forward() * -3.3) + (ang:Up() * 2)
	--ang:RotateAroundAxis(ang:Right(), 90)
	
	return model, pos, ang
end
