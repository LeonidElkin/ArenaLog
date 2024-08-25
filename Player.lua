local Player = ArenaLog.Player

Player.__index = Player

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

    self.deathStamp = nil

    return self
end

function Player:FullName()
    if self.name and self.server then
        return self.name .. "-" .. self.server
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

    self.server = self.server or select(2, UnitFullName(self.id))

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

        local playerLocation = PlayerLocation:CreateFromGUID(self.guid)
        local raceID = C_PlayerInfo.GetRace(playerLocation)

        self.name = self.name or C_PlayerInfo.GetName(playerLocation)
        if raceID and not self.race then
            self.race = C_CreatureInfo.GetRaceInfo(raceID).raceName
        end
        self.class = self.class or C_PlayerInfo.GetClass(playerLocation)
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

function Player:isFakingDeath()
    local fakeDeathSpellIDS = { 5384 } --It's actually the only one spell so far but it may change
    for _, spellId in ipairs(fakeDeathSpellIDS) do
        local spellName = C_Spell.GetSpellInfo(spellId).name
        if spellName ~= nil and C_UnitAuras.GetAuraDataByIndex(spellName, self.id) ~= nil then
            return true
        end
    end
    return false
end

function Player:died()
    if not self:isFakingDeath() then
        self.died_timestamp = time()
    end
end
