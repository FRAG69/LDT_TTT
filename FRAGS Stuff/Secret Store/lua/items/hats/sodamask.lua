item.unique = "16"

item.price = 300

if (CLIENT) then
	item.name = "Soda Mask"
	item.model = Model("models/props_junk/PopCan01a.mdl")
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")

		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)

			position = position +(angles:Forward() *0.5) +(angles:Right() *5.5)

			angles:RotateAroundAxis(angles:Up(), -90)
			angles:RotateAroundAxis(angles:Right(), -90)
		end
		
		return entity, position, angles
	end
end
