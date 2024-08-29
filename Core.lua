local AddonName, AddonTable = ...

ArenaLog = LibStub("AceAddon-3.0"):NewAddon(AddonTable, AddonName, "AceConsole-3.0", "AceEvent-3.0")

local UI = ArenaLog.UI
local AceDB = LibStub("AceDB-3.0")

function ArenaLog:HandleSlashCommands(input)
    UI:InitiateMainFrame()
end

function ArenaLog:SetUpDb()
    if not self.db.char.gameHistory then
        self.db.char.gameHistory = {}
    end
end

function ArenaLog:OnInitialize()
    self.db = AceDB:New("ArenaLogDB")
    ArenaLog:SetUpDb()
end

function ArenaLog:OnEnable()
    ArenaLog:RegisterChatCommand("arenalog", "HandleSlashCommands")
    ArenaLog:RegisterChatCommand("al", "HandleSlashCommands")

    ArenaLog:RegisterEvent("PVP_MATCH_COMPLETE", "GetArenaInfo")
    ArenaLog:RegisterEvent("PLAYER_JOINED_PVP_MATCH", "GetArenaTime")
end

function ArenaLog:GetArenaTime()
    if C_PvP.IsRatedArena() then
        self.db.char.gameHistory[#self.db.char.gameHistory + 1] = { date = C_DateAndTime.GetCurrentCalendarTime() }
    end
end

function ArenaLog:GetArenaInfo()
    if C_PvP.IsRatedArena() then
        local game = {}
        local numScores = GetNumBattlefieldScores()

        game.date = self.db.char.gameHistory[#self.db.char.gameHistory].date
        game.alliedTeam = {}
        game.enemyTeam = {}
        game.duration = C_PvP.GetActiveMatchDuration()

        local infos = {}

        for i = 1, numScores do
            infos[i] = C_PvP.GetScoreInfo(i)
            if UnitGUID("player") == infos[i].guid then
                game.ratingChange = infos[i].ratingChange
                game.alliedTeam.teamIndex = infos[i].faction
                game.enemyTeam.teamIndex = 1 - infos[i].faction
            end
        end

        local myTeamInfo = C_PvP.GetTeamInfo(game.alliedTeam.teamIndex)
        local enemyTeamInfo = C_PvP.GetTeamInfo(game.enemyTeam.teamIndex)

        if myTeamInfo and enemyTeamInfo then
            game.type = max(myTeamInfo.size, enemyTeamInfo.size)
            game.alliedTeam.rating = myTeamInfo.rating
            game.enemyTeam.rating = enemyTeamInfo.rating
        else
            game.type = numScores / 2
            game.alliedTeam.rating = nil
            game.enemyTeam.rating = nil
        end

        local myTeamCounter = 1
        local enemyTeamCounter = 1

        for _, v in ipairs(infos) do
            if UnitGUID("player") == v.guid then
                game.alliedTeam.player = v
            elseif v.faction == game.alliedTeam.teamIndex then
                game.alliedTeam["party" .. myTeamCounter] = v
                myTeamCounter = myTeamCounter + 1
            else
                game.enemyTeam["arena" .. enemyTeamCounter] = v
            end
        end

        self.db.char.gameHistory[#self.db.char.gameHistory] = game
    end
end
