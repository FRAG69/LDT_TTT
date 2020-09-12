-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "7"

item.price = 400

if (CLIENT) then
	item.name = "Monitor Head"
	item.model = Model("models/props_lab/monitor02.mdl")
	
	local scale = Vector(0.6, 0.6, 0.6)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")
		
		entity:SetModelScale(scale)
		
		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)
			
			position = position -(angles:Forward() *3)
			
			angles:RotateAroundAxis(angles:Up(), -90)
			angles:RotateAroundAxis(angles:Forward(), -90)
		end
		
		return entity, position, angles
	end
end