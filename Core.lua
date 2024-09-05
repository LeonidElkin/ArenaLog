local AddonName, AddonTable = ...

ArenaLog = LibStub("AceAddon-3.0"):NewAddon(AddonTable, AddonName, "AceConsole-3.0", "AceEvent-3.0")

local UI = ArenaLog.UI
local Player = ArenaLog.Player
local Game = ArenaLog.Game
local LGIST = LibStub:GetLibrary("LibGroupInSpecT-1.1")
local AceDB = LibStub("AceDB-3.0")

function ArenaLog:HandleSlashCommands(input)
    UI:InitiateMainFrame()
end

function ArenaLog:SetUpDb()
    if not self.db.char.gameHistory then
        self.db.char.gameHistory = {}
    end
    self.db.char.currentMatch = self.db.char.currentMatch or nil
end

function ArenaLog:OnInitialize()
    self.db = AceDB:New("ArenaLogDB")
    ArenaLog:SetUpDb()
end

function ArenaLog:OnEnable()
    ArenaLog.currentMatch = nil

    ArenaLog:RegisterChatCommand("arenalog", "HandleSlashCommands")
    ArenaLog:RegisterChatCommand("al", "HandleSlashCommands")

    ArenaLog:RegisterEvent("PVP_MATCH_COMPLETE")
    ArenaLog:RegisterEvent("PLAYER_ENTERING_WORLD")
    ArenaLog:RegisterEvent("PLAYER_JOINED_PVP_MATCH")
    ArenaLog:RegisterEvent("ARENA_OPPONENT_UPDATE")

    LGIST.RegisterCallback(ArenaLog, "GroupInSpecT_Update", "ARENA_ALLY_UPDATE")
end

-- Events handlers
function ArenaLog:PLAYER_JOINED_PVP_MATCH(event)
    ArenaLog:OnArenaStart()
end

function ArenaLog:PLAYER_ENTERING_WORLD(event, isInitialLogin, isReloadingUi)
    ArenaLog:OnArenaStart()
end

function ArenaLog:PVP_MATCH_COMPLETE(event, winner, duration)
    ArenaLog:OnArenaEnd(winner, duration)
end

function ArenaLog:ARENA_ALLY_UPDATE(event, guid, id, info)
    if C_PvP.IsRatedArena() and self.db.char.currentMatch ~= nil then
        self.db.char.currentMatch.alliedTeam.players[id]:UpdateAllyPlayerInfo(guid, id, info)
    end
end

function ArenaLog:ARENA_OPPONENT_UPDATE(event, id, reason)
    if C_PvP.IsRatedArena() and reason == "seen" then
        self.db.char.currentMatch.enemyTeam.players[id]:UpdateEnemyPlayerInfo()
    end
end

function ArenaLog:OnArenaStart()
    if self.db.char.currentMatch == nil and C_PvP.IsRatedArena() then
        self.db.char.currentMatch = Game.New()
        self.db.char.currentMatch:UpdateZone()
    end
end

function ArenaLog:OnArenaEnd(winner, duration)
    if self.db.char.currentMatch ~= nil then
        self.db.char.currentMatch:Finish(winner, duration)
        self.db.char.gameHistory[#self.db.char.gameHistory + 1] = self.db.char.currentMatch
        self.db.char.currentMatch = nil
    end
end
