local category = achievements.CreateCategory("GMR")
category.Icon = "gui/achievements/ttt_1OCKED.png"
category.DisplayOrder = 3
category.Active = function() return gmod.GetGamemode().Name == "racer" end