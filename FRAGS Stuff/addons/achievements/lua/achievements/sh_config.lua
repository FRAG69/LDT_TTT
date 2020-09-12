if SERVER then AddCSLuaFile() end

local config = achievements.Config

achievements.Skin = "sleek" -- Defaults: sleek, derma
achievements.FrameTitle = [[LDT Community - Achievements]]
achievements.ChatCommand = "!achv" -- You probably want this handled by your admin mod.
achievements.ConsoleCommand = "OpenAchv"
achievements.OpenKey = KEY_F4 -- http://wiki.garrysmod.com/page/Enums/KEY