local Game = ArenaLog.Game
local Team = ArenaLog.Team
local Logger = ArenaLog.Logger

Game.__index = Game

function Game.New()
    local self = setmetatable({}, Game)

    self.date = nil
    self.duration = nil
    self.type = nil --[2 - 2x2, 3 - 3x3] - other types and bg are not supported
    self.score = nil
    self.zone = nil

    self.alliedTeam = Team.New()
    self.enemyTeam = Team.New()

    return self
end

function Game:UpdateTeamsInfo()
    Logger:Debug("UPDATING TEAMS")
    self.alliedTeam:UpdateTeamInfo()
    self.enemyTeam:UpdateTeamInfo()
end

function Game:UpdateZone()
    self.zone = GetRealZoneText()
end

function Game:Finish(winner, duration)
    Logger:Debug("FINISHING THE GAME")
    self:UpdateTeamsInfo()
    self:UpdateZone()
    self.score = winner
    self.date = C_DateAndTime.GetCurrentCalendarTime()
    self.duration = string.format("%dm%ds", duration / 60, duration % 60)
    self.type = math.max(self.alliedTeam.size, self.enemyTeam.size)
end
