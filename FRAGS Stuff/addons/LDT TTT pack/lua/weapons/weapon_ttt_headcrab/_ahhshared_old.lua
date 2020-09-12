/*<><><><><><><><><><><><><><><><><><>*/
/*		Server and Client	      	  */
/*<><><><><><><><><><><><><><><><><><>*/
/**/
/**/	if (SERVER) then
/**/		AddCSLuaFile("shared.lua")
           SWEP.Base = "weapon_tttbase"
		   SWEP.Kind = WEAPON_EQUIP1 
		   SWEP.CanBuy = { ROLE_TRAITOR }
		   SWEP.LimitedStock = true
		   SWEP.EquipMenuData = {
   type = "Headcrab bomb",
   desc = "shoots headcrabs."
           SWEP.AllowDrop = true
		   SWEP.NoSights = true
		   
};
/**/   
/**/   		SWEP.HoldType = "pistol"
/**/ 	end
/**/ 
/**/	if (CLIENT) then
/**/    	SWEP.PrintName      = "Headcrab_canister_artillery"   
/**/    	SWEP.Author   		= "Monster_kill"
/**/   		SWEP.Slot           = 1
/**/    	SWEP.SlotPos		= 7
/**/    	SWEP.ViewModelFOV   = 60
/**/   		SWEP.IconLetter     = "x"
/**/   
/**/    	killicon.AddFont("weapon_ak47", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
/**/	end
/**/
/*<><><><><><><><><><><><><><><><><><>*/
/*		Contact Info   			 	  */
/*<><><><><><><><><><><><><><><><><><>*/
/**/
/**/	SWEP.Author   		= "Monster_kill"
/**/	SWEP.Contact        = ""
/**/	SWEP.Purpose        = ""
/**/	SWEP.Instructions   = "Left click will make a headcrab canister come down, right click will make it fly out from you like a bullet. That way is stronger but it has a smaller radius."
/**/
/*<><><><><><><><><><><><><><><><><><>*/
/*		Who can make it?	      	  */
/*<><><><><><><><><><><><><><><><><><>*/
/**/
/**/	SWEP.Spawnable      = true
/**/	SWEP.AdminSpawnable = true
/**/
/*<><><><><><><><><><><><><><><><><><>*/
/*		Weapon Models	      	      */
/*<><><><><><><><><><><><><><><><><><>*/
/**/
/**/	SWEP.ViewModel      = "models/weapons/v_pistol.mdl"
/**/	SWEP.WorldModel		= "models/weapons/w_pistol.mdl"
/**/
/*<><><><><><><><><><><><><><><><><><>*/
/*		Initialize Function	    	  */
/*<><><><><><><><><><><><><><><><><><>*/
/**/
/**/	function SWEP.Initialize()
/**/		util.PrecacheModel("models/props_combine/headcrabcannister01a.mdl")
/**/		util.PrecacheModel("models/props_combine/headcrabcannister01b.mdl")
/**/		util.PrecacheModel("models/props_combine/headcrabcannister01a_skybox.mdl")
/**/		util.PrecacheModel("models/headcrabclassic.mdl")
/**/		util.PrecacheModel("models/headcrab.mdl")
/**/		util.PrecacheModel("models/headcrabblack.mdl")
/**/	end
/**/
/*<><><><><><><><><><><><><><><><><><>*/
/*		Reload Function	      	  	  */
/*<><><><><><><><><><><><><><><><><><>*/
/**/
/**/	function SWEP:Reload()
/**/		local props = ents.FindByClass("env_headcrabcanister") -- Much simpler than inserting all the canisters into tables, and it works a lot better
/**/
/**/		for k,v in pairs(props) do -- This part took forever to get working
/**/			props[k]:Remove()
/**/
/**/			local explosion = ents.Create("env_explosion") -- Kaboom!                 
/**/			explosion:SetPos(props[k]:GetPos())            
/**/			explosion:SetKeyValue("iMagnitude", " 200")                
/**/			explosion:SetKeyValue("iRadiusOverride", 0)                 
/**/			explosion:Spawn()                 
/**/			explosion:Activate()                 
/**/			explosion:Fire("explode", "", 0)                 
/**/			explosion:Fire("kill", "", 0) 
/**/		end
/**/	end
/**/
/*<><><><><><><><><><><><><><><><><><>*/
/*		Think Function	      	      */
/*<><><><><><><><><><><><><><><><><><>*/
/**/
/**/	function SWEP:Think()
/**/		if (n == 1) then 
/**/			self.target:Remove() -- Removes the info_target so that every shot has a new starting point, relative to where you shoot
/**/			n = 0
/**/		end
/**/		if (n == 2) then
/**/			self.target2:Remove() -- Removes the secondary info_target so that every shot has a new starting point, relative to where you are when you shoot
/**/			n = 0
/**/		end
/**/	end
/**/
/*<><><><><><><><><><><><><><><><><><>*/
/*		Primary Attack	      	  	  */
/*<><><><><><><><><><><><><><><><><><>*/
/**/
/**/	function SWEP:PrimaryAttack()
/**/		local trace = self.Owner:GetEyeTrace()
/**/		local hitpos = trace.HitPos
/**/		
/**/		if (!trace.HitWorld) then -- ! means not
/**/		return end
/**/
/**/		self.target = ents.Create("info_target") -- We need an info_target to set where the canister starts
/**/		self.target:SetPos(self.Owner:GetShootPos() + ((self.Owner:GetAimVector() * -35000) + Vector(0, 0, 50000))) -- From above and behind the
/**/		self.target:SetKeyValue("targetname", "target")                                                             -- player's position
/**/		self.target:Spawn()
/**/		self.target:Activate()
/**/
/**/		local offset = self.target:GetPos() - hitpos 
/**/		local angle = offset:Angle() -- Used to make it facing out from where it hit so the headcrabs can actually get out
/**/
/**/		self.canister = ents.Create("env_headcrabcanister")
/**/		self.canister:SetPos(hitpos)
/**/		self.canister:SetAngles(angle)
/**/			--|| Headcrab Types ||------------_
/**/			-- 0 - Normal headcrabs                 `------------_                                             
/**/			-- 1 - Fast headcrabs                                             `-------------_                                                          
/**/			-- 2 - Poison headcrabs                     			                `\/
/**/		self.canister:SetKeyValue("HeadcrabType", "0")
/**/		self.canister:SetKeyValue("HeadcrabCount", "0") -- The number of headcrabs that come out
/**/		self.canister:SetKeyValue("LaunchPositionName", "target") -- It launches from the info_target
/**/		self.canister:SetKeyValue("FlightSpeed", "100")
/**/		self.canister:SetKeyValue("FlightTime", "2")
/**/		self.canister:SetKeyValue("Damage", "150") -- Damage when it impacts
/**/		self.canister:SetKeyValue("DamageRadius", "100") -- Damage radius
/**/		self.canister:SetKeyValue("SmokeLifetime", "10") -- How long it smokes
/**/		self.canister:Fire("Spawnflags", "16384", 0)
/**/		self.canister:Fire("FireCanister", "", 0)
/**/		self.canister:Fire("AddOutput", "OnImpacted OpenCanister", 0)
/**/		self.canister:Fire("AddOutput", "OnOpened SpawnHeadcrabs", 0)
/**/		self.canister:Spawn()
/**/		self.canister:Activate()
/**/
/**/		n = 1
/**/	end
/**/
/*<><><><><><><><><><><><><><><><><><>*/
/*		Secondary Attack	      	  */
/*<><><><><><><><><><><><><><><><><><>*/
/**/
/**/	function SWEP:SecondaryAttack()
/**/		local trace2 = self.Owner:GetEyeTrace()
/**/		local hitpos2 = trace2.HitPos
/**/		
/**/		if (!trace2.HitWorld) then -- ! means not
/**/		return end
/**/
/**/		self.target2 = ents.Create("info_target") -- We need an info_target to set where the canister starts
/**/		self.target2:SetPos(self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 280)) -- From a little ahead of the player's position
/**/		self.target2:SetKeyValue("targetname", "target2")                                                          
/**/		self.target2:Spawn()
/**/		self.target2:Activate()
/**/
/**/		local offset2 = self.target2:GetPos() - hitpos2
/**/		local angle2 = offset2:Angle() -- Used to make it facing out from where it hit so the headcrabs can actually get out
/**/
/**/		self.canister2 = ents.Create("env_headcrabcanister")
/**/		self.canister2:SetPos(hitpos2)
/**/		self.canister2:SetAngles(angle2)
/**/			--|| Headcrab Types ||------------_
/**/			-- 0 - Normal headcrabs                 `--------------_                                             
/**/			-- 1 - Fast headcrabs                                               `-------------_                                                          
/**/			-- 2 - Poison headcrabs                     			                   `\/
/**/		self.canister2:SetKeyValue("HeadcrabType", "2")
/**/		self.canister2:SetKeyValue("HeadcrabCount", "0") -- The number of headcrabs that come out
/**/		self.canister2:SetKeyValue("LaunchPositionName", "target2") -- It launches from the secondary info_target
/**/		self.canister2:SetKeyValue("FlightSpeed", "100")
/**/		self.canister2:SetKeyValue("FlightTime", "0.5")
/**/		self.canister2:SetKeyValue("Damage", "170") -- Damage when it impacts
/**/		self.canister2:SetKeyValue("DamageRadius", "30") -- Damage radius
/**/		self.canister2:SetKeyValue("SmokeLifetime", "0") -- How long it smokes
/**/		self.canister2:Fire("Spawnflags", "16384", 0)
/**/		self.canister2:Fire("FireCanister", "", 0)
/**/		self.canister2:Fire("AddOutput", "OnImpacted OpenCanister", 0)
/**/		self.canister2:Fire("AddOutput", "OnOpened SpawnHeadcrabs", 0)
/**/		self.canister2:Spawn()
/**/		self.canister2:Activate()
/**/
/**/		n = 2
/**/	end
/**/
/*<><><><><><><><><><><><><><><><><><>*/
/*		Yay!!	      	  	  */
/*<><><><><><><><><><><><><><><><><><>*/
/*\