local utils, ZKVMOD = ...
-- ====================================================================================================================
-- ZKV Mod Utils for CP2077 by Kvalyr
-- Settings - Interface between Config and Native Settings UI
-- ====================================================================================================================
if not utils.ValidateZKVMOD(ZKVMOD) then
    return
end
local json = json
-- ====================================================================================================================

local configFileName = ZKVMOD.configFileName

local Settings = {}
utils.Settings = Settings

-- ====================================================================================================================
-- TODO: Logic to ensure Settings UI state, file state and utils.Config.configTable state are all in-sync


local function initializeSettingsFirstTime()
    -- Save config to config.json once then recurse to account for first-time load
    -- This is janky, but it works and only needs to happen once or when the config structure changes significantly
    Settings.Save()
    Settings.Load(true)
end

function Settings.Load(initializedOnce)
    -- utils.debug("LoadSettings()")
    local file = io.open(configFileName, "r")
    if file == nil then
        if not initializedOnce then
            utils.printWarning("Failed to open '" .. configFileName .. "' - Initializing config.json as first-time load.")
            initializeSettingsFirstTime() -- Recurse
        else
            utils.printError("Failed to open '" .. configFileName .. "'  - Even after forced initialization?!")
        end
        return
    end

    local rawContents = file:read("*a")
    local validJSON, decodedSettingsTable = utils.pcall(
        function()
            return json.decode(rawContents)
        end
    )
    file:close()

    if not validJSON or decodedSettingsTable == nil then
        utils.printError(
            "Invalid JSON parsed from '" .. configFileName .. "' validJSON: ", validJSON, "decodedSettingsTable:", decodedSettingsTable
        )
        return
    end

    for key, _ in pairs(utils.Config.configTable) do
        if decodedSettingsTable[key] ~= nil then
            utils.Config.SetValue(key, decodedSettingsTable[key])
        end
    end

    -- Fire all the config callbacks - Especially before we init the settings UI so that it starts out in-sync with loaded config
    utils.Config.InitAllCallbacks()
end

local function ConfigToJson()
    return json.encode(utils.Config.configTable)
end

function Settings.Save()
    -- ZKVMOD.debug("SaveSettings()")
    local validJSON, encodedJSONStr = pcall(ConfigToJson)

    if validJSON and encodedJSONStr ~= nil then
        local file = io.open(configFileName, "w+")
        if not file then
            utils.printError("Failed to open file for writing settings:", configFileName)
            return
        end
        file:write(encodedJSONStr)
        file:close()
    end
end

-- ====================================================================================================================

-- function Settings.UnpackWidgetParams( widgetType, paramsTable, configKey, initOverride )
function Settings.UnpackWidgetParams( paramsTable, configKey, initOverride )
    -- widgetType = string.lower(widgetType)
    local widgetInitValue = initOverride
    if initOverride == nil then
        widgetInitValue = utils.Config.GetValue(configKey)
    end
    local widgetDefaultValue = paramsTable["default"]
    local sliderMin, sliderMax, sliderStep, sliderFormat
    -- if widgetType == "switch" then
    --     return widgetInitValue, widgetDefaultValue
    -- elseif widgetType == "sliderint" then
    --     sliderMin = paramsTable["sliderMin"]
    --     sliderMax = paramsTable["sliderMax"]
    --     sliderStep = paramsTable["sliderStep"]
    --     -- return sliderMin, sliderMax, sliderStep, widgetInitValue, widgetDefaultValue
    -- elseif widgetType == "sliderfloat" then
    -- end
    sliderMin = paramsTable["sliderMin"]
    sliderMax = paramsTable["sliderMax"]
    sliderStep = paramsTable["sliderStep"]
    sliderFormat = paramsTable["sliderFormat"] or "%.2f"
    return widgetInitValue, widgetDefaultValue, sliderMin, sliderMax, sliderStep, sliderFormat
end

-- ====================================================================================================================

-- function Settings:AddCategory( subCategoryPath, subCategoryLabelKey )
--     local subCategoryLabel = i18n:GetString(currentLangKey, subCategoryLabelKey)
--     utils.NativeSettings.AddSubCategory(subCategoryPath, subCategoryLabel, "ZKVMOD")
-- end

function Settings.AddSetting( settingCategory, widgeti18nStringKey, configKey, widgetType, widgetParamsTable, callbackKey, initOverride, generateCallback, flatKey )
    -- TODO: Add setting to config here or elsewhere?
    -- TODO: Set up callback here or elsewhere?

    if not callbackKey then
        callbackKey = "Callback_" .. configKey
    end

    local widgetInitValue, widgetDefaultValue, sliderMin, sliderMax, sliderStep, sliderFormat = Settings.UnpackWidgetParams(widgetParamsTable, configKey, initOverride)

    if generateCallback then
        local valueType = "bool"
        if widgetType == "sliderint" then
            valueType = "Int32"
        elseif widgetType == "sliderfloat" then
            valueType = "Float"
        end
        utils.Config.AddCallback_GenericSetFlat(flatKey, configKey, widgetDefaultValue, callbackKey, valueType)
    end

    local callbackFunc = utils.Config.GetCallback(callbackKey)

    if widgetType == "switch" then
        -- local widgetInitValue, widgetDefaultValue = Settings.UnpackWidgetParams(widgetType, widgetParamsTable, configKey, initOverride)
        utils.NativeSettings.AddWidgetToSubCategory_Switch(settingCategory, widgeti18nStringKey, widgetInitValue, widgetDefaultValue, callbackFunc)
    elseif widgetType == "sliderint" then
        -- local sliderMin, sliderMax, sliderStep, widgetInitValue, widgetDefaultValue = Settings.UnpackWidgetParams(
        --     widgetType, widgetParamsTable, configKey, initOverride
        -- )
        utils.NativeSettings.AddWidgetToSubCategory_SliderInt(
            settingCategory, widgeti18nStringKey, sliderMin, sliderMax, sliderStep, widgetInitValue, widgetDefaultValue, callbackFunc
        )
    elseif widgetType == "sliderfloat" then
        -- local sliderMin, sliderMax, sliderStep, sliderFormat, widgetInitValue, widgetDefaultValue = Settings.UnpackWidgetParams(
        --     widgetType, widgetParamsTable, configKey, initOverride
        -- )
        utils.NativeSettings.AddWidgetToSubCategory_SliderFloat(
            settingCategory, widgeti18nStringKey, sliderMin, sliderMax, sliderStep, sliderFormat, widgetInitValue, widgetDefaultValue, callbackFunc
        )
    end
end

function Settings.AddSettingWithGenericSetFlatCallback( settingCategory, widgeti18nStringKey, configKey, widgetType, widgetParamsTable, flatKey, initOverride )
    local callbackKey = "Callback_" .. configKey
    Settings.AddSetting(settingCategory, widgeti18nStringKey, configKey, widgetType, widgetParamsTable, callbackKey, initOverride, true, flatKey)
end

-- ====================================================================================================================

return Settings
