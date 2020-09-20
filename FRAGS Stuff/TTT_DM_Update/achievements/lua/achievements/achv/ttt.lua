local category = achievements.CreateCategory("TTT")
category.Icon = "gui/achievements/cat_ttt.png"
category.DisplayOrder = 2
category.Active = function() return gmod.GetGamemode().Name == "Trouble in Terrorist Town" end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Kill a traitor with the very knife they dropped."
    ACH.Icon = "gui/achievements/knife.png"

    function ACH:Initialize()
        hook.Add("PlayerDeath", "AchvDroppedThis", function( victim, inflictor, attacker )
            if not inflictor:GetClass() == "weapon_ttt_knife" then return end
            if not inflictor.IsDropped then return end
            if not victim:IsTraitor() then return end
            if not IsValid(attacker) or not attacker:IsPlayer() then return end

            self:Complete( attacker )
        end)
    end

    achievements.Register( category, "droppedthis", "I Think You Dropped This", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Push someone off a high place with a crowbar resulting in their deaths."
    ACH.Icon = "gui/achievements/falling.png"

    function ACH:Initialize()
        hook.Add("TTTEndRound", "AchvNiceTrip", function()
            for _, ev in pairs(SCORE.Events) do
                if ev.id ~= EVENT_KILL then continue end
                if not util.BitSet(ev.dmg.t, DMG_FALL) then continue end
                local attacker = player.GetByUniqueID(ev.att.uid)
                if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then continue end
           
                self:AddPoint( attacker )
            end
        end)
    end

    achievements.Register( category, "nicetrip", "Have A Nice Trip", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Kill with a thrown knife over 100ft."
    ACH.Icon = "gui/achievements/knife.png"

    function ACH:Initialize()
        hook.Add("PlayerDeath", "AchvThrowingKnife", function( victim, inflictor, attacker )
            if not inflictor:GetClass() == "ttt_knife_proj" then return end
            if not victim:IsTraitor() then return end
            if not IsValid(attacker) or not attacker:IsPlayer() then return end

            local distance = attacker:GetPos():Distance(victim:GetPos())
            if distance < 1600 then return end

            self:Complete( attacker )
        end)
    end

    achievements.Register( category, "throwingknife", "Is This Call Of Duty?", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Kill every innocent without a single body ever being found."
    ACH.Icon = "gui/achievements/ninja.png"

    function ACH:Initialize()
        hook.Add("TTTEndRound", "AchvNoEvidence", function( winner )
            if winner ~= WIN_TRAITOR then return end

            for _, ev in pairs(SCORE.Events) do
                if ev.id == EVENT_BODYFOUND then return end
            end

            for _, ply in pairs(player.GetAll()) do
                if not ply:IsTraitor() then continue end
                self:Complete( ply )
            end
        end)
    end

    achievements.Register( category, "noevidence", "Silent Assassin", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Kill 8 innocents with explosives in a single round."
    ACH.Icon = "gui/achievements/c4.png"

    function ACH:Initialize()
        hook.Add("TTTEndRound", "AchvDemoExpert", function()
            local playerCount = {}

            for _, ev in pairs(SCORE.Events) do
                if ev.id ~= EVENT_KILL then continue end
                if not util.BitSet(ev.dmg.t, DMG_BLAST) then continue end
                if not ev.att.uid then continue end
                playerCount[ev.att.uid] = playerCount[ev.att.uid] and ( playerCount[ev.att.uid] + 1 ) or 1
            end

            for uid, count in pairs(playerCount) do
                local atacker = player.GetByUniqueID(uid)
                if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then continue end

                if count > 7 then self:Complete( attacker ) end
            end
        end)
    end

    achievements.Register( category, "demoexpert", "Demolition Expert", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Identify 100 bodies."
    ACH.Icon = "gui/achievements/watson.png"
    ACH.Target = 100

    function ACH:Initialize()
        hook.Add("TTTEndRound", "AchvWatson", function( )
            local playerCount = {}
            for _, ev in pairs(SCORE.Events) do
                if ev.id ~= EVENT_BODYFOUND then continue end
                playerCount[ev.uid] = playerCount[ev.uid] and (playerCount[ev.uid] + 1) or 1
            end
            for uid, count in pairs(playerCount) do
                local ply = player.GetByUniqueID(uid)
                if not ply or not IsValid(ply) or not ply:IsPlayer() then continue end

                self:AddPoint( ply, count )
            end
        end)
    end

    achievements.Register( category, "watson", "Watson!", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Defuse a C4 set for 10 minutes."
    ACH.Icon = "gui/achievements/c4.png"

    function ACH:Initialize()
        local ENT = scripted_ents.Get( "ttt_c4" )
        local oldDisarm = ENT.Disarm

        function ENT.Disarm(e, ply)
            if e:GetTimerLength() == 600 then
                self:Complete( ply )
            end

            return oldDisarm(e, ply)
        end
    end

    achievements.Register( category, "bombsquad", "No The Red Wire!", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "In one round have your health station heal over 500 points."
    ACH.Icon = "gui/achievements/medic.png"

    function ACH:Initialize()
        local ENT = scripted_ents.Get( "ttt_health_station" )
        local oldTakeFromStorage = ENT.TakeFromStorage

        function ENT.TakeFromStorage(e, amount)
            local ply = self:GetPlacer()
            ply._HealthGiven = ply._HealthGiven + amount or amount

            return oldTakeFromStorage(e, amount)
        end

        hook.Add("TTTEndRound", "AchvMedic", function()
            for _, ply in pairs(player.GetAll()) do
                if ply._HealthGiven and ply._HealthGiven > 499 then
                    self:Complete( ply )
                end

                ply._HealthGiven = nil
            end
        end)
    end

    achievements.Register( category, "notadoctor", "I'm A Detective, Not A Doctor", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Over time, burn a total of 50 bodies."
    ACH.Icon = "gui/achievements/pyro.png"
    ACH.Target = 50

    function ACH:Initialize()
        -- this is the most convinent global function ever.
        local oldIgniteTarget = IgniteTarget
        function IgniteTarget(att, path, dmginfo)
            local ent = path.Entity
            if IsValid(ent) and ent:GetClass() == "prop_ragdoll" then
                self:AddPoint( att )
            end

            return oldIgniteTarget(att, path, dmginfo)
        end
    end

    achievements.Register( category, "wastedisposal", "Waste Disposal", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Have 100 C4s you've planted successfully explode."
    ACH.Icon = "gui/achievements/c4.png"
    ACH.Target = 100

    function ACH:Initialize()
        hook.Add("TTTEndRound", "AchvDemoExpert", function()
            local playerCount = {}

            for _, ev in pairs(SCORE.Events) do
                if ev.id ~= EVENT_C4EXPLODE then continue end
                local ply
                for _, v in pairs(player.GetAll()) do if v:Nick() == ev.ni then ply = v end end -- ty for that ttt guy

                playerCount[ply:UniqueID()] = playerCount[ply:UniqueID()] and ( playerCount[ply:UniqueID()] + 1 ) or 1
            end

            for uid, count in pairs(playerCount) do
                local atacker = player.GetByUniqueID(uid)
                if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then continue end

                self:AddPoint( attacker, count )
            end
        end)
    end

    achievements.Register( category, "boomboom", "Boom Boom", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Fry over 100 innocents with incendiary grenades."
    ACH.Icon = "gui/achievements/grenade.png"
    ACH.Target = 100

    function ACH:Initialize()
        hook.Add("TTTEndRound", "AchvBonfire", function()
            for _, ev in pairs(SCORE.Events) do
                if ev.id ~= EVENT_KILL then continue end
                if not util.BitSet(ev.dmg.t, DMG_BURN) then continue end
                local attacker = player.GetByUniqueID(ev.att.uid)
                if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then continue end
               
                self:AddPoint( attacker )
            end
        end)
    end

    achievements.Register( category, "bonfire", "Bonfire", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Kill someone you have DNA on as an innocent."
    ACH.Icon = "gui/achievements/deputy.png"

    function ACH:Initialize()
        local dnaTable = {}
        hook.Add("TTTEndRound", "AchvDeputy", function()
            for _, ev in pairs(SCORE.Events) do
                if ev.id ~= EVENT_KILL then continue end
                if not ev.att.uid then continue end
                if not ev.vic.uid then continue end

                local attDNA = dnaTable[ev.att.uid]
                if not attDNA then continue end
                if not table.HasValue(attDNA, ev.vic.uid) then continue end

                local ply = player.GetByUniqueID(ev.att.uid)
                if not ply or not IsValid(ply) or not ply:IsPlayer() then continue end

                self:AddPoint( ply )
            end

            dnaTable = {}
        end)

        hook.Add("TTTFoundDNA", "AchvDeputy", function(ply, killer, corpse)
            dnaTable[ply:UniqueID()] = dnaTable[ply:UniqueID()] or {}
            table.insert(dnaTable[ply:UniqueID()], killer:UniqueID())
        end)
    end

    achievements.Register( category, "deputy", "Sheriff's Deputy", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Survive a round after being stabbed."
    ACH.Icon = "gui/achievements/knife.png"

    function ACH:Initialize()
        hook.Add("TTTEndRound", "AchvFleshWound", function()
            for _, v in pairs(player.GetAll()) do
                if v:Alive() and v._WasStabbed then
                    self:Complete( v )
                end

                v._WasStabbed = nil
            end
        end)
        hook.Add("EntityTakeDamage", "AchvFleshWound", function(ent, dmginfo)
            if not IsValid(ent) or not ent:IsPlayer() then return end
            if not dmginfo:IsDamageType(DMG_SLASH) then return end
            ent._WasStabbed = true
        end)
    end

    achievements.Register( category, "fleshwound", "Tis But A Flesh Wound", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Be accused of being a traitor as an innocent 1000 times."
    ACH.Icon = "gui/achievements/objection.png"
    ACH.Target = 1000

    function ACH:Initialize()
        hook.Add("TTTPlayerRadioCommand", "AchvObjection", function(ply, msg_name, msg_target)
            if msg_name ~= "quick_traitor" then return end
            if not msg_target or not IsValid(msg_target) then return end
            if not msg_target:IsPlayer() then return end
            if msg_target:IsTraitor() then return end

            self:AddPoint( msg_target )
        end)
    end

    achievements.Register( category, "objection", "Objection!", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Play 100 Rounds!"
    ACH.Target = 100

    function ACH:Initialize()
        hook.Add("TTTEndRound", "AchvPlayTTT100", function()
            for _, ply in pairs( player.GetAll() ) do
                self:AddPoint( ply, 1 )
            end
        end)
    end

    achievements.Register( category, "playttt100", "Addicted to TTT", ACH )
end