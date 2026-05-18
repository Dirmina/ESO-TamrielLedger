TamrielLedger = TamrielLedger or {}

TamrielLedger.uiRows = {}

function TamrielLedger.ToggleUI()
    if TamrielLedgerWindow:IsHidden() then
        TamrielLedger.RefreshTabs()
        TamrielLedger.RefreshUI()
        TamrielLedgerWindow:SetHidden(false)
    else
        TamrielLedgerWindow:SetHidden(true)
    end
end

function TamrielLedger.ClearUIRows()
    for _, row in ipairs(TamrielLedger.uiRows) do
        row:SetHidden(true)
    end
end

function TamrielLedger.AddSpacing(row, amount)
    amount = amount or 16

    TamrielLedger.SetRow(row, " ", amount)

    return row + 1
end

function TamrielLedger.SetRow(index, text, spacing)
    spacing = spacing or 8

    local row = TamrielLedger.uiRows[index]

    if not row then
        row = CreateControl(
            "TamrielLedgerRow" .. index,
            TamrielLedgerWindowContent,
            CT_LABEL
        )

        row:SetFont("ZoFontGame")
        row:SetColor(1, 1, 1, 1)

        if index == 1 then
            row:SetAnchor(TOPLEFT, TamrielLedgerWindowContent, TOPLEFT, 0, 0)
        else
            row:SetAnchor(TOPLEFT, TamrielLedger.uiRows[index - 1], BOTTOMLEFT, 0, spacing)
        end

        TamrielLedger.uiRows[index] = row
    end

    row:SetText(text)
    row:SetHidden(false)
end

function TamrielLedger.RefreshUI()
    TamrielLedger.ClearUIRows()

    row = 1
    local isAccount = TamrielLedger.currentStatsScope == "account"

    local trovesCount

    if isAccount then
        trovesCount = TamrielLedger.GetAccountStat("thievesTrove")
    else
        trovesCount = TamrielLedger.GetCharacterStat("thievesTrove")
    end

    TamrielLedger.SetRow(
    row,
    TamrielLedger.T("thievesTroves")
        .. ": "
        .. trovesCount
)
    row = row + 1
    row = TamrielLedger.AddSpacing(row, 1)

    local chestDifficulties = {
        "simple",
        "intermediate",
        "advanced",
        "master",
    }

    for _, difficulty in ipairs(chestDifficulties) do
        local label =
            TamrielLedger.chestDifficultyLabels[difficulty]
            or difficulty

        local label = TamrielLedger.T("chest_" .. difficulty)

        local count

        if isAccount then
            count = TamrielLedger.GetNestedAccountStat("lockpickedChests", difficulty)
        else
            count = TamrielLedger.GetNestedCharacterStat("lockpickedChests", difficulty)
        end

        TamrielLedger.SetRow(
            row,
            label
                .. ": "
                .. count
        )

        row = row + 1
    end
end

TamrielLedger.currentStatsScope = "character"

function TamrielLedger.RefreshTabs()
    local isCharacter =
        TamrielLedger.currentStatsScope == "character"

    TamrielLedgerWindowCharacterTab:SetEnabled(true)
    TamrielLedgerWindowAccountTab:SetEnabled(true)

    if isCharacter then
        TamrielLedgerWindowCharacterTab:SetText("> Personnage <")
        TamrielLedgerWindowAccountTab:SetText("Compte")
    else
        TamrielLedgerWindowCharacterTab:SetText("Personnage")
        TamrielLedgerWindowAccountTab:SetText("> Compte <")
    end
end

function TamrielLedger.SetStatsScope(scope)
    TamrielLedger.currentStatsScope = scope
    TamrielLedger.RefreshTabs()
    TamrielLedger.RefreshUI()
end

function TamrielLedger.InitUI()
    SLASH_COMMANDS["/tlui"] = TamrielLedger.ToggleUI
end
