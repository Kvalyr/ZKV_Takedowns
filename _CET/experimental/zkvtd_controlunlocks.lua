local ZKVTD = GetMod("ZKVTD")
-- ====================================================================================================================
-- ZKV_Takedowns for CP2077 by Kvalyr
-- ====================================================================================================================

local function SetupControlUnlocks()
    -- AerialTakedown
    -- AllowRotation
    TweakDB:SetFlat("PlayerLocomotion.player_locomotion_data_AerialTakedown_inline10.value", 1) -- Default: 0
    -- AllowMovementInput
    TweakDB:SetFlat("PlayerLocomotion.player_locomotion_data_AerialTakedown_inline9.value", 1) -- Default: 0

    -- TakedownBegin
    -- AllowMovementInput
    TweakDB:SetFlat("PlayerLocomotionTakedown.player_locomotion_data_TakedownBegin_inline10.value", 1) -- Default: 0
    -- AllowRotation
    TweakDB:SetFlat("PlayerLocomotionTakedown.player_locomotion_data_TakedownBegin_inline10.value", 1) -- Default: 0

    -- TakedownEnd
    -- AllowMovementInput
    TweakDB:SetFlat("PlayerLocomotionTakedown.player_locomotion_data_TakedownEnd_inline10.value", 1) -- Default: 0
    -- AllowRotation
    TweakDB:SetFlat("PlayerLocomotionTakedown.player_locomotion_data_TakedownEnd_inline11.value", 1) -- Default: 0

    -- TakedownExecuteTakedownAndDispose
    -- AllowMovementInput
    TweakDB:SetFlat("PlayerLocomotionTakedown.player_locomotion_data_TakedownExecuteTakedownAndDispose_inline11.value", 1) -- Default: 0
    -- AllowRotation
    TweakDB:SetFlat("PlayerLocomotionTakedown.player_locomotion_data_TakedownExecuteTakedownAndDispose_inline11.value", 1) -- Default: 0

    -- TakedownExecuteTakedown
    -- AllowMovementInput
    TweakDB:SetFlat("PlayerLocomotionTakedown.player_locomotion_data_TakedownExecuteTakedown_inline10.value", 1) -- Default: 0
    -- AllowRotation
    TweakDB:SetFlat("PlayerLocomotionTakedown.player_locomotion_data_TakedownExecuteTakedown_inline11.value", 1) -- Default: 0

    -- -- TakedownExecuteTakedown
    -- -- AllowMovementInput
    -- TweakDB:SetFlat("PlayerLocomotionTakedown.player_locomotion_data_TakedownExecuteTakedown_inline10.value", 1) -- Default: 0
    -- -- AllowRotation
    -- TweakDB:SetFlat("PlayerLocomotionTakedown.player_locomotion_data_TakedownExecuteTakedown_inline11.value", 1) -- Default: 0

    TweakDB:SetFlat("playerStateMachineLocomotionTakedown.takedownExecuteTakedown.onEnterCameraParamsName", "Default") -- Default: n"WorkspotLocked"
end
