local AddonName, AddonTable = ...

ArenaLog = LibStub("AceAddon-3.0"):NewAddon(AddonTable, AddonName, "AceConsole-3.0", "AceEvent-3.0")

local UI = ArenaLog.UI
local Game = ArenaLog.Game
local LGIST = LibStub:GetLibrary("LibGroupInSpecT-1.1")
local AceDB = LibStub("AceDB-3.0")
local Logger = ArenaLog.Logger
local Player = ArenaLog.Player

function ArenaLog:HandleSlashCommands(input)
    UI:InitiateMainFrame()
end

function ArenaLog:SetUpDb()
    if not self.db.char.gameHistory then
        self.db.char.gameHistory = {}
    end
    self.db.char.loggerModes = self.db.char.loggerModes or { error = true, warning = true, info = true, debug = false }
    self.db.char.currentMatch = self.db.char.currentMatch or nil
end

function ArenaLog:OnInitialize()
    self.db = AceDB:New("ArenaLogDB")
    ArenaLog:SetUpDb()
end

function ArenaLog:OnEnable()
    ArenaLog:RegisterChatCommand("arenalog", "HandleSlashCommands")
    ArenaLog:RegisterChatCommand("al", "HandleSlashCommands")

    ArenaLog:RegisterEvent("PVP_MATCH_COMPLETE")
    ArenaLog:RegisterEvent("PLAYER_ENTERING_WORLD")
    ArenaLog:RegisterEvent("ARENA_OPPONENT_UPDATE")

    LGIST.RegisterCallback(ArenaLog, "GroupInSpecT_Update", "ARENA_ALLY_UPDATE")
end

-- Events handlers

function ArenaLog:PLAYER_ENTERING_WORLD(event, _, _)
    Logger:Debug("PLAYER_ENTERING_WORLD")
    ArenaLog:OnArenaStart()
end

function ArenaLog:PVP_MATCH_COMPLETE(event, winner, duration)
    Logger:Debug("PVP_MATCH_COMPLETE")
    ArenaLog:OnArenaEnd(winner, duration)
end

function ArenaLog:ARENA_ALLY_UPDATE(event, guid, id, info)
    if C_PvP.IsRatedArena() and self.db.char.currentMatch ~= nil then
        Logger:Debug("ARENA_ALLY_UPDATE")
        if not self.db.char.currentMatch.alliedTeam.players[id] then
            self.db.char.currentMatch.alliedTeam.players[id] = Player.New(id)
        end
        self.db.char.currentMatch.alliedTeam.players[id]:UpdateAllyPlayerInfo(guid, id, info)
    end
end

function ArenaLog:ARENA_OPPONENT_UPDATE(event, id, reason)
    if C_PvP.IsRatedArena() and reason == "seen" and self.db.char.currentMatch ~= nil then
        Logger:Debug("ARENA_OPPONENT_UPDATE")
        local isArenaPlayer = false
        for i = 1, 3 do
            local checkId = "arena" .. i
            if id == checkId then
                isArenaPlayer = true
            end
        end
        if not isArenaPlayer then
            return
        end
        if not self.db.char.currentMatch.enemyTeam.players[id] then
            self.db.char.currentMatch.enemyTeam.players[id] = Player.New(id)
        end
        self.db.char.currentMatch.enemyTeam.players[id]:UpdateEnemyPlayerInfo()
    end
end

function ArenaLog:OnArenaStart()
    if self.db.char.currentMatch == nil and C_PvP.IsRatedArena() then
        Logger:Info("Arena Started")
        self.db.char.currentMatch = Game.New()
    end
end

function ArenaLog:OnArenaEnd(winner, duration)
    if self.db.char.currentMatch ~= nil then
        self.db.char.currentMatch:Finish(winner, duration)
        self.db.char.gameHistory[#self.db.char.gameHistory + 1] = self.db.char.currentMatch
        self.db.char.currentMatch = nil
        Logger:Info("Arena recorded")
    end
end
