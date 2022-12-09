-- ====================================================================================================================
-- ZKV_Takedowns for CP2077 by Kvalyr
-- ====================================================================================================================
local version = "0.4.0"
local modString = "ZKV_Takedowns v" .. version
local ZKV_Takedowns = {
    version = version,
    modString = modString,
    description = modString .. " - Takedowns & Finishers Overhaul for CP2077 - Version: " .. version,
    descSimple = "Takedowns & Finishers Overhaul",
    nativeSettingsBasePath = "/ZKV",
    configFileName = "config.json",
    displayName = "ZKVTD - Finisher & Takedown Overhaul",
}
local ZKVTD = ZKV_Takedowns
ZKVTD.debugMode = true
ZKVTD.version = version
ZKVTD.modString = modString
local utils = assert(loadfile("utils.lua"))(ZKVTD)
utils.ImportUtilMethods()

-- ====================================================================================================================

local function SetupLocalization()
    ZKVTD.debug("SetupLocalization")

    ZKVTD:InitModule("i18n")
    ZKVTD:InitModule("i18n_strings")
end

local function SetupConfig()
    ZKVTD.debug("SetupConfig")

    ZKVTD:InitModule("ConfigDefaults")
end

local function SetupSettings()
    ZKVTD.debug("SetupSettings")

    ZKVTD:InitModule("SettingsUI")
    ZKVTD:InitModule("Settings")
end

local function SetupMeleeTakedowns()
    ZKVTD.debug("SetupMeleeTakedowns")

    -- ZKVTD.doFile("melee_takedowns/config_takedown_animations.lua")  -- Old setup

    ZKVTD:InitModule("MeleeTakedowns_Constants")
    ZKVTD:InitModule("MeleeTakedowns")
end

local function onInit()
    ZKVTD.debug("onInit")
    utils.doFile("constants.lua")

    utils.doFile("i18n/i18n.lua")
    utils.doFile("i18n/i18n_strings.lua")

    utils.doFile("settings/mem_config.lua")
    utils.doFile("settings/config_defaults.lua")
    utils.doFile("settings/settingsUI_api.lua")
    utils.doFile("settings/settings.lua")

    -- ZKVTD.doFile("melee_takedowns/config_takedown_animations.lua")  -- Old setup
    ZKVTD.doFile("melee_takedowns/melee_takedowns.lua")
    ZKVTD.doFile("melee_takedowns/constants.lua")

    utils.pcall(SetupConfig)
    utils.pcall(SetupLocalization)
    utils.pcall(SetupMeleeTakedowns)
    -- utils.doFile("experimental/speedups.lua")
    -- utils.doFile("experimental/control_unlocks.lua")
    utils.pcall(SetupSettings)

    utils.doFile("debug/debug.lua", true)

    ZKVTD.print("Finished Loading!")
end

function ZKVTD:New()
    registerForEvent("onInit", onInit)

    return ZKVTD
end

return ZKVTD:New()
