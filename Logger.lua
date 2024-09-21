local Logger = ArenaLog.Logger

Logger.types = {
    error = {
        msg = "ERROR",
        color = "cffff0000"
    },
    warning = {
        msg = "WARNING",
        color = "cfffff000"
    },
    info = {
        msg = "INFO",
        color = "cff00ff00"
    },
    debug = {
        msg = "DEBUG",
        color = "cff00ff00"
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
    if ArenaLog.db.char.loggerModes.error then
        self:_log("error", msg, ...)
    end
end

function Logger:Warning(msg, ...)
    if ArenaLog.db.char.loggerModes.warning then
        self:_log("warning", msg, ...)
    end
end

function Logger:Info(msg, ...)
    if ArenaLog.db.char.loggerModes.info then
        self:_log("info", msg, ...)
    end
end

function Logger:Debug(msg, ...)
    if ArenaLog.db.char.loggerModes.debug then
        self:_log("debug", msg, ...)
    end
end
