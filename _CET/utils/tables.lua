local utils, ZKVMOD = ...
-- ====================================================================================================================
-- ZKV Mod Utils for CP2077 by Kvalyr
-- ====================================================================================================================
if not utils.ValidateZKVMOD(ZKVMOD) then
    return
end

local tinsert = table.insert

local tableFuncs = {}
utils.table = tableFuncs
utils.Table = tableFuncs

-- ====================================================================================================================
-- Tables
function utils.Table.Size( tab )
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
tableFuncs.size = tableFuncs.Size
tableFuncs.Len = tableFuncs.size
tableFuncs.len = tableFuncs.size

function utils.Table.CreateInverseArray( tab, asStrings )
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

function utils.Table.CreateInverseArray_Strings( tab )
    return tableFuncs.CreateInverseArray(tab, true)
end

return tableFuncs
