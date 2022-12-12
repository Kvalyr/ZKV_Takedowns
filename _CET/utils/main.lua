local ZKVMOD = ...
-- ====================================================================================================================
-- ZKV Mod Utils for CP2077 by Kvalyr
-- ====================================================================================================================

local function ValidateZKVMOD( mod )
    local function err( additionalMsg )
        print("ERROR: Invalid ZKVMOD", "(Reason: " .. (additionalMsg or "") .. ")")
    end
    if not mod then
        err("Nil mod")
        return false
    end

    if not mod.modString then
        err("nil mod.modString")
        return false
    end

    if not mod.configFileName then
        err("nil mod.configFileName")
        return false
    end

    return true
end

-- ====================================================================================================================
local utils = {}
if ValidateZKVMOD(ZKVMOD) then
    ZKVMOD.utils = utils
end

-- ====================================================================================================================
-- Core

function utils.LoadFileWithParams( filePath, ... )
    -- print("utils.LoadFileWithParams()", filePath, ... )

    if not utils.doesFileExist( filePath ) then
        print("ZKVUtils ERROR: File does not exist:", filePath)
        return
    end

    return assert(loadfile(filePath))(...)
end

utils.ValidateZKVMOD = ValidateZKVMOD

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
utils.dofile = utils.doFile

-- ====================================================================================================================
local function loadOtherModules()
    -- Other util modules
    local utilsModulesLoaded = {
        -- TODO: Handle dir structure more robustly. This assaumes utils in mod_dir/utils/...
        output = utils.LoadFileWithParams("utils/output.lua", utils, ZKVMOD),
        strings = utils.LoadFileWithParams("utils/strings.lua", utils, ZKVMOD),
        tables = utils.LoadFileWithParams("utils/tables.lua", utils, ZKVMOD),
        tweakdb = utils.LoadFileWithParams("utils/tweakdb.lua", utils, ZKVMOD),
        i18n = utils.LoadFileWithParams("utils/i18n.lua", utils, ZKVMOD),
        config = utils.LoadFileWithParams("utils/config.lua", utils, ZKVMOD),
        settings = utils.LoadFileWithParams("utils/settings.lua", utils, ZKVMOD),
        nativesettings = utils.LoadFileWithParams("utils/nativesettings.lua", utils, ZKVMOD),
    }

    --  DEBUG
    for k, v in pairs(utilsModulesLoaded) do
        utils.debug("ZKVUtils Loaded Modules: ", k, v)
    end
end

utils.pcall(loadOtherModules)

-- ====================================================================================================================
-- Modules

function utils.InitModule( mod, moduleKey )
    if not mod then mod = ZKVMOD end
    if not mod.Modules then mod.Modules = {} end
    local module = utils.GetModule(mod, moduleKey)
    if not module then
        utils.printError("Invalid module:", moduleKey, mod.modString, module)
        utils.DumpModules(mod)
        return
    end
    local initFunc = module.init or module.Init
    local status_ok, retVal = utils.pcall(initFunc, module)
    if not status_ok then
        utils.printError("Problem initializing module:", moduleKey, retVal)
    end
end
function utils.AddModule( mod, moduleKey, moduleTable )
    if not mod then mod = ZKVMOD end
    if not mod.Modules then mod.Modules = {} end
    mod.Modules[moduleKey] = moduleTable
end
function utils.GetModule( mod, moduleKey )
    if not mod then mod = ZKVMOD end
    if not mod.Modules then mod.Modules = {} end
    return mod.Modules[moduleKey]
end
function utils.DumpModules(mod)
    if not mod then mod = ZKVMOD end
    for k, v in pairs(mod.Modules) do
        utils.debug("Module:", k, v)
    end
end

-- ====================================================================================================================
-- Misc

function utils.ImportUtilMethods( mod )
    if not mod then
        mod = ZKVMOD
    end
    local function pcallSimple(func, ...)
        local _, retVal = utils.pcall(func, ...)
        return retVal
    end
    mod.print = function(...) return pcallSimple(utils.print, ...) end
    mod.printError = function(...) return pcallSimple(utils.printError, ...) end
    mod.debug = function(...) return pcallSimple(utils.debug, ...) end
    mod.pcall = function(...) return pcallSimple(utils.pcall, ...) end
    mod.assert = function(...) return pcallSimple(utils.assert, ...) end
    mod.doFile = function(...) return pcallSimple(utils.doFile, ...) end

    if not mod.Modules then mod.Modules = {} end
    mod.InitModule = function(...) return pcallSimple(utils.InitModule, ...) end
    mod.AddModule = function(...) return pcallSimple(utils.AddModule, ...) end
    mod.GetModule = function(...) return pcallSimple(utils.GetModule, ...) end
end

function utils.IsNumFloat(number)
    return not(number % 1 == 0)
end

-- ====================================================================================================================

return utils
