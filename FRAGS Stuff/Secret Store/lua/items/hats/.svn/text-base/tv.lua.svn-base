-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "11"

item.price = 900

if (CLIENT) then
	item.name = "TV"
	item.model = Model("models/props_c17/tv_monitor01.mdl")
	
	local scale = Vector(0.8, 0.8, 0.8)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")
		
		entity:SetModelScale(scale)
		
		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)

			position = position -(angles:Right() *2) +(angles:Forward() *3) -(angles:Up() *1.5)
			
			angles:RotateAroundAxis(angles:Up(), -90)
			angles:RotateAroundAxis(angles:Forward(), -90)
		end
		
		return entity, position, angles
	end
end