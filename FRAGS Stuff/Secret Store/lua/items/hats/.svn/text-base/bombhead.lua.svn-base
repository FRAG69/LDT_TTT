-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "4"

item.price = 20

if (CLIENT) then
	item.name = "Bomb Head"
	item.model = Model("models/combine_helicopter/helicopter_bomb01.mdl")
	
	local scale = Vector(0.5, 0.5, 0.5)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")
		
		entity:SetModelScale(scale)
		
		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)
	
			position = position +(angles:Forward() *4)
			
			angles:RotateAroundAxis(angles:Right(), 90)
		end
		
		return entity, position, angles
	end
end