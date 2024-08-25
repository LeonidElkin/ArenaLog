local Team = ArenaLog.Team

Team.__index = Team

function Team.New()
    local self = setmetatable({}, Team)

    self.teamIndex = nil -- [0 - green team, 1 - yellow team]
    self.teamRating = nil
    self.players = {}

    return self
end
