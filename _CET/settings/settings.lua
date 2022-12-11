local ZKVTD = GetMod("ZKV_Takedowns")
-- ====================================================================================================================
-- ZKV_Takedowns for CP2077 by Kvalyr
-- ====================================================================================================================

local i18n = ZKVTD.i18n
local currentLangKey = i18n:GetCurrentLanguageKey()
local utils = ZKVTD.utils

local ZKVTD_Settings = {}
ZKVTD.Settings = ZKVTD_Settings
ZKVTD.Modules["Settings"] = ZKVTD_Settings

-- ====================================================================================================================
-- TODO: Logic to ensure Settings UI state, file state and ZKVTD.configTable state are all in-sync

local function ConfigToJson()
    return json.encode(ZKVTD.configTable)
end

function ZKVTD_Settings.Load()
    -- ZKVTD.debug("LoadSettings()")
    local file = io.open(ZKVTD.configFileName, "r")
    if file == nil then
        ZKVTD.printError("Failed to open '" .. ZKVTD.configFileName .. "'")

        -- Save config to config.json once then recurse to account for first-time load
        ZKVTD_Settings.Save()
        ZKVTD_Settings.Load()

        return
    end

    local rawContents = file:read("*a")
    local validJSON, decodedSettingsTable = ZKVTD.utils.pcall(
        function()
            return json.decode(rawContents)
        end
    )
    file:close()

    if not validJSON or decodedSettingsTable == nil then
        ZKVTD.printError(
            "Invalid JSON parsed from '" .. ZKVTD.configFileName .. "' validJSON: ", validJSON, "decodedSettingsTable:", decodedSettingsTable
        )
        return
    end

    for key, _ in pairs(ZKVTD.configTable) do
        if decodedSettingsTable[key] ~= nil then
            ZKVTD.Config.SetValue(key, decodedSettingsTable[key])
        end
    end

    -- Fire all the config callbacks - Especially before we init the settings UI so that it starts out in-sync with loaded config
    ZKVTD.Config.InitAllCallbacks()
end

function ZKVTD_Settings.Save()
    -- ZKVTD.debug("SaveSettings()")
    local validJSON, encodedJSONStr = pcall(ConfigToJson)

    if validJSON and encodedJSONStr ~= nil then
        local file = io.open(ZKVTD.configFileName, "w+")
        file:write(encodedJSONStr)
        file:close()
    end
end

function ZKVTD:LoadSettings()
    return ZKVTD_Settings.Load()
end
function ZKVTD:SaveSettings()
    return ZKVTD_Settings.Save()
end

-- ====================================================================================================================

function ZKVTD_Settings.UnpackWidgetParams( widgetType, paramsTable, configKey, initOverride )
    widgetType = string.lower(widgetType)
    local widgetInitValue = initOverride
    if initOverride == nil then
        widgetInitValue = ZKVTD.Config.GetValue(configKey)
    end
    local widgetDefaultValue = paramsTable["default"]
    if widgetType == "switch" then
        return widgetInitValue, widgetDefaultValue
    elseif widgetType == "sliderint" then
        local sliderMin = paramsTable["sliderMin"]
        local sliderMax = paramsTable["sliderMax"]
        local sliderStep = paramsTable["sliderStep"]
        return sliderMin, sliderMax, sliderStep, widgetInitValue, widgetDefaultValue
    elseif widgetType == "sliderfloat" then
        local sliderMin = paramsTable["sliderMin"]
        local sliderMax = paramsTable["sliderMax"]
        local sliderStep = paramsTable["sliderStep"]
        local sliderFormat = paramsTable["sliderFormat"] or "%.2f"
        return sliderMin, sliderMax, sliderStep, sliderFormat, widgetInitValue, widgetDefaultValue
    end
end

-- ====================================================================================================================

function ZKVTD_Settings:AddCategory( subCategoryPath, subCategoryLabelKey )
    local subCategoryLabel = i18n:GetString(currentLangKey, subCategoryLabelKey)
    ZKVTD.SettingsUI.AddSubCategory(subCategoryPath, subCategoryLabel, "ZKVTD - Finisher & Takedown Overhaul")
end

function ZKVTD_Settings:AddSetting( settingCategory, widgeti18nStringKey, configKey, widgetType, widgetParamsTable, callbackKey, initOverride )
    -- TODO: Add setting to config here or elsewhere?
    -- TODO: Set up callback here or elsewhere?
    local callbackFunc = ZKVTD.Config.GetCallback(callbackKey)

    if widgetType == "switch" then
        local widgetInitValue, widgetDefaultValue = ZKVTD_Settings.UnpackWidgetParams(widgetType, widgetParamsTable, configKey, initOverride)
        ZKVTD.SettingsUI.AddWidgetToSubCategory_Switch(settingCategory, widgeti18nStringKey, widgetInitValue, widgetDefaultValue, callbackFunc)
    elseif widgetType == "sliderint" then
        local sliderMin, sliderMax, sliderStep, widgetInitValue, widgetDefaultValue = ZKVTD_Settings.UnpackWidgetParams(
            widgetType, widgetParamsTable, configKey, initOverride
        )
        ZKVTD.SettingsUI.AddWidgetToSubCategory_SliderInt(
            settingCategory, widgeti18nStringKey, sliderMin, sliderMax, sliderStep, widgetInitValue, widgetDefaultValue, callbackFunc
        )
    elseif widgetType == "sliderfloat" then
        local sliderMin, sliderMax, sliderStep, sliderFormat, widgetInitValue, widgetDefaultValue = ZKVTD_Settings.UnpackWidgetParams(
            widgetType, widgetParamsTable, configKey, initOverride
        )
        ZKVTD.SettingsUI.AddWidgetToSubCategory_SliderFloat(
            settingCategory, widgeti18nStringKey, sliderMin, sliderMax, sliderStep, sliderFormat, widgetInitValue, widgetDefaultValue, callbackFunc
        )
    end
end

-- ====================================================================================================================

-- GetMod("ZKV_Takedowns").Settings:Debug()
function ZKVTD_Settings:Init()
    self.Load()

    local modPathPrefix = "zkvtd_"

    local subcategories = { "takedowns", "mtb_animswap", "misc_tweaks", "takedowns_byweapon" }

    for _, key in pairs(subcategories) do
        ZKVTD.SettingsUI.AddSubCategory(modPathPrefix .. key, "zkvtd_settings.category." .. key, ZKVTD.displayName)
    end

    self:AddSetting(
        modPathPrefix .. "takedowns", "zkvtd_settings.Takedowns.OnlyMelee", "Takedowns_OnlyWithMeleeWeaponHeld", "switch", { default = true },
            "Update_Takedowns_OnlyMelee"
    )
    self:AddSetting(
        modPathPrefix .. "takedowns", "zkvtd_settings.Takedowns.NonLethalBlunt", "Takedowns_NonLethalBlunt", "switch", { default = true },
            "Update_Takedowns_NonLethalBlunt"
    )

    self:AddSetting(
        modPathPrefix .. "mtb_animswap", "zkvtd_settings.MTBAnimSwap.UseAerial", "MantisSwap_Finishers_UseAerialTakedownAnimation", "switch",
            { default = true }, "Update_MTBAnimSwap_UseAerial"
    )
    self:AddSetting(
        modPathPrefix .. "mtb_animswap", "zkvtd_settings.MTBAnimSwap.RandomChoice", "MantisSwap_Finishers_MixDifferentAnimations", "switch",
            { default = true }, "Update_MTBAnimSwap_RandomChoice"
    )

    self:AddSetting(
        modPathPrefix .. "misc_tweaks", "zkvtd_settings.Misc_Stealth.MeleeMult", "Misc_Stealth_MeleeMult", "sliderfloat",
            { default = 1.30, sliderMin = 1.0, sliderMax = 10, sliderStep = 0.05, sliderFormat = "%.2f" }, "Update_Misc_Stealth_MeleeMult"
    )

    local MeleeTakedowns = ZKVTD:GetModule("MeleeTakedowns")

    for _, weaponType in pairs(ZKVTD.constants.weaponTypes) do
        local subCatKey = modPathPrefix .. "takedowns_byweapon_" .. weaponType
        ZKVTD.SettingsUI.AddSubCategory(subCatKey, weaponType, "ZKVTD - " .. i18n:GetString("Animations"))
        local anims = MeleeTakedowns.constants.allowedAnimsByWeapon[weaponType]
        for _, animKey in pairs(anims) do
            local callbackKey = MeleeTakedowns:GetCallbackKeyByWeaponAnim(weaponType, animKey, false)
            local initOverride = MeleeTakedowns:GetAnimStateForWeapon(weaponType, animKey)

            self:AddSetting(subCatKey, animKey, nil, "switch", { default = false }, callbackKey, initOverride)
        end
    end

end

-- ====================================================================================================================
