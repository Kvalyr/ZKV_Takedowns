-- ====================================================================================================================
-- ZKV_Takedowns for CP2077 by Kvalyr
-- ====================================================================================================================
local ZKVTD = GetMod("ZKV_Takedowns")
local utils = ZKVTD.utils
local zkvtd_constants = ZKVTD.constants
local constants = {}
ZKVTD:AddModule("MeleeTakedowns_Constants", constants)

function constants:Init()
    local MeleeTakedowns = ZKVTD:GetModule("MeleeTakedowns")
    MeleeTakedowns.constants = constants

    constants.configKey = "Takedowns_Anims"
    constants.callbackKey = "Callback_" .. constants.configKey

    constants.tweakDBKey_base = "ZKVTD.MeleeTakedowns"
    constants.tweakDBKey_constants = constants.tweakDBKey_base .. ".constants"
    constants.tweakDBKey_constants_Anims = constants.tweakDBKey_constants .. ".Anims"
    constants.tweakDBKey_constants_SharedAnims = constants.tweakDBKey_constants .. ".SharedAnims"
    constants.tweakDBKey_constants_WeaponTypes = constants.tweakDBKey_constants .. ".WeaponTypes"

    constants.tweakDBKey_AnimStates = constants.tweakDBKey_base .. ":AnimStates"
    constants.tweakDBKey_AnimsAvailable = constants.tweakDBKey_base .. ":AnimsAvailable"

    -- ====================================================================================================================

    local weaponTypes = zkvtd_constants.weaponTypes
    local weaponTypesIndices = zkvtd_constants.weaponTypesIndices
    constants.weaponTypes = weaponTypes
    constants.weaponTypesIndices = weaponTypesIndices

    utils.TweakDB.CreateArrayOfFlatsAndIndices(weaponTypes, constants.tweakDBKey_constants_WeaponTypes, true)

    -- ====================================================================================================================

    function MeleeTakedowns:ValidateWeaponType( weaponType )
        if not constants.weaponTypesIndices[weaponType] then
            utils.printError("Invalid weaponType:", weaponType)
            return false
        end
        return true
    end

    function MeleeTakedowns:ValidateAnimKey( animKey )
        if not constants.takedownAnimsIndices[animKey] then
            utils.printError("Invalid animKey:", animKey)
            return false
        end
        return true
    end

    -- ====================================================================================================================

    local takedownAnims = {
        -- ==== ====
        -- CDPR effects/workspots

        -- Default takedown
        "finisher_default", -- Throat-punch with haymaker follow-up

        -- Unarmed Aerial
        "AerialTakedown_Simple", -- Occipital smash
        "AerialTakedown_Back_Simple", -- Face-to-ground smash

        -- Long Blades
        "Wea_Katana", -- Impale from front
        "Wea_Katana_Back", -- Kneel and behead. Target turns to face V

        -- Mantis Blades
        "Cyb_MantisBlades", -- Double-impale and lift
        "Cyb_MantisBlades_Back", -- Double-impale and lift (target turns to face V)
        "AerialTakedown_MantisBlades", -- Ground-slam with neck/head impale
        "AerialTakedown_Back_MantisBlades", -- Ground-slam with neck/head impale

        -- Gorilla Arms
        "Cyb_StrongArms_Back", -- No difference from finisher_default in CDPR effectSet

        -- ==== ====
        -- ZKVTD custom effects/workspots

        -- Katana
        "ZKVTD_Katana_backstab", -- Same as Wea_Katana but target remains facing away from V
        "ZKVTD_Katana_behead_behind", -- Same as Wea_Katana_Back but target remains facing away from V

        -- Monowire
        "ZKVTD_Monowire_behead_behind", -- Monowire behead-from-behind takedown. Target kneels and head flies off.

        "ZKVTD_Knife_backstab", -- Same as ZKVTD_Katana_backstab, but with offsets adjusted for a shorter blade

        -- Repurposed attack animations
        -- _QuickDeath == Target dies and ragdolls quickly, instead of using katana front-stab death sequence
        "ZKVTD_Takedown_HeavyAttack01", -- Strong attack from neutral
        "ZKVTD_Takedown_HeavyAttack01_NonLethal",
        "ZKVTD_Takedown_HeavyAttack02", -- Strong attack 2nd hit in combo
        "ZKVTD_Takedown_HeavyAttack02_NonLethal",
        "ZKVTD_Takedown_ComboAttack03", -- Light attack, third hit in combo
        "ZKVTD_Takedown_ComboAttack03_NonLethal",
        "ZKVTD_Takedown_SafeAttack", -- ??? Unsure when the base game uses this attack
        "ZKVTD_Takedown_SafeAttack_NonLethal", -- ??? Unsure when the base game uses this attack
        "ZKVTD_Takedown_BlockAttack", -- Strong attack from block (Defensive attack)
        "ZKVTD_Takedown_BlockAttack_NonLethal", -- Strong attack from block (Defensive attack)
    }
    local takedownAnimsIndices = utils.Table.CreateInverseArray_Strings(takedownAnims)
    constants.takedownAnims = takedownAnims
    constants.takedownAnimsIndices = takedownAnimsIndices

    utils.TweakDB.CreateArrayOfFlatsAndIndices(takedownAnims, constants.tweakDBKey_constants_Anims, true)

    -- ====================================================================================================================
    -- Allowed animations by weapon

    local allowedAnims_FISTS = {
        --
        "finisher_default",
        "AerialTakedown_Back_Simple",
        "AerialTakedown_Simple",
    }

    local allowedAnims_LONG_BLADE = {
        "Wea_Katana",
        "Wea_Katana_Back",

        "ZKVTD_Katana_backstab",
        "ZKVTD_Katana_behead_behind",

        "ZKVTD_Takedown_SafeAttack",
        "ZKVTD_Takedown_BlockAttack",
    }

    local allowedAnims_SHORT_BLADE = {
        --
        "ZKVTD_Knife_backstab",
        "ZKVTD_Takedown_SafeAttack",
        "ZKVTD_Takedown_BlockAttack",
    }

    local allowedAnims_MEDIUM_BLADE = {
        "Wea_Katana",
        "Wea_Katana_Back",

        "ZKVTD_Katana_backstab",
        "ZKVTD_Katana_behead_behind",

        "ZKVTD_Knife_backstab",

        "ZKVTD_Takedown_SafeAttack",
        "ZKVTD_Takedown_BlockAttack",
    }

    local allowedAnims_ONE_HANDED_CLUB = {

        --
        "ZKVTD_Takedown_ComboAttack03",
        "ZKVTD_Takedown_HeavyAttack02",
    }

    local allowedAnims_TWO_HANDED_CLUB = {
        --
        "ZKVTD_Takedown_ComboAttack03",
        "ZKVTD_Takedown_HeavyAttack02",
    }

    local allowedAnims_HAMMER = {
        --
        "ZKVTD_Takedown_ComboAttack03",
        "ZKVTD_Takedown_HeavyAttack02",
    }

    local allowedAnims_MANTIS_BLADES = {
        "Cyb_MantisBlades",
        "Cyb_MantisBlades_Back",
        "AerialTakedown_MantisBlades",
        "AerialTakedown_Back_MantisBlades",

        "ZKVTD_Takedown_BlockAttack",
    }

    local allowedAnims_MONOWIRE = {
        --
        "ZKVTD_Monowire_behead_behind",
    }

    local allowedAnimsByWeapon = {
        Wea_Fists = allowedAnims_FISTS,

        Wea_LongBlade = allowedAnims_LONG_BLADE,
        Wea_Katana = allowedAnims_LONG_BLADE,

        Wea_Machete = allowedAnims_MEDIUM_BLADE,
        Wea_Chainsword = allowedAnims_MEDIUM_BLADE,

        Wea_ShortBlade = allowedAnims_SHORT_BLADE,
        Wea_Knife = allowedAnims_SHORT_BLADE,

        Wea_OneHandedClub = allowedAnims_ONE_HANDED_CLUB,
        Wea_TwoHandedClub = allowedAnims_TWO_HANDED_CLUB,
        Wea_Hammer = allowedAnims_HAMMER,

        Cyb_MantisBlades = allowedAnims_MANTIS_BLADES,
        Cyb_StrongArms = allowedAnims_FISTS,
        Cyb_NanoWires = allowedAnims_MONOWIRE,
    }
    constants.allowedAnimsByWeapon = allowedAnimsByWeapon

    for idx, weaponType in ipairs(weaponTypes) do
        utils.TweakDB.CreateArrayOfFlats(allowedAnimsByWeapon[weaponType], constants.tweakDBKey_AnimsAvailable .. ":" .. weaponType, true)
    end
end
