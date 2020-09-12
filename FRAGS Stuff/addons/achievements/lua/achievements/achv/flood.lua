local category = achievements.CreateCategory("Flood")
category.Icon = "gui/achievements/ttt_1OCKED.png"
category.DisplayOrder = 3
category.Active = function() return gmod.GetGamemode().Name == "Flood" end