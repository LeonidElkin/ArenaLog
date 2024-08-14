local AddonName, AddonTable = ...
local AceDB = LibStub("AceDB-3.0")

ArenaLog = LibStub("AceAddon-3.0"):NewAddon(AddonTable, AddonName, "AceConsole-3.0", "AceEvent-3.0")

function ArenaLog:HandleSlashCommands(input)
    if ArenaLog.isMainFrameShown then
        return
    end

    ArenaLog.isMainFrameShown = true

    ArenaLog:InitiateMainFrame()
end

local gameExample = {
    time = "2024-08-10 15:30",
    ratingChange = 25,
    alliedTeam = {
        player = { spec = 250 },
        party1 = { spec = 250 }
    },
    enemyTeam = {
        arena1 = { spec = 250 },
        arena2 = { spec = 250 }
    }
}

function ArenaLog:SetUpDb()
    if not self.db.char.game2x2History then
        self.db.char.game2x2History = {}
    end

    if not self.db.char.game3x3History then
        self.db.char.game3x3History = {}
    end

    --experiment below
    for i = 1, 10 do
        self.db.char.game2x2History[i] = gameExample
    end
end

function ArenaLog:OnInitialize()
    ArenaLog:RegisterChatCommand("arenalog", "HandleSlashCommands")
    ArenaLog:RegisterChatCommand("al", "HandleSlashCommands")
    ArenaLog.isMainFrameShown = false

    self.db = AceDB:New("ArenaLogDB")
    ArenaLog:SetUpDb()
end

function ArenaLog:OnEnable()
    --TODO
end

function ArenaLog:OnDisable()
    --TODO
end
