-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "5"

item.price = 250

if (CLIENT) then
	item.name = "No Entry Mask"
	item.model = Model("models/props_c17/streetsign004f.mdl")
	
	local scale = Vector(0.7, 0.7, 0.7)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")
		
		entity:SetModelScale(scale)
		
		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)
			
			position = position +(angles:Forward() *5) +(angles:Right() *6.5)
			
			angles:RotateAroundAxis(angles:Up(), -160)
			angles:RotateAroundAxis(angles:Right(), -80)
		end
		
		return entity, position, angles
	end
end