local utils, ZKVMOD = ...
-- ====================================================================================================================
-- ZKV Mod Utils for CP2077 by Kvalyr
-- ====================================================================================================================
if not utils.ValidateZKVMOD(ZKVMOD) then
    return
end

local NativeSettings = {}
utils.NativeSettings = NativeSettings
NativeSettings.initialized = false
local i18n = utils.i18n

-- ====================================================================================================================

function utils.NativeSettings.Get()
    local nativeSettings = GetMod("nativeSettings")
    if not nativeSettings then
        utils.print("Warning: Native Settings UI is not installed. Please install this dependency if you want to configure " .. ZKVMOD.descSimple)
        return
    end

    if not nativeSettings.pathExists(ZKVMOD.nativeSettingsBasePath) then
        nativeSettings.addTab(ZKVMOD.nativeSettingsBasePath, i18n:GetString(ZKVMOD.nativeSettingsTabi18nKey))
    end

    return nativeSettings
end

-- ====================================================================================================================

function utils.NativeSettings:Init()
    local nativeSettings = utils.NativeSettings.Get()
    if not nativeSettings then
        ZKVMOD.print("Warning: Skipping setup of Native Settings UI due to missing dependency.")
        self.canDoSettingsUI = false
        return
    end
    self.canDoSettingsUI = true
    self.nativeSettings = nativeSettings
    i18n = utils.i18n
    self.initialized = true
end
local function isInitialized()
    return NativeSettings.initialized and NativeSettings.canDoSettingsUI
end

-- ====================================================================================================================

local function GetSubcategoryFullPath( subCategoryPath )
    return ZKVMOD.nativeSettingsBasePath .. "/" .. subCategoryPath
end

function utils.NativeSettings.AddSubCategory( subCategoryPath, subCategoryLabelKey, labelPrefix, optionalIndex )
    if not isInitialized() then
        return
    end
    local subCategoryLabel = i18n:GetString(subCategoryLabelKey, "<missing_label: " .. subCategoryLabelKey .. ">")--"<missing_category_label>")
    if labelPrefix and labelPrefix ~= "" then
        subCategoryLabel = labelPrefix .. " - " .. subCategoryLabel
    end

    local path = GetSubcategoryFullPath(subCategoryPath)
    -- ZKVTD.debug("Settings: Add subCategory:", path)
    NativeSettings.nativeSettings.addSubcategory(path, subCategoryLabel, optionalIndex)
end

local function GetLocalizedStrings( widgeti18StringKey )
    local widgetLabelKey = widgeti18StringKey .. ".label"
    local widgetTooltipKey = widgeti18StringKey .. ".tooltip"
    local widgetLabel = i18n:GetString(widgetLabelKey, "<missing_label: " .. widgetLabelKey .. ">")
    local widgetTooltip = i18n:GetString(widgetTooltipKey, "<missing_tooltip: " .. widgetTooltipKey .. ">")
    return widgetLabel, widgetTooltip
end

function utils.NativeSettings.AddWidgetToSubCategory_Switch(subCategory, widgeti18nStringKey, widgetInitValue, widgetDefaultValue, widgetUpdateCallback, optionalIndex )
    if not isInitialized() then
        return
    end
    local widgetLabel, widgetTooltip = GetLocalizedStrings(widgeti18nStringKey)
    local fullPath = GetSubcategoryFullPath(subCategory)
    return NativeSettings.nativeSettings.addSwitch(fullPath, widgetLabel, widgetTooltip, widgetInitValue, widgetDefaultValue, widgetUpdateCallback)
end

function utils.NativeSettings.AddWidgetToSubCategory_SliderInt(subCategory, widgeti18nStringKey, sliderMin, sliderMax, sliderStep, widgetInitValue, widgetDefaultValue, widgetUpdateCallback, optionalIndex )
    if not isInitialized() then
        return
    end
    local widgetLabel, widgetTooltip = GetLocalizedStrings(widgeti18nStringKey)
    local fullPath = GetSubcategoryFullPath(subCategory)
    return NativeSettings.nativeSettings.addRangeInt(
        fullPath, widgetLabel, widgetTooltip, sliderMin, sliderMax, sliderStep, widgetInitValue, widgetDefaultValue, widgetUpdateCallback
    )
end

function utils.NativeSettings.AddWidgetToSubCategory_SliderFloat(subCategory, widgeti18nStringKey, sliderMin, sliderMax, sliderStep, sliderFormat, widgetInitValue, widgetDefaultValue, widgetUpdateCallback, optionalIndex )
    if not isInitialized() then
        return
    end
    local widgetLabel, widgetTooltip = GetLocalizedStrings(widgeti18nStringKey)
    local fullPath = GetSubcategoryFullPath(subCategory)
    if not sliderFormat then
        sliderFormat = "%.2f"
    end
    return NativeSettings.nativeSettings.addRangeFloat(
        fullPath, widgetLabel, widgetTooltip, sliderMin, sliderMax, sliderStep, sliderFormat, widgetInitValue, widgetDefaultValue,
            widgetUpdateCallback
    )
end

-- ====================================================================================================================

return NativeSettings
