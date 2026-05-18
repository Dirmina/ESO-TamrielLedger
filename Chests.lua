TamrielLedger = TamrielLedger or {}

TamrielLedger.lockQualityToDifficulty = {
    [LOCK_QUALITY_SIMPLE] = "simple",
    [LOCK_QUALITY_INTERMEDIATE] = "intermediate",
    [LOCK_QUALITY_ADVANCED] = "advanced",
    [LOCK_QUALITY_MASTER] = "master",
}

TamrielLedger.chestDifficultyLabels = {
    simple = "Simple",
    intermediate = "Intermédiaire",
    advanced = "Avancé",
    master = "Maître",
    unknown = "Inconnu",
}

TamrielLedger.pendingChest = false
TamrielLedger.currentChestDifficulty = nil

function TamrielLedger.CheckChest(interactable)
    if not interactable or not interactable.name then
        return
    end

    local normalizedAction = TamrielLedger.NormalizeName(interactable.actionName)

    if normalizedAction == "déverrouiller"
        or normalizedAction == "deverrouiller"
        or normalizedAction == "unlock"
    then
        TamrielLedger.pendingChest = true
        TamrielLedger.StartLockQualityCapture()
        TamrielLedger.Debug("Chest detected: " .. TamrielLedger.Safe(interactable.name))
    end
end

function TamrielLedger.OnLockpickingBegin()
    d('lockpick begins')
    if not TamrielLedger.pendingChest then
        return
    end
    d('lockpick continue')


    local lockQuality = GetLockQuality()
    d('lockpick continue 2')

    local difficulty = TamrielLedger.lockQualityToDifficulty[lockQuality] or "unknown"

    TamrielLedger.currentChestDifficulty = difficulty

    local label = TamrielLedger.chestDifficultyLabels[difficulty] or difficulty

    TamrielLedger.Debug("Lockpicking difficulty: " .. label)
end

function TamrielLedger.StartLockQualityCapture()
    EVENT_MANAGER:RegisterForUpdate(
        TamrielLedger.name .. "_LockQualityCapture",
        100,
        function()
            local lockQuality = GetLockQuality()

            if lockQuality and lockQuality ~= 0 then
                local difficulty =
                    TamrielLedger.lockQualityToDifficulty[lockQuality]
                    or "unknown"

                TamrielLedger.currentChestDifficulty = difficulty

                local label =
                    TamrielLedger.chestDifficultyLabels[difficulty]
                    or difficulty

                TamrielLedger.Debug("Lockpicking difficulty captured: " .. label)

                EVENT_MANAGER:UnregisterForUpdate(
                    TamrielLedger.name .. "_LockQualityCapture"
                )
            end
        end
    )
end

function TamrielLedger.OnLockpickSuccess()
    if not TamrielLedger.pendingChest then
        return
    end

    local difficulty = TamrielLedger.currentChestDifficulty or "unknown"
    local label = TamrielLedger.chestDifficultyLabels[difficulty] or difficulty

    TamrielLedger.IncrementNestedStat(
        "lockpickedChests",
        difficulty,
        1
    )

    d(
        "[TL] Chest opened: "
            .. label
            .. " | lockQuality="
            .. TamrielLedger.Safe(lockQuality)
            .. " | Character: "
            .. TamrielLedger.GetNestedCharacterStat("lockpickedChests", difficulty)
            .. " | Account: "
            .. TamrielLedger.GetNestedAccountStat("lockpickedChests", difficulty)
    )

    TamrielLedger.pendingChest = false
    TamrielLedger.currentChestDifficulty = nil
end

function TamrielLedger.OnLockpickFailed()
    TamrielLedger.pendingChest = false
    TamrielLedger.currentChestDifficulty = nil
end

function TamrielLedger.PrintChestStats()
    TamrielLedger.Debug("Chest stats")

    local difficulties = {
        "simple",
        "intermediate",
        "advanced",
        "master",
        "impossible",
        "unknown",
    }

    for _, difficulty in ipairs(difficulties) do
        local label = TamrielLedger.chestDifficultyLabels[difficulty] or difficulty

        d(
            label
                .. ": "
                .. TamrielLedger.GetNestedCharacterStat(
                    "lockpickedChests",
                    difficulty
                )
                .. " | Account: "
                .. TamrielLedger.GetNestedAccountStat(
                    "lockpickedChests",
                    difficulty
                )
        )
    end
end

function TamrielLedger.InitChests()
    EVENT_MANAGER:RegisterForEvent(
        TamrielLedger.name .. "_LockpickSuccess",
        EVENT_LOCKPICK_SUCCESS,
        TamrielLedger.OnLockpickSuccess
    )

    EVENT_MANAGER:RegisterForEvent(
        TamrielLedger.name .. "_LockpickFailed",
        EVENT_LOCKPICK_FAILED,
        TamrielLedger.OnLockpickFailed
    )

    SLASH_COMMANDS["/tlchests"] = TamrielLedger.PrintChestStats
end