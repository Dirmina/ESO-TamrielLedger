TamrielLedger = TamrielLedger or {}

TamrielLedger.currentInteractableName = nil

function TamrielLedger.GetCurrentInteractable()
    local actionName, interactableName = GetGameCameraInteractableActionInfo()

    return {
        actionName = actionName,
        name = interactableName,
    }
end

function TamrielLedger.CheckInteractable()
    local interactable = TamrielLedger.GetCurrentInteractable()

    if not interactable.name or interactable.name == "" then
        TamrielLedger.currentInteractableName = nil
        TamrielLedger.OnInteractableCleared()
        return
    end

    if interactable.name == TamrielLedger.currentInteractableName then
        return
    end

    TamrielLedger.currentInteractableName = interactable.name

    TamrielLedger.OnInteractableChanged(interactable)
end

function TamrielLedger.OnInteractableChanged(interactable)
    TamrielLedger.CheckThievesTrove(interactable)
    TamrielLedger.CheckChest(interactable)
end

function TamrielLedger.OnInteractableCleared()
    TamrielLedger.ClearThievesTroveState()
end

function TamrielLedger.InitInteractables()
    EVENT_MANAGER:RegisterForUpdate(
        TamrielLedger.name .. "_InteractableCheck",
        250,
        TamrielLedger.CheckInteractable
    )
end