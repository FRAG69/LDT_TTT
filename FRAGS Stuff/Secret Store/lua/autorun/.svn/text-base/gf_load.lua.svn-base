GF = {}

if (SERVER) then
	include("gf_server.lua")
	
	local tags = GetConVar("sv_tags"):GetString()
	
	if (!string.find(tags, "GoldenForge")) then
		RunConsoleCommand("sv_tags", tags .. ",GoldenForge 1.1")
	end	
else
	include("gf_client.lua")
end