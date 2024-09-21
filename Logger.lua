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
    if self.types.error.isOn then
        self:_log("error", msg, ...)
    end
end

function Logger:Warning(msg, ...)
    if self.types.warning.isOn then
        self:_log("warning", msg, ...)
    end
end

function Logger:Info(msg, ...)
    if self.types.info.isOn then
        self:_log("info", msg, ...)
    end
end

function Logger:Debug(msg, ...)
    if self.types.debug.isOn then
        self:_log("debug", msg, ...)
    end
end
