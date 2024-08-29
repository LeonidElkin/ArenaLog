local _, AddonTable = ...

local Logger = AddonTable.Logger

local Team = ArenaLog.Team
local Player = ArenaLog.Player

Team.__index = Team

function Team.New(isAlied)
    local self = setmetatable({}, Team)

    self.teamIndex = nil -- [0 - green team, 1 - yellow team]
    self.teamRating = nil
    self.name = nil
    self.isAlied = isAlied
    self.size = nil
    self.players = {}

    if isAlied then
        self.players.player = Player.New("player")
        for i = 1, 2 do
            local id = "party" .. i
            self.players[id] = Player.New(id)
        end
    else
        for i = 1, 3 do
            local id = "arena" .. i
            self.players[id] = Player.New(id)
        end
    end


    return self
end

function Team:UpdateTeamInfo()
    for _, v in pairs(self.players) do
        v:UpdatePlayerInfo(nil)
        if v.faction then
            self.teamIndex = v.faction
        end
        if self.teamIndex and not v.faction and v.faction ~= self.teamIndex then
            Logger:Error("%s and their team have different team indices!", v.id)
        end
    end

    local info = C_PvP.GetTeamInfo(self.teamIndex)

    if info then
        self.teamRating = self.teamRating or info.rating
        self.size = info.size
        self.name = self.name or self.name
    end
end
