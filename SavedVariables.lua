TamrielLedger = TamrielLedger or {}

local DEFAULT_DATA = {
    account = {
        thievesTrove = 0,
        lockpickedChests = {
    simple = 0,
    intermediate = 0,
    advanced = 0,
    master = 0,
    impossible = 0,
    unknown = 0,
},
    },
    characters = {},
}

function TamrielLedger.GetCurrentCharacterId()
    return GetCurrentCharacterId()
end

function TamrielLedger.GetCurrentCharacterName()
    return GetUnitName("player")
end

function TamrielLedger.InitSavedVariables()
    TamrielLedger.saved = ZO_SavedVars:NewAccountWide(
        "TamrielLedgerSaved",
        1,
        nil,
        DEFAULT_DATA
    )

    local characterId = TamrielLedger.GetCurrentCharacterId()

    if not TamrielLedger.saved.characters[characterId] then
        TamrielLedger.saved.characters[characterId] = {
            name = TamrielLedger.GetCurrentCharacterName(),
            thievesTrove = 0,
            lockpickedChests = {
    simple = 0,
    intermediate = 0,
    advanced = 0,
    master = 0,
    impossible = 0,
    unknown = 0,
},
        }
    end

    TamrielLedger.character = TamrielLedger.saved.characters[characterId]
end

function TamrielLedger.IncrementStat(statName, amount)
    amount = amount or 1

    TamrielLedger.saved.account[statName] =
        (TamrielLedger.saved.account[statName] or 0) + amount

    TamrielLedger.character[statName] =
        (TamrielLedger.character[statName] or 0) + amount
end

function TamrielLedger.GetAccountStat(statName)
    return TamrielLedger.saved.account[statName] or 0
end

function TamrielLedger.GetCharacterStat(statName)
    return TamrielLedger.character[statName] or 0
end

function TamrielLedger.IncrementNestedStat(category, statName, amount)
    amount = amount or 1

    if not TamrielLedger.saved.account[category] then
        TamrielLedger.saved.account[category] = {}
    end

    if not TamrielLedger.character[category] then
        TamrielLedger.character[category] = {}
    end

    TamrielLedger.saved.account[category][statName] =
        (TamrielLedger.saved.account[category][statName] or 0) + amount

    TamrielLedger.character[category][statName] =
        (TamrielLedger.character[category][statName] or 0) + amount
end

function TamrielLedger.GetNestedAccountStat(category, statName)
    if not TamrielLedger.saved.account[category] then
        return 0
    end

    return TamrielLedger.saved.account[category][statName] or 0
end

function TamrielLedger.GetNestedCharacterStat(category, statName)
    if not TamrielLedger.character[category] then
        return 0
    end

    return TamrielLedger.character[category][statName] or 0
end