-- ====================================================================================================================
-- ZKV_Takedowns for CP2077 by Kvalyr
-- ====================================================================================================================
local ZKVTD = GetMod("ZKVTD")
local i18n = ZKVTD.i18n
local i18n_strings = {}
ZKVTD:AddModule("i18n_strings", i18n_strings)
i18n.strings = i18n_strings

-- ====================================================================================================================

local function AddStringsForLanguage( langKey, stringsTable )
    for key, value in pairs(stringsTable) do
        i18n:AddString(langKey, key, value)
    end
end

-- ====================================================================================================================
-- Localization Strings for ZKVTD
-- Any missing entries will just show the English string as default
-- Please submit translations on GitHub: https://github.com/Kvalyr/ZKV_Takedowns
-- ====================================================================================================================

function i18n_strings:Init()
    local strings_EN = {
        ["zkvtd_settings.tab"] = "ZKVTD",

        ["Animations"] = "Animations",

        -- Takedown animations
        ["finisher_default.label"] = "Default Finisher",
        ["finisher_default.tooltip"] = "Throat-punch followed by Haymaker knockdown",
        ["AerialTakedown_Simple.label"] = "Aerial Takedown (Unarmed)",
        ["AerialTakedown_Simple.tooltip"] = "Aerial Takedown (Unarmed)",
        ["AerialTakedown_Back_Simple.label"] = "Aerial Takedown (Behind) (Unarmed)",
        ["AerialTakedown_Back_Simple.tooltip"] = "Aerial Takedown (Behind) (Unarmed)",
        ["AerialTakedown_MantisBlades.label"] = "Aerial Takedown (Mantis Blades)",
        ["AerialTakedown_MantisBlades.tooltip"] = "Aerial Takedown (Mantis Blades)",
        ["AerialTakedown_Back_MantisBlades.label"] = "Aerial Takedown (Behind) (Mantis Blades)",
        ["AerialTakedown_Back_MantisBlades.tooltip"] = "Aerial Takedown (Behind) (Mantis Blades)",

        ["Wea_Katana.label"] = "Long Blade 2H Impale",
        ["Wea_Katana.tooltip"] = "Two-Handed Impale Finisher (Katana)",
        ["Wea_Katana_Back.label"] = "Decapitate",
        ["Wea_Katana_Back.tooltip"] = "Decapitate (Katana) - Target turns to face V",

        ["Cyb_MantisBlades.label"] = "Double-Impale-and-Lift Finisher (Front)",
        ["Cyb_MantisBlades.tooltip"] = "Double-Impale-and-Lift Finisher (Front)",
        ["Cyb_MantisBlades_Back.label"] = "Double-Impale-and-Lift Finisher (Behind)",
        ["Cyb_MantisBlades_Back.tooltip"] = "Double-Impale-and-Lift Finisher (Behind)",

        ["ZKVTD_Takedown_HeavyAttack01.label"] = "Heavy Attack 1",
        ["ZKVTD_Takedown_HeavyAttack01.tooltip"] = "Heavy Attack 1",
        ["ZKVTD_Takedown_HeavyAttack02.label"] = "Heavy Attack 2",
        ["ZKVTD_Takedown_HeavyAttack02.tooltip"] = "Heavy Attack 2",
        ["ZKVTD_Takedown_ComboAttack03.label"] = "Combo Attack 3",
        ["ZKVTD_Takedown_ComboAttack03.tooltip"] = "Combo Attack 3",
        ["ZKVTD_Takedown_BlockAttack.label"] = "Defensive Attack",
        ["ZKVTD_Takedown_BlockAttack.tooltip"] = "Defensive Attack",
        ["ZKVTD_Takedown_SafeAttack.label"] = "Safe Attack",
        ["ZKVTD_Takedown_SafeAttack.tooltip"] = "Safe Attack",

        ["ZKVTD_Katana_backstab.label"] = "Long Blade Backstab",
        ["ZKVTD_Katana_backstab.tooltip"] = "Two-Handed Impale Backstab (Katana)",
        ["ZKVTD_Katana_behead_behind.label"] = "Decapitate (Behind)",
        ["ZKVTD_Katana_behead_behind.tooltip"] = "Decapitate (Katana) - Target remains facing away from V",
        ["ZKVTD_Knife_backstab.label"] = "Short Blade 2H Backstab",
        ["ZKVTD_Knife_backstab.tooltip"] = "Short Blade 2H Backstab",
        ["ZKVTD_Monowire_behead_behind.label"] = "Decapitate",
        ["ZKVTD_Monowire_behead_behind.tooltip"] = "Decapitate by lateral crossover-slice with monowires",

        -- Weapons -- TODO: Pull from game's own localization files?
        ["Wea_Fists"] = "Fists",
        ["Wea_ShortBlade"] = "Short Blade",
        ["Wea_Knife"] = "Knife",
        ["Wea_LongBlade"] = "Long Blade",
        ["Wea_Katana"] = "Katana",
        ["Wea_Chainsword"] = "Chainsword",
        ["Wea_Machete"] = "Machete",
        ["Wea_OneHandedClub"] = "1H Club",
        ["Wea_TwoHandedClub"] = "2H Club",
        ["Wea_Hammer"] = "Hammer",
        ["Cyb_MantisBlades"] = "Mantis Blades",
        ["Cyb_StrongArms"] = "Gorilla Arms",
        ["Cyb_NanoWires"] = "Monowire",
        -- ["Cyb_Launcher"] = "Wea_Machete",

        ["zkvtd_settings.category.takedowns"] = "Takedowns",
        ["zkvtd_settings.category.mtb_animswap"] = "Mantis Blades Finishers",
        ["zkvtd_settings.category.misc_tweaks"] = "Miscellaneous Tweaks",
        ["zkvtd_settings.category.takedowns_byweapon"] = "Takedowns - Animation Choices",

        ["zkvtd_settings.Takedowns.OnlyMelee.label"] = "Only with Melee Weapon In-Hand",
        ["zkvtd_settings.Takedowns.OnlyMelee.tooltip"] = "Toggle whether or not the new takedown/kill prompt shows only with a melee weapon held (On) or with any weapon (Off) \nGrappling is unaffected.",

        ["zkvtd_settings.Takedowns.NonLethalBlunt.label"] = "Non-Lethal Blunt",
        ["zkvtd_settings.Takedowns.NonLethalBlunt.tooltip"] = "Toggles whether or not takedowns with blunt weapons (fists, gorilla arms, clubs, bats, etc.) leave the target unconscious instead of dead.\n Switch this off to make blunt weapon takedowns lethal.",

        ["zkvtd_settings.MTBAnimSwap.UseAerial.label"] = "Use Mantis Blades Aerial Takedown Finisher",
        ["zkvtd_settings.MTBAnimSwap.UseAerial.tooltip"] = "Switch this on to use the Aerial Takedown animation as a Mantis Blades finisher in combat instead of the normal finisher animation.",

        ["zkvtd_settings.MTBAnimSwap.RandomChoice.label"] = "Also use normal Mantis Blades Finisher",
        ["zkvtd_settings.MTBAnimSwap.RandomChoice.tooltip"] = "Switch this on to have the mod choose randomly between the Aerial Takedown animation and the original animation for Mantis Blades finishers during combat. \nHas no effect if the previous setting is off.",

        ["zkvtd_settings.Misc_Stealth.MeleeMult.label"] = "Stealth Melee Damage Multiplier",
        ["zkvtd_settings.Misc_Stealth.MeleeMult.tooltip"] = "This damage multiplier is applied to attacks from stealth.\n Sufficiently high damage can turn strong attacks (such as Mantis Blade leap attacks) into instant takedowns by triggering finishers.\n The default in the base game is +30% damage (i.e.; 1.3)",
    }
    AddStringsForLanguage("en-us", strings_EN)

    -- ====================================================================================================================

    -- Polski
    -- Translation by PeterMods76 @ NexusMods
    local strings_PL = {
        ["zkvtd_settings.category.takedowns"] = "Ogłuszenia",
        ["zkvtd_settings.category.mtb_animswap"] = "Eliminacja Ostrzami Modliszki",
        ["zkvtd_settings.category.misc_tweaks"] = "Inne ulepszenia",
        ["zkvtd_settings.category.takedowns_byweapon"] = "Ogłuszenia - Wybór animacji",

        ["zkvtd_settings.Takedowns.OnlyMelee.label"] = "Tylko z bronią w ręku",
        ["zkvtd_settings.Takedowns.OnlyMelee.tooltip"] = "Ustawia, czy monit o ogłuszenie/zabicie ma być wyświetlany tylko przy trzymanej broni białej (wł), czy przy dowolnej broni (wył) \nChwyt pozostaje niezmieniony.",

        ["zkvtd_settings.Takedowns.NonLethalBlunt.label"] = "Nieśmiercionośna broń obuchowa",
        ["zkvtd_settings.Takedowns.NonLethalBlunt.tooltip"] = "Ustawia, czy ogłuszenia bronią obuchową (pięści, ramiona gorilla, pałki, młoty itp.) pozostawiają cel nieprzytomny zamiast martwy.\n Wyłącz tę opcję, aby ogłuszenia bronią obuchową były śmiertelne.",

        ["zkvtd_settings.MTBAnimSwap.UseAerial.label"] = "Dodaj eliminację z powietrza",
        ["zkvtd_settings.MTBAnimSwap.UseAerial.tooltip"] = "Włącz tą opcję, aby aktywować animację eliminacji z powietrza ostrzami modliszki w walce zamiast normalnej animacji eliminacji.",

        ["zkvtd_settings.MTBAnimSwap.RandomChoice.label"] = "Używaj TYLKO eliminacji z powietrza",
        ["zkvtd_settings.MTBAnimSwap.RandomChoice.tooltip"] = "Włącz tą opcję, aby mod wybierał losowo między animacją eliminacji z powietrza a oryginalną animacją eliminacji ostrzami modliszki podczas walki. \nNie działa, jeśli poprzednie ustawienie jest wyłączone.",

        ["zkvtd_settings.Misc_Stealth.MeleeMult.label"] = "Mnożnik obrażeń w walce wręcz z ukrycia",
        ["zkvtd_settings.Misc_Stealth.MeleeMult.tooltip"] = "Ten mnożnik obrażeń jest stosowany do ataków z ukrycia.\n Wystarczająco wysokie obrażenia mogą zamienić silne ataki (takie jak ataki z wyskoku Ostrzami Modliszki) w natychmiastowe eliminacje, uruchamiając ciosy kończące.\n Domyślna wartość w grze podstawowej to +30% do obrażeń (i.e.; 1.3)",
    }
    AddStringsForLanguage("pl-pl", strings_PL)

    -- ====================================================================================================================

    -- العربية
    local strings_AR = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("ar-ar", strings_AR)

    -- ====================================================================================================================

    -- Čeština
    local strings_CZ = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("cz-cz", strings_CZ)

    -- ====================================================================================================================

    -- Deutsch
    local strings_DE = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("de-de", strings_DE)

    -- ====================================================================================================================

    -- Español
    local strings_ES = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("es-es", strings_ES)

    -- ====================================================================================================================

    -- Español de Latinoamérica
    local strings_ESMX = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("es-mx", strings_ESMX)

    -- ====================================================================================================================

    -- Français
    local strings_FR = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("fr-fr", strings_FR)

    -- ====================================================================================================================

    -- Magyar
    local strings_HU = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("hu-hu", strings_HU)

    -- ====================================================================================================================

    -- Italiano
    local strings_IT = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("it-it", strings_IT)

    -- ====================================================================================================================

    -- 日本語
    local strings_JP = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("jp-jp", strings_JP)

    -- ====================================================================================================================

    -- 한국인
    local strings_KR = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("kr-kr", strings_KR)

    -- ====================================================================================================================

    -- Português brasileiro
    local strings_PTBR = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("pt-br", strings_PTBR)

    -- ====================================================================================================================

    -- Русский
    local strings_RU = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("ru-ru", strings_RU)

    -- ====================================================================================================================

    -- ชาวไทย
    local strings_TH = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("th-th", strings_TH)

    -- ====================================================================================================================

    -- Türkçe
    local strings_TR = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("tr-tr", strings_TR)

    -- ====================================================================================================================

    -- Chinese (PRC)
    -- Translation submitted by Zo7lin @ NexusMods
    local strings_ZHCN = {
        ["Animations"] = "处决动作",

        -- Takedown animations
        ["finisher_default.label"] = "默认处决",
        ["finisher_default.tooltip"] = "先打喉咙，再一拳撂倒！",
        ["AerialTakedown_Simple.label"] = "空中击倒 (拳头)",
        ["AerialTakedown_Simple.tooltip"] = "空中击倒敌人再轻轻敲醒他沉睡的心灵 (拳头)",
        ["AerialTakedown_Back_Simple.label"] = "空中击倒 (背身-拳头)",
        ["AerialTakedown_Back_Simple.tooltip"] = "空中击倒敌人再轻轻敲醒他沉睡的心灵 (背身-拳头)",
        ["AerialTakedown_MantisBlades.label"] = "空中击倒 (螳螂刀)",
        ["AerialTakedown_MantisBlades.tooltip"] = "空中击倒敌人再捅穿他的脑袋~ (螳螂刀)",
        ["AerialTakedown_Back_MantisBlades.label"] = "空中击倒 (背身-螳螂刀)",
        ["AerialTakedown_Back_MantisBlades.tooltip"] = "空中击倒敌人再捅穿他的脑袋~ (背身-螳螂刀)",

        ["Wea_Katana.label"] = "刺穿处决",
        ["Wea_Katana.tooltip"] = "双手握柄刺穿处决 (武士刀)",
        ["Wea_Katana_Back.label"] = "斩首处决",
        ["Wea_Katana_Back.tooltip"] = "斩下敌人狗头 (武士刀) - 目标会面向于V",

        ["Cyb_MantisBlades.label"] = "双刃刺穿 (正面)",
        ["Cyb_MantisBlades.tooltip"] = "双刃刺穿敌人再举高高~ (正面)",
        ["Cyb_MantisBlades_Back.label"] = "双刃刺穿 (背身)",
        ["Cyb_MantisBlades_Back.tooltip"] = "双刃刺穿敌人再举高高~ (背身)",

        ["ZKVTD_Takedown_HeavyAttack01.label"] = "重击 1",
        ["ZKVTD_Takedown_HeavyAttack01.tooltip"] = "长按鼠标右键的重击",
        ["ZKVTD_Takedown_HeavyAttack02.label"] = "重击 2",
        ["ZKVTD_Takedown_HeavyAttack02.tooltip"] = "长按鼠标右键的重击",
        ["ZKVTD_Takedown_ComboAttack03.label"] = "连击 3",
        ["ZKVTD_Takedown_ComboAttack03.tooltip"] = "无脑狂点鼠标左键的攻击",
        ["ZKVTD_Takedown_BlockAttack.label"] = "格挡攻击",
        ["ZKVTD_Takedown_BlockAttack.tooltip"] = "格挡弹反攻击",
        ["ZKVTD_Takedown_SafeAttack.label"] = "无害攻击",
        ["ZKVTD_Takedown_SafeAttack.tooltip"] = "无害的攻击",

        ["ZKVTD_Katana_backstab.label"] = "长刀剑刺穿处决 (背身)",
        ["ZKVTD_Katana_backstab.tooltip"] = "双手握柄背刺处决 (武士刀)",
        ["ZKVTD_Katana_behead_behind.label"] = "斩首处决 (背身)",
        ["ZKVTD_Katana_behead_behind.tooltip"] = "斩下敌人狗头 (武士刀) - 目标会面向于V",
        ["ZKVTD_Knife_backstab.label"] = "短刀剑刺穿处决 (背身)",
        ["ZKVTD_Knife_backstab.tooltip"] = "短刀剑刺穿处决 (背身)",
        ["ZKVTD_Monowire_behead_behind.label"] = "斩首处决",
        ["ZKVTD_Monowire_behead_behind.tooltip"] = "单分子线横向交叉切割斩首处决",

        -- Weapons -- TODO: Pull from game's own localization files?
        ["Wea_Fists"] = "拳头",
        ["Wea_ShortBlade"] = "短刀剑",
        ["Wea_Knife"] = "小刀",
        ["Wea_LongBlade"] = "长刀剑",
        ["Wea_Katana"] = "武士刀",
        ["Wea_Chainsword"] = "链锯剑",
        ["Wea_Machete"] = "剃刀",
        ["Wea_OneHandedClub"] = "单手棍棒",
        ["Wea_TwoHandedClub"] = "双手棍棒",
        ["Wea_Hammer"] = "锤子",
        ["Cyb_MantisBlades"] = "螳螂刀",
        ["Cyb_StrongArms"] = "大猩猩手臂",
        ["Cyb_NanoWires"] = "单分子线",
        -- ["Cyb_Launcher"] = "Wea_Machete",

        ["zkvtd_settings.category.takedowns"] = "击倒处决大修",
        ["zkvtd_settings.category.mtb_animswap"] = "螳螂刀处决",
        ["zkvtd_settings.category.misc_tweaks"] = "其他调整",
        ["zkvtd_settings.category.takedowns_byweapon"] = "击倒处决大修 - 处决动作选择",

        ["zkvtd_settings.Takedowns.OnlyMelee.label"] = "仅持有近战武器时击杀",
        ["zkvtd_settings.Takedowns.OnlyMelee.tooltip"] = "仅在持有近战武器时显示新的击杀提示，禁用则任何武器都可显示击杀提示",

        ["zkvtd_settings.Takedowns.NonLethalBlunt.label"] = "非致命性钝器",
        ["zkvtd_settings.Takedowns.NonLethalBlunt.tooltip"] = "使钝器(拳头、大猩猩手臂、棍棒等)的击杀会让目标失去知觉而不是死亡，禁用则钝器击杀能致死目标",

        ["zkvtd_settings.MTBAnimSwap.UseAerial.label"] = "螳螂刀空中击倒动作",
        ["zkvtd_settings.MTBAnimSwap.UseAerial.tooltip"] = "启用/禁用 空中击倒动作变更为螳螂刀处决动作",

        ["zkvtd_settings.MTBAnimSwap.RandomChoice.label"] = "随机空中击倒动作",
        ["zkvtd_settings.MTBAnimSwap.RandomChoice.tooltip"] = "启用该选项则随机选择螳螂刀空中击倒动作和原版空中击倒动作(如果禁用螳螂刀动作则无法生效)",

        ["zkvtd_settings.Misc_Stealth.MeleeMult.label"] = "潜行伤害倍数",
        ["zkvtd_settings.Misc_Stealth.MeleeMult.tooltip"] = "足够高的伤害可将螳螂刀重攻击变更为瞬间处决，原版游戏默认值是+30%伤害(即：1.3)",
    }
    AddStringsForLanguage("zh-cn", strings_ZHCN)

    -- ====================================================================================================================

    -- Chinese (TW)
    local strings_ZHTW = {
        -- TODO: Using strings_EN as a reference, add translation strings here
    }
    AddStringsForLanguage("zh-tw", strings_ZHTW)

    -- ====================================================================================================================
end
