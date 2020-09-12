CurrentRound = 0

hook.Add("Initialize", "SetupLogs", function()
	GAMEMODE.DetailedDamagelog = {}
	 GAMEMODE.RoundStartTime = 0
end)

--Round beginning
hook.Add("TTTBeginRound", "ClearDetailed", function()
   CurrentRound = CurrentRound + 1
   GAMEMODE.DetailedDamageLog = {}
   GAMEMODE.DetailedDamageLog.Info = { game.GetMap(), CurrentRound }
   
   GAMEMODE.RoundStartTime = CurTime()
   
   AddToDamageLog( { DMG_LOG.GAME, Format("Round started at %s", os.date("%I:%M%p")) } )
   
     for _, v in ipairs(player.GetAll()) do
		v.InnoKills = 0 v.TraitorKills = 0
		v.LastShot = nil
	end
end)

--Round preparing
hook.Add("TTTPrepareRound", "SaveLogs", function()
	if GAMEMODE.DetailedDamageLog != nil then
		file.Write("lastdetailedevents.txt", von.serialize(GAMEMODE.DetailedDamageLog))
	end
end)

--Round ending
hook.Add("TTTEndRound", "AddEndToLogs", function(type)
	   local roundwinner = "Innocents won the round"
   if type == WIN_TIMELIMIT then
	  roundwinner = "Innocents won when the traitors ran out of time"
   elseif type == WIN_TRAITOR then
	  roundwinner = "Traitors won the round"
   end
   AddToDamageLog({DMG_LOG.GAME, Format("%s at %s!", roundwinner, os.date("%I:%M%p"))})
end)

--Player death
hook.Add("DoPlayerDeath", "LogDeath", function(ply, attacker, dmginfo)
	 if GetRoundState() == ROUND_ACTIVE then
		if IsValid(attacker) and attacker:IsPlayer() then
			local wepName = getWepName(dmginfo)
			local info = getVictimInfo(attacker, ply)
			if ply:IsTraitor() then 
				attacker.TraitorKills = attacker.TraitorKills + 1 
			else 
				attacker.InnoKills = attacker.InnoKills + 1 
			end
			local scene = GetDamageLogSceneData(ply,attacker,dmginfo)
			AddToDamageLog( { DMG_LOG.KILL, attacker:Nick(), attacker:GetRoleString(), ply:Nick(), ply:GetRoleString(), wepName, info, scene != nil and scene or {}, {attacker:SteamID(), ply:SteamID()}})
		else
			AddToDamageLog( { DMG_LOG.WORLDKILL, ply:Nick(), ply:GetRoleString(), {ply:SteamID()} } )
		end
	 end
end)

--Player damage
function LogDamage(att, ent, dmginfo)
		local wepName = getWepName( dmginfo )
	  local info = getVictimInfo(att, ent)
	  AddToDamageLog({ DMG_LOG.DMG, att:Nick(), att:GetRoleString(), ent:Nick(), ent:GetRoleString(), math.Round(dmginfo:GetDamage()), wepName, info, {att:SteamID(), ent:SteamID()} })
end

function LogFall(ply, damage)
	AddToDamageLog( { DMG_LOG.FALL, ply:Nick(), ply:GetRoleString(), math.floor(damage), {ply:SteamID()} } )
end

util.AddNetworkString("recreate_move")
net.Receive("recreate_move", function(len, client)
	if client:IsSpec() then
		client:UnSpectate()
		client:SetObserverMode(OBS_MODE_ROAMING)
		
		local pos = net.ReadVector()
		local ang = net.ReadAngle()
		pos = pos - (ang:Forward()*75)
		pos.z = pos.z + 80
		
		ang.p = ang.p + 20
		client:SetPos( pos )
		client:SetEyeAngles( ang )
	end
end)