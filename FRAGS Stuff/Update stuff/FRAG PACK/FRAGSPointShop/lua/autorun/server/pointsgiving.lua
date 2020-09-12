--in case the lua gets openscripted.
for id, pla in pairs(player.GetAll()) do
	pla.AFKTime = os.time()
end

hook.Add( "PlayerInitialSpawn", "TTT_Shop_FSpawn", function( ply )
	ply.prev = 0
	ply.AFKTime = os.time()
end )

hook.Add( "KeyPress", "Shop_AFKpress", function( ply )
	ply.AFKTime = os.time()
end )

hook.Add( "PlayerSay", "Shop_AFKsay", function( ply )
	ply.AFKTime = os.time()
end )

function _R.Player:IsAFK(time)
	local secs = tonumber(time) or 45
	if (os.time() - self.AFKTime > secs) then
		return true
	else
		return false
	end
end

hook.Add( "TTTEndRound", "TTT_Shop_Score", function( type )
	for _,v in pairs(player.GetAll()) do
		local points = math.max(math.Round((v:Frags() - math.abs(v.prev))*1.25), 0)
		if points > 0 then
			v:PS_GivePoints(points, "received due to your score!")
		end
		v.prev = v:Frags()
	end
end )

hook.Add( "Initialize", "TTT_Shop_Active", function()
if gmod.GetGamemode().Name == "Trouble in Terrorist Town" then
	Msg([[
 => Pointshop: GAMEMODE IS TROUTBLE IN TERRORIST TOWN
 ]])
	timer.Create( "Points_ActiveTimer", 300, 0, function()
		if #player.GetAll() > 4 then
			for _,v in pairs(player.GetAll()) do
				if v:Alive() then
					if !v:IsAFK(45) then
						v:PS_GivePoints(15, "received due being active!")
					end
				else
					if !v:IsAFK(200) then
						v:PS_GivePoints(15, "received due being active!")
					end
				end
			end
		end
	end )
else
	Msg([[
 => Pointshop: GAMEMODE IS NOT TROUTBLE IN TERRORIST TOWN
]])
end
end )