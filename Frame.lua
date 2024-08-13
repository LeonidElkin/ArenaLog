local AceGUI = LibStub("AceGUI-3.0")

local function CreateTeamWidget(team, justify)
    local teamGroup = AceGUI:Create("SimpleGroup")
    teamGroup:SetLayout("Flow")
    teamGroup:SetWidth(100)
    teamGroup:SetPoint(justify)

    for _, spec in ipairs(team) do
        local iconWidget = AceGUI:Create("Icon")
        local id, name, description, icon, role, classFile, className = GetSpecializationInfoByID(spec)
        iconWidget:SetImage(icon)
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

local function CreateGameFrame(time, rc, team1, team2)
    local singleGameFrame = AceGUI:Create("InlineGroup")
    singleGameFrame:SetFullWidth(true)
    singleGameFrame:SetLayout("Flow")

    singleGameFrame:AddChild(CreateLabeledGroup("Time", time))
    singleGameFrame:AddChild(CreateTeamsGroup(team1, team2))
    singleGameFrame:AddChild(CreateLabeledGroup("Rating Change", rc))

    local viewButton = AceGUI:Create("Button")
    viewButton:SetText("View Details")
    viewButton:SetWidth(120)
    singleGameFrame:AddChild(viewButton)

    return singleGameFrame
end

local function CreateArenaHistoryWidget(container)
    local arenaHistoryWidget = AceGUI:Create("SimpleGroup")
    arenaHistoryWidget:SetFullWidth(true)
    arenaHistoryWidget:SetFullHeight(true)
    arenaHistoryWidget:SetLayout("Fill")
    container:AddChild(arenaHistoryWidget)

    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("Flow")
    arenaHistoryWidget:AddChild(scroll)

    for i = 1, 10 do
        scroll:AddChild(CreateGameFrame("2024-08-10 15:30", "+25", { 250, 251 }, { 252, 252 }))
    end
end

function InitiateMainFrame()
    local function SelectGroup(container, event, group)
        container:ReleaseChildren()
        if group == "2x2" or group == "3x3" then
            CreateArenaHistoryWidget(container)
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
    frame:SetWidth(1200)
    frame:SetCallback("OnClose",
        function (widget)
            AceGUI:Release(widget)
            ArenaLog.isMainFrameShown = false
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

    return frame
end
