-- ====================================================================================================================
-- ZKV_Takedowns for CP2077 by Kvalyr
-- ====================================================================================================================
local ZKVTD = GetMod("ZKV_Takedowns")
local utils = ZKVTD.utils
local constants = {}
ZKVTD.constants = constants

local weaponTypes = {
    "Wea_Fists",

    -- "Wea_LongBlade",
    "Wea_Katana",
    "Wea_Machete",

    -- "Wea_ShortBlade",
    "Wea_Knife",
    "Wea_Chainsword",

    "Wea_OneHandedClub",
    "Wea_TwoHandedClub",
    "Wea_Hammer",
    "Cyb_MantisBlades",
    "Cyb_StrongArms",
    "Cyb_NanoWires",
    -- "Cyb_Launcher",
}
local weaponTypesIndices = utils.Table_createInverseArray_Strings(weaponTypes)
constants.weaponTypes = weaponTypes
constants.weaponTypesIndices = weaponTypesIndices
