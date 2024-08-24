local AceGUI = LibStub("AceGUI-3.0")
local UI = ArenaLog.UI
UI.isMainFrameShown = false

local function CreateTeamWidget(team, justify)
    local teamGroup = AceGUI:Create("SimpleGroup")
    teamGroup:SetLayout("Flow")
    teamGroup:SetWidth(100)
    teamGroup:SetPoint(justify)

    for _, info in pairs(team) do
        local iconWidget = AceGUI:Create("Icon")
        -- local id, name, description, icon, role, classFile, className = GetSpecializationInfoByID(info.spec)
        iconWidget:SetImage(info.stats.iconName)
        iconWidget:SetImageSize(36, 36)
        iconWidget:SetWidth(40)
        teamGroup:AddChild(iconWidget)
    end

    return teamGroup
end

local function CreateTeamsGroup(team1, team2)
    local teams = AceGUI:Create("SimpleGroup")
    teams:SetWidth(300)
    teams:SetLayout("Flow")

    teams:AddChild(CreateTeamWidget(team1, "LEFT"))

    local vsLabel = AceGUI:Create("Label")
    vsLabel:SetText("vs")
    vsLabel:SetWidth(30)
    vsLabel:SetPoint("CENTER")
    vsLabel:SetFontObject(GameFontNormalLarge)
    teams:AddChild(vsLabel)

    teams:AddChild(CreateTeamWidget(team2, "RIGHT"))

    return teams
end

local function CreateLabeledGroup(label, value)
    local group = AceGUI:Create("SimpleGroup")
    group:SetLayout("List")
    group:SetWidth(120)

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

local function CreateGameFrame(game)
    local singleGameFrame = AceGUI:Create("InlineGroup")
    singleGameFrame:SetFullWidth(true)
    singleGameFrame:SetLayout("Flow")

    singleGameFrame:AddChild(CreateLabeledGroup("Date", tostring(game.date.monthDay) .. tostring(game.date.year)))
    singleGameFrame:AddChild(CreateTeamsGroup(game.alliedTeam, game.enemyTeam))
    singleGameFrame:AddChild(CreateLabeledGroup("Rating Change", game.ratingChange))

    local viewButton = AceGUI:Create("Button")
    viewButton:SetText("View Details")
    viewButton:SetWidth(120)
    singleGameFrame:AddChild(viewButton)

    return singleGameFrame
end

function UI:CreateArenaHistoryWidget(container, group)
    local arenaHistoryWidget = AceGUI:Create("SimpleGroup")
    arenaHistoryWidget:SetFullWidth(true)
    arenaHistoryWidget:SetFullHeight(true)
    arenaHistoryWidget:SetLayout("Fill")
    container:AddChild(arenaHistoryWidget)

    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("Flow")
    arenaHistoryWidget:AddChild(scroll)

    local db = self.db.char.gameHistory

    for i = #db, 1, -1 do
        scroll:AddChild(CreateGameFrame(db[i]))
    end
end

local function DrawProfilesFrame()
    --TODO
end

local function DrawSettingsFrame()
    --TODO
end

local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "2x2" or group == "3x3" then
        UI:CreateArenaHistoryWidget(container, group)
    elseif group == "settings" then
        DrawSettingsFrame()
    elseif group == "profiles" then
        DrawProfilesFrame()
    end
end

function UI:InitiateMainFrame()
    if UI.isMainFrameShown then
        return
    end

    UI.isMainFrameShown = true

    local frame = AceGUI:Create("Frame")
    frame:SetTitle("ArenaLog")
    frame:SetLayout("Fill")
    frame:SetHeight(600)
    frame:SetWidth(1200)
    frame:SetCallback("OnClose",
        function (widget)
            AceGUI:Release(widget)
            UI.isMainFrameShown = false
        end
    )

    local tab = AceGUI:Create("TabGroup")
    tab:SetLayout("Fill")
    tab:SetTabs({
        { text = "2x2",      value = "2x2" },
        { text = "3x3",      value = "3x3" },
        { text = "Settings", value = "settings" },
        { text = "Profiles", value = "profiles" }
    })
    tab:SetCallback("OnGroupSelected", SelectGroup)
    tab:SelectTab("2x2")

    frame:AddChild(tab)
end
