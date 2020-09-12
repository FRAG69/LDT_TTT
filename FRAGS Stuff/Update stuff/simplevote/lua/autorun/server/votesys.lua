AddCSLuaFile("autorun/client/cl_votesys.lua")
require("datastream")

CreateConVar("simplevote_maxrounds", 6, FCVAR_NOTIFY)
CreateConVar("simplevote_maxvotetime", 60, FCVAR_NOTIFY)
CreateConVar("simplevote_minplayers", 3, FCVAR_NOTIFY)

local maplist = {} 
local votes = {}
local playervoted = 0
local votehasstarted = false
local roundsplayed = 0
local prefix = {"ttt_"}

local function LogVote(ply, map)
	filex.Append("simplevote_log.txt", "\n\t" .. ply:Nick() .. "(".. ply:SteamID() .. ")" .. " has voted for: " .. map)
end	

local function AddLogEntry(text)
	filex.Append("simplevote_log.txt","\n" .. os.date() .. " - " .. text)
end	

local function UpdateClientsVotes(str)
	umsg.Start("UpdateSVVotes")
		umsg.String(str)
	umsg.End()
end	

local function UpdateCVars(cvar, prevv, newv)
	RunConsoleCommand("ttt_round_limit", newv + 1)
end

cvars.AddChangeCallback("simplevote_maxrounds", UpdateCVars)
	
function SetupVoteSystem()
if file.Exists("simplevote_log.txt") then
	Msg("[SimpleVote] Log file found and loaded\n")
else
	file.Write("simplevote_log.txt", "==NEW LOG FILE==")
	Msg("[SimpleVote] Log file created\n")
end
	
game.ConsoleCommand("ttt_round_limit " .. GetConVarNumber("simplevote_maxrounds") + 1 .. "\n")

for _, pr in pairs(prefix) do
	for k, v in pairs(file.Find("../maps/" .. pr .."*.bsp")) do
		local toadd = string.Replace(v, ".bsp", "")
		table.insert(maplist, toadd)
	end
	for I = 0, #maplist do
		I = I + 1
		votes[I] = 0
	end
end	
end	
hook.Add("InitPostEntity", "SetupVoteSystem", SetupVoteSystem)
	
function SendMaps(ply)
	ply.canvote = true
	datastream.StreamToClients( ply, "ReceiveMaps", maplist )
end

hook.Add("PlayerInitialSpawn", "SendMaps", SendMaps)

local function CheckPlayersVoted()
	if playervoted == #player.GetAll() then return true else return false end
end

local function InsertVote(key)
	local votenum = votes[key]
	votes[key] = votenum + 1
end	

function AddVote(ply, cmd, args)
	if votehasstarted then
		if ply.canvote then
			InsertVote(tonumber(args[1]))
			ply.canvote = false
			playervoted = playervoted + 1
			UpdateClientsVotes(args[1] .. " " .. votes[tonumber(args[1])])
			LogVote(ply, maplist[tonumber(args[1])])
			ply:ChatPrint("[SimpleVote] You have voted for: " .. maplist[tonumber(args[1])])
		else ply:ChatPrint("[SimpleVote] You can't vote or you've already voted!") return end
		if CheckPlayersVoted() then DoVote() end
	else ply:ChatPrint("[SimpleVote] You can't vote or you've already voted!") return end
end

concommand.Add("votefor", AddVote)

function StartVote()
if #player.GetAll() >= GetConVarNumber("simplevote_minplayers") then
	votehasstarted = true
	for _, v in pairs(player.GetAll()) do
		v:ConCommand("vmenu")
		--v:Lock()
	end
	AddLogEntry("Vote Started")
	timer.Create("VoteTime", GetConVarNumber("simplevote_maxvotetime"), 1, DoVote)
else 
	AddLogEntry("Only " .. #player.GetAll() .. " players in the server, vote skipped")
	return end
end

local function ReleasePlayers()
	for k, v in pairs(player.GetAll()) do
		v:UnLock()
	end
end	

function DoVote()
	local winner = maplist[table.GetWinningKey(votes)]
	if winner == game.GetMap() then
		votes = {}
		playervoted = 0
		roundsplayed = 0
		votehasstarted = false
		SetGlobalInt("ttt_rounds_left", GetConVar("ttt_round_limit"):GetInt())
		AddLogEntry("Vote finished, extending map time for " .. GetConVarNumber("simplevote_maxrounds") .. " rounds")
		umsg.Start("ResetClientVotes")
		umsg.End()
		for I = 0, #maplist do
			I = I + 1
			votes[I] = 0
		end
		for k, v in pairs(player.GetAll()) do 
		v:ChatPrint("[SimpleVote] Extending map time for " .. tostring(GetConVarNumber("simplevote_maxrounds")) .. " rounds")
		v.canvote = true
		end
		ReleasePlayers()
	else
		for k, v in pairs(player.GetAll()) do v:ChatPrint("[SimpleVote] Changing map to: " .. winner .. " in 5 seconds") end
		AddLogEntry("Vote finished, changing map to: " .. winner)
		timer.Simple(5, function()
							game.ConsoleCommand("changelevel " .. winner .. "\n")
		end)					
	end	
end	

function RoundsPlayed()
	roundsplayed = roundsplayed + 1
	if roundsplayed == GetConVarNumber("simplevote_maxrounds") then 
		StartVote() 
	end
end

hook.Add("TTTEndRound", "RoundsPlayed", RoundsPlayed)	