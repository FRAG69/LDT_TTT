local give = CCachievements.GetValue( "I am a good guy", "total", 0 )

local function PlayerDonator()

if give > 0 then
   timer.Destroy( "Achievement.donate" )
   return
end
	local ply = LocalPlayer()
	
	 if ply:GetNWBool("LDTdonator",false) then
		CCachievements.Update( "I am a good guy", 1, "" )
		CCachievements.SetValue( "I am a good guy", "give", 1 )
	end
end
timer.Create( "Achievement.donate",2,0, PlayerDonator )
CCachievements.Register( "I am a good guy", "Donate.", "achievements/donate", give, "" )