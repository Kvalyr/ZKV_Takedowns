local utils, ZKVMOD = ...
-- ====================================================================================================================
-- ZKV Mod Utils for CP2077 by Kvalyr
-- ====================================================================================================================
if not utils.ValidateZKVMOD(ZKVMOD) then
    -- Special case for output funcs
    -- return
    ZKVMOD = {}
    ZKVMOD.modString = "ZKVUtils"
end

function utils.print( ... )
    print(ZKVMOD.modString, ": ", ...)
end

function utils.printWarning( ... )
    print("-- ", ZKVMOD.modString, ":WARN:", ...)
end

function utils.printError( ... )
    print("-- ", ZKVMOD.modString, ":ERROR:", ...)
end

function utils.debug( ... )
    if not ZKVMOD.debugMode then
        return
    end
    print("-- ", ZKVMOD.modString, ":DEBUG:", ...)
end

return true
