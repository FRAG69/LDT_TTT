-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "3"

item.price = 200000

if (CLIENT) then
	item.name = "Skull Head"
	item.model = Model("models/gibs/hgibs.mdl")
	
	local scale = Vector(1.6, 1.6, 1.6)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local bone = player:LookupBone("ValveBiped.Bip01_Head1")
		
		entity:SetModelScale(scale)
		
		if (bone != -1) then
			position, angles = player:GetBonePosition(bone)

			position = position +(angles:Forward() *4.5) +(angles:Right() *1.2)
			
			angles:RotateAroundAxis(angles:Up(), 90)
			angles:RotateAroundAxis(angles:Right(), 180)
			angles:RotateAroundAxis(angles:Forward(), 90)
		end
		
		return entity, position, angles
	end
end