local AddonName, AddonTable = ...
local options = nil
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

ArenaLog = LibStub("AceAddon-3.0"):NewAddon(AddonTable, AddonName, "AceConsole-3.0", "AceEvent-3.0")

local function DrawProfilesFrame()
    --TODO
end

local function DrawSettingsFrame()
    --TODO
end


function ArenaLog:HandleSlashCommands(input)
    if ArenaLog.isMainFrameShown then
        return
    end

    ArenaLog.isMainFrameShown = true

    local mainFrame = InitiateMainFrame()
end

function ArenaLog:OnInitialize()
    ArenaLog:RegisterChatCommand("arenalog", "HandleSlashCommands")
    ArenaLog:RegisterChatCommand("al", "HandleSlashCommands")
    ArenaLog.isMainFrameShown = false

    self.db = LibStub("AceDB-3.0"):New("ArenaLogDB")
    ArenaLog:SetUpOptions()
    if options then
        options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    end

    AceConfigRegistry:RegisterOptionsTable("ArenaLog", options, { "/helpmeplsokay", "/bruhbruh" })
    ArenaLog.optionsFrame = AceConfigDialog:AddToBlizOptions("ArenaLog", nil, nil, "general")
end

function ArenaLog:OnEnable()
    --TODO
end

function ArenaLog:OnDisable()
    --TODO
end

function ArenaLog:SetUpOptions()
    if not options then
        local options = {
            name = "ArenaLog",
            handler = ArenaLog,
            type = 'group',
            args = {
                msg = {
                    type = 'input',
                    name = 'My Message',
                    desc = 'The message for my addon',
                    set = 'SetMyMessage',
                    get = 'GetMyMessage',
                },
            },
        }
    end
end
