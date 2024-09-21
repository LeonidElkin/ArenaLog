local AceGUI = LibStub("AceGUI-3.0")
local UI = ArenaLog.UI
local Logger = ArenaLog.Logger

UI.IconSize = 40 --px
UI.IconSpacers = 5
UI.MainFrame = {
    height = 600,
    width = 1100
}

UI.Color = {
    red = "cffff0000",
    green = "cff00ff00"
}

local function CreateSpacerH(width)
    local spacer = AceGUI:Create("Label")
    spacer:SetText(" ")
    spacer:SetWidth(width)
    return spacer
end

local function CreateTeamWidget(team)
    local teamGroup = AceGUI:Create("SimpleGroup")
    teamGroup:SetLayout("Flow")
    teamGroup:SetWidth(team.size * UI.IconSize + 1 + (team.size - 1) * UI.IconSpacers)

    local i = 1

    for _, player in pairs(team.players) do
        local iconWidget = AceGUI:Create("Icon")
        iconWidget:SetImage(player.specIcon)
        iconWidget:SetImageSize(UI.IconSize, UI.IconSize)
        iconWidget:SetWidth(UI.IconSize)
        teamGroup:AddChild(iconWidget)
        if (i ~= team.size) then
            teamGroup:AddChild(CreateSpacerH(UI.IconSpacers))
        end
        i = i + 1
    end

    return teamGroup
end

local function CreateLabeledGroup(label, value, color, width)
    local group = AceGUI:Create("SimpleGroup")
    group:SetLayout("List")
    group:SetWidth(width)

    local font = "Fonts\\FRIZQT__.TTF"

    local labelWidget = AceGUI:Create("Label")
    labelWidget:SetText(label)
    labelWidget:SetJustifyH("CENTER")
    labelWidget:SetFullWidth(true)
    labelWidget:SetFont(font, 14, "THICKOUTLINE")
    group:AddChild(labelWidget)


    local spacer = AceGUI:Create("Label")
    spacer:SetText(" ")
    spacer:SetFullWidth(true)
    spacer:SetHeight(5)
    group:AddChild(spacer)


    local i, j = string.find(value, "[%w-]+")

    if not (i == 1 and j == #value) then
        font = "Fonts\\ARIALN.TTF"
    end
    if color then
        value = string.format("|%s%s|r", UI.Color[color], value)
    end

    local valueWidget = AceGUI:Create("Label")
    valueWidget:SetText(value)
    valueWidget:SetJustifyH("CENTER")
    valueWidget:SetFullWidth(true)
    valueWidget:SetFont(font, 12, "OUTLINE")
    group:AddChild(valueWidget)


    return group
end

local function CreateTeamsGroup(container, game)
    container:AddChild(CreateTeamWidget(game.alliedTeam))

    local vsGroup = AceGUI:Create("SimpleGroup")
    vsGroup:SetLayout("List")
    vsGroup:SetWidth(30)
    local vsLabel = AceGUI:Create("Label")
    vsLabel:SetText("vs")
    vsLabel:SetJustifyH("CENTER")
    vsLabel:SetFullWidth(true)
    vsLabel:SetFontObject(GameFontNormalLarge)
    vsGroup:AddChild(vsLabel)

    container:AddChild(vsGroup)

    container:AddChild(CreateTeamWidget(game.enemyTeam))
end

local function CreateGameFrame(game)
    local singleGameFrame = AceGUI:Create("InlineGroup")
    singleGameFrame:SetFullWidth(true)
    singleGameFrame:SetLayout("Flow")

    local date = tostring(game.date.monthDay) .. "-" .. tostring(game.date.month) .. "-" .. tostring(game.date.year)
    singleGameFrame:AddChild(CreateLabeledGroup("Date", date, nil, 100))

    CreateTeamsGroup(singleGameFrame, game)

    singleGameFrame:AddChild(CreateLabeledGroup("Location", game.zone, nil, 200))

    singleGameFrame:AddChild(CreateLabeledGroup("Duration", game.duration, nil, 100))

    local score, color
    if game.score == game.alliedTeam.teamIndex then
        score, color = "WIN", "green"
    else
        score, color = "LOSE", "red"
    end

    singleGameFrame:AddChild(CreateLabeledGroup("Result", score, color, 60))

    singleGameFrame:AddChild(CreateLabeledGroup("Rating Change", tostring(game.alliedTeam.players.player.ratingChange),
        color, 140))


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

    local games = ArenaLog.db.char.gameHistory
    Logger:Debug("The current number of games stored - %d", #games)

    for i = #games, 1, -1 do
        Logger:Debug("Drawing game %d", i)
        if games[i].type == tonumber(group) then
            scroll:AddChild(CreateGameFrame(games[i]))
        end
    end
end

local function CreateCheckBox(label, type)
    local checkBox = AceGUI:Create("CheckBox")
    checkBox:SetLabel(label)
    checkBox:SetValue(ArenaLog.db.char.loggerModes[type])
    checkBox:SetCallback("OnValueChanged", function (widget, event, value) ArenaLog.db.char.loggerModes[type] = value end)
    return checkBox
end

function UI:CreateSettingsWidget(container)
    local settingsWidget = AceGUI:Create("SimpleGroup")
    settingsWidget:SetFullWidth(true)
    settingsWidget:SetFullHeight(true)
    settingsWidget:SetLayout("Fill")
    container:AddChild(settingsWidget)

    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("Flow")
    settingsWidget:AddChild(scroll)

    scroll:AddChild(CreateCheckBox("Enable error messages", "error"))
    scroll:AddChild(CreateCheckBox("Enable info messages", "info"))
    scroll:AddChild(CreateCheckBox("Enable warning messages", "warning"))

    local button = AceGUI:Create("Button")
    button:SetText("Reset games history?")
    button:SetWidth(200)
    button:SetCallback("OnClick", function ()
        ArenaLog.db.char.gameHistory = {}
        Logger:Info("Games history was reseted")
    end)
    scroll:AddChild(button)
end

local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "2" or group == "3" then
        UI:CreateArenaHistoryWidget(container, group)
    elseif group == "Settings" then
        UI:CreateSettingsWidget(container)
    end
end

function UI:InitiateMainFrame()
    if UI.isMainFrameShown then
        return
    end

    UI.isMainFrameShown = true

    local frame = AceGUI:Create("Frame")
    frame:SetTitle("ArenaLog")
    frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:SetLayout("Fill")
    frame:SetHeight(UI.MainFrame.height)
    frame:SetWidth(UI.MainFrame.width)
    frame:SetCallback("OnClose",
        function (widget)
            AceGUI:Release(widget)
            UI.isMainFrameShown = false
        end
    )

    local tab = AceGUI:Create("TabGroup")
    tab:SetLayout("Fill")
    tab:SetTabs({
        { text = "2x2",      value = "2" },
        { text = "3x3",      value = "3" },
        { text = "Settings", value = "Settings" }
    })
    tab:SetCallback("OnGroupSelected", SelectGroup)
    tab:SelectTab("2")

    frame:AddChild(tab)
end
