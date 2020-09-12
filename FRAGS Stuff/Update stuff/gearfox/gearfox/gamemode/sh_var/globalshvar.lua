local EPT 		= FindMetaTable("Entity")
local SHQTab	= 0
local SHQLimit	= 200
local SHQSend 	= {}
local SHNonTemp = {}

GM._GlobalSHVars = {}

if (CLIENT) then
	usermessage.Hook("_SetGlobalSHVar",function(um)
		GM = GM or GAMEMODE
	
		local Type 	= um:ReadChar()
		local Name 	= um:ReadString()
		
		if (Type == 1) then
			GM._GlobalSHVars[Name] = um:ReadString()
		elseif (Type == 2) then
			GM._GlobalSHVars[Name] = um:ReadLong()
		elseif (Type == 3) then
			GM._GlobalSHVars[Name] = um:ReadBool()
		elseif (Type == 4) then
			local ID2 = um:ReadShort()
			GM._GlobalSHVars[Name] = ents.GetByIndex(ID2)
		elseif (Type == 5) then
			local ID2 = um:ReadShort()
			GM._GlobalSHVars[Name] = ents.GetByIndex(ID2)
		elseif (Type == 6) then
			GM._GlobalSHVars[Name] = um:ReadAngle()
		elseif (Type == 7) then
			GM._GlobalSHVars[Name] = um:ReadVector()
		elseif (Type == 8) then
			GM._GlobalSHVars[Name] = um:ReadShort()
		elseif (Type == 9) then
			GM._GlobalSHVars[Name] = um:ReadFloat()
		elseif (Type == 10) then
			GM._GlobalSHVars[Name] = um:ReadChar()
		else
			print( "Invailed Type: "..Type )
			GM._GlobalSHVars[Name] = nil
		end
	end)
else
	hook.Add("PlayerAuthed","_AddGlobalSHVar",function(pl,sid,uid)
		GM = GM or GAMEMODE
		
		for k,v in pairs( GM._GlobalSHVars ) do
			GM:SetGlobalSHVar(k,v,pl)
		end
	end)
end

function GM:GetGlobalSHVarTable()
	return self._GlobalSHVars
end

function GM:SetGlobalSHVar(Name,Var,ply)
	self._GlobalSHVars[Name] = Var

	if (SERVER) then
		SHQTab 							= SHQTab + 1
		local Delay 					= SHQTab/SHQLimit
		
		timer.Simple(Delay,function() --Delaying each every single umsg
			local RP = RecipientFilter()
			if (ValidEntity(ply)) then
				RP:AddPlayer(ply)
			else
				RP:AddAllPlayers()
			end
			
			if (!SHVAR_TYPE[type(Var):lower()]) then return end
			local Type = type(Var):lower()
			if (Type == "number" and !math.IsFloat(Var) and Var < 32768 and Var > -32767) then Type = "short" end
			if (Type == "short" and !math.IsFloat(Var) and Var < 128 and Var > -127) then Type = "char" end
			if (Type == "number" and math.IsFloat(Var)) then Type = "float" end
			
			umsg.Start("_SetGlobalSHVar",RP)
				umsg.Char(SHVAR_TYPE[Type])
				umsg.String(Name)

				if (Type == "string") then
					umsg.String(Var)
				elseif (Type == "number") then
					umsg.Long(Var)
				elseif (Type == "boolean") then
					umsg.Bool(Var)
				elseif (Type == "entity") then
					umsg.Short(Var:EntIndex())
				elseif (Type == "player") then
					umsg.Short(Var:EntIndex())
				elseif (Type == "angle") then
					umsg.Angle(Var)
				elseif (Type == "vector") then
					umsg.Vector(Var)
				elseif (Type == "short") then
					umsg.Short(Var)
				elseif (Type == "char") then
					umsg.Char(Var)
				elseif (Type == "float") then
					umsg.Float(Var)
				end
			umsg.End()
			
			SHQTab = SHQTab - 1
		end)
	end
end

function GM:GetGlobalSHVar(Name,Var)
	if (!self._GlobalSHVars or self._GlobalSHVars[Name] == nil) then return Var or nil end
	return self._GlobalSHVars[Name]
end