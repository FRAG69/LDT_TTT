# Achievements

## Install
Copy the achievements folder into addons so this file exists as garrysmod/addons/achievements/README.MD

## Configuration
General options can be modified in sh_config.lua such as:

*   achievements.Skin = "sleek" -- two default skins are derma and sleek
*   achievements.FrameTitle = [[My Community - Achievements]]
*   achievements.ChatCommand = "!achv" -- You probably want this handled by your admin mod.
*   achievements.ConsoleCommand = "OpenAchv"
*   achievements.OpenKey = KEY_F4 -- http://wiki.garrysmod.com/page/Enums/KEY 

Configuring an SQLLite or MySQL database can be done and is explained in _sv_config.lua_.

## Adding new achievements
Docs for adding new achievements can be found in lua/achievements/achv/README.md instructions also include converting RocketMania's achievements.

## Support
I'll give you support as best as I can, but there are no guarantees I can help you if you're making your own adjustments to the script, or if you simply can't understand how to move files around on your operating system.

## Suggestions
Suggestions for new achievements to add are always welcome, just leave a comment and I'll make it happen. :)