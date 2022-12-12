local ZKVTD = GetMod("ZKV_Takedowns")

ZKVTD.debugMode = false

-- GetMod("ZKV_Takedowns").GiveDebugItems()
function ZKVTD.GiveDebugItems()
    Game.AddToInventory("Items.Preset_Crowbar_Default", 1);
    Game.AddToInventory("Items.Preset_Dildo_Stout", 1);
    Game.AddToInventory("Items.Preset_Baseball_Bat_Default", 1);

    Game.AddToInventory("Items.Preset_Hammer_Default", 1);
end
