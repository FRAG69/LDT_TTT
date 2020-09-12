local category = achievements.CreateCategory("Deathrun")
category.Icon = "gui/achievements/cat_deathrun.png"
category.DisplayOrder = 3
category.Active = function() return gmod.GetGamemode().Name == "Deathrun" end


local function GetAlivePlayersFromTeam( t )
    local pool = {}
    for k, v in pairs( team.GetPlayers(t) ) do
        if not v:Alive() then continue end
        pool[#pool+1] = v
    end

    return pool
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Survive a runner round with 10 HP or less."
    ACH.Icon = "gui/achievements/medic.png"

    function ACH:Initialize()
        local function EndRound(round, winner)
            if round ~= ROUND_ENDING then return end
            if winner ~= TEAM_RUNNER then return end

            for _, ply in pairs( GetAlivePlayersFromTeam( TEAM_RUNNER ) ) do
                if ply:Health() > 10 then continue end
                self:Complete(ply)
            end
        end

        hook.Add("OnRoundSet", "AchievementDRSurvivor", EndRound)
    end

    achievements.Register( category, "drluckysurvivor", "Survivalist", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Win as the single last runner alive."
    ACH.Icon = "gui/achievements/stillalive.png"

    function ACH:Initialize()
        local function EndRound(round, winner)
            if round ~= ROUND_ENDING then return end
            if winner ~= TEAM_RUNNER then return end
            if #GetAlivePlayersFromTeam(TEAM_RUNNER) > 1 then return end

            for _, ply in pairs( GetAlivePlayersFromTeam(TEAM_RUNNER) ) do
                self:Complete(ply)
            end
        end

        hook.Add("OnRoundSet", "AchievementDRLastRunner", EndRound)
    end

    achievements.Register( category, "drlastrunner", "Still Alive", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Win a total of 100 games as runner."
    ACH.Target = 100
    ACH.Rewards = { { ps_points = 1000 } }

    function ACH:Initialize()
        local function EndRound(round, winner)
            if round ~= ROUND_ENDING then return end
            if winner ~= TEAM_RUNNER then return end

            for _, ply in pairs( GetAlivePlayersFromTeam(TEAM_RUNNER) ) do
                self:AddPoint(ply)
            end
        end

        hook.Add("OnRoundSet", "AchievementDRRunnerWin", EndRound)
    end

    achievements.Register( category, "drrunwin_1", "Cheating Death", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Win a total of 100 games as death."
    ACH.Target = 100
    ACH.Icon = "gui/achievements/death.png"
    ACH.Rewards = { { ps_points = 1000 } }

    function ACH:Initialize()
        local function EndRound(round, winner)
            if round ~= ROUND_ENDING then return end
            if winner ~= TEAM_DEATH then return end

            for _, ply in pairs( GetAlivePlayersFromTeam(TEAM_DEATH) ) do
                self:AddPoint(ply)
            end
        end

        hook.Add("OnRoundSet", "AchievementDRDeathWin", EndRound)
    end

    achievements.Register( category, "drdeadwin_1", "Not So Fast", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Kill 100 runners."
    ACH.Target = 100
    ACH.Rewards = { { ps_points = 1000 } }

    function ACH:Initialize()
        hook.Add("DoPlayerDeath", "AchievementDRRunnerKiller", function(ply, attacker)
            if not IsValid(ply) or not IsValid(attacker) or not ply:IsPlayer() or not attacker:IsPlayer() then return end
            if ply:Team() ~= TEAM_RUNNER then return end
            if attacker:Team() ~= TEAM_DEATH then return end
            self:AddPoint(attacker)
        end)
    end

    achievements.Register( category, "drrunnerkiller", "Grim Reaper", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Kill 100 deaths."
    ACH.Target = 100
    ACH.Icon = "gui/achievements/death.png"
    ACH.Rewards = { { ps_points = 1000 } }

    function ACH:Initialize()
        hook.Add("DoPlayerDeath", "AchievementDRDeathKiller", function(ply, attacker)
            if not IsValid(ply) or not IsValid(attacker) or not ply:IsPlayer() or not attacker:IsPlayer() then return end
            if ply:Team() ~= TEAM_DEATH then return end
            if attacker:Team() ~= TEAM_RUNNER then return end
            self:AddPoint(attacker)
        end)
    end

    achievements.Register( category, "drdeathkiller", "Deadlier", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Win as a runner within 2 minutes on deathrun_iceworld_*."
    ACH.Icon = "gui/achievements/iceworld.png"

    function ACH:Initialize()
        if not string.find(game.GetMap(), "iceworld") then return end

        local function EndRound(round, winner)
            if round ~= ROUND_ENDING then return end
            if winner ~= TEAM_RUNNER then return end
            if GAMEMODE:GetRoundTime() > 120 then return end

            for _, ply in pairs( GetAlivePlayersFromTeam(TEAM_RUNNER) ) do
                self:Complete(ply)
            end
        end

        hook.Add("OnRoundSet", "AchievementDRMapRecord", EndRound)
    end

    achievements.Register( category, "driceworld", "Vanilla Ice", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Win as a runner within 4 minutes on deathrun_marioworld_*."
    ACH.Icon = "gui/achievements/marioworld.png"

    function ACH:Initialize()
        if not string.find(game.GetMap(), "marioworld") then return end

        local function EndRound(round, winner)
            if round ~= ROUND_ENDING then return end
            if winner ~= TEAM_RUNNER then return end
            if GAMEMODE:GetRoundTime() > 240 then return end

            for _, ply in pairs( GetAlivePlayersFromTeam(TEAM_RUNNER) ) do
                self:Complete(ply)
            end
        end

        hook.Add("OnRoundSet", "AchievementDRMapRecord", EndRound)        
    end

    achievements.Register( category, "drmarioworld", "Goomba Stomper", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Win as a runner within 2 minutes on deathrun_poker_*."
    ACH.Icon = "gui/achievements/poker.png"

    function ACH:Initialize()
        if not string.find(game.GetMap(), "poker") then return end

        local function EndRound(round, winner)
            if round ~= ROUND_ENDING then return end
            if winner ~= TEAM_RUNNER then return end
            if GAMEMODE:GetRoundTime() > 120 then return end

            for _, ply in pairs( GetAlivePlayersFromTeam(TEAM_RUNNER) ) do
                self:Complete(ply)
            end
        end

        hook.Add("OnRoundSet", "AchievementDRMapRecord", EndRound)
    end

    achievements.Register( category, "drpoker", "P-P-P-Poker Face", ACH )
end