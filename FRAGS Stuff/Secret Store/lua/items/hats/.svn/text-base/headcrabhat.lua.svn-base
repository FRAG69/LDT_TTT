-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "14"

item.price = 1000000

if (CLIENT) then
	item.name = "Headcrab Hat"
	item.model = Model("models/headcrabclassic.mdl")
	
	local scale = Vector(0.7, 0.7, 0.7)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")
		
		entity:SetModelScale(scale)
		
		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)

			position = position +(angles:Forward() *3.5) +(angles:Right() *5)
			
			angles:RotateAroundAxis(angles:Up(), -60)
			angles:RotateAroundAxis(angles:Forward(), -90)
		end
		
		return entity, position, angles
	end
end