
local function LDTgranking( msg )
	local int = msg:ReadShort()
	local str = msg:ReadString()
	local grey = Color(150,150,150)
	local oran = Color(233,152,37)
	local green = Color(0,200,0)
	local red = Color(200,0,0)
	local blue = Color(0,0,200)
	
	if int == 0 then
		chat.AddText(oran, "LDT ",grey,"global ranking: ",red,"Ranks do not match!")
		chat.AddText(grey, "Ranking you: ",blue,str)
		chat.AddText(grey,"Re-checking ranking in 5 seconds.")
	elseif int == 1 then
		chat.AddText(oran, "LDT ",grey,"global ranking: ",green,"Ranks match!")
		chat.AddText(grey, "You are ranked: ",blue,str)
	elseif int == 2 then
		chat.AddText(oran, "LDT ",grey,"global ranking: Rank on database is ",green,str)
		chat.AddText(blue, "You will have to be ranked manually!")
	elseif int == 3 then
		chat.AddText(oran, "LDT ",grey,"global ranking: ",oran,"unranked")
	end
 
end

usermessage.Hook( "LDTgranking", LDTgranking )
