local Player = ArenaLog.Player

Player.__index = Player

LibStub:GetLibrary("AceEvent-3.0"):Embed(Player)

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

local function GetSpec(self)
    if self.id and not self.specId then
        self.specId, _, _, self.specIcon, _, _, _ = GetSpecializationInfo(GetSpecialization())
    else
        return nil
    end
end

local function IsPlayerInfoComplete(self)
    if self.guid and self.server and self.name and self.class and self.race and self.specId and self.specIcon then
        return true
    end
    return false
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

function Player:INSPECT_READY(guid)
    GetSpec(self)
end

function Player:FullName()
    if self.name and self.server then
        return self.name .. "-" .. self.server
    else
        return nil
    end
end

function Player:UpdatePlayerArenaInfo(index)
    local info = nil

    if index then
        info = C_PvP.GetScoreInfo(index)
    end

    self.guid = self.guid or UnitGUID(self.id)

    if not info then
        info = C_PvP.GetScoreInfoByPlayerGuid(self.guid)
    end

    if info then
        self.name = self.name or info.name
        self.killingBlows = info.killingBlows
        self.faction = self.faction or info.faction
        self.race = self.race or info.raceName
        self.class = self.class or info.className
        self.damageDone = info.damageDone
        self.healingDone = info.healingDone
        self.ratingChange = self.ratingChange or info.ratingChange
    end
end

function Player:UpdatePlayerInfo()
    if IsPlayerInfoComplete(self) then
        return
    end

    self.guid = self.guid or UnitGUID(self.id)

    local playerLocation = PlayerLocation:CreateFromGUID(self.guid)
    local raceID = C_PlayerInfo.GetRace(playerLocation)

    self.server = self.server or select(2, UnitFullName(self.id))
    self.name = self.name or C_PlayerInfo.GetName(playerLocation)
    self.class = self.class or C_PlayerInfo.GetClass(playerLocation)

    if raceID and not self.race then
        self.race = C_CreatureInfo.GetRaceInfo(raceID).raceName
    end

    self:RegisterEvent("INSPECT_READY")
    NotifyInspect(self.id)
end

function Player:Died()
    if not IsFakingDeath(self) then
        self.deathStamp = time()
    end
end
