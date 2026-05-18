TamrielLedger = TamrielLedger or {}

TamrielLedger.name = "TamrielLedger"
TamrielLedger.debugEnabled = false
TamrielLedger.uiLabels = {
    fr = {
        character = "Personnage",
        account = "Compte",
        thievesTroves = "Trésors des voleurs",

        chest_simple = "Coffres simples",
        chest_intermediate = "Coffres intermédiaires",
        chest_advanced = "Coffres avancés",
        chest_master = "Coffres maîtres",
    },

    en = {
        character = "Character",
        account = "Account",
        thievesTroves = "Thieves Troves",

        chest_simple = "Simple Chests",
        chest_intermediate = "Intermediate Chests",
        chest_advanced = "Advanced Chests",
        chest_master = "Master Chests",
    },
}

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


function TamrielLedger.GetLanguage()
    local language = GetCVar("language.2")

    if language == "fr" then
        return "fr"
    end

    return "en"
end

function TamrielLedger.T(key)
    local language = TamrielLedger.GetLanguage()
    local labels = TamrielLedger.uiLabels[language] or TamrielLedger.uiLabels.en

    return labels[key] or TamrielLedger.uiLabels.en[key] or key
end



function TamrielLedger.Debug(message)
    if not TamrielLedger.debugEnabled then
        return
    end

    d("[TL DEBUG] " .. tostring(message))
end