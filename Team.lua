local Team = ArenaLog.Team
local Logger = ArenaLog.Logger

Team.__index = Team

function Team.New()
    local self = setmetatable({}, Team)

    self.teamIndex = nil -- [0 - green team, 1 - yellow team]
    self.teamRating = nil
    self.name = nil
    self.size = nil
    self.players = {}

    return self
end

function Team:UpdateTeamInfo()
    Logger:Debug("UPDATING ONE OF THE TEAMS")

    for i, v in pairs(self.players) do
        Logger:Debug("UPDATING %s", i)
        v:GetPlayerArenaInfo()
        if v.faction and not self.teamIndex then
            self.teamIndex = v.faction
        end
    end

    Logger:Debug("GetTeamInfo")
    local info = C_PvP.GetTeamInfo(self.teamIndex)
    Logger:Debug("GetTeamInfo succes")


    if info then
        Logger:Debug("GetTeamInfo succes2")
        self.teamRating = self.teamRating or info.rating
        self.size = info.size
        self.name = self.name or self.name
    end
end
