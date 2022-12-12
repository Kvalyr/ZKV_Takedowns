local utils, ZKVMOD = ...
-- ====================================================================================================================
-- ZKV Mod Utils for CP2077 by Kvalyr
-- ====================================================================================================================
if not utils.ValidateZKVMOD(ZKVMOD) then
    return
end
local tostring = tostring
local tinsert = table.insert
-- local TweakDB = TweakDB
-- ====================================================================================================================
local flatArrayMax = 1000 -- Arbitrary max to catch inf. loops and runaways

local tweakDBFuncs = {}
utils.tweakDB = tweakDBFuncs
utils.tweakdb = tweakDBFuncs
utils.TweakDB = tweakDBFuncs

function utils.TweakDB.CreateArrayOfFlats( tab, flatKey, doIPairs )
    local count = utils.Table.Size(tab)
    if not count or count < 1 then
        utils.printWarning("utils.TweakDB.CreateArrayOfFlats -- invalid count or empty table:", count, "flatKey:", flatKey)
    end
    if count > flatArrayMax then
        utils.printError("utils.TweakDB.CreateArrayOfFlats() - Excessive table size for insertion to TweakDB:", flatKey, count)
        return
    end
    local setCountSuccess = TweakDB:SetFlat(flatKey .. ".count", tostring(count))
    if not setCountSuccess then
        utils.printError("utils.TweakDB.CreateArrayOfFlats() - Aborting: Failed to set count (" .. (count or "nil") .. ") flat for flatKey:", flatKey)
        return
    end

    local successCount = 0
    if doIPairs then
        for idx, val in ipairs(tab) do
            local newFlatKey = flatKey .. ":" .. idx
            if TweakDB:SetFlat(newFlatKey, val) then
                successCount = successCount + 1
            else
                utils.printError("utils.TweakDB.CreateArrayOfFlats().ipairs - Failed to set flat:", newFlatKey, val)
            end
        end
    else
        -- local idx = 1
        for key, val in pairs(tab) do
            local newFlatKey = flatKey .. ":" .. key
            if TweakDB:SetFlat(newFlatKey, val) then
                successCount = successCount + 1
            else
                utils.printError("utils.TweakDB.CreateArrayOfFlats().pairs - Failed to set flat:", newFlatKey, val)
            end
            -- idx = idx + 1
        end
    end
    if successCount ~= count then
        utils.printError("utils.TweakDB.CreateArrayOfFlats() - Count mismatch against successes:", flatKey, count, successCount)
        return false
    end
    return true
end

function utils.TweakDB.CreateArrayOfFlatsAndIndices( tab, flatKey, doIPairs, zeroPad )
    tweakDBFuncs.CreateArrayOfFlats(tab, flatKey, doIPairs)

    -- Create the inverse table map and put that in TDB too
    local indicesTab = utils.Table.CreateInverseArray_Strings(tab)
    tweakDBFuncs.CreateArrayOfFlats(indicesTab, flatKey .. "_idx", false)
end

function utils.TweakDB.GetArrayFromFlats( flatKey )
    local count = TweakDB:GetFlat(flatKey .. ".count")
    if not count or count < 0 or count > flatArrayMax then
        utils.printError("utils.TweakDB.GetArrayFromFlats() - Invalid array size for retrieval from TweakDB:", flatKey, count)
        return
    end
    local arrayTab = {}
    local idx = 0
    while idx < count do
        arrayTab[idx] = TweakDB:GetFlat(flatKey .. idx)
        idx = idx + 1
    end
    local newTableSize = utils.Table.Size(arrayTab)
    if newTableSize ~= count then
        utils.print("Warning: utils.TweakDB.GetArrayFromFlats() - Count mismatch against table size:", flatKey, count, newTableSize)

    end
    return arrayTab
    -- Get count flat
    -- Get each flat from 0 to count
    -- store flats in table, check len, return
end

function utils.TweakDB.GetFlatWithBackup( flatKey )
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

function utils.TweakDB.MultiplyValueWithBackup( flatKey, mult )
    local baseValue = tweakDBFuncs.GetFlatWithBackup(flatKey)
    local newValue = baseValue * mult
    TweakDB:SetFlat(flatKey, newValue)
    utils.debug("utils.TweakDB.MultiplyValueWithBackup: ", flatKey, baseValue, newValue)
end

function utils.TweakDB.AddValueWithBackup( flatKey, value )
    local baseValue = tweakDBFuncs.GetFlatWithBackup(flatKey)
    local newValue = baseValue + value
    TweakDB:SetFlat(flatKey, newValue)
    utils.debug("utils.TweakDB.AddValueWithBackup: ", flatKey, baseValue, newValue)
end

function utils.TweakDB.CreateConstantStatModifier( recordName, modifierType, statType, value )
    -- modifierType:   Additive, AdditiveMultiplier, Multiplier, Count, Invalid
    -- statType:    BaseStats.Health, BaseStats.DPS, BaseStats.Quantity, etc.
    TweakDB:CreateRecord(recordName, "gamedataConstantStatModifier_Record")
    TweakDB:SetFlat(recordName .. ".modifierType", modifierType)
    TweakDB:SetFlat(recordName .. ".statType", statType)
    TweakDB:SetFlat(recordName .. ".value", value)
end

function utils.TweakDB.InsertElementInFlatTable( flatTableKey, newRecordFlatKey )
    -- "Items.FirstAidWhiffV0
    local flatTable = TweakDB:GetFlat(flatTableKey)
    if not flatTable then
        utils.printError("utils.TweakDB.InsertElementInFlatTable() - Failed to retrieve Flat Table:", flatTableKey)
        return false
    end
    tinsert(flatTable, newRecordFlatKey)
    local success = TweakDB:SetFlat(flatTableKey, flatTable)
    if not success then
        utils.printError("utils.TweakDB.InsertElementInFlatTable() - Failed to set updated flat/record:", flatTableKey)
        return false
    end
    return true
end

function utils.TweakDB.SetQuantityFlat(flatKey, quantityValue)
    -- CDPR quantities for ammo, etc. count back from this value for some reason (assumption of 1m limit as default?)
    local offset = -999999
    return TweakDB:SetFlat(flatKey, quantityValue + offset)
end
