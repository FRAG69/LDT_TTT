//Achivements Achieved stuff

//Colours
ACH_COLOUR_BLUE = Color( 0, 110, 255 )
ACH_COLOUR_RED = Color( 30, 200, 20 )
ACH_COLOUR_WHITE = Color( 255, 255, 255 )

//Imported evolve functions (Removing dependancy)
local function Notify( ... )
	local ply
	local arg = { ... }
	
	if ( type( arg[1] ) == "Player" or arg[1] == NULL ) then ply = arg[1] end
	
	if ( ply != NULL ) then
		umsg.Start( "ACH_Notification", ply )
			umsg.Short( #arg )
			for _, v in ipairs( arg ) do
				if ( type( v ) == "string" ) then
					umsg.String( v )
				elseif ( type ( v ) == "table" ) then
					umsg.Short( v.r )
					umsg.Short( v.g )
					umsg.Short( v.b )
					umsg.Short( v.a )
				end
			end
		umsg.End()
	end
	
	local str = ""
	for _, v in ipairs( arg ) do
		if ( type( v ) == "string" ) then str = str .. v end
	end
	
	if ( ply ) then
		print( "[ACH] " .. ply:Nick() .. " -> " .. str )
	else
		print( "[ACH] " .. str )
	end
end
local function CreatePlayerList( tbl )
	local lst = ""
	
	if ( #tbl == 1 ) then
		lst = tbl[1]:Nick()
	elseif ( #tbl == #player.GetAll() ) then
		lst = "Everyone"
	else
		for i = 1, #tbl do
			if ( i == #tbl ) then
				lst = lst .. " and " .. tbl[i]:Nick()
			elseif ( i == 1 ) then
				lst = tbl[i]:Nick()
			else lst = lst .. ", " .. tbl[i]:Nick() end
		end
	end
	
	return lst
end

//Prints achivement messages
local function AchNotify(players, ach)
	if not (#players > 0) then return end
	if not ach then return end
	
	Notify( ACH_COLOUR_BLUE, CreatePlayerList( players ), ACH_COLOUR_WHITE, " has earned the achivement ", ACH_COLOUR_RED, table.concat(ach," ") )
	
	//Client side stuff
	for _,ply in pairs(players) do
		ply:SetNWString("Ach_last_Name",table.concat(ach," "))
		ply:SendLua([[ local name = LocalPlayer():GetNWString("Ach_last_Name","")
Achievements_PopUp(name) ]])

		ply:SendLua([[ if (GetConVarNumber("achievements_effect")>0) then
	local ed=EffectData()
	ed:SetEntity(LocalPlayer())
	util.Effect("achievement",ed,true,true)
end ]])
	end
end

//Checks who earned achivements
local function CheckAch(ach)
	if (GAMEMODE.Name == "Trouble in Terrorist Town") and (GetRoundState() == ROUND_ACTIVE) then
		return
	end
	
	timer.Destroy("Ach_"..table.concat(ach,"_"))
	
	local players={}
	
	for k,ply in pairs(player.GetAll()) do
		if ply:GetNWBool("Ach_"..table.concat(ach,"_")) then
			table.insert(players,ply)
			ply:SetNWBool("Ach_"..table.concat(ach,"_"),false)
		end
	end
	
	if not (#players > 0) then 
		MsgN("Achievement called, no players achieved!")
		return
	end
	AchNotify(players, ach)
end


//Starts the check for named achivement
concommand.Add("achivements_achieved",function(ply,command,args)
	timer.Create("Ach_"..table.concat(args,"_"),2,0,CheckAch,args)
end)


//Achievement Validation
local function AcceptStream(pl, handler, id)
	if ( string.find(handler,"AchivementsAchData") ) then 
		return true
	end
end
hook.Add("AcceptStream","AchivementsValidateAccept",AcceptStream)

local function IncomingHook(ply, handler, id, encoded, decoded)
	if (string.Left(handler,18) == "AchivementsAchData") then 
		ply = decoded[1]
		ach = "Ach_" .. decoded[2]
		
		ply:SetNWBool(ach, true)
	end
end

for i = 1,10 do
	datastream.Hook( "AchivementsAchData_" .. tostring(i), IncomingHook )
end