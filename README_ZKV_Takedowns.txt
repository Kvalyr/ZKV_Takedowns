-- ====================================================================================================================
-- Finisher & Takedown Overhaul (ZKV_Takedowns) by Kvalyr for CP2077
-- =========================================================
:: Adds the following features ::
♦ Melee Weapon finishers as stealth takedowns (Configurable, and extensible with new animations from other mods)
♦ Takedowns without grappling first - Initiate grapple OR takedown from stealth (See screenshots)
♦ Mantis Blades finisher: Use aerial takedown animation instead of normal finisher animation, either 50% of the time or all the time (See screenshots)
    • The aerial takedown animation works surprisingly well from a standing position, and arguably looks better and less janky than the normal Mantis Blades finisher.


:: Configuration ::
♦ There is a configuration UI using 'Native Settings UI'.


:: Known Issues ::
♦ Lack of suitable takedown animations for most weapons
    • This mod does not add fully 'new' animations yet - It just reuses and repurposes animations already in the game by kitbashing them together.
    • Some weapons don't have great takedown animations and share some default takedowns.
♦ Existing CP2077 problems with T-posing, bad ragdolls, un-synced animations, etc.
    • The base game's implementations of Takedowns, Finishers, Ragdolls and synced-animations are flaky already without mods. Don't expect perfection here.
♦ Takedowns with blunt weapons being lethal when "Non-lethal blunt" is enabled:
    • This should be fixed as of 0.4.0, but there may still be instances of it occurring. If you absolutely must not kill the target, use a normal grapple->takedown

:: Future Plans ::
♦ More animations (Unlikely, as I'm not an animator - but if another mod adds new takedowns or finishers, this mod will automatically support them)
♦ Reduce control & camera lock-in during finishers & takedowns
♦ Optionally speed up some finishers that feel too slow in the midst of combat
♦ Weapon XP for kills with weapons


:: Requirements ::
♦ Cyberpunk 2077 v1.61
♦ Cyber Engine Tweaks (latest version) ( https://www.nexusmods.com/cyberpunk2077/mods/107 )
♦ redscript (latest version) ( https://www.nexusmods.com/cyberpunk2077/mods/1511 )
    • cybercmd (If using redmod) ( https://www.nexusmods.com/cyberpunk2077/mods/5176 )
♦ Native Settings UI (latest version) ( https://www.nexusmods.com/cyberpunk2077/mods/3518 )


:: Installation
♦ Install manually by extracting the bin, archive and r6 folders to your CP2077 main folder. (Drag and drop from the .zip)
♦ Vortex installation is not supported. It might work, it might not. I don't use Vortex myself and can't help you with it.


:: Compatibility & Technical details ::

The following redscript methods are replaced:
♦ TakedownUtils.TakedownActionNameToEnum()
♦ TakedownExecuteTakedownEvents.OnEnter()
♦ LocomotionTakedownEvents.SelectSyncedAnimationAndExecuteAction()
♦ DamageSystem.PlayFinisherGameEffect()
♦ ScriptedPuppetPS.GetValidChoices()

The following workspots were modified:
♦ archive\base\gameplay\workspots\takedowns\takedowns_mantisblades\enemy_aerial_takedown_back_mantisblades.workspot
♦ archive\base\gameplay\workspots\takedowns\takedowns_mantisblades\enemy_aerial_takedown_forward_mantisblades.workspot
♦ archive\base\gameplay\workspots\takedowns\takedowns_mantisblades\player_aerial_takedown_back_mantisblades.workspot
♦ archive\base\gameplay\workspots\takedowns\takedowns_mantisblades\player_aerial_takedown_forward_mantisblades.workspot
(The only modification was adding the necessary tags to these workspots to give the player the same invulnerability during this takedown animation as they get during finishers)


Mods that also modify/replace the above functions/files will likely be incompatible with this mod.
Known compatibility risks:
♦ Breach Takedown by Scissors123454321 ( https://www.nexusmods.com/cyberpunk2077/mods/4808 )
    • ZKV_Takedowns and Breach Takedown both modify the `LocomotionTakedownEvents.SelectSyncedAnimationAndExecuteAction` method; but this mod incorporates the same fix to that method and as long as this mod loads last, they might work okay together. No guarantees.
    • I'll make changes for compatibility if necessary in a later version.


::  CREDITS ::
♦ The developers behind Cyber Engine Tweaks & redscript, without which this mod wouldn't be possible whatsoever
♦ The CP2077 modding discord members for answering questions


:: Source Code ::
GitHub link to follow
