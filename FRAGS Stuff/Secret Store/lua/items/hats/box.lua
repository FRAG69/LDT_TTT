item.unique = "15"

item.price = 250

if (CLIENT) then
	item.name = "Box"
	item.model = Model("models/props_junk/wood_crate001a.mdl")
	
	local scale = Vector(.4, .4, .4)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")
		
		entity:SetModelScale(scale)
		
		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)
	
			position = position +(angles:Forward() *2) -(angles:Up() *3)
		end
		
		return entity, position, angles
	end
	
	item.LayoutModel = function(panel, entity)
		if (entity:GetMaterial() != "models/weapons/v_stunbaton/w_shaft01a") then
			entity:SetMaterial("models/weapons/v_stunbaton/w_shaft01a")
		end
	end
end

