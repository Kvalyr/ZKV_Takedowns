local ZKVTD = GetMod("ZKVTD")
-- ====================================================================================================================
-- ZKV_Takedowns for CP2077 by Kvalyr
-- ====================================================================================================================

-- WIP
local function AnimSpeedups()
    -- Full role of these effectors in the finisher/takedown is unknown.
    -- Reducing the effector duration without also reducing animation lock-in could cause issues such as desync
    -- between animation and finisher-invulnerability, etc.
    local animSpeedMult = 0.25

    local function applyMult(flatKey)
        local backupKey = flatKey .. "_backup"
        local baseValue = TweakDB:GetFlat(backupKey)
        if not baseValue then
            baseValue = TweakDB:GetFlat(flatKey)
            TweakDB:SetFlat(backupKey, baseValue)
        end
        if not baseValue then
            ZKVTD.printError("Failed to get baseValue for:", flatKey)
        end
        local newValue = baseValue * animSpeedMult
        TweakDB:SetFlat(flatKey, newValue)
        ZKVTD.print("AnimSpeedup: ", flatKey, baseValue, newValue)
    end

    -- TweakDB:SetFlat("Effectors.PlayerMantisBladesFinisher_inline0.duration", 1.2)
    -- Finishers
    applyMult("Effectors.PlayerFinisher_inline0.duration")
    applyMult("Effectors.PlayerMantisBladesFinisher_inline0.duration")
    applyMult("Effectors.PlayerKatanaFinisher_inline0.duration")
    applyMult("Effectors.PlayerKatanaFinisherNoDismemberment_inline0.duration")
    applyMult("Effectors.PlayerStrongArmsFinisher_inline0.duration")

    -- Takedowns
    applyMult("Effectors.PlayerLethalTakedown_inline0.duration")
    applyMult("Effectors.PlayerNonLethalTakedown_inline0.duration")
    applyMult("Effectors.PlayerNonLethalNetworkBreachTakedown_inline0.duration")
    applyMult("Effectors.PlayerNonLethalAerialTakedown_inline0.duration")
end