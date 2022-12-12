/*
// ZKV_Takedowns by Kvalyr

*/

public static func ZKVLog(const str: script_ref<String>) -> Void {
  LogChannel(n"DEBUG", "ZKVTD: " + str);
}


/*
public final importonly class WorkspotGameSystem extends IWorkspotGameSystem {

public final native func PlayInDeviceSimple(device: ref<GameObject>, actor: ref<GameObject>, allowCameraMov: Bool, opt actorDataCompName: CName, opt deviceDataCompName: CName, opt syncSlotName: CName, opt slideTime: Float, opt slideBehaviour: WorkspotSlidingBehaviour, opt callbackEventRecipient: ref<Entity>) -> Void;

public final native func PlayInDevice(device: ref<GameObject>, actor: ref<GameObject>, opt workspotStateFlavourName: CName, opt actorDataCompName: CName, opt deviceDataCompName: CName, opt syncSlotName: CName, opt slideTime: Float, opt slideBehaviour: WorkspotSlidingBehaviour, opt callbackEventRecipient: ref<Entity>) -> Void;

*/

// It would be better to stop these calls altogether; but it's probably less conflict-prone to only replace these small methods


@replaceMethod(DefaultTransition)
    protected final func QueueSetCameraParamsEvent(cameraParams: CName, scriptInterface: ref<StateGameScriptInterface>) -> Void {
        // Kv
        if Equals(cameraParams, n"WorkspotLocked"){
            return;
        }
        // Kv End
        let setCameraParamsEvent: ref<SetCameraParamsEvent> = new SetCameraParamsEvent();
        setCameraParamsEvent.paramsName = cameraParams;
        scriptInterface.executionOwner.QueueEvent(setCameraParamsEvent);
    }

@replaceMethod(DamageSystem)
    public final func SetCameraContext(target: ref<GameObject>, paramsName: CName) -> Void {
        // Kv
        if Equals(paramsName, n"WorkspotLocked"){
            return;
        }
        // Kv End
        let setCameraParamsEvent: ref<SetCameraParamsEvent> = new SetCameraParamsEvent();
        setCameraParamsEvent.paramsName = paramsName;
        target.QueueEvent(setCameraParamsEvent);
    }
