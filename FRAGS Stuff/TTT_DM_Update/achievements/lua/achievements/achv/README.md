# Adding New Categories
To add a new category is very simple, just create a new categoryname.lua file in this directory and fill in the blanks:

  local category = achievements.CreateCategory("Category Name")
  category.Icon = "gui/achievements/cat_icon.png"
  category.DisplayOrder = 2 -- the order you want them displayed in the tabs menu
  category.Active = function() return gmod.GetGamemode().Name == "Gamemode Name" end

# Adding New Achievements
To add a new achievement, you have to place it in the same file as the category you wish it to be in.
For example if I wanted to add a new TTT achievement I would append the following to the bottom of ttt.lua:

  do
      local ACH = {}
      ACH.Type = ACHIEVEMENT_ONEOFF -- ACHIEVEMENT_PROGRESS
      ACH.Description = "Description"

      function ACH:Initialize()
          hook.Add("PlayerConnect", "AchvConnect", function( ply )
              self:Complete( ply )
          end)
      end

      achievements.Register( category, "uniqueidentifer", "Achievement Name", ACH )
  end

An important thing to note is that uniqueidentifer HAS to be unique and can not be changed afterwards.
Achievement names however can be changed, as long as the unique identifer stays the same.
In this example achievement, the player would unlock the achievement by connecting to the server.

# RocketMania's Achievements
If you've previously used RocketMania's achievement system and wish to convert your achievements from his system to this one, it's pretty painless.
Take the following achievement from RocketMania's system:

  local ACVMT = ACV_CreateACVStruct()
  ACVMT.LuaName = "ACV_TTT_Main_PlayTTT100"
  ACVMT.PrintName = "Addicted to TTT"
  ACVMT.Description = "Play 100 Rounds!"
  ACVMT.Category = "TTT"
  ACVMT.TTT_BroadCastWhenRoundEnd = true
	
  ACVMT.Order = 1
  ACVMT.Min = 0
  ACVMT.Max = 100

  RegisterACVMT(ACVMT)

  if SERVER then
      hook.Add("TTTEndRound","ACV " .. "TTTEndRound" .. ACVMT.LuaName,function(GM,type)
	      for k,v in pairs(player.GetAll()) do
	          v:ACV_Increase(ACVMT.LuaName,1)
	      end
	  end)
  end

First off we find the category it belongs to and use that file, eliminating ACVMT.Category.
Then we lay down the basic info of our achievement, where
printname = ACVMT.PrintName
luaname = ACVMT.LuaName
desc = ACVMT.Description

  do
      local ACH = {}
      ACH.Description = "desc"

      achievements.Register( category, "luaname", "printname", ACH )
  end

We can ignore ACVMT.TTT_BroadCastWhenRoundEnd and ACVMT.Order, our system handles these differently.
We then need to tell our achievement system the goals to trigger the achievement, if it's a one off thing:
  ACH.Type = ACHIEVEMENT_ONEOFF
else we tell it it's a progress thing and set the target:
  ACH.Type = ACHIEVEMENT_PROGRESS
  ACH.Target = 100

Lastly our code that actually handles the achievement, all the hooks and stuff we can just throw inside of ACH:Initialize()
ACH:Initalize() is only called serverside anyway so we can also remove the if SERVER check. So from that given example achievement we can make:

  do
      local ACH = {}
      ACH.Type = ACHIEVEMENT_PROGRESS
      ACH.Description = "Play 100 Rounds!"
      ACH.Target = 100

      function ACH:Initialize()
          hook.Add("TTTEndRound", "AchvPlayTTT100", function()
		      for _, ply in pairs(player.GetAll()) do
		      	self:AddPoint( ply, 1 )
		      end
		  end)
      end

      achievements.Register( category, "ACV_TTT_Main_PlayTTT100", "Addicted to TTT", ACH )
  end