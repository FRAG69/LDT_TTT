if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "pistol"

if CLIENT then

   SWEP.PrintName    = "Ragdoll Taser"
   SWEP.Slot         = 6

   SWEP.ViewModelFlip = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Knock someone out for 5 seconds. Only useable once. Can purchase again."
   };

   SWEP.Icon = "vgui/ttt/icon_skull.vmt"
end

SWEP.Base               = "weapon_tttbase"

SWEP.ViewModel          = "models/weapons/v_pistol.mdl"
SWEP.WorldModel         = "models/weapons/w_pistol.mdl"

SWEP.DrawCrosshair      = true

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= ""

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_DETECTIVE} -- only traitors can buy
SWEP.LimitedStock = false -- only buyable once
SWEP.WeaponID = AMMO_TASER

SWEP.IsSilent = false

-- Pull out faster than standard guns
SWEP.DeploySpeed = 2

SWEP.Used = false

local taseredrags = {}
local taseruniquetimer1 = 0
local taseruniquetimer2 = 0

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD ) //animation for reloading
end 
 
 function SWEP:PrimaryAttack()
 if ( !self:CanPrimaryAttack() ) then return end
 local eyetrace = self.Owner:GetEyeTrace(); 
 if !eyetrace.Entity:IsPlayer() then 
  if !eyetrace.Entity:IsNPC() then return end       // Check to see if what the player is aiming at is an NPC or Player
  end
  
self.Weapon:EmitSound( "Weapon_StunStick.Activate")  
self.BaseClass.ShootEffects( self ) 
self:TakePrimaryAmmo(1) 

 
 if (!SERVER) then return end 
 
 if eyetrace.Entity:IsPlayer() then
 self.Owner:PrintMessage( HUD_PRINTCENTER, "Now right click to electrocute "..eyetrace.Entity:GetName( ) )  
 self:tasePlayer(eyetrace.Entity)    // If the it is a player then bring them down tranqPlayer()
 end
 if eyetrace.Entity:IsNPC() then
 self.Owner:PrintMessage( HUD_PRINTCENTER, "Now right click to electrocute the NPC" )
 self:taseNPC(eyetrace.Entity, self.Owner)    // If the it is a NPC then bring them down with tranqNPC()
 end
  end 


function SWEP:tasePlayer(ply)
	-- create ragdoll
	local rag = ents.Create( "prop_ragdoll" )
    if not rag:IsValid() then return end

	-- build rag
	rag:SetModel( ply:GetModel() )
    rag:SetKeyValue( "origin", ply:GetPos().x .. " " .. ply:GetPos().y .. " " .. ply:GetPos().z )
	rag:SetAngles(ply:GetAngles())
			
	-- player vars
	rag.taseredply = ply
	table.insert(taseredrags, rag)
		
	-- "remove" player
	ply:StripWeapons()
	ply:DrawViewModel(false)
	ply:DrawWorldModel(false)
	ply:Spectate(OBS_MODE_CHASE)
	ply:SpectateEntity(rag)
	
	-- finalize ragdoll
    rag:Spawn()
    rag:Activate()
	
	-- make ragdoll fall
	rag:GetPhysicsObject():SetVelocity(4*ply:GetVelocity())
	
	-- bring the motherfucker back

     self:setrevivedelay(rag)
	
end

function SWEP:taseNPC(npc, npcShooter)
	-- get info about npc
	local skin = npc:GetSkin()
	local wep = ""
	local possibleWep = ents.FindInSphere(npc:GetPos(),0.01) -- find anything in the center basically
	for k, v in pairs(possibleWep) do 
		if string.find(v:GetClass(),"weapon_") == 1 then 
			wep = v:GetClass()
		end
	end

	local citType = "" -- citizen type
	local citMed = 0 -- is it a medic? assume no
	if npc:GetClass() == "npc_citizen" then
		citType = string.sub(npc:GetModel(),21,21) -- get group number (e.g. models/humans/group0#/whatever)
		if string.sub(npc:GetModel(),22,22) == "m" then citMed = 1 end -- medic skins have an "m" after the number
	end

	-- make ragdoll now that all info is gathered	
	local rag = ents.Create( "prop_ragdoll" )
    if not rag:IsValid() then return end
	
	-- build rag
	rag:SetModel( npc:GetModel() )
    rag:SetKeyValue( "origin", npc:GetPos().x .. " " .. npc:GetPos().y .. " " .. npc:GetPos().z )
	rag:SetAngles(npc:GetAngles())
	
	-- npc vars
	rag.tasewasNPC = true
	rag.tasenpcType = npc:GetClass()
	rag.tasenpcWep = wep
	rag.tasenpcCitType = citType
	rag.tasenpcCitMed = citMed
	rag.tasenpcSkin = skin
	rag.tasenpcShooter = npcShooter
	table.insert(taseredrags, rag)
	
	--finalize
	rag:Spawn()
    rag:Activate()
	
	-- make ragdoll fall
  rag:GetPhysicsObject():SetVelocity(8*npc:GetVelocity())
		
	--remove npc
	npc:Remove()

 self:setrevivedelay(rag)

	
	end

function SWEP:setrevivedelay(rag)
if taseruniquetimer1 > 30 then
taseruniquetimer1 = 0
end
taseruniquetimer1 = taseruniquetimer1 + 1

timer.Create("revivedelay"..taseruniquetimer1, 10, 1, self.taserevive, self, rag ) 
end

function SWEP:taserevive(ent)
	-- revive player
	if !ent then return end
	
	if ent.taseredply then
   if ( !ent.taseredply:IsValid() ) then return end
   local phy = ent:GetPhysicsObject()
		phy:EnableMotion(false)
		ent:SetSolid(SOLID_NONE)
   	ent.taseredply:DrawViewModel(true)
	ent.taseredply:DrawWorldModel(true)
	ent.taseredply:Spawn()
	ent.taseredply:SetPos(ent:GetPos())
	ent.taseredply:SetVelocity(ent:GetPhysicsObject():GetVelocity())
ent.taseredply:SetMoveType(MOVETYPE_NONE)
ent.taseredply:ConCommand("pp_motionblur 1")
ent.taseredply:ConCommand("pp_motionblur_addalpha 0.06 ")
ent.taseredply:ConCommand("pp_motionblur_delay 0")
ent.taseredply:ConCommand("pp_motionblur_drawalpha 0.99 ")
if taseruniquetimer2 > 30 then
taseruniquetimer2 = 0
end
taseruniquetimer2 = taseruniquetimer2 + 1
timer.Create("pauseplayer"..taseruniquetimer2, 3, 1, self.pauseplayer, self, ent.taseredply) 

	-- revive npc
	elseif ent.tasewasNPC then
		local npc = ents.Create(ent.tasenpcType) -- create the entity
		
		util.PrecacheModel(ent:GetModel()) -- precache the model
		npc:SetModel(ent:GetModel()) -- and set it
		local spawnPos = ent:GetPos()+Vector(0,0,0) -- position to spawn it
		
		npc:SetPos(spawnPos) -- position
		npc:SetSkin(ent.tasenpcSkin)
		npc:SetAngles(Angle(0,ent:GetAngles().y,0))
		
		if ent.tasenpcWep != "" then -- if it's an NPC and we found a weapon for it when it was spawned, then
			npc:SetKeyValue("additionalequipment",ent.tasenpcWep) -- give it the weapon
		end
		
		if ent.taseentType == "npc_citizen" then
			npc:SetKeyValue("citizentype",ent.tasenpcCitType) -- set the citizen type - rebel, refugee, etc.
			if ent.tasenpcCitType == "3" && ent.tasenpcCitMed==1 then -- if it's a rebel, then it might be a medic, so check that
				npc:SetKeyValue("spawnflags","131072") -- set medic spawn flag
			end
		end
				
		npc:Spawn()
		npc:Activate()
		
cleanup.Add (uplayer, "NPC", npc);

undo.Create ("Tasered NPC");
undo.AddEntity (npc);
undo.SetPlayer (ent.tasenpcShooter);

undo.Finish();

		
	-- don't deal with other ents
	else 
		return
	end
	
		for k, v in pairs(taseredrags) do 
		if v == ent then 
			 table.remove( taseredrags, k ) 
		end
	end
	ent:Remove()

end


function SWEP:pauseplayer(ply)

ply:SetMoveType(MOVETYPE_WALK )
ply:ConCommand("pp_motionblur 0")

end




 function SWEP:SecondaryAttack()
 if table.Count( taseredrags ) == 0 then return end
 
 self.Owner:EmitSound( "Weapon_Pistol.Empty")
  self.Owner:EmitSound( "Weapon_SMG1.Empty")
  if (!SERVER) then return end 
    
   	for k, v in pairs(taseredrags) do 
   	 local shock1 = math.random(-1200, 1200 )
   local shock2 = math.random(-1200, 1200 )
    local shock3 = math.random(-1200, 1200 )
	v:GetPhysicsObject():ApplyForceCenter( Vector( shock1, shock2, shock3 ) ) 
		end
   
    end