if ( SERVER ) then
	include("init.lua")
	include("items.lua")
else
	include("cl_init.lua")
end

if (!file.IsDir("inventory", "DATA")) then
	file.CreateDir("inventory")
end

-- Create text files if they don't exist
if !file.Exists("inventory/database.txt", "DATA") then
	file.Write("inventory/database.txt")
end