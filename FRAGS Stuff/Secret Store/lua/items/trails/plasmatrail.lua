-- Only use strings, also don't change once set.
item.unique = "t_3"

item.price = 350

if (CLIENT) then
	item.name = "Plasma Trail"
	item.material = surface.GetTextureID("trails/plasma")
else
	item.material = "trails/plasma"
end