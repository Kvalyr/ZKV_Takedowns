local ZKVTD = GetMod("ZKV_Takedowns")
-- ====================================================================================================================
-- ZKV_Takedowns for CP2077 by Kvalyr
-- ====================================================================================================================
local utils = ZKVTD.utils
local i18n = utils.i18n

local ZKVTD_Settings = {}
ZKVTD.Settings = ZKVTD_Settings
ZKVTD.Modules["Settings"] = ZKVTD_Settings

-- ====================================================================================================================

function ZKVTD:LoadSettings()
    return utils.Settings.Load()
end

function ZKVTD:SaveSettings()
    return utils.Settings.Save()
end

-- GetMod("ZKV_Takedowns").Settings:Debug()
function ZKVTD_Settings:Init()
    utils.NativeSettings:Init()

    ZKVTD:LoadSettings()

    local modPathPrefix = "zkvtd_"

    local subcategories = { "takedowns", "mtb_animswap", "misc_tweaks", "takedowns_byweapon" }

    for _, key in pairs(subcategories) do
        utils.NativeSettings.AddSubCategory(modPathPrefix .. key, "zkvtd_settings.category." .. key, ZKVTD.displayName)
    end

    utils.Settings.AddSetting(
        modPathPrefix .. "takedowns", "zkvtd_settings.Takedowns.OnlyMelee", "Takedowns_OnlyWithMeleeWeaponHeld", "switch", { default = true },
            "Update_Takedowns_OnlyMelee"
    )
    utils.Settings.AddSetting(
        modPathPrefix .. "takedowns", "zkvtd_settings.Takedowns.NonLethalBlunt", "Takedowns_NonLethalBlunt", "switch", { default = true },
            "Update_Takedowns_NonLethalBlunt"
    )

    utils.Settings.AddSetting(
        modPathPrefix .. "mtb_animswap", "zkvtd_settings.MTBAnimSwap.UseAerial", "MantisSwap_Finishers_UseAerialTakedownAnimation", "switch",
            { default = true }, "Update_MTBAnimSwap_UseAerial"
    )

    utils.Settings.AddSetting(
        modPathPrefix .. "mtb_animswap", "zkvtd_settings.MTBAnimSwap.RandomChoice", "MantisSwap_Finishers_MixDifferentAnimations", "switch",
            { default = true }, "Update_MTBAnimSwap_RandomChoice"
    )

    utils.Settings.AddSetting(
        modPathPrefix .. "misc_tweaks", "zkvtd_settings.Misc_Stealth.MeleeMult", "Misc_Stealth_MeleeMult", "sliderfloat",
            { default = 1.30, sliderMin = 1.0, sliderMax = 10, sliderStep = 0.05, sliderFormat = "%.2f" }, "Update_Misc_Stealth_MeleeMult"
    )

    local MeleeTakedowns = ZKVTD:GetModule("MeleeTakedowns")

    for _, weaponType in pairs(ZKVTD.constants.weaponTypes) do
        local subCatKey = modPathPrefix .. "takedowns_byweapon_" .. weaponType
        utils.NativeSettings.AddSubCategory(subCatKey, weaponType, "ZKVTD - " .. i18n:GetString("Animations"))
        local anims = MeleeTakedowns.constants.allowedAnimsByWeapon[weaponType]
        for _, animKey in pairs(anims) do
            local callbackKey = MeleeTakedowns:GetCallbackKeyByWeaponAnim(weaponType, animKey, false)
            local initOverride = MeleeTakedowns:GetAnimStateForWeapon(weaponType, animKey)

            utils.Settings.AddSetting(subCatKey, animKey, nil, "switch", { default = false }, callbackKey, initOverride)
        end
    end

end

-- ====================================================================================================================
