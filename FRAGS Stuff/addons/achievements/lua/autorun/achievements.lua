if SERVER then AddCSLuaFile()
    include("achievements/init.lua")
    else include("achievements/cl_init.lua") end