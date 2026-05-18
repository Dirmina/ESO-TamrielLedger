TamrielLedger = TamrielLedger or {}

local function OnAddonLoaded(eventCode, addonName)
    if addonName ~= TamrielLedger.name then
        return
    end

    TamrielLedger.InitSavedVariables()
    TamrielLedger.InitThievesTrove()
    TamrielLedger.InitChests()
    TamrielLedger.InitInteractables()
    TamrielLedger.InitUI()

    TamrielLedger.Debug("Tamriel Ledger loaded.")

    EVENT_MANAGER:UnregisterForEvent(
        TamrielLedger.name,
        EVENT_ADD_ON_LOADED
    )
end

EVENT_MANAGER:RegisterForEvent(
    TamrielLedger.name,
    EVENT_ADD_ON_LOADED,
    OnAddonLoaded
)

SLASH_COMMANDS["/tldebug"] = function()
    TamrielLedger.debugEnabled =
        not TamrielLedger.debugEnabled

    d(
        "[TL] Debug "
            .. (
                TamrielLedger.debugEnabled
                and "enabled"
                or "disabled"
            )
    )
end