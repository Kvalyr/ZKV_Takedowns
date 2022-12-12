local utils, ZKVMOD = ...
-- ====================================================================================================================
-- ZKV Mod Utils for CP2077 by Kvalyr
-- ====================================================================================================================
if not utils.ValidateZKVMOD(ZKVMOD) then
    return
end

local strlen = string.len
local strlower = string.lower
local strupper = string.upper

local strFuncs = {}
utils.str = strFuncs
utils.Str = strFuncs
utils.string = strFuncs
utils.String = strFuncs

-- ====================================================================================================================
-- Strings

function strFuncs.IsValid( inputStr, allowEmpty )
    if not allowEmpty and inputStr == "" then
        return false
    end
    return inputStr ~= nil
end


function utils.String.Split( inputStr, sep )
    if sep == nil then
        sep = "%s"
    end
    local tab = {}
    for str in string.gmatch(inputStr, "([^" .. sep .. "]+)") do
        table.insert(tab, str)
    end
    return tab
end


function utils.String.FirstToUpper( inputStr )
    return (inputStr:gsub("^%l", strupper))
end


function utils.String.FirstOnlyToUpper( inputStr )
    return strFuncs.firstToUpper(strlower(inputStr))
end


local function titleCaseHelper( first, rest )
    return first:upper() .. rest:lower()
end
function utils.String.TitleCase( inputStr )
    -- http://lua-users.org/wiki/StringRecipes
    return inputStr:gsub("(%a)([%w_']*)", titleCaseHelper)
end


function utils.String.AddLeadingZeroes( number, intendedLength )
    local str = tostring(number)
    local diff = intendedLength - strlen(str)
    if diff > 0 then
        for i = 1, diff do
            str = "0" .. str
        end
    end
    return str
end


function utils.String.starts_with( str, start )
    return str:sub(1, #start) == start
end
strFuncs.StartsWith = utils.String.starts_with


function utils.String.ends_with( str, ending )
    return ending == "" or str:sub(-#ending) == ending
end
strFuncs.EndsWith = utils.String.ends_with

return strFuncs
