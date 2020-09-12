-- Only use strings, also don't change once set.
item.unique = "t_2"

item.price = 5090

if (CLIENT) then
	item.name = "LOL Trail"
	item.material = surface.GetTextureID("trails/lol")
else
	item.material = "trails/lol"
end