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

local function CreateLabeledGroup(label, value, color)
    local group = AceGUI:Create("SimpleGroup")
    group:SetLayout("List")
    group:SetWidth(12 * max(#label, #value))

    if color then
        value = string.format("|%s%s|r", UI.Color[color], value)
    end

    local labelWidget = AceGUI:Create("Label")
    labelWidget:SetText(label)
    labelWidget:SetJustifyH("CENTER")
    labelWidget:SetFullWidth(true)
    labelWidget:SetFont("Fonts\\FRIZQT__.TTF", 14, "THICKOUTLINE")
    group:AddChild(labelWidget)


    local spacer = AceGUI:Create("Label")
    spacer:SetText(" ")
    spacer:SetFullWidth(true)
    spacer:SetHeight(5)
    group:AddChild(spacer)

    local valueWidget = AceGUI:Create("Label")
    valueWidget:SetText(value)
    valueWidget:SetJustifyH("CENTER")
    valueWidget:SetFullWidth(true)
    valueWidget:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    group:AddChild(valueWidget)


    return group
end

local function CreateGameFrame(game)
    local singleGameFrame = AceGUI:Create("InlineGroup")
    singleGameFrame:SetFullWidth(true)
    singleGameFrame:SetLayout("Flow")

    singleGameFrame:AddChild(CreateLabeledGroup("Date",
        tostring(game.date.monthDay) .. "-" .. tostring(game.date.month) .. "-" .. tostring(game.date.year)))

    singleGameFrame:AddChild(CreateTeamWidget(game.alliedTeam))


    local vsGroup = AceGUI:Create("SimpleGroup")
    vsGroup:SetLayout("List")
    vsGroup:SetWidth(30)
    local vsLabel = AceGUI:Create("Label")
    vsLabel:SetText("vs")
    vsLabel:SetJustifyH("CENTER")
    vsLabel:SetFullWidth(true)
    vsLabel:SetFontObject(GameFontNormalLarge)
    vsGroup:AddChild(vsLabel)

    singleGameFrame:AddChild(vsGroup)

    singleGameFrame:AddChild(CreateTeamWidget(game.enemyTeam))

    singleGameFrame:AddChild(CreateLabeledGroup("Location", game.zone))

    singleGameFrame:AddChild(CreateLabeledGroup("Duration",
        string.format("%dm%ds", game.duration / 60, game.duration % 60)))


    local score, color
    if game.score == game.alliedTeam.teamIndex then
        score, color = "WIN", "green"
    else
        score, color = "LOSE", "red"
    end

    singleGameFrame:AddChild(CreateLabeledGroup("Result", score, color))

    if game.alliedTeam.players.player.ratingChange > 0 then
        color = "green"
    else
        color = "red"
    end


    singleGameFrame:AddChild(CreateLabeledGroup("Rating Change", tostring(game.alliedTeam.players.player.ratingChange),
        color))

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
        ArenaLog:Print(games[i].type)
        if games[i].type == tonumber(group) then
            scroll:AddChild(CreateGameFrame(games[i]))
        end
    end
end

local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "2" or group == "3" then
        UI:CreateArenaHistoryWidget(container, group)
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
        { text = "2x2", value = "2" },
        { text = "3x3", value = "3" }
    })
    tab:SetCallback("OnGroupSelected", SelectGroup)
    tab:SelectTab("2")

    frame:AddChild(tab)
end
