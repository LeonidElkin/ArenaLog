if not ArenaLogDB then
        ArenaLogDB = {}
end

local mainFrame = CreateFrame("Frame", "ArenaLogMainFrame", UIParent, "BasicFrameTemplateWithInset")
mainFrame:SetSize(500, 350)
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
mainFrame.TitleBg:SetHeight(30)
mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
mainFrame.title:SetPoint("CENTER", mainFrame.TitleBg, "CENTER", 0, 5)
mainFrame.title:SetText("ArenaLog")
mainFrame:Hide()
mainFrame:EnableMouse(true)
mainFrame:SetMovable(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", function (self)
        self:StartMoving()
end)
mainFrame:SetScript("OnDragStop", function (self)
        self:StopMovingOrSizing()
end)

mainFrame:SetScript("OnShow", function ()
        PlaySound(808)
end)

mainFrame:SetScript("OnHide", function ()
        PlaySound(808)
end)

SLASH_ARENALOG1 = "/ArenaLog"
SLASH_ARENALOG2 = "/AL"
SLASH_ARENALOG3 = "/al"
SLASH_ARENALOG4 = "/arenalog"
SlashCmdList["ARENALOG"] = function ()
        if mainFrame:IsShown() then
                mainFrame:Hide()
        else
                mainFrame:Show()
        end
end


table.insert(UISpecialFrames, "ArenaLogMainFrame")
