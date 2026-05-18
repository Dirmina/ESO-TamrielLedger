TamrielLedger = TamrielLedger or {}

TamrielLedger.thievesTrovePatterns = {
    "trésor des voleurs",
    "tresor des voleurs",
    "thieves trove",
}

TamrielLedger.pendingThievesTrove = false
TamrielLedger.thievesTroveAlreadyCounted = false

function TamrielLedger.IsThievesTrove(name)
    local normalizedName = TamrielLedger.NormalizeName(name)

    return TamrielLedger.MatchesAnyPattern(
        normalizedName,
        TamrielLedger.thievesTrovePatterns
    )
end

function TamrielLedger.CheckThievesTrove(interactable)
    if not interactable or not interactable.name then
        return
    end

    if not TamrielLedger.IsThievesTrove(interactable.name) then
        return
    end

    TamrielLedger.pendingThievesTrove = true
    TamrielLedger.thievesTroveAlreadyCounted = false

    TamrielLedger.Debug("Thieves Trove detected: " .. interactable.name)
end

function TamrielLedger.ClearThievesTroveState()
    TamrielLedger.pendingThievesTrove = false
    TamrielLedger.thievesTroveAlreadyCounted = false
end

function TamrielLedger.OnLootReceived()
    if not TamrielLedger.pendingThievesTrove then
        return
    end

    if TamrielLedger.thievesTroveAlreadyCounted then
        return
    end

    TamrielLedger.IncrementStat("thievesTrove", 1)

    TamrielLedger.thievesTroveAlreadyCounted = true

    d(
        "[TL] Thieves Trove looted. Character: "
            .. TamrielLedger.GetCharacterStat("thievesTrove")
            .. " | Account: "
            .. TamrielLedger.GetAccountStat("thievesTrove")
    )
end

function TamrielLedger.PrintThievesTroveStats()
    TamrielLedger.Debug("Thieves Trove stats")
    d("Character: " .. TamrielLedger.GetCharacterStat("thievesTrove"))
    d("Account: " .. TamrielLedger.GetAccountStat("thievesTrove"))
end

function TamrielLedger.InitThievesTrove()
    EVENT_MANAGER:RegisterForEvent(
        TamrielLedger.name,
        EVENT_LOOT_RECEIVED,
        TamrielLedger.OnLootReceived
    )

    SLASH_COMMANDS["/tltrove"] = TamrielLedger.PrintThievesTroveStats
end