-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "12"

item.price = 9001

if (CLIENT) then
	item.name = "Turtle"
	item.model = Model("models/props/de_tides/vending_turtle.mdl")
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")

		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)

			position = position +(angles:Forward() *5.5)
			
			angles:RotateAroundAxis(angles:Up(), 180)
			angles:RotateAroundAxis(angles:Right(), 90)
		end
		
		return entity, position, angles
	end
end