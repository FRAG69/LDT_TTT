-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "10"

item.price = 250

if (CLIENT) then
	item.name = "Pan"
	item.model = Model("models/props_interiors/pot02a.mdl")
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")

		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)

			position = position +(angles:Forward() *7.5) +(angles:Right() *5)
			
			angles:RotateAroundAxis(angles:Up(), 15)
			angles:RotateAroundAxis(angles:Right(), 90)
		end
		
		return entity, position, angles
	end
end