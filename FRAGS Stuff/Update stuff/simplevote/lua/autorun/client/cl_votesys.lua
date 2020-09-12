require("datastream")

local maplist = {}
votes = {}

function ResetSVVotes()
	for k, _ in pairs(maplist) do
		votes[k] = 0
	end
end

usermessage.Hook("ResetClientVotes", ResetSVVotes)

function UpdateSVVotes(um)
	local t = string.Explode(" ", um:ReadString())
	votes[tonumber(t[1])] = tonumber(t[2])
end

usermessage.Hook("UpdateSVVotes", UpdateSVVotes)
	
function ReceiveMaps(handle, id, encoded, decoded)
	maplist = decoded
	for k, _ in pairs(maplist) do
		votes[k] = 0
	end
	Msg("[SimpleVote] Maplist Recieved!, number of maps avaible: " .. tostring(#maplist) .. "\n")
end

datastream.Hook("ReceiveMaps", ReceiveMaps)
 
function vmenu()

local VotePanel = vgui.Create( "DFrame" )
VotePanel:SetPos( ScrW() / 2.5, ScrH() - (ScrH() - 55) )
VotePanel:SetSize( 550, 550 )
VotePanel:SetTitle( "Click the map you want to vote for" )
VotePanel:SetVisible( true )
VotePanel:SetDraggable( false )
VotePanel:ShowCloseButton( true )
VotePanel:MakePopup()
 
local VoteList = vgui.Create("DListView")
VoteList:SetParent(VotePanel)
VoteList:SetPos((ScrW()/2.5) - 50, ScrH() - (ScrH() - 45))
VoteList:SetSize(225, 500)
VoteList:Center()
VoteList:SetMultiSelect(false)
VoteList:AddColumn("Map")
local votec = VoteList:AddColumn("Votes")
    votec:SetMinWidth(34)
    votec:SetMaxWidth(34)
VoteList.DoDoubleClick = function(parent, index, line)
							RunConsoleCommand("votefor", line:GetID())
							VotePanel:Close()
						end
VoteList.Think = function()
					for k, v in pairs(VoteList:GetLines()) do
						v:SetValue(2, votes[k])
					end
				end

for k, v in pairs(maplist) do
	VoteList:AddLine(v, votes[k])
end

end

concommand.Add("vmenu", vmenu)	