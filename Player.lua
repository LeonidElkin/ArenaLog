local Player = ArenaLog.Player
local Logger = ArenaLog.Logger

Player.__index = Player

function Player.New(id)
    local self = setmetatable({}, Player)

    self.id = id
    self.guid = UnitGUID(id)
    self.name, self.server = UnitFullName(id)
    self.race = UnitRace(id)
    self.class = UnitClass(id)
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

local function IsFakingDeath(self)
    local fakeDeathSpellIDS = { 5384 } --It's literally the only one spell so far but it may change
    for _, spellId in ipairs(fakeDeathSpellIDS) do
        local spellName = C_Spell.GetSpellInfo(spellId).name
        if spellName and C_UnitAuras.GetAuraDataByIndex(self.id, spellId) then
            return true
        end
    end
    return false
end

local function IsPlayerInfoComplete(self)
    if self.guid and self.name and self.server and self.race and self.class and self.specId and self.specIcon then
        return true
    else
        return false
    end
end

function Player:UpdateAllyPlayerInfo(guid, unit, info)
    if unit == self.id and not IsPlayerInfoComplete(self) then
        self.guid = guid
        self.specId = info.spec_index
        self.specIcon = info.spec_icon
        self.name = info.name
        self.class = info.class_localized
        self.race = info.race_localized
        self.server = select(2, UnitFullName(self.id))
    end
end

function Player:FullName()
    if self.name and self.server then
        return self.name .. "-" .. self.server
    else
        return nil
    end
end

function Player:GetPlayerArenaInfo()
    Logger:Debug("GetPlayerArenaInfo")
    local info = C_PvP.GetScoreInfoByPlayerGuid(self.guid)

    if info then
        Logger:Debug("GetPlayerArenaInfo is here")
        self.killingBlows = info.killingBlows
        self.faction = info.faction
        self.damageDone = info.damageDone
        self.healingDone = info.healingDone
        self.ratingChange = info.ratingChange
    end
end

function Player:UpdateEnemyPlayerInfo()
    if IsPlayerInfoComplete(self) then
        return
    end

    Logger:Debug("UpdateEnemyPlayerInfo")

    local _, _, numId = string.find(self.id, "(%d+)")

    self.guid = UnitGUID(self.id)
    self.name, self.server = UnitFullName(self.id)
    self.race = UnitRace(self.id)
    self.class = UnitClass(self.id)
    self.specId, _ = GetArenaOpponentSpec(numId)
    _, _, _, self.specIcon, _, _, _ = GetSpecializationInfoByID(self.specId)
end

function Player:Died()
    if not IsFakingDeath(self) then
        self.deathStamp = time()
    end
end
