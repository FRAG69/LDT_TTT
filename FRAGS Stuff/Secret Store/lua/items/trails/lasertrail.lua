-- Only use strings, also don't change once set.
item.unique = "t_1"

item.price = 100

if (CLIENT) then
	item.name = "Laser Trail"
	item.material = surface.GetTextureID("trails/laser")
else
	item.material = "trails/laser"
end