
/*
   __     ___  ______                     _        _             _        
  / /    /   \/__  __|_ __ ___   _   _   /_\    __| | _ __ ___  (_) _ __  
 / /    / /\ /  / /  | '_ ` _ \ | | | | //_\\  / _` || '_ ` _ \ | || '_ \ 
/ /___ / /_//  / /   | | | | | || |_| |/  _  \| (_| || | | | | || || | | |
\____//___,'   \/    |_| |_| |_| \__, |\_/ \_/ \__,_||_| |_| |_||_||_| |_|
                                 |___/                                    

	LDTmyAdmin - fucking incomplete version
	Property of the Let's Do This community
	Made by psycix
*/

/*==========================================================
	Initialize
==========================================================*/
include("lma_sh.lua")

function LMA_Initialize()

end
hook.Add( "Initialize", "LMA_Initialize", LMA_Initialize );

net.Receive( "LMA_chatmsg", function( length, client )
	chat.AddText(Color(128,128,128),"[", Color(255,158,0), "LDTmyAdmin", Color(128,128,128),"] ",Color(255,255,255), net.ReadString())
end )

local LMA_Commands = {}
LMA_Commands["slay"] = {}
LMA_Commands["slay"]["rank"] = 1
LMA_Commands["slay"]["help"] = "<player> [reason]"

LMA_Commands["sitout"] = {}
LMA_Commands["sitout"]["rank"] = 1
LMA_Commands["sitout"]["help"] = "<player> [reason]"

LMA_Commands["unsitout"] = {}
LMA_Commands["unsitout"]["rank"] = 1
LMA_Commands["unsitout"]["help"] = "<player>"

LMA_Commands["kick"] = {}
LMA_Commands["kick"]["rank"] = 1
LMA_Commands["kick"]["help"] = "<player> [reason]"

LMA_Commands["ban"] = {}
LMA_Commands["ban"]["rank"] = 2
LMA_Commands["ban"]["help"] = "<player> <time> [reason]"

LMA_Commands["tp"] = {}
LMA_Commands["tp"]["rank"] = 2
LMA_Commands["tp"]["help"] = "<player>"

LMA_Commands["goto"] = {}
LMA_Commands["goto"]["rank"] = 2
LMA_Commands["goto"]["help"] = "<player>"

/*LMA_Commands["mute"] = {}
LMA_Commands["unmute"] = {}
LMA_Commands["mute"]["rank"] = 1
LMA_Commands["unmute"]["rank"] = 1
LMA_Commands["mute"]["help"] = "<player>"
LMA_Commands["unmute"]["help"] = "<player>"*/

local LMA_NonPlayerCommands = {}
LMA_NonPlayerCommands["ban"] = {}
LMA_NonPlayerCommands["ban"]["rank"] = 2
LMA_NonPlayerCommands["ban"]["help"] = "<steamID> <time> [reason]"
LMA_NonPlayerCommands["unban"] = {}
LMA_NonPlayerCommands["unban"]["rank"] = 2
LMA_NonPlayerCommands["unban"]["help"] = "<steamID>"
LMA_NonPlayerCommands["g"] = {}
LMA_NonPlayerCommands["g"]["rank"] = 2
LMA_NonPlayerCommands["g"]["help"] = "<your global message>"

/*==========================================================
	Chat input reading
==========================================================*/

local LMA_IsChatting = false
local LMA_ChatString = ""
local LMA_ChatChanged = false
local LMA_TargetPlayers = {}
local LMA_ChatCmd = ""

local LMA_top_drawtable = {}
local LMA_top_unknown = {"Not a known LDTmyAdmin command."}
local LMA_top_instr = {"! - commands by player name",
"/ - commands by player sessionID",
"@ - commands without target"}
local LMA_drawbot = 0
local LMA_logomaterial = Material("LMA/LDTmyAdmin.png")

local function LMA_StartChat(TeamSay)
LMA_IsChatting = true
LMA_ChatString = ""
LMA_ChatChanged = true
LMA_TargetPlayers = {}
LMA_ChatCmd = ""
end
hook.Add("StartChat", "LMA_StartChat", LMA_StartChat)

function LMA_FinishChat() 
LMA_IsChatting = false
LMA_ChatString = ""
LMA_ChatChanged = true
LMA_TargetPlayers = {}
LMA_ChatCmd = ""
end
hook.Add( "FinishChat", "LMA_FinishChat", LMA_FinishChat )

function LMA_ChatTextChanged( text )
LMA_ChatString = text
LMA_ChatChanged = true
end
hook.Add( "ChatTextChanged", "LMA_ChatTextChanged", LMA_ChatTextChanged )

/*==========================================================
	Chat processing and drawing
==========================================================*/

surface.CreateFont ("LMA_ListFont", {font = "Calibri", size = 20})
//surface.CreateFont ("LMA_ASCII", {font = "Courier New", size = 10,  weight = 1000})
/*local LMA_ascii = {"   __     ___  ______                     _        _             _        ",
				 "  / /    /   \\/__  __|_ __ ___   _   _   /_\\    __| | _ __ ___  (_) _ __  ",
				 " / /    / /\\ /  / /  | '_ ` _ \\ | | | | //_\\\\  / _` || '_ ` _ \\ | || '_ \\ ",
				 "/ /___ / /_//  / /   | | | | | || |_| |/  _  \\| (_| || | | | | || || | | |",
				 "\\____//___,'   \\/    |_| |_| |_| \\__, |\\_/ \\_/ \\__,_||_| |_| |_||_||_| |_|",
				 "                                 |___/                                    "}			
			for k, v in pairs(LMA_ascii) do
				draw.SimpleText(v, "LMA_ASCII", x, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				y = y + 10
			end*/

function LMA_DrawOnchatPlayerlist()
if LMA_IsChatting then	
	if LMA_ChatString != "" then
	
		local firstchar = string.Left(LMA_ChatString,1)
		
		if firstchar == "/" or firstchar == "!" or firstchar == "@" then
			local arg = string.Explode(" ", LMA_ChatString)
			local worktable = LMA_Commands
			if firstchar == "@" then
				worktable = LMA_NonPlayerCommands
			end
			LMA_drawbot = 0
			LMA_ChatCmd = string.lower(string.sub(arg[1], 2))
			if arg[2] then
				if worktable[LMA_ChatCmd] then
					//Draw TOP cmdhelp
					LMA_top_drawtable = {"Usage: "..arg[1].." "..worktable[LMA_ChatCmd]["help"]}
					
					if firstchar == "!" then
						//Draw BOT players
						LMA_TargetPlayers = LMA_GetPlayerGroupByName(arg[2])
						LMA_drawbot = 1
					elseif firstchar == "/" then
						//Draw BOT players
						LMA_TargetPlayers = {}
						local pl = LMA_GetPlayerBySession(tonumber(arg[2]))
						if pl then
							LMA_TargetPlayers[1] = pl
						end
						LMA_drawbot = 1
					else//if firstchar != "@" then
						//No players to be drawn.
					end
				else
					//Draw TOP unknown cmd
					LMA_top_drawtable = LMA_top_unknown
				end
			else
				//Draw TOP instr
				LMA_top_drawtable = LMA_top_instr
				//Draw BOT command list
				LMA_drawbot = 2
			end			
		
			//Draw prep
			local cx, cy = chat.GetChatBoxPos()
			
			//Execute BOT draw
			if LMA_drawbot == 1 then
				--Draw players
				local cutoff = 16
				local cols = math.ceil(#player.GetAll() / cutoff)
				local cutoff  = math.ceil(#player.GetAll() / cols)
				local w = 50 + cols * 150
				local h = 20 * math.min(#player.GetAll(), cutoff) + 10			
				local x = cx
				local y = cy-h
				draw.RoundedBox( 10, x, y, w, h, Color(0,0,0, 225) )
				cy = y
				x = x + 10 - 150
				y = y + 5
				local basey = y
				local i = 1
				
				for k, v in pairs(player.GetAll()) do				
					if i % cutoff != 1 then
						y = y + 20
					else
						y = basey + 20
						x = x + 150
					end
					i = i + 1				
					local v = player.GetAll()[k]
					if LMA_TargetPlayers and LMA_TargetPlayers != {} then
						if (table.HasValue(LMA_TargetPlayers, v)) then
							if (#LMA_TargetPlayers == 1) then
								draw.SimpleText(v:GetNWInt("LMA_session")..": "..v:Nick(), "LMA_ListFont", x, y, Color(233,89,37,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
							else
								draw.SimpleText(v:GetNWInt("LMA_session")..": "..v:Nick(), "LMA_ListFont", x, y, Color(233,152,37,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
							end
						else
							draw.SimpleText(v:GetNWInt("LMA_session")..": "..v:Nick(), "LMA_ListFont", x, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						end
					else
						draw.SimpleText(v:GetNWInt("LMA_session")..": "..v:Nick(), "LMA_ListFont", x, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					end
				end
			elseif LMA_drawbot == 2 then
				--Draw cmds
				local worktable = {}
				if firstchar == "@" then
					worktable = LMA_NonPlayerCommands
				else
					worktable = LMA_Commands
				end
				local w = 200
				local h = 20 * table.Count(worktable) + 10
				local x = cx
				local y = cy-h
				draw.RoundedBox( 10, x, y, w, h, Color(0,0,0, 225) )
				cy = y
				x = x + 10
				y = y + 20 + 5		
				for k,v in pairs(worktable) do
					if LocalPlayer():LMA_IsRank(v["rank"]) then //We may execute this
						if worktable[LMA_ChatCmd] then //Existing command, let's color
							if k == LMA_ChatCmd then //Got it!
								draw.SimpleText(firstchar..k, "LMA_ListFont", x, y, Color(233,89,37,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
							else //Others!
								draw.SimpleText(firstchar..k, "LMA_ListFont", x, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
							end
						
						else //Not an existing command - everything white
							draw.SimpleText(firstchar..k, "LMA_ListFont", x, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						end
					else //Not high enough rank - make it grey
							draw.SimpleText(firstchar..k, "LMA_ListFont", x, y, Color(150,150,150,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						end
					y = y + 20
				end
				
			end
			
			//Execute TOP draw
			if #LMA_top_drawtable > 0 then
				local w = 300
				local h = #LMA_top_drawtable * 20 + 15 + 70
				local x = cx
				local y = cy - h
				draw.RoundedBox( 10, x, y-5, w, h, Color(0,0,0, 225) )
				x = x + 10
				y = y + 5			
				surface.SetMaterial(LMA_logomaterial)
				surface.SetDrawColor(Color(255,255,255,255))
				surface.DrawTexturedRect(x, y, 215, 35)
				y = y + 70 + 20
				for k, v in pairs(LMA_top_drawtable) do
					draw.SimpleText(v, "LMA_ListFont", x, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					y = y + 20
				end
			end
		else
			//Not a command
		end
	end
end
end
hook.Add("HUDPaint", "LMA_DrawOnchatPlayerlist", LMA_DrawOnchatPlayerlist)

//plinitspawn: LMA_ChatChanged = false

/*function LMA_Copy(msg)
str = msg:ReadString()
nick = msg:ReadString()
SetClipboardText(str)
chat.AddText("Copied "..nick.."'s: "..str)
end
usermessage.Hook("LMA_Copy", LMA_Copy)*/