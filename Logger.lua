local Logger = ArenaLog.Logger

Logger.types = {
    error = {
        msg = "ERROR",
        color = "cffff0000",
        isOn = true
    },
    warning = {
        msg = "WARNING",
        color = "cfffff000",
        isOn = true
    },
    info = {
        msg = "INFO",
        color = "cff00ff00",
        isOn = true
    },
    debug = {
        msg = "DEBUG",
        color = "cff00ff00",
        isOn = true
    }
}

local function CheckFormat(msg, ...)
    if ... then
        msg = string.format(msg, ...)
    end
    return msg
end

function Logger:_log(type, msg, ...)
    local formatedMsg = CheckFormat(msg, ...)
    local source = Logger.types
    print(string.format("|%sArenaLog [%s]|r: %s", source[type].color, source[type].msg, formatedMsg))
end

function Logger:Error(msg, ...)
    self:_log("error", msg, ...)
end

function Logger:Warning(msg, ...)
    self:_log("warning", msg, ...)
end

function Logger:Info(msg, ...)
    self:_log("info", msg, ...)
end

function Logger:Debug(msg, ...)
    self:_log("debug", msg, ...)
end

function Logger:SwitchMessages(type)
    Logger.types[type].isOn = not Logger.types[type].isOn
end
