local Game = ArenaLog.Game
local Team = ArenaLog.Team
local Player = ArenaLog.Player

function Game.New()
    local self = setmetatable({}, Game)

    self.date = nil
    self.duration = nil
    self.type = nil --[2 - 2x2, 3 - 3x3] - other types and bg are not supported
    self.score = nil
    self.zone = nil

    self.aliedTeam = Team.New()
    self.aliedTeam.players.player = Player.new("player")
    for i = 1, 2 do
        local id = "party" .. i
        self.aliedTeam.players[id] = Player.New(id)
    end

    self.enemyTeam = Team.New()
    for i = 1, 3 do
        local id = "arena" .. i
        self.aliedTeam.players[id] = Player.New(id)
    end
    return self
end
