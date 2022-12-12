-- ====================================================================================================================
-- ZKV_Takedowns for CP2077 by Kvalyr
-- Default Config values - Editing this file is not advisable - Use the in-game settings UI instead (Main Menu -> Mods -> Kvalyr Mods)
-- ====================================================================================================================
local ZKVTD = GetMod("ZKV_Takedowns")
local ConfigDefaults = {}
ZKVTD:AddModule("ConfigDefaults", ConfigDefaults)

function ConfigDefaults:Init()
    -- Set this value to true or false to toggle using the Aerial Takedown for Mantis Blades finishers.
    -- i.e.; If this is true, the Mantis Blades aerial takedown animation added in 1.5 will be used in place of the normal mantis blades finisher animation.
    local MantisSwap_Finishers_UseAerialTakedownAnimation = true

    -- Set this value to true or false to toggle using either the Aerial Takedown animation or the old finisher animation on a 50/50 basis.
    -- i.e.; If this is true, then about 50% of the time, the new Mantis Blades aerial takedown animation from 1.5 will be used for MB finishers.
    -- If 'MantisSwap_Finishers_UseAerialTakedownAnimation' is true and this is false, then the 1.5 aerial takedown animation will be used 100% of the time.
    -- If 'MantisSwap_Finishers_UseAerialTakedownAnimation' is false then this has no effect.
    local MantisSwap_Finishers_MixDifferentAnimations = false

    -- Set this value to true or false to toggle the new takedown/kill prompt showing only with a melee weapon held (true) or with any weapon (false)
    local Takedowns_OnlyWithMeleeWeaponHeld = true

    -- By default, takedowns with blunt weapons (fists, gorilla arms, clubs, bats, etc.) leave the target unconscious
    -- Set this to false to make those takedowns lethal instead
    local Takedowns_NonLethalBlunt = true

    local StealthMeleeDamageMultiplier = 1.30 -- Default in CP2077 v1.61: 1.30

    -- -- Unlock camera during finishers & takedowns
    -- -- May cause weirdness
    -- -- WIP - CURRENTLY UNUSED
    -- local TakedownsFinishers_UnlockCamera = true

    -- -- Unlock movement during finishers & takedowns
    -- -- Will cause weirdness
    -- -- WIP - CURRENTLY UNUSED
    -- local TakedownsFinishers_UnlockControls = true

    ZKVTD.Config.SetDefaultValue("MantisSwap_Finishers_UseAerialTakedownAnimation", MantisSwap_Finishers_UseAerialTakedownAnimation)
    ZKVTD.Config.SetDefaultValue("MantisSwap_Finishers_MixDifferentAnimations", MantisSwap_Finishers_MixDifferentAnimations)
    ZKVTD.Config.SetDefaultValue("Takedowns_OnlyWithMeleeWeaponHeld", Takedowns_OnlyWithMeleeWeaponHeld)
    ZKVTD.Config.SetDefaultValue("Takedowns_NonLethalBlunt", Takedowns_NonLethalBlunt)
    ZKVTD.Config.SetDefaultValue("Misc_Stealth_MeleeMult", StealthMeleeDamageMultiplier)

    local defaultAnimsByWeapon = {
        Wea_Fists = {
            --
            "finisher_default",
            "AerialTakedown_Back_Simple",
            -- "AerialTakedown_Simple",  -- Disabled by default as it rotates the player to the correct position for the takedown, which is weird from behind
        },
        Wea_LongBlade = {
            "ZKVTD_Katana_backstab",
            "ZKVTD_Katana_behead_behind",
            -- "ZKVTD_Takedown_SafeAttack",
            -- "ZKVTD_Takedown_BlockAttack",
        },
        Wea_ShortBlade = {
            --
            "ZKVTD_Knife_backstab",
            "ZKVTD_Takedown_BlockAttack",
        },
        _Wea_MediumBlade = {
            --
            "ZKVTD_Katana_backstab",
            "ZKVTD_Katana_behead_behind",
            "ZKVTD_Knife_backstab",
            "ZKVTD_Takedown_BlockAttack",
        },
        Wea_OneHandedClub = {
            --
            "ZKVTD_Takedown_HeavyAttack02",
        },
        Wea_TwoHandedClub = {
            --
            "ZKVTD_Takedown_ComboAttack03",
        },
        Wea_Hammer = {
            --
            "ZKVTD_Takedown_HeavyAttack02",
        },
        Cyb_MantisBlades = {
            --
            "Cyb_MantisBlades_Back",
            "AerialTakedown_Back_MantisBlades",
            -- "ZKVTD_Takedown_BlockAttack",
        },
        Cyb_StrongArms = {
            --
            "finisher_default",
            "AerialTakedown_Back_Simple",
            "AerialTakedown_Simple",
        },
        Cyb_NanoWires = {
            --
            "ZKVTD_Monowire_behead_behind",
        },
    }
    defaultAnimsByWeapon["Wea_Katana"] = defaultAnimsByWeapon["Wea_LongBlade"]
    defaultAnimsByWeapon["Wea_Knife"] = defaultAnimsByWeapon["Wea_ShortBlade"]
    defaultAnimsByWeapon["Wea_Machete"] = defaultAnimsByWeapon["_Wea_MediumBlade"]
    defaultAnimsByWeapon["Wea_Chainsword"] = defaultAnimsByWeapon["_Wea_MediumBlade"]

    for _, weaponType in pairs(ZKVTD.constants.weaponTypes) do
        local statesTable = {}
        for _, animKey in ipairs(defaultAnimsByWeapon[weaponType]) do
            statesTable[animKey] = true
        end
        ZKVTD.Config.SetDefaultValue("Takedowns_Anims" .. ":" .. weaponType, statesTable)
    end

    ZKVTD.print("Default Configuration loaded!")
end
