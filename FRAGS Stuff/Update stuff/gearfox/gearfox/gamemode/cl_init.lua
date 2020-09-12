include( "shared.lua" )

GM.UseMawChat 		= true
GM.UseMawBlockCHud 	= true
GM.UseMawSun		= true

function GM:Initialize()
end

function GM:ShouldDrawLocalPlayer()
	return (!IsFirstPerson())
end



--Overrides the pixelrendere to avoid hacks using it. 
concommand.Add("pp_pixelrender",function() end) --This line will get removed once garry has updated gmod.

