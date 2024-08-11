local AddonName, AddonTable = ...
local options = nil
local AceGUI = LibStub("AceGUI-3.0")
local ArenaLog = LibStub("AceAddon-3.0"):NewAddon(AddonTable, AddonName, "AceConsole-3.0", "AceEvent-3.0")

local function CreateLabeledGroup(label, value)
    local group = AceGUI:Create("SimpleGroup")
    group:SetLayout("List")
    group:SetWidth(150)

    local labelWidget = AceGUI:Create("Label")
    labelWidget:SetText(label)
    labelWidget:SetFontObject(GameFontHighlight)
    group:AddChild(labelWidget)

    local spacer = AceGUI:Create("Label")
    spacer:SetText(" ")
    spacer:SetFullWidth(true)
    spacer:SetHeight(5)
    group:AddChild(spacer)

    local valueWidget = AceGUI:Create("Label")
    valueWidget:SetText(value)
    group:AddChild(valueWidget)

    return group
end

local function DrawArenaHistoryFrame(container, arenaType)
    if arenaType == "2x2" then
        local scroll = AceGUI:Create("ScrollFrame")
        scroll:SetLayout("Flow")
        container:AddChild(scroll)

        local singleGameFrame = AceGUI:Create("InlineGroup")
        singleGameFrame:SetFullWidth(true)
        singleGameFrame:SetLayout("Flow")
        container:AddChild(singleGameFrame)

        singleGameFrame:AddChild(CreateLabeledGroup("Time", "2024-08-10 15:30"))

        singleGameFrame:AddChild(CreateLabeledGroup("Teams", "Team A vs Team B"))

        singleGameFrame:AddChild(CreateLabeledGroup("Rating Change", "+25"))

        local viewButton = AceGUI:Create("Button")
        viewButton:SetText("View Details")
        viewButton:SetWidth(120)
        singleGameFrame:AddChild(viewButton)
    end

    if arenaType == "3x3" then

    end
end

local function DrawProfilesFrame()
    --TODO
end

local function DrawSettingsFrame()
    --TODO
end

local function InitiateMainFrame()
    local function SelectGroup(container, event, group)
        container:ReleaseChildren()
        if group == "2x2" or group == "3x3" then
            DrawArenaHistoryFrame(container, group)
        elseif group == "settings" then
            DrawSettingsFrame()
        elseif group == "profiles" then
            DrawProfilesFrame()
        end
    end

    local frame = AceGUI:Create("Frame")
    frame:SetTitle("ArenaLog")
    frame:SetLayout("Fill")
    frame:SetHeight(600)
    frame:SetWidth(900)
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
    tab:SelectTab("2x2")

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
