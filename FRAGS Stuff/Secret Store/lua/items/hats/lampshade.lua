-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "8"

item.price = 500

if (CLIENT) then
	item.name = "Lampshade Hat"
	item.model = Model("models/props_c17/lampShade001a.mdl")
	
	local scale = Vector(0.6, 0.6, 0.6)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")
		
		entity:SetModelScale(scale)
		
		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)
			
			position = position +(angles:Forward() *8) -(angles:Right() *0.8)
			
			angles:RotateAroundAxis(angles:Up(), 10)
			angles:RotateAroundAxis(angles:Right(), -90)
		end
		
		return entity, position, angles
	end
end