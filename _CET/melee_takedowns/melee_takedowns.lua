-- ====================================================================================================================
-- ZKV_Takedowns for CP2077 by Kvalyr
-- ====================================================================================================================
local ZKVTD = GetMod("ZKV_Takedowns")
local utils = ZKVTD.utils
-- ====================================================================================================================
local MeleeTakedowns = {}
ZKVTD:AddModule("MeleeTakedowns", MeleeTakedowns)

function MeleeTakedowns:GetAnimTableConfigKeyByWeapon( weaponType, skipValidation )
    if not skipValidation and not self:ValidateWeaponType(weaponType) then
        return
    end

    return self.constants.configKey .. ":" .. weaponType
end

function MeleeTakedowns:GetAnimTableTweakDBKeyByWeapon( weaponType, skipValidation )
    if not skipValidation and not self:ValidateWeaponType(weaponType) then
        return
    end

    local tweakDBKey = self.constants.tweakDBKey_AnimStates
    return tweakDBKey .. ":" .. weaponType
end

function MeleeTakedowns:GetAnimTableForWeapon( weaponType, skipValidation )
    if not skipValidation and not self:ValidateWeaponType(weaponType) then
        return
    end

    local configKey = self:GetAnimTableConfigKeyByWeapon(weaponType, true)
    local animTable = ZKVTD.Config.GetValue(configKey, {})
    -- if not animTable then
    --     utils.printError("GetAnimTableForWeapon() - animTable is nil")
    --     return
    -- end
    return animTable
end

function MeleeTakedowns:SetAnimTableForWeapon( weaponType, newTable, skipValidation )
    if not skipValidation and not self:ValidateWeaponType(weaponType) then
        return
    end

    local configKey = self:GetAnimTableConfigKeyByWeapon(weaponType, true)
    ZKVTD.Config.SetValue(configKey, newTable)
end

function MeleeTakedowns:SetAnimStateForWeapon( weaponType, animKey, newState )
    if not self:ValidateWeaponType(weaponType) then
        return
    end
    if not self:ValidateAnimKey(animKey) then
        return
    end
    -- if newState ~= true and newState ~= false then
    --     ZKVTD.printError("Invalid new anim state for weapon:", newState)
    --     return
    -- end
    local animTable = self:GetAnimTableForWeapon(weaponType, true)
    if newState ~= nil then
        -- Store in Config
        animTable[animKey] = newState
        self:SetAnimTableForWeapon(weaponType, animTable)
    end

    -- Update TweakDB with new array
    local tweakDBKey = MeleeTakedowns:GetAnimTableTweakDBKeyByWeapon(weaponType, true)
    -- ZKVTD.debug("MeleeTakedowns:SetAnimStateForWeapon()", weaponType, animKey, newState)
    -- utils.TweakDB.CreateArrayOfFlatsAndIndices(animTable, tweakDBKey, false)
    utils.TweakDB.CreateArrayOfFlats(animTable, tweakDBKey, false)
end

function MeleeTakedowns:GetAnimStateForWeapon( weaponType, animKey )
    if not self:ValidateWeaponType(weaponType) then
        return
    end
    if not self:ValidateAnimKey(animKey) then
        return
    end

    local animTable = self:GetAnimTableForWeapon(weaponType, true) or {}
    return animTable[animKey] or false
end

function MeleeTakedowns:GetCallbackKeyByWeaponAnim( weaponType, animKey, skipValidation )
    if not skipValidation and not self:ValidateWeaponType(weaponType) then
        return
    end
    if not skipValidation and not self:ValidateAnimKey(animKey) then
        return
    end

    return self.constants.callbackKey .. ":" .. weaponType .. ":" .. animKey
end

local function Callback_Takedowns_OnlyMelee( newValue )
    -- Make takedown prompt only show when a weapon is held
    local instigatorPrereqs = TweakDB:GetFlat("Takedown.Grapple.instigatorPrereqs") -- Use grapple's prereqs as our basis
    local configKey = "Takedowns_OnlyWithMeleeWeaponHeld"
    if newValue == nil then
        newValue = ZKVTD.Config.GetValue(configKey, true)
    end

    ZKVTD.Config.SetValue(configKey, newValue)
    if newValue == true then
        table.insert(instigatorPrereqs, "Prereqs.MeleeWeaponHeldPrereq")
    end

    local flatKey = "Takedown.Kv_MeleeTakedown.instigatorPrereqs"
    local success = TweakDB:SetFlat(flatKey, instigatorPrereqs)
    ZKVTD.debug("-Config Callback-", flatKey, "newValue:", newValue, "SetFlat success:", success)
    if not success then
        ZKVTD.printError("Failed to SetFlat:", "'" .. flatKey .. "'", newValue)
    end
end

local function SetupInteractions_Lethal()
    -- Set up new interaction at same interaction layer as Grapple, using Choice2 (Grapple uses Choice1)
    TweakDB:CloneRecord("Interactions.Kv_MeleeTakedown", "Interactions.Takedown")
    TweakDB:SetFlat("Interactions.Kv_MeleeTakedown.action", "Choice2")
    TweakDB:SetFlat("Interactions.Kv_MeleeTakedown.name", "Kv_MeleeTakedown")
    TweakDB:SetFlat("Interactions.Kv_MeleeTakedown.caption", LocKey(320)) -- "Stealth Kill"

    -- Create new Takedown record and link to new interaction
    TweakDB:CloneRecord("Takedown.Kv_MeleeTakedown", "Takedown.Grapple")
    TweakDB:SetFlat("Takedown.Kv_MeleeTakedown.objectActionUI", "Interactions.Kv_MeleeTakedown")
    TweakDB:SetFlat("Takedown.Kv_MeleeTakedown.actionName", "Kv_MeleeTakedown")
    -- Mimic the rewards flat of the Takedown.Takedown objectAction Record so that we properly award Ninjutsu XP on takedowns
    TweakDB:SetFlat("Takedown.Kv_MeleeTakedown.rewards", TweakDB:GetFlat("Takedown.Takedown.rewards"))
end

local function SetupInteractions_NonLethal()
    -- Non-lethal variant (used with blunt weapons and bare hands)
    TweakDB:CloneRecord("Interactions.Kv_MeleeTakedownNonLethal", "Interactions.Takedown")
    TweakDB:SetFlat("Interactions.Kv_MeleeTakedownNonLethal.action", "Choice2")
    TweakDB:SetFlat("Interactions.Kv_MeleeTakedownNonLethal.name", "Kv_MeleeTakedownNonLethal")
    TweakDB:SetFlat("Interactions.Kv_MeleeTakedownNonLethal.caption", LocKey(324)) -- "Non-Lethal Takedown"

    -- Create new Takedown record and link to new interaction
    TweakDB:CloneRecord("Takedown.Kv_MeleeTakedownNonLethal", "Takedown.Grapple")
    TweakDB:SetFlat("Takedown.Kv_MeleeTakedownNonLethal.objectActionUI", "Interactions.Kv_MeleeTakedownNonLethal")
    TweakDB:SetFlat("Takedown.Kv_MeleeTakedownNonLethal.actionName", "Kv_MeleeTakedownNonLethal")
    -- Mimic the rewards flat of the Takedown.Takedown objectAction Record so that we properly award Ninjutsu XP on takedowns
    TweakDB:SetFlat("Takedown.Kv_MeleeTakedownNonLethal.rewards", TweakDB:GetFlat("Takedown.Takedown.rewards"))

    -- Set up prereqs (Bare Hands)
    local instigatorPrereqs = TweakDB:GetFlat("Takedown.Grapple.instigatorPrereqs")
    table.insert(instigatorPrereqs, "Prereqs.FistsHeldPrereq")

    local flatKey = "Takedown.Kv_MeleeTakedownNonLethal.instigatorPrereqs"
    TweakDB:SetFlat(flatKey, instigatorPrereqs)
end

-- function ZKVTD:DumpTakedownsData()
--     for _, weaponType in ipairs(ZKVTD.constants.weaponTypes) do
--         for _, anim in pairs(ZKVTD.constants.allowedAnimsByWeapon[weaponType]) do
--         end
--     end
-- end

local function setupAnims()

    for _, weaponType in ipairs(ZKVTD.constants.weaponTypes) do
        local animTable = MeleeTakedowns.constants.allowedAnimsByWeapon[weaponType]

        for _, animKey in pairs(animTable) do
            local function callback_weaponTypeAnims( newValue )
                MeleeTakedowns:SetAnimStateForWeapon(weaponType, animKey, newValue)
            end

            local callbackKey = MeleeTakedowns:GetCallbackKeyByWeaponAnim(weaponType, animKey, false)
            utils.Config.AddCallback(callbackKey, callback_weaponTypeAnims)
        end
    end
end

function MeleeTakedowns:Init()
    utils.debug("MeleeTakedowns:Init()")

    SetupInteractions_Lethal()

    -- SetupInteractions_NonLethal() --TODO: For fists & blunt

    setupAnims()

    utils.Config.AddCallback("Update_Takedowns_OnlyMelee", Callback_Takedowns_OnlyMelee)

    utils.Config.AddCallback_GenericSetFlat("ZKVTD.Takedowns.nonLethalBlunt", "Takedowns_NonLethalBlunt", true, "Update_Takedowns_NonLethalBlunt")

    -- TODO: Move this
    -- MTB AnimSwap
    utils.Config.AddCallback_GenericSetFlat(
        "ZKVTD.MantisBladesAnimSwap.UseAerial", "MantisSwap_Finishers_UseAerialTakedownAnimation", true, "Update_MTBAnimSwap_UseAerial"
    )
    utils.Config.AddCallback_GenericSetFlat(
        "ZKVTD.MantisBladesAnimSwap.RandomChoice", "MantisSwap_Finishers_MixDifferentAnimations", true, "Update_MTBAnimSwap_RandomChoice"
    )

    -- TODO: Move this
    -- Misc. Tweaks
    utils.Config.AddCallback_GenericSetFlat(
        "EquipmentGLP.MeleeStealthPlayerBuff_inline1.value", "Misc_Stealth_MeleeMult", 1.3, "Update_Misc_Stealth_MeleeMult"
    )
end

-- ZKVTD:SetupMeleeTakedowns()

ZKVTD:AddModule("MeleeTakedowns", MeleeTakedowns)
-- ZKVTD.Modules["MeleeTakedowns"] = MeleeTakedowns
