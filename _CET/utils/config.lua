-- ====================================================================================================================
-- ZKV Mod Utils for CP2077 by Kvalyr
-- ====================================================================================================================
local utils, ZKVMOD = ...
if not utils.ValidateZKVMOD(ZKVMOD) then
    return
end

local Config = {}
utils.Config = Config
local configTable = {}
local configCallbacks = {}
Config.configTable = configTable
Config.configCallbacks = configCallbacks

ZKVMOD.Config = Config

-- ====================================================================================================================

function utils.Config.GetValue( key, default )
    -- TODO: Move to settings.lua
    local value = configTable[key]
    if value == nil then
        return default
    end
    return value
end

function utils.Config.SetValue( key, value, noSave )
    -- TODO: Move to settings.lua
    configTable[key] = value
    if not noSave then
        -- ZKVTD:SaveSettings() -- TODO: Do we really want to call this on each value update? Probably not..
        utils.Settings.Save() -- TODO: Do we really want to call this on each value update? Probably not..
    end
end

function utils.Config.SetDefaultValue( key, value )
    Config.SetValue(key, value, true)
end

-- local function dumpConfig()
--     -- TODO: Move to settings.lua
--     if not ZKVTD.debugMode then return end

--     for key, value in pairs(configTable) do
--         if type(value) == "table" then
--             ZKVTD.debug("Config: ", key, ": ", #value, "(table)")
--         else
--             ZKVTD.debug("Config: ", key, ": ", value)
--         end
--     end
-- end

function utils.Config.AddCallback( callbackKey, callbackFunc )
    local existing = configCallbacks[callbackKey]
    if existing then
        utils.printError("Config callback already exists at key:", callbackKey)
    else
        configCallbacks[callbackKey] = callbackFunc
        utils.debug("Added config callback at key:", callbackKey)
    end
end

function utils.Config.AddCallback_GenericSetFlat( flatKey, configKey, default, callbackKey, valueType )
    if default == nil then
        default = true
    end

    local function callbackFunc( newValue )
        if newValue == nil then
            newValue = utils.Config.GetValue(configKey, default)
        else
            utils.Config.SetValue(configKey, newValue)
        end
        local success

        if type(newValue) == "number" then
            -- utils.debug("AddCallback_GenericSetFlat - ambiguous type")
            if utils.IsNumFloat(newValue) then
                utils.debug("AddCallback_GenericSetFlat - ambiguous type - Float", valueType)
                success = TweakDB:SetFlat(flatKey, newValue, "Float")
            else
                utils.debug("AddCallback_GenericSetFlat - ambiguous type - Int32", valueType)
                success = TweakDB:SetFlat(flatKey, newValue, "Int32")
            end
        else
            success = TweakDB:SetFlat(flatKey, newValue)
        end

        -- if type(newValue) == "boolean" then
        --     success = TweakDB:SetFlat(flatKey, newValue)
        -- elseif type(newValue) == "string" then
        --     success = TweakDB:SetFlat(flatKey, newValue)
        -- else
        --     success = TweakDB:SetFlat(flatKey, newValue, valueType)
        -- end
        -- if valueType == "bool" then
        -- elseif valueType == "Int" then
        --     success = TweakDB:SetFlat(flatKey, newValue)
        -- end
        utils.debug("-Config Callback-", flatKey, "newValue:", newValue, "SetFlat success:", success)
        if not success then
            utils.printError("Failed to SetFlat:", "'" .. flatKey .. "'", newValue)
        end

        -- dumpConfig()
    end

    if not callbackKey or callbackKey == "" then
        callbackKey = "SetFlat_" .. flatKey
    end

    Config.AddCallback(callbackKey, callbackFunc)
end

function utils.Config.GetCallback( callbackKey )
    -- TODO: Move to settings.lua?
    local callbackFunc = configCallbacks[callbackKey]
    if not callbackFunc then
        utils.printWarning("Failed to retrieve config callback:", callbackKey)
        return function()
            utils.printWarning("Dummy no-op callback called for:", callbackKey)
        end
    end
    return callbackFunc
end

function utils.Config.CallCallback( callbackKey )
    -- TODO: Move to settings.lua?
    local func = utils.Config.GetCallback(callbackKey)
    local funcType = type(func)
    if funcType == "function" then
        return func()
    else
        utils.printError("Invalid type (" .. funcType .. ") for config callback:", callbackKey)
    end
end

-- ====================================================================================================================

function utils.Config.InitAllCallbacks()
    -- Note: No params passed
    for _, callbackFunc in pairs(configCallbacks) do
        callbackFunc()
    end
end
