local Game = ArenaLog.Game
local Team = ArenaLog.Team

Game.__index = Game

function Game.New()
    local self = setmetatable({}, Game)

    local allied = true

    self.date = nil
    self.duration = nil
    self.type = nil --[2 - 2x2, 3 - 3x3] - other types and bg are not supported
    self.score = nil
    self.zone = nil

    self.alliedTeam = Team.New(allied)
    self.enemyTeam = Team.New(not allied)

    return self
end

function Game:UpdateTeamsInfo()
    self.alliedTeam:UpdateTeamInfo()
    self.enemyTeam:UpdateTeamInfo()
end

function Game:Finish(winner, duration)
    self:UpdateTeamsInfo()
    self.score = winner
    self.date = C_DateAndTime.GetCurrentCalendarTime()
    self.duration = duration
    self.type = math.max(self.alliedTeam.size, self.enemyTeam.size)
end
