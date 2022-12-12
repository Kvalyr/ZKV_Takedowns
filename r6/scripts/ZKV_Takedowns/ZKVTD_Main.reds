/*
// ZKV_Takedowns by Kvalyr

// Known issues:
* Weapon in hand during aerial takedowns
    * Not a huge problem. Looks better, IMO.

*/

public static func ZKVLog(const str: script_ref<String>) -> Void {
  LogChannel(n"DEBUG", "ZKVTD: " + str);
}


@replaceMethod(TakedownUtils)
    public final static func TakedownActionNameToEnum(actionName: CName) -> ETakedownActionType {
        // ZKVLog(s"ZKV - TakedownActionNameToEnum() - actionName: " + NameToString(actionName));
        switch actionName {
            case n"GrappleFailed":
                return ETakedownActionType.GrappleFailed;
            case n"GrappleTarget":
                return ETakedownActionType.Grapple;
            case n"Takedown":
                return ETakedownActionType.Takedown;
            case n"TakedownNonLethal":
                return ETakedownActionType.TakedownNonLethal;
            case n"TakedownNetrunner":
                return ETakedownActionType.TakedownNetrunner;
            case n"TakedownMassiveTarget":
                return ETakedownActionType.TakedownMassiveTarget;
            case n"LeapToTarget":
                return ETakedownActionType.LeapToTarget;
            case n"AerialTakedown":
                return ETakedownActionType.AerialTakedown;
            case n"Struggle":
                return ETakedownActionType.Struggle;
            case n"BreakFree":
                return ETakedownActionType.BreakFree;
            case n"TargetDead":
                return ETakedownActionType.TargetDead;
            case n"KillTarget":
                return ETakedownActionType.KillTarget;
            case n"SpareTarget":
                return ETakedownActionType.SpareTarget;
            case n"ForceShove":
                return ETakedownActionType.ForceShove;
            case n"BossTakedown":
                return ETakedownActionType.BossTakedown;

            // Kv
            case n"Kv_MeleeTakedown":
                // ZKVLog(s"ZKV - TakedownActionNameToEnum() - actionName: " + NameToString(actionName));
                // return ETakedownActionType.LeapToTarget; // DEBUG: -> AerialTakedown
                return ETakedownActionType.KillTarget;
            // Kv End

            default:
        };
        return ETakedownActionType.None;
    }


@wrapMethod(ScriptedPuppetPS)
    public final const func GetValidChoices(actions: array<wref<ObjectAction_Record>>, context: GetActionsContext, objectActionsCallbackController: wref<gameObjectActionsCallbackController>, checkPlayerQuickHackList: Bool, out choices: array<InteractionChoice>) -> Void {
        ArrayPush(actions, TweakDBInterface.GetObjectActionRecord(t"Takedown.Kv_MeleeTakedown"));
        wrappedMethod(actions, context, objectActionsCallbackController, checkPlayerQuickHackList, choices);
    }


public final static func ZKV_GetActiveWeaponType(owner: ref<GameObject>) -> gamedataItemType {
    let weaponType: gamedataItemType;
    // TODO: Validation
    weaponType = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(ScriptedPuppet.GetWeaponRight(owner).GetItemID())).ItemType().Type();
    weaponType = CatchAndCoerceWeaponType(weaponType);
    return weaponType;
}


public final static func ZKV_IsMantisBladesActive(owner: ref<GameObject>) -> Bool {
    return Equals(ZKV_GetActiveWeaponType(owner), gamedataItemType.Cyb_MantisBlades);
}


// Modify this method to stop it from force-unequipping weapons
// TODO: Find a way to do this by wrapping the method instead of replacing the whole thing?
// TODO: Continue to force-unequip weapons for grapple takedowns?
@replaceMethod(TakedownExecuteTakedownEvents)
    public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
        let actionName: CName;
        let weaponType: gamedataItemType;
        if TakedownUtils.ShouldForceTakedown(scriptInterface) {
            actionName = n"TakedownNonLethal";
        } else {
            actionName = this.stateMachineInitData.actionName;
        };
        if Equals(this.GetTakedownAction(stateContext), ETakedownActionType.LeapToTarget) {
            actionName = n"AerialTakedown";
        };
        this.UpdateCameraParams(stateContext, scriptInterface);
        this.SetGameplayCameraParameters(scriptInterface, "cameraTakedowns");
        weaponType = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(ScriptedPuppet.GetWeaponRight(scriptInterface.executionOwner).GetItemID())).ItemType().Type();
        // Kv
        // if NotEquals(weaponType, gamedataItemType.Cyb_MantisBlades) {
        //     this.ForceTemporaryWeaponUnequip(stateContext, scriptInterface, true);
        // };
        // Kv End
        TakedownUtils.SetTakedownAction(stateContext, TakedownUtils.TakedownActionNameToEnum(actionName));
        this.SelectSyncedAnimationAndExecuteAction(stateContext, scriptInterface, scriptInterface.executionOwner, this.stateMachineInitData.target, actionName);
        this.SetLocomotionParameters(stateContext, scriptInterface);
        this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Takedown, EnumInt(gamePSMTakedown.Takedown));
        if !scriptInterface.HasStatFlag(gamedataStatType.CanTakedownSilently) {
            this.TriggerNoiseStim(scriptInterface.executionOwner, TakedownUtils.TakedownActionNameToEnum(actionName));
        };
        if Equals(this.GetTakedownAction(stateContext), ETakedownActionType.TakedownNonLethal) && stateContext.GetConditionBool(n"CrouchToggled") {
            scriptInterface.SetAnimationParameterFloat(n"crouch", 1.00);
        };
        GameInstance.GetRazerChromaEffectsSystem(scriptInterface.GetGame()).PlayAnimation(n"Takedown", false);
        GameInstance.GetTelemetrySystem(scriptInterface.GetGame()).LogTakedown(actionName, this.stateMachineInitData.target);
    }


// // Modify this method to stop it from force-unequipping weapons
// // TODO: Continue to force-unequip weapons for grapple takedowns?
// @replaceMethod(LocomotionTakedownEvents)
//     protected final func ForceTemporaryWeaponUnequip(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, value: Bool) -> Void {

//         if Equals(this.GetTakedownAction(stateContext), ETakedownActionType.LeapToTarget) {
//         // Kv
//         // stateContext.SetPermanentBoolParameter(n"forcedTemporaryUnequip", value, true);
//         // Kv End
//         return;
//     }

public final static func CatchAndCoerceWeaponType(weaponType: gamedataItemType) -> gamedataItemType{
    ZKVLog("CatchAndCoerceWeaponType - weaponType: " + ToString(weaponType));

    switch weaponType {
        // Equipped weapon sometimes returns as clothing slots.. Let's just catch them all
        case gamedataItemType.Clo_Face:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Clo_Feet:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Clo_Head:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Clo_InnerChest:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Clo_Legs:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Clo_OuterChest:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Clo_Outfit:
            return gamedataItemType.Wea_Fists;

        // Treat guns as Wea_Fists until we've implemented Gun takedowns
        case gamedataItemType.Wea_AssaultRifle:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Wea_Axe:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Wea_Handgun:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Wea_HeavyMachineGun:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Wea_LightMachineGun:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Wea_PrecisionRifle:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Wea_Revolver:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Wea_Rifle:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Wea_Shotgun:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Wea_ShotgunDual:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Wea_SniperRifle:
            return gamedataItemType.Wea_Fists;
        case gamedataItemType.Wea_SubmachineGun:
            return gamedataItemType.Wea_Fists;

        default:
            return weaponType;
    };
}

public final static func ZKV_Takedowns_IsWeaponLethal(weaponType: gamedataItemType) -> Bool {
    let nonLethalBluntKey: TweakDBID = TDBID.Create(s"ZKVTD.Takedowns.nonLethalBlunt");
    let nonLethalBlunt: Bool = TweakDBInterface.GetBool(nonLethalBluntKey, true);
    let lethal: Bool = true;

    if nonLethalBlunt {
        // Equipped weapon sometimes returns as clothing slots.. Let's just catch them all
        switch weaponType {
            // Blunt weapons
            case gamedataItemType.Wea_Fists:
                lethal = false;
                break;
            case gamedataItemType.Wea_OneHandedClub:
                lethal = false;
                break;
            case gamedataItemType.Wea_TwoHandedClub:
                lethal = false;
                break;
            case gamedataItemType.Wea_Hammer:
                lethal = false;
                break;
            case gamedataItemType.Cyb_StrongArms:
                lethal = false;
                break;
            default:
                break;
        };
    };
    // ZKVLog("ZKV_Takedowns_IsWeaponLethal: " + lethal);
    return lethal;
}


public final static func ZKV_Takedowns_GetLethalityEffectByWeapon(weaponType: gamedataItemType, aerial: Bool) -> CName {
    let lethalityTag: CName = n"kill";
    let bluntTag: CName = n"setUnconscious";
    let nonLethalBluntKey: TweakDBID = TDBID.Create(s"ZKVTD.Takedowns.nonLethalBlunt");
    let nonLethalBlunt: Bool = TweakDBInterface.GetBool(nonLethalBluntKey, true);
    let weaponLethal: Bool = ZKV_Takedowns_IsWeaponLethal(weaponType);
    if !weaponLethal {
        if aerial {
            bluntTag = n"setUnconsciousAerialTakedown";
        };
        return bluntTag;
    }
    ZKVLog("ZKV_Takedowns_GetLethalityEffectByWeapon - tag: " + NameToString(lethalityTag));
    return lethalityTag;
}


public final static func ZKV_Takedowns_GetRandomFromArray(workspots: array<CName>) -> CName {
    let randIndex: Int32;
    let numWorkspots: Int32 = ArraySize(workspots);

    // ZKVLog(s"ZKV_Takedowns_GetRandomFromArray - numWorkspots: " + ToString(numWorkspots));

    switch numWorkspots {
        case 0:
            ZKVLog(s"Empty array of takedown workspots!");
            return n"finisher_default";
        case 1:
            // ZKVLog(s"ZKV_Takedowns_GetRandomFromArray - 1 workspot only, returning idx 0");
            return workspots[0];
        default:
            randIndex = RandRange(0, numWorkspots);
            // ZKVLog(s"ZKV_Takedowns_GetRandomFromArray - numWorkspots: " + ToString(numWorkspots) + " - randIndex: " + randIndex);
            return workspots[randIndex];
    };
}


public final static func ZKV_Takedowns_GetTDBIDPrefixForWeaponType(weaponType: gamedataItemType, opt configured: Bool) -> String{
    // TODO: Use an enum for this instead?
    let weaponTypeStr: String = ToString(weaponType);
    // return s"ZKVTD.MeleeTakedownAnims." + weaponTypeStr;
    if configured
    {
        return s"ZKVTD.MeleeTakedowns:AnimStates:" + weaponTypeStr;
    }
    else
    {
        return s"ZKVTD.MeleeTakedowns:AnimsAvailable:" + weaponTypeStr;
    }

}


public final static func ZKV_Takedowns_GetEnabledAnimCountForWeapon(weaponType: gamedataItemType) -> Int32{
    let prefix: String = ZKV_Takedowns_GetTDBIDPrefixForWeaponType(weaponType, true);
    let countKey: String = prefix + ".count";
    let countStr: String = TweakDBInterface.GetString(TDBID.Create(countKey), s"0");
    let count: Int32 = StringToInt(countStr);

    // .MeleeTakedowns:AnimStates:Wea_Knife

    ZKVLog(s"ZKV_Takedowns_GetEnabledAnimCountForWeapon - weaponType: " + ToString(weaponType) + " - statedCount: " + count + " - prefix: " + prefix);

    return count;
}

public final static func ZKV_Takedowns_GetAvailableAnimsForWeapon(weaponType: gamedataItemType) -> array<String>
{
    let animArray: array<String>;
    let animKey: TweakDBID;
    let animString: String;
    let weaponTypeStr: String = ToString(weaponType);
    let prefix: String = s"ZKVTD.MeleeTakedowns:AnimsAvailable:" + weaponTypeStr;
    let i: Int32;

    // ZKVTD.MeleeTakedowns:AnimsAvailable:Wea_ShortBlade:1
    // let prefix: String = ZKV_Takedowns_GetTDBIDPrefixForWeaponType(weaponType);
    let countKey: String = prefix + ".count";
    let countStr: String = TweakDBInterface.GetString(TDBID.Create(countKey), s"0");
    let count: Int32 = StringToInt(countStr);

    i = 0;
    while i <= count {
        animKey = TDBID.Create(prefix + s":" + ToString(i));
        animString = TweakDBInterface.GetString(animKey, s"");
        if NotEquals(animString, ""){
            ArrayPush(animArray, animString);
        };
        i += 1;
    };

    ZKVLog(s"ZKV_Takedowns_GetAvailableAnimsForWeapon - weaponType: " + ToString(weaponType) + " - statedCount: " + count + " - retrievedCount: " + ArraySize(animArray) + " - prefix: " + prefix);

    return animArray;
}

public final static func ZKV_Takedowns_GetAnimsForWeapon(weaponType: gamedataItemType, count: Int32) -> array<CName>{
    let prefix: String = ZKV_Takedowns_GetTDBIDPrefixForWeaponType(weaponType, true);
    let animStateKey: TweakDBID;
    let animState: Bool;
    let animString: String;
    let animArray: array<CName>;
    let i: Int32;
    let availableAnimsArray: array<String> = ZKV_Takedowns_GetAvailableAnimsForWeapon(weaponType);

    ZKVLog(s"ZKV_Takedowns_GetAnimsForWeapon - weaponType: " + ToString(weaponType) + " - count: " + count + " - prefix: " + prefix);

    if count < 1 {
        ZKVLog(s"ZKV_Takedowns_GetAnimsForWeapon - Returning empty anim array! - weaponType: " + ToString(weaponType) + " - count: " + ToString(count));
        return animArray;
    }


    // ZKVTD.MeleeTakedowns:AnimStates:Wea_Fists:AerialTakedown_Back_Simple

    i = 0;
    while i < ArraySize(availableAnimsArray) {
        animString = availableAnimsArray[i];
        animStateKey = TDBID.Create(prefix + s":" + animString);
        animState = TweakDBInterface.GetBool(animStateKey, false);
        // ZKVLog("ZKV_Takedowns_GetAnimsForWeapon() - Checking state for:" + prefix + s": " + animString + " - State: " + animState);
        if animState {
            ArrayPush(animArray, StringToName(animString));
        };
        i += 1;
    };

    return animArray;
}


public final static func ZKV_IsEffectTagInEffectSet(activator: wref<GameObject>, effectSetName: CName, effectTag: CName) -> Bool {
    return GameInstance.GetGameEffectSystem(activator.GetGame()).HasEffect(effectSetName, effectTag);
}


public final static func ZKV_Takedowns_GetBestEffectSetForEffectTag(activator: wref<GameObject>, effectTag: CName, out effectSet: CName) -> Bool{
    // TODO: Get a dynamic list of effectSets from lua & TweakDB instead of hardcoding these
    let finisherEffectSet: CName = n"playFinisher";
    let takedownEffectSet: CName = n"takedowns";
    let zkvtdEffectSet: CName = n"zkv_takedowns";

    // DEBUG
    // let effectInSet_zkvtd: Bool = ZKV_IsEffectTagInEffectSet(activator, zkvtdEffectSet, effectTag);
    // let effectInSet_finishers: Bool = ZKV_IsEffectTagInEffectSet(activator, finisherEffectSet, effectTag);
    // let effectInSet_takedowns: Bool = ZKV_IsEffectTagInEffectSet(activator, takedownEffectSet, effectTag);
    // ZKVLog(s"ZKV_Takedowns_GetBestEffectSetForEffectTag - effectTag: " + NameToString(effectTag) + " - effectInSet_zkvtd: " + effectInSet_zkvtd);
    // ZKVLog(s"ZKV_Takedowns_GetBestEffectSetForEffectTag - effectTag: " + NameToString(effectTag) + " - effectInSet_finishers: " + effectInSet_finishers);
    // ZKVLog(s"ZKV_Takedowns_GetBestEffectSetForEffectTag - effectTag: " + NameToString(effectTag) + " - effectInSet_takedowns: " + effectInSet_takedowns);
    // DEBUG

    // Prefer ZKVTD effectSet
    if ZKV_IsEffectTagInEffectSet(activator, zkvtdEffectSet, effectTag) {
        effectSet = zkvtdEffectSet;
        return true;
    }

    // Fall back to CDPR finishers/takedowns effectSets if absent from ZKVTD
    if ZKV_IsEffectTagInEffectSet(activator, finisherEffectSet, effectTag) {
        effectSet = finisherEffectSet;
        return true;
    }
    if ZKV_IsEffectTagInEffectSet(activator, takedownEffectSet, effectTag) {
        effectSet = takedownEffectSet;
        return true;
    }

    // If we've reached this point, the effectTag isn't present in any of our known effectSets - This is a bad time.
    ZKVLog(s"ERROR: effectTag not found in any known effectSets: " + NameToString(effectTag));

    return false;
}


public final static func ZKV_Takedowns_GetEffectTagNonLethalVariant(owner: ref<GameObject>, effectTag: CName) -> CName
{
    let effectSet: CName = n"zkv_takedowns";
    if !Equals(effectTag, n"AerialTakedown_Back_Simple") && !Equals(effectTag, n"AerialTakedown_Simple")
    {
        effectTag = StringToName( NameToString( effectTag ) + s"_NonLethal" );
    };
    ZKV_IsEffectTagInEffectSet(owner, n"zkv_takedowns", effectTag);

    if !ZKV_Takedowns_GetBestEffectSetForEffectTag(owner, effectTag, effectSet){
        ZKVLog(s"ERROR: Failed to get effectSet for NonLethal tag. Falling back to default. effectTag: " + NameToString(effectTag));
        effectTag = n"finisher_default_NonLethal";
    }
    return effectTag;
}


public final static func ZKV_Takedowns_DoFinisherByWeaponType(
    scriptInterface: ref<StateGameScriptInterface>,
    owner: ref<GameObject>,
    target: ref<GameObject>,
    weaponType: gamedataItemType
) -> CName {
    let effectTag: CName;
    let effectSet: CName = n"playFinisher";
    let randIndex: Int32;
    let randMax: Int32;
    let effectArray_takedowns: array<CName>;
    let lethal: Bool = true;
    let countTakedowns: Int32 = ZKV_Takedowns_GetEnabledAnimCountForWeapon(weaponType);
    lethal = ZKV_Takedowns_IsWeaponLethal(weaponType);

    if countTakedowns < 1 {
        return n"finisher_default";
    }

    effectArray_takedowns = ZKV_Takedowns_GetAnimsForWeapon(weaponType, countTakedowns);
    effectTag = ZKV_Takedowns_GetRandomFromArray(effectArray_takedowns);

    if !lethal {
        effectTag = ZKV_Takedowns_GetEffectTagNonLethalVariant(owner, effectTag);
    }

    // Get the best effectSet for the requested effectTag, or fall back to default
    if !ZKV_Takedowns_GetBestEffectSetForEffectTag(owner, effectTag, effectSet){
        ZKVLog(s"ERROR: Failed to get effectSet. Falling back to default. effectTag: " + NameToString(effectTag));
        effectSet = n"playFinisher";
        effectTag = n"finisher_default";
    }

    ZKVLog(s"ZKV_Takedowns_DoFinisherByWeaponType - effectSet: " + NameToString(effectSet) + " - effectTag:" + NameToString(effectTag));

    TakedownGameEffectHelper.FillTakedownData(scriptInterface.executionOwner, owner, target, effectSet, effectTag);

    return effectTag;
}


// public final static func ZKV_Takedowns_GiveXP(owner: ref<GameObject>, target: ref<GameObject>){
//     // TODO: Can't find the call-chain that ends with GiveReward() from the normal takedown
//     // TODO: This isn't ideal as we could end up double-rewarding Ninjutsu XP for takedowns
//     RPGManager.GiveReward(owner.GetGame(), t"RPGActionRewards.Stealth", Cast<StatsObjectID>(target.GetEntityID()));
// }


@replaceMethod(LocomotionTakedownEvents)
    protected final func SelectSyncedAnimationAndExecuteAction(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, owner: ref<GameObject>, target: ref<GameObject>, action: CName) -> Void {
        let effectTag: CName;
        let syncedAnimName: CName;
        let dataTrackingEvent: ref<TakedownActionDataTrackingRequest> = new TakedownActionDataTrackingRequest();
        let gameEffectName: CName = n"takedowns";
        // Kv: Changes
        // gameEffectName: Refers to effectSet file: n"takedowns" -> `takedowns.es`
        // effectTag: Refers to specific entry tag in takedowns.es (effectSet) file (specified by gameEffectName)
        // syncedAnimName: Refers to effectExecutor entry by tag in [takedowns.es].effects.[entry].Tag
        // ZKVLog(s"ZKVTEST - action: " + NameToString(action));
        // Kv: End
        switch this.GetTakedownAction(stateContext) {
            case ETakedownActionType.GrappleFailed:
                TakedownGameEffectHelper.FillTakedownData(scriptInterface.executionOwner, owner, target, gameEffectName, action, "");
                break;
            case ETakedownActionType.TargetDead:
                syncedAnimName = n"grapple_sync_death";
                break;
            case ETakedownActionType.BreakFree:
                syncedAnimName = n"grapple_sync_recover";
                break;
            case ETakedownActionType.Takedown:
                syncedAnimName = this.SelectRandomSyncedAnimation(stateContext);
                effectTag = n"kill";
                (target as NPCPuppet).SetMyKiller(owner);
                break;
            case ETakedownActionType.TakedownNonLethal:
                if stateContext.GetConditionBool(n"CrouchToggled") {
                    syncedAnimName = n"grapple_sync_nonlethal_crouch";
                } else {
                    syncedAnimName = this.SelectRandomSyncedAnimation(stateContext);
                };
                effectTag = n"setUnconscious";
                break;
            case ETakedownActionType.TakedownNetrunner:
                syncedAnimName = n"personal_link_takedown_01";
                effectTag = n"setUnconsciousTakedownNetrunner";
                break;
            case ETakedownActionType.TakedownMassiveTarget:
                TakedownGameEffectHelper.FillTakedownData(scriptInterface.executionOwner, owner, target, gameEffectName, action, "");
                effectTag = n"setUnconsciousTakedownMassiveTarget";
                break;
            case ETakedownActionType.AerialTakedown:
                // Kv: Changes
                let aerialTakedownWorkspot: CName = this.SelectAerialTakedownWorkspot(scriptInterface, owner, target, true, true, false, false, action);
                TakedownGameEffectHelper.FillTakedownData(scriptInterface.executionOwner, owner, target, gameEffectName, aerialTakedownWorkspot);
                // Kv: Bugfix for visually-lethal Mantis Blades aerial takedown added in 1.5 not killing the target
                // TODO: Make this optional?
                if ZKV_IsMantisBladesActive(owner) {
                    effectTag = n"kill";
                    (target as NPCPuppet).SetMyKiller(owner);
                }else {
                    effectTag = n"setUnconsciousAerialTakedown";
                };
                // ZKVLog("ETakedownActionType.AerialTakedown - AerialTakedown - effectTag: " + NameToString(effectTag) + " - aerialTakedownWorkspot: " + NameToString(aerialTakedownWorkspot));
                // Kv: End Changes
                break;

            // Kv
            // Repurpose unused KillTarget enumValue as Melee-weapon-takedown
            case ETakedownActionType.KillTarget:
                let weaponType: gamedataItemType = ZKV_GetActiveWeaponType(owner);
                effectTag = ZKV_Takedowns_GetLethalityEffectByWeapon(weaponType, false);
                let zkv_animName: CName = ZKV_Takedowns_DoFinisherByWeaponType(scriptInterface, owner, target, weaponType);
                if !(Equals(effectTag, n"setUnconsciousAerialTakedown") || Equals(effectTag, n"setUnconscious")){
                    (target as NPCPuppet).SetMyKiller(owner);
                }
                ZKVLog("ETakedownActionType.KillTarget - effectTag: " + NameToString(effectTag) + " - zkv_animName: " + NameToString(zkv_animName));
                break;
            // Kv End

            case ETakedownActionType.BossTakedown:
                TakedownGameEffectHelper.FillTakedownData(scriptInterface.executionOwner, owner, target, gameEffectName, this.SelectSyncedAnimationBasedOnPhase(stateContext, target), "");
                effectTag = this.SetEffectorBasedOnPhase(stateContext);
                syncedAnimName = this.GetSyncedAnimationBasedOnPhase(stateContext);
                StatusEffectHelper.ApplyStatusEffect(target, t"BaseStatusEffect.BossTakedownCooldown");
                target.GetTargetTrackerComponent().AddThreat(owner, true, owner.GetWorldPosition(), 1.00, 10.00, false);
                break;
            case ETakedownActionType.ForceShove:
                syncedAnimName = n"grapple_sync_shove";
                break;
            default:
                syncedAnimName = n"grapple_sync_kill";
                effectTag = n"kill";
        };

    if IsNameValid(syncedAnimName) && IsDefined(owner) && IsDefined(target) {
        if this.IsTakedownWeapon(stateContext, scriptInterface) {
            this.FillAnimWrapperInfoBasedOnEquippedItem(scriptInterface, false);
        };
        this.PlayExitAnimation(scriptInterface, owner, target, syncedAnimName);
    };
    dataTrackingEvent.eventType = this.GetTakedownAction(stateContext);
    scriptInterface.GetScriptableSystem(n"DataTrackingSystem").QueueRequest(dataTrackingEvent);
    this.DefeatTarget(stateContext, scriptInterface, owner, target, gameEffectName, effectTag);
  }
