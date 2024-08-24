local Player = ArenaLog.Player


function Player.New(id)
    local self = setmetatable({}, Player)

    self.id = id and id or nil
    self.guid = id and UnitGUID(id) or nil
    self.name = nil
    self.server = nil
    self.race = nil
    self.class = nil
    self.faction = nil --actually a team in arenas [0 - green team, 1 - yellow team]
    self.specId = nil
    self.specIcon = nil
    self.damageDone = nil
    self.healingDone = nil
    self.ratingChange = nil
    self.killingBlows = nil

    return self
end

function Player:FullName()
    if self.id and self.server then
        return self.id .. "-" .. self.server
    else
        return nil
    end
end

function Player:UpdateArenaPlayerInfo(index)
    local info = nil

    if index then
        info = C_PvP.GetScoreInfo(index)
    end

    if not info then
        info = C_PvP.GetScoreInfoByPlayerGuid(self.guid)
    end

    if info then
        self.name = self.name or info.name
        self.guid = self.guid or info.guid
        self.killingBlows = self.killingBlows or info.killingBlows
        self.faction = self.faction or info.faction
        self.race = self.race or info.raceName
        self.class = self.class or info.className
        self.damageDone = self.damageDone or info.damageDone
        self.healingDone = self.healingDone or info.healingDone
        self.ratingChange = self.ratingChange or info.ratingChange
    else
        self.guid = self.guid or UnitGUID(self.id)
    end

    Player:SetSpec()
end

function Player:SetSpec()
    if self.id and not self.specId then
        self.specId, _, _, self.specIcon, _, _, _ = GetSpecializationInfoByID(GetInspectSpecialization(self.id))
    else
        return nil
    end
end
