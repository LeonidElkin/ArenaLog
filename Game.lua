local Game = ArenaLog.Game
local Team = ArenaLog.Team

Game.__index = Game

function Game.New()
    local self = setmetatable({}, Game)

    self.date = nil
    self.duration = nil
    self.type = nil --[2 - 2x2, 3 - 3x3] - other types and bg are not supported
    self.score = nil
    self.zone = nil

    self.aliedTeam = Team.New(true)
    self.enemyTeam = Team.New(false)

    return self
end

function Game:UpdateZone()
    self.zone = GetRealZoneText()
end

function Game:UpdatePlayers()
    self.aliedTeam:UpdateTeam()
    self.enemyTeam:UpdateTeam()
end
