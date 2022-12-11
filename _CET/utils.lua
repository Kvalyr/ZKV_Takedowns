local ZKVMOD = ...
-- ====================================================================================================================
-- ZKV Mod Utils for CP2077 by Kvalyr
-- ====================================================================================================================
-- Localize some frequently-called globals
local strlen = string.len
local strlower = string.lower
local strupper = string.upper
-- ====================================================================================================================
local utils = {}
ZKVMOD.utils = utils

-- ====================================================================================================================
-- Modules

ZKVMOD.Modules = {}
function utils.InitModule( mod, moduleKey )
    local module = mod.Modules[moduleKey]
    if not module then
        utils.printError("Invalid module:", moduleKey)
    end
    local initFunc = module.init or module.Init
    local status_ok, retVal = utils.pcall(initFunc, module)
    if not status_ok then
        utils.printError("Problem initializing module:", moduleKey, retVal)
    end
end
function utils.AddModule( mod, moduleKey, moduleTable )
    mod.Modules[moduleKey] = moduleTable
end
function utils.GetModule( mod, moduleKey )
    return mod.Modules[moduleKey]
end

-- ====================================================================================================================
-- Output
utils.print = function( ... )
    print(ZKVMOD.modString, ": ", ...)
end
utils.printWarning = function( ... )
    print(ZKVMOD.modString, ":WARN:", ...)
end
utils.printError = function( ... )
    print(ZKVMOD.modString, ":ERROR:", ...)
end
utils.debug = function( ... )
    if not ZKVMOD.debugMode then
        return
    end
    print(ZKVMOD.modString, ":DEBUG:", ...)
end

function utils.ImportUtilMethods( mod )
    if not mod then
        mod = ZKVMOD
    end
    mod.print = utils.print
    mod.printError = utils.printError
    mod.debug = utils.debug
    mod.pcall = utils.pcall
    mod.assert = utils.assert
    mod.doFile = utils.doFile

    mod.InitModule = utils.InitModule
    mod.AddModule = utils.AddModule
    mod.GetModule = utils.GetModule
end

-- TODO: Namespace the utils better?

-- ====================================================================================================================
-- Misc

function utils.GetNativeSettingsMod()
    local nativeSettings = GetMod("nativeSettings")
    if not nativeSettings then
        utils.print("Warning: Native Settings UI is not installed. Please install this dependency if you want to configure " .. ZKVMOD.descSimple)
        return
    end

    if not nativeSettings.pathExists(ZKVMOD.nativeSettingsBasePath) then
        nativeSettings.addTab(ZKVMOD.nativeSettingsBasePath, "Kvalyr Mods")
    end

    return nativeSettings
end

function utils.pcall( func, ... )
    local status_ok, retVal = pcall(func, ...)
    if not status_ok then
        utils.printError("Problem executing func: ", "'" .. tostring(retVal) .. "'")
    end
    return status_ok, retVal
end

function utils.assert( testVal, msg )
    if not testVal then
        utils.print("[Fatal error]: '" .. tostring(msg) .. "'")
        assert(testVal, msg)
    end
end

function utils.doesFileExist( filePath )
    local f = io.open(filePath, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

function utils.doFile( filePath, silent )
    if not utils.doesFileExist(filePath) then
        if not silent then
            utils.printWarning("filePath invalid for utils.doFile:", filePath)
        end
        return
    end
    if not silent then
        utils.debug("doFile: Executing Lua file: " .. filePath)
    end
    local status_ok, retVal = pcall(dofile, filePath)
    if not silent then
        if status_ok then
            utils.debug("doFile: Finished executing file: " .. filePath)
        else
            utils.printError("doFile: Problem executing file: " .. filePath)
            utils.printError("doFile: '" .. tostring(retVal) .. "'")
        end
    end
    utils.assert(status_ok, tostring(retVal))
end

-- ====================================================================================================================
-- Strings

function utils.IsStrValid( inputStr, allowEmpty )
    if not allowEmpty and inputStr == "" then
        return false
    end
    return inputStr ~= nil
end

function utils.strsplit( inputStr, sep )
    if sep == nil then
        sep = "%s"
    end
    local tab = {}
    for str in string.gmatch(inputStr, "([^" .. sep .. "]+)") do
        table.insert(tab, str)
    end
    return tab
end

function utils.firstToUpper( inputStr )
    return (inputStr:gsub("^%l", strupper))
end

function utils.firstOnlyToUpper( inputStr )
    return utils.firstToUpper(strlower(inputStr))
end

local function tchelper( first, rest )
    return first:upper() .. rest:lower()
end
function utils.strTitleCase( inputStr )
    -- http://lua-users.org/wiki/StringRecipes
    return inputStr:gsub("(%a)([%w_']*)", tchelper)
end

function utils.Str_AddLeadingZeroes( number, intendedLength )
    local str = tostring(number)
    local diff = intendedLength - strlen(str)
    if diff > 0 then
        for i = 1, diff do
            str = "0" .. str
        end
    end
    return str
end

function utils.Str_starts_with( str, start )
    return str:sub(1, #start) == start
end

function utils.Str_ends_with( str, ending )
    return ending == "" or str:sub(-#ending) == ending
end

-- ====================================================================================================================
-- Tables
function utils.Table_Size( tab )
    -- if tab == nil then return nil end
    -- if type(tab) ~= "table" then return nil end
    if next(tab) == nil then
        return 0
    end
    local numItems = 0
    for _, _ in pairs(tab) do
        numItems = numItems + 1
    end
    return numItems or 0
end

function utils.Table_createInverseArray( tab, asStrings )
    -- Create a mapping table for getting the index of a value
    local mapping = {}
    for idx, value in ipairs(tab) do
        if asStrings then
            mapping[value] = tostring(idx)
        else
            mapping[value] = idx
        end
    end
    return mapping
end

function utils.Table_createInverseArray_Strings( tab, asStrings )
    return utils.Table_createInverseArray(tab, true)
end

-- ====================================================================================================================
-- TweakDB
local flatArrayMax = 1000 -- Arbitrary max to catch inf. loops and runaways

function utils.TweakDB_CreateArrayOfFlats( tab, flatKey, doIPairs )
    local count = utils.Table_Size(tab)
    if not count or count < 1 then
        utils.printWarning("utils.TweakDB_CreateArrayOfFlats -- invalid count or empty table:", count, "flatKey:", flatKey)
    end
    if count > flatArrayMax then
        utils.printError("utils.TweakDB_CreateArrayOfFlats() - Excessive table size for insertion to TweakDB:", flatKey, count)
        return
    end
    local setCountSuccess = TweakDB:SetFlat(flatKey .. ".count", tostring(count))
    if not setCountSuccess then
        utils.printError("utils.TweakDB_CreateArrayOfFlats() - Aborting: Failed to set count (" .. (count or "nil") .. ") flat for flatKey:", flatKey)
        return
    end

    local successCount = 0
    if doIPairs then
        for idx, val in ipairs(tab) do
            local newFlatKey = flatKey .. ":" .. idx
            if TweakDB:SetFlat(newFlatKey, val) then
                successCount = successCount + 1
            else
                utils.printError("utils.TweakDB_CreateArrayOfFlats().ipairs - Failed to set flat:", newFlatKey, val)
            end
        end
    else
        -- local idx = 1
        for key, val in pairs(tab) do
            local newFlatKey = flatKey .. ":" .. key
            if TweakDB:SetFlat(newFlatKey, val) then
                successCount = successCount + 1
            else
                utils.printError("utils.TweakDB_CreateArrayOfFlats().pairs - Failed to set flat:", newFlatKey, val)
            end
            -- idx = idx + 1
        end
    end
    if successCount ~= count then
        utils.printError("utils.TweakDB_CreateArrayOfFlats() - Count mismatch against successes:", flatKey, count, successCount)
        return false
    end
    return true
end

function utils.TweakDB_CreateArrayOfFlatsAndIndices( tab, flatKey, doIPairs, zeroPad )
    utils.TweakDB_CreateArrayOfFlats(tab, flatKey, doIPairs)

    -- Create the inverse table map and put that in TDB too
    local indicesTab = utils.Table_createInverseArray_Strings(tab)
    utils.TweakDB_CreateArrayOfFlats(indicesTab, flatKey .. "_idx", false)
end

function utils.TweakDB_GetArrayFromFlats( flatKey )
    local count = TweakDB:GetFlat(flatKey .. ".count")
    if not count or count < 0 or count > flatArrayMax then
        utils.printError("utils.TweakDB_GetArrayFromFlats() - Invalid array size for retrieval from TweakDB:", flatKey, count)
        return
    end
    local arrayTab = {}
    local idx = 0
    while idx < count do
        arrayTab[idx] = TweakDB:GetFlat(flatKey .. idx)
        idx = idx + 1
    end
    local newTableSize = utils.Table_Size(arrayTab)
    if newTableSize ~= count then
        utils.print("Warning: utils.TweakDB_GetArrayFromFlats() - Count mismatch against table size:", flatKey, count, newTableSize)

    end
    return arrayTab
    -- Get count flat
    -- Get each flat from 0 to count
    -- store flats in table, check len, return
end

function utils.TweakDB_GetFlatWithBackup( flatKey )
    -- Get value at flatKey and save to another free flat so that we can reference CDPR values when reloading mod
    local backupKey = flatKey .. "_zkvbackup"
    local baseValue = TweakDB:GetFlat(backupKey)
    if not baseValue then
        -- No previous backup; Create a new one
        baseValue = TweakDB:GetFlat(flatKey)
        if not baseValue then
            utils.printError("Failed to get baseValue for:", flatKey)
            return
        end
        local backupSuccess = TweakDB:SetFlat(backupKey, baseValue)
        if not backupSuccess then
            utils.printError("Failed to save flat backup at:", backupKey)
            return
        end
    end
    return baseValue
end

function utils.TweakDB_MultiplyValueWithBackup( flatKey, mult )
    local baseValue = utils.TweakDB_GetFlatWithBackup(flatKey)
    local newValue = baseValue * mult
    TweakDB:SetFlat(flatKey, newValue)
    utils.debug("TweakDB_MultiplyValueWithBackup: ", flatKey, baseValue, newValue)
end

function utils.TweakDB_AddValueWithBackup( flatKey, value )
    local baseValue = utils.TweakDB_GetFlatWithBackup(flatKey)
    local newValue = baseValue + value
    TweakDB:SetFlat(flatKey, newValue)
    utils.debug("TweakDB_AddValueWithBackup: ", flatKey, baseValue, newValue)
end

-- ====================================================================================================================

return utils
