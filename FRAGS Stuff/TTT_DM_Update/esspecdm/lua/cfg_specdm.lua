-- :::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::::               Configuration               ::::
-- :::::::::::::::::::::::::::::::::::::::::::::::::::

-- Toggles rendering a material on ghosts
ESConfig.UseMaterial = true

-- Material file to be used if materials are enabled
ESConfig.GhostMat = "models/shadertest/shader3"

-- Specifies the chat command which toggles spectator deathmatch
ESConfig.Cmd = "!ldtdm"

-- Enable restricting spec deathmatch to a specific user group
ESConfig.RestrictCmd = false

-- Group to allow access to spectator deathmatch if RestrictCmd is enabled
-- Add a comma and additional groups in quotes like so: { "superadmin", "owner", "donator" }
ESConfig.RestrictGroup = { "superadmin" }

-- Allows ghosts to jump multiple times in a row giving them the ability to fly
ESConfig.GhostJump = false

-- How high ghosts jump with each jump
ESConfig.JumpVelocity = 250

-- Should ghosts take fall damage?
ESConfig.GhostFallDamage = false

-- Give ghosts infinite ammo?
-- This prevents them from taking ammo drops when enabled and they fill their clip.
-- Temporary fix until I can resolve a way to dupe ammo pickups. I've had no luck in the hours I've spent messing with this.
ESConfig.InfiniteAmmo = true

-- This will override the standard HUD GM:HUDPaint() for ghosts only causing it to render the original HUD while in SpecDM.
ESConfig.HookHud = true

-- This is what gets drawn where inno, traitor, and detective text would when using HookHud
ESConfig.HUDName = "Ghost"

-- Enable restricting certain weapon to not be picked up by ghosts
ESConfig.RestrictWeapons = false

-- Weapons to prevent ghosts from picking up
ESConfig.RestrictedWeaponClasses = { "weapon_ttt_m16" }

-- :::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::::             End Configuration             ::::
-- :::::::::::::::::::::::::::::::::::::::::::::::::::