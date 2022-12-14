-- ====================================================================================================================
-- ZKV_Takedowns for CP2077 by Kvalyr
-- ====================================================================================================================
local version = "0.4.3"
local modString = "ZKVTD v" .. version
local ZKVTD = {
    name = "ZKVTD",
    version = version,
    modString = modString,
    description = modString .. " - Takedowns & Finishers Overhaul for CP2077 - Version: " .. version,
    descSimple = "Takedowns & Finishers Overhaul",
    nativeSettingsBasePath = "/ZKV",
    nativeSettingsTabLabel = "ZKVTD",
    -- nativeSettingsTabi18nKey = "zkvtd_settings.tab",
    configFileName = "config.json",
    displayName = "ZKVTD - Finisher & Takedown Overhaul",
    profiles = {
        User = "config.json",
    },
    archive_files = {
        "ZKV_Takedowns.archive",
    },
}
ZKVTD.debugMode = false
ZKVTD.version = version
ZKVTD.modString = modString

local utils = assert(loadfile("utils/main.lua"))(ZKVTD)
utils.ClearLog() -- Clear the log file for a new startup

-- ====================================================================================================================

local function SetupLocalization()
    ZKVTD.debug("SetupLocalization")

    ZKVTD:InitModule("i18n_strings")
end

local function SetupConfig()
    ZKVTD.debug("SetupConfig")

    ZKVTD:InitModule("ConfigDefaults")
end

local function SetupSettings()
    ZKVTD.debug("SetupSettings")

    ZKVTD:InitModule("Settings")
end

local function SetupMeleeTakedowns()
    ZKVTD.debug("SetupMeleeTakedowns")

    ZKVTD:InitModule("MeleeTakedowns_Constants")
    ZKVTD:InitModule("MeleeTakedowns")
end

local function onInit()
    if not utils.Init() then
        print("ZKVTD: Failed to initialize mod - Please check for error messages above.")
        return
    end
    ZKVTD.debug("onInit")
    utils.doFile("debug/debug.lua")

    utils.doFile("constants.lua")
    utils.doFile("i18n/i18n_strings.lua")
    utils.doFile("settings/config_defaults.lua")
    utils.doFile("settings/settings.lua")

    ZKVTD.doFile("melee_takedowns/melee_takedowns.lua")
    ZKVTD.doFile("melee_takedowns/constants.lua")


    utils.pcall(SetupConfig)
    utils.pcall(SetupLocalization)
    utils.pcall(SetupMeleeTakedowns)
    -- utils.doFile("experimental/speedups.lua")
    -- utils.doFile("experimental/control_unlocks.lua")
    utils.pcall(SetupSettings)
end

function ZKVTD:New()
    registerForEvent("onInit", function() utils.ModInit(onInit) end)

    return ZKVTD
end

return ZKVTD:New()
