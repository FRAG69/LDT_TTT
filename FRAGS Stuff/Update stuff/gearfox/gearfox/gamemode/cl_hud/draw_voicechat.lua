local VoiceMat = surface.GetTextureID("voice/speaker4")
local VoiceEna = true

function GM:PlayerStartVoice( ply )
	if (!VoiceEna) then self.BaseClass:PlayerStartVoice( ply ) return end
	ply.Talking = true
end

function GM:PlayerEndVoice( ply )
	if (!VoiceEna) then self.BaseClass:PlayerEndVoice( ply ) return end
	ply.Talking = nil
end

function GM:SetEnableMawVoiceHUD(bool)
	VoiceEna = bool
end

hook.Add("HUDPaint","_VoiceChatDraw",function()
	if (!VoiceEna) then return end
	
	local D = 0

	for k,v in pairs( player.GetAll() ) do
		if (v.Talking) then
			local H = 30 + 30*D
			D = D+1
			
			DrawBoxy( 10, H, 200, 25, MAIN_VOICECOLOR )
			DrawTexturedRect( 190, H+4, 16, 16, MAIN_TEXTCOLOR, VoiceMat )
			DrawText( v:Nick(), "Trebuchet18", 14, H+3, MAIN_TEXTCOLOR )
		end
	end
end)