local AddonName, AddonTable = ...
local options = nil
local AceGUI = LibStub("AceGUI-3.0")
local ArenaLog = LibStub("AceAddon-3.0"):NewAddon(AddonTable, AddonName, "AceConsole-3.0", "AceEvent-3.0")

local function DrawArenaHistoryFrame(group)
    --TODO
end

local function DrawProfilesFrame(group)
    --TODO
end

local function DrawSettingsFrame(group)
    --TODO
end

local function InitiateMainFrame()
    local function SelectGroup(container, event, group)
        container:ReleaseChildren()
        if group == "2x2" or group == "3x3" then
            DrawArenaHistoryFrame(group)
        elseif group == "settings" then
            DrawSettingsFrame()
        elseif group == "profiles" then
            DrawProfilesFrame()
        end
    end

    local frame = AceGUI:Create("Frame")
    frame:IsShown()
    frame:SetTitle("ArenaLog")
    frame:SetLayout("Fill")
    frame:SetCallback("OnClose",
        function (widget)
            AceGUI:Release(widget)
            ArenaLog.isMainFrameShown = false
        end
    )

    local tab = AceGUI:Create("TabGroup")
    tab:SetLayout("Flow")
    tab:SetTabs({
        { text = "2x2",      value = "2x2" },
        { text = "3x3",      value = "3x3" },
        { text = "Settings", value = "settings" },
        { text = "Profiles", value = "profiles" }
    })
    tab:SetCallback("OnGroupSelected", SelectGroup)
    tab:SelectTab("tab1")

    frame:AddChild(tab)

    return frame
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
    self:SetUpOptions()
    if options then
        options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    end
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
