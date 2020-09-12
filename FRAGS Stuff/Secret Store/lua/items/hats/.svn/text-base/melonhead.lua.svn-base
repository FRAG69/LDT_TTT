-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "6"

item.price = 350

if (CLIENT) then
	item.name = "Melon Head"
	item.model = Model("models/props_junk/watermelon01.mdl")
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")

		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)
			
			position = position +(angles:Forward() *4)

			angles:RotateAroundAxis(angles:Right(), -12)
		end
		
		return entity, position, angles
	end
end