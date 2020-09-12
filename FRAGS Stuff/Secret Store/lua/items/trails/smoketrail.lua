-- Only use strings, also don't change once set.
item.unique = "t_5"

item.price = 4200

if (CLIENT) then
	item.name = "Smoke Trail"
	item.material = surface.GetTextureID("trails/smoke")
else
	item.material = "trails/smoke"
end