local EPT 		= FindMetaTable("Entity")
local SHQTab	= 0
local SHQLimit	= 100
local SHQTabC	= 0
local SHQSend 	= {}
local SHNonTemp = {}

SHVAR_TYPE 				= {}
SHVAR_TYPE["string"] 	= 1
SHVAR_TYPE["number"] 	= 2
SHVAR_TYPE["boolean"] 	= 3
SHVAR_TYPE["entity"] 	= 4
SHVAR_TYPE["player"] 	= 5
SHVAR_TYPE["angle"] 	= 6
SHVAR_TYPE["vector"] 	= 7
SHVAR_TYPE["short"] 	= 8
SHVAR_TYPE["float"] 	= 9
SHVAR_TYPE["char"] 		= 10

local MB_SHVarEnts = {}


if (CLIENT) then
	usermessage.Hook("_SHVarEntityClean",function(um)
		local ID = um:ReadShort()
		MB_SHVarEnts[ID] = nil
	end)
	
	usermessage.Hook("_SetSHVar",function(um)
		local Type 	= um:ReadChar()
		local ID 	= um:ReadShort()
		local Name 	= um:ReadString()
		
		if (!MB_SHVarEnts[ID]) then MB_SHVarEnts[ID] = {} end
		if (!ValidEntity(ents.GetByIndex(ID))) then return end
			
		if (Type == 1) then
			MB_SHVarEnts[ID][Name] = um:ReadString()
		elseif (Type == 2) then
			MB_SHVarEnts[ID][Name] = um:ReadLong()
		elseif (Type == 3) then
			MB_SHVarEnts[ID][Name] = um:ReadBool()
		elseif (Type == 4) then
			local ID2 = um:ReadShort()
			MB_SHVarEnts[ID][Name] = ents.GetByIndex(ID2)
		elseif (Type == 5) then
			local ID2 = um:ReadShort()
			MB_SHVarEnts[ID][Name] = ents.GetByIndex(ID2)
		elseif (Type == 6) then
			MB_SHVarEnts[ID][Name] = um:ReadAngle()
		elseif (Type == 7) then
			MB_SHVarEnts[ID][Name] = um:ReadVector()
		elseif (Type == 8) then
			MB_SHVarEnts[ID][Name] = um:ReadShort()
		elseif (Type == 9) then
			MB_SHVarEnts[ID][Name] = um:ReadFloat()
		elseif (Type == 10) then
			MB_SHVarEnts[ID][Name] = um:ReadChar()
		else
			print( "Invailed Type: "..Type, "Setting to nil" )
			MB_SHVarEnts[ID][Name] = nil
		end
	end)
else
	hook.Add("PlayerAuthed","_AddSHVar",function(pl,sid,uid)
		for k,v in pairs( SHNonTemp ) do
			local Ent = ents.GetByIndex(k)
			if (ValidEntity(Ent)) then
				for a,b in pairs( v ) do
					Ent:SetSHVar(a,b,pl)
				end
			else
				SHNonTemp[k] = nil
			end
		end
	end)
	
	hook.Add("EntityRemoved","ClearEntitySHVarTable",function(E) 
		SHQTabC = SHQTabC+1
		timer.Simple(SHQTabC/80,function(ID)
			local RP = RecipientFilter()
			RP:AddAllPlayers()
				
			umsg.Start("_SHVarEntityClean",RP)
				umsg.Short(ID)
			umsg.End()
			
			MB_SHVarEnts[ID] = nil
			SHQTabC=SHQTabC-1
		end,E:EntIndex())
	end)
end

function EPT:GetSHVarTable()
	return MB_SHVarEnts[self:EntIndex()]
end

function EPT:SearchSHVarTable(Name)
	local DAT = {}
	local ID  = self:EntIndex()
	
	if (!MB_SHVarEnts[ID]) then return {} end
	for k,v in pairs(MB_SHVarEnts[ID]) do
		if (k:find(Name) and v != nil) then
			DAT[k] = v
		end
	end
	
	return DAT
end

function EPT:AddNonTempSH(bKey,Value)
	local ID = self:EntIndex()
	
	if (!SHNonTemp[ID]) then SHNonTemp[ID] = {} end
	SHNonTemp[ID][bKey] = Value
	
	self:SetSHVar(bKey,Value)
end

function EPT:SetSHVar(Name,Var,ply) --Third argument should only be defined if it is send specificly only for this player.
	local ID = self:EntIndex()

	if (!MB_SHVarEnts[ID]) then MB_SHVarEnts[ID] = {} end
	MB_SHVarEnts[ID][Name] = Var

	if (SERVER) then
		SHQTab 							= SHQTab + 1
		local Delay 					= SHQTab/SHQLimit
		
		timer.Simple(Delay,function(D) --Delaying each every single umsg
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
			
			umsg.Start("_SetSHVar",RP)
				umsg.Char(SHVAR_TYPE[Type])
				umsg.Short(D)
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
				elseif (Type == "float") then
					umsg.Float(Var)
				elseif (Type == "char") then
					umsg.Char(Var)
				end
			umsg.End()
			
			SHQTab = SHQTab - 1
		end,ID)
	end
end

function EPT:GetSHVar(Name,Var)
	local ID = self:EntIndex()
	if (!MB_SHVarEnts[ID] or MB_SHVarEnts[ID][Name] == nil) then return Var or nil end
	return MB_SHVarEnts[ID][Name]
end