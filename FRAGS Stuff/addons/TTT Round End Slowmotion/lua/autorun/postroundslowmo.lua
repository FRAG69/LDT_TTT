AddCSLuaFile() --Include this clientside
if GetConVarString("gamemode") == "terrortown" and SERVER then
if not ConVarExists("ttt_slowmo_sound") then CreateConVar("ttt_slowmo_sound","",{FCVAR_ARCHIVE }) end
if not ConVarExists("ttt_slowmo_draw") then CreateConVar("ttt_slowmo_draw",1,{FCVAR_ARCHIVE }) end
if not ConVarExists("ttt_slowmo_time") then CreateConVar("ttt_slowmo_time",0.5,{FCVAR_ARCHIVE }) end
resource.AddFile("sound/"..GetConVarString("ttt_slowmo_sound"))
util.AddNetworkString("slowmo_clslow")

SetGlobalBool("slowmo_draw",tobool(GetConVarNumber("ttt_slowmo_draw")))
SetGlobalString("slowmo_sound",GetConVarString("ttt_slowmo_sound"))
SetGlobalInt("slowmo_time",GetConVarNumber("ttt_slowmo_time"))

hook.Add("PlayerDeath","ttlor_PostRound_slow", function()
	--Wait a moment, so the player entity is actually dead.
	timer.Simple(0.005,function()	
		if GetRoundState() == ROUND_ACTIVE then
			if CheckForWin() == WIN_TRAITOR or CheckForWin() == WIN_INNOCENT then
			
				net.Start("slowmo_clslow")
				net.WriteBit(CheckForWin() == WIN_TRAITOR)
				net.Broadcast()	--Send this to all players
			
				game.SetTimeScale(0.25)
				local steps = 10
				local slowtime = GetGlobalInt("slowmo_time",0.5)
				timer.Simple(1,function() 
					for i = 1, steps do --Hacky system to fade out the slowmo
						timer.Simple((slowtime/steps)*i, function() game.SetTimeScale(0.25+0.75*((i^2)/100)) end)
					end
					timer.Simple(slowtime+0.05, function() game.SetTimeScale(1) end)
				end)
				timer.Simple(slowtime+1,function() game.SetTimeScale(1) end) --Ensure the scale is back to 1
			end
		end
	end)
end)
end

if CLIENT then
local ttt_draw_slowmo = false
local mt = 0

local ColorConstTable 
local ColorModifyTable
local BloomTable
net.Receive("slowmo_clslow",function()
	surface.PlaySound(GetGlobalString("slowmo_sound",""))
	ttt_draw_slowmo = GetGlobalBool("slowmo_draw",true)
	if ttt_draw_slowmo == false then return end
	local traitorwon = net.ReadBit() --This returns either 1 or 0; 1 if traitors won.
	
	--Put conditional here to control color and such. Maybe initiate the colormodify table outside of this hook
	if traitorwon == 1 then
		ColorConstTable = 
		{
			 .14,
			0,
			0,
			.026,
			.88,
			.2,
			.5,
			0,
			2
		}
		BloomTable =
		{
			.76,
			3.74,
			45.1,
			26.03,
			2,
			2.58,
			1,
			1,
			1
		}
	else
		ColorConstTable = 
		{
			0,
			0,
			.1,
			.05,
			.88,
			.65,
			0,
			0,
			0
		}
		BloomTable =
		{
			.72,
			1.73,
			37.89,
			22.94,
			2,
			4.23,
			1,
			1,
			1
		}
	end
	--And then set it in here depending on traitorwon?
	
	local slowtime = GetGlobalInt("slowmo_time",0.5)
	timer.Simple(1.5+slowtime,function() ttt_draw_slowmo = false end)
	
	for i = 1, 20 do
		timer.Simple(0.00625*i,function() mt = (i^2)/400 end) --Fade In
		timer.Simple((1.25+.125+0.0125*i)*(slowtime/0.5), function() mt = 1 - (i^2)/400 end) --Fade out
	end
end)

hook.Add("RenderScreenspaceEffects","ttt_slowmo_effects",function()
	if ttt_draw_slowmo then
		--Put rendering effect code here.
		ColorModifyTable = 
		{
			[ "$pp_colour_addr" ]		= ColorConstTable[1]*mt,
			[ "$pp_colour_addg" ]		= ColorConstTable[2]*mt,
			[ "$pp_colour_addb" ]		= ColorConstTable[3]*mt,
			[ "$pp_colour_brightness" ]	= ColorConstTable[4]*mt,
			[ "$pp_colour_contrast" ]	= 1 +(mt*(ColorConstTable[5]-1)), -- ISSUE!
			[ "$pp_colour_colour" ]		= 1 +(mt*(ColorConstTable[6]-1)),
			[ "$pp_colour_mulr" ]		= ColorConstTable[7]*mt,
			[ "$pp_colour_mulg" ]		= ColorConstTable[8]*mt,
			[ "$pp_colour_mulb" ]		= ColorConstTable[9]*mt
		}
		DrawToyTown(4, mt*(ScrH()*.33))
		DrawBloom( mt*BloomTable[1], mt*BloomTable[2], mt*BloomTable[3], mt*BloomTable[4], math.Round(mt*BloomTable[5])	, mt*BloomTable[6], mt*BloomTable[7], mt*BloomTable[8], mt*BloomTable[9])
		DrawColorModify(ColorModifyTable)
	end
end)
end