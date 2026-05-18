TamrielLedger = TamrielLedger or {}

TamrielLedger.name = "TamrielLedger"

function TamrielLedger.Safe(value)
    if value == nil or value == "" then
        return "Unknown"
    end

    return tostring(value)
end

function TamrielLedger.NormalizeName(name)
    if not name then
        return nil
    end

    return zo_strlower(zo_strformat("<<1>>", name))
end

function TamrielLedger.Contains(text, pattern)
    if not text or not pattern then
        return false
    end

    return string.match(text, pattern) ~= nil
end

function TamrielLedger.MatchesAnyPattern(text, patterns)
    if not text or not patterns then
        return false
    end

    for _, pattern in ipairs(patterns) do
        if TamrielLedger.Contains(text, pattern) then
            return true
        end
    end

    return false
end