local Tabs = {
	["Serverside"] = {
		{"function","GM:SetEnableGlobalNoclip(bool)",},
		{"function","GM:SetEnablePlayerCollision(bool)",},
		{"function","GM:SetEnablePlayerPickup(bool,bool)",},
		{"function","mysql:Start(Host,User,Pass,Database)",},
		{"function","mysql:Query(Query,Database)",},
		{"function","resource.AddDir(Directory)",},
	},
	["Shared"] = {
		{"function","AddLuaCSFolder(Lua Directory)",},
		{"function","AddLuaSVFolder(Lua Directory)",},
		{"function","math.IsFloat(Integer/Float)",},
		{"function","math.AngleNormalize(Angle)",},
		{"function","Player:AddNote(Msg)",},
		{"function","GM:GetGlobalSHVarTable()",},
		{"function","GM:SetGlobalSHVar(Index,Value,[Player])",},
		{"function","GM:GetGlobalSHVar(Index,[Default value])",},
		{"function","Entity:GetSHVarTable()",},
		{"function","Entity:SearchSHVarTable(Part of Index)",},
		{"function","Entity:AddNonTempSH(Key,Value)",},
		{"function","Entity:SetSHVar(Index,Value,[Player])",},
		{"function","Entity:GetSHVar(Index,[Default value])",},
	},
	["Clientside"] = {
		{"function","GM:SetCameraDistance(Integer)",},
		{"function","GM:AddCameraDistance(Integer)",},
		{"function","GM:SetEnableThirdPerson(bool)",},
		{"function","GM:SetMOTD(url)",},
		{"function","GM:EnableMOTD(bool)",},
		{"function","GM:ReloadMOTD()",},
		{"function","GM:AddBlockCHud(CHud string)",},
		{"function","GM:SetEnableMawChat(bool)",},
		{"function","GM:EnableMawFace(bool)",},
		{"function","GM:SetEnableMawNameTag(bool)",},
		{"function","GM:SetEnableMawCircle(bool)",},
		{"function","GM:SetEnableMawVoiceHUD(bool)",},
		{"function","IsFirstPerson()",},
		{"function","GetCameraPos()",},
		{"function","SetCameraObject(Entity)",},
		{"function","SetDefaultDeathPos(Vector)",},
		{"function","SetCameraMinDistance(Integer)",},
		{"function","SetCameraMaxDistance(Integer)",},
		{"function","SetCameraZNear(Float)",},
		{"function","SetCameraZFar(Integer)",},
		{"function","input.IsMouseInBox( x , y , w , h )",},
		{"function","input.KeyPress(KEY,[SpecificID])",},
		{"function","input.MousePress(MOUSE,[SpecificID])",},
		{"function","ChangeSkybox(String 'Root is skybox/')",},
		{"function","DrawBoxy(x,y,w,h,color)",},
		{"function","DrawText(text,font,x,y,color,bCentered 'integer')",},
		{"function","DrawRect(x,y,w,h,color)",},
		{"function","DrawOutlinedRect(x,y,w,h,color)",},
		{"function","DrawLeftGradient(x,y,w,h,color)",},
		{"function","DrawTexturedRect(x,y,w,h,color,textureID)",},
		{"function","DrawTexturedRectRotated(x,y,w,h,color,textureID,ang)",},
		{"function","DrawLine(x,y,x2,y2,color)",},
	},
	["MB Panels"] = {
		{"PANEL","MBFrame",},
		{"PANEL","MBButton",},
		{"PANEL","MBBrowser",},
		{"PANEL","MBUserBrowser",},
		{"PANEL","MBLabel",},
		{"PANEL","MBModel",},
		{"PANEL","MBPanelList",},
		{"PANEL","MBTab",},
	},
	["MB Vars"] = {
		{"ClientVar","GM.UseMawChat",},
		{"ClientVar","GM.UseMawBlockCHud",},
		{"ClientVar","GM.UseMawSun",},
		{"Color","MAIN_COLORD",},
		{"Color","MAIN_COLOR",},
		{"Color","MAIN_COLOR2",},
		{"Color","MAIN_TEXTCOLOR",},
		{"Color","MAIN_BLACKCOLOR",},
		{"Color","MAIN_NOCOLOR",},
		{"Color","MAIN_VOICECOLOR",},
		{"Color","MAIN_GREENCOLOR",},
		{"Color","MAIN_YELLOWCOLOR",},
		{"Color","MAIN_REDCOLOR",},
		{"Color","MAIN_WHITECOLOR",},
		{"Font","ScoreboardFont",},
		{"Font","MBDefaultFont",},
		{"Font","MBChatFont",},
		{"Font","MBChatFont_Tag",},
		{"Font","MBPlayerNameFont",},
	},
}



local TextC = Color(40,40,40,255)
local FuncC = Color(0,0,255,255)
local Exi 

hook.Add("OnSpawnMenuOpen","OpenFunctionList",function()
	--This is a snip used to automaticly remove the functionlist if it is not GearFox.
	if (!GAMEMODE.Name:find("GearFox")) then hook.Remove("OnSpawnMenuOpen","OpenFunctionList") return end

	if (!Exi) then
		Exi = vgui.Create("MBTab")
		Exi:SetPos(50,50)
		Exi:SetSize(400,400)
		Exi:MakePopup()
		
		for d,l in pairs(Tabs) do
			local A = Exi:AddTab(d)
		
			local a = vgui.Create("MBPanelList",A)
			a:SetPos(10,10)
			a:SetSize(A:GetWide()-20,A:GetTall()-20)
			a:SetSpacing(1)
			a:EnableHorizontal(false)
			a:EnableVerticalScrollbar(true)
			a.Paint = function(s) DrawRect(0,0,s:GetWide(),s:GetTall(),MAIN_WHITECOLOR) end
		
			for k,v in pairs(l) do
				local p = vgui.Create("MBLabel")
				p:SetSize(a:GetWide()-5,1)
				
				p:AddText(v[1],"Default",FuncC)
				p:AddText(v[2],"Default",TextC)
				
				p:SetupLines()
				
				a:AddItem(p)
			end
		end
	end
	
	Exi:SetVisible(true)
end)

hook.Add("OnSpawnMenuClose","CloseFunctionList",function()
	if (!GAMEMODE.Name:find("GearFox")) then hook.Remove("OnSpawnMenuClose","CloseFunctionList") return end
	if (!Exi) then return end
	
	Exi:SetVisible(false)
end)