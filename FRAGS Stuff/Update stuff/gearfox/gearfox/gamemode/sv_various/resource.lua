
function resource.AddDir(DIR)
	local GAMEFIL = file.Find(DIR.."/*",true)
	for k,v in pairs( GAMEFIL ) do
		if (file.IsDir("../"..DIR.."/"..v)) then
			resource.AddDir(DIR.."/"..v)
		else
			resource.AddFile(DIR.."/"..v)
		end
	end
end
