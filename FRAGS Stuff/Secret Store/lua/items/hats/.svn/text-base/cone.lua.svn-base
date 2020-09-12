-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "2"

item.price = 2000

if (CLIENT) then
	item.name = "Cone Hat"
	item.model = Model("models/props_junk/trafficcone001a.mdl")
	
	local scale = Vector(0.8, 0.8, 0.8)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")
		
		entity:SetModelScale(scale)
		
		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)
			
			position = position +(angles:Forward() *18) -(angles:Right() *1.5)
			
			angles:RotateAroundAxis(angles:Up(), 10)
			angles:RotateAroundAxis(angles:Right(), -90)
		end
		
		return entity, position, angles
	end
end