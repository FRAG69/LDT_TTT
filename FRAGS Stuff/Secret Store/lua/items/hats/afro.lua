-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "1"

item.price = 2

if (CLIENT) then
	item.name = "Afro"
	item.model = Model("models/dav0r/hoverball.mdl")
	
	local scale = Vector(1.6, 1.6, 1.6)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")
		
		entity:SetModelScale(scale)
		
		if (entity:GetMaterial() != "models/weapons/v_stunbaton/w_shaft01a") then
			entity:SetMaterial("models/weapons/v_stunbaton/w_shaft01a")
		end
		
		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)
	
			position = position -(angles:Right() *5) +(angles:Forward() *8)
			
			angles:RotateAroundAxis(angles:Right(), 90)
		end
		
		return entity, position, angles
	end
	
	item.LayoutModel = function(panel, entity)
		if (entity:GetMaterial() != "models/weapons/v_stunbaton/w_shaft01a") then
			entity:SetMaterial("models/weapons/v_stunbaton/w_shaft01a")
		end
	end
end

