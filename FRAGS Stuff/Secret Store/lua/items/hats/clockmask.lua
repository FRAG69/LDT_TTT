-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "9"

item.price = 600

if (CLIENT) then
	item.name = "Clock Mask"
	item.model = Model("models/props_c17/clock01.mdl")
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")

		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)
			
			position = position +(angles:Forward() *2.3) +(angles:Right() *4)
			
			angles:RotateAroundAxis(angles:Right(), -180)
			angles:RotateAroundAxis(angles:Forward(), 90)
		end
		
		return entity, position, angles
	end
end