To see all commits, including all alpha changes, [*go here*](https://github.com/tflo/Move-em-All/commits/master/).

---

## Releases

#### 2.3.2 (2025-09-14)

- Standardized licensing information in the files.
- ReadMe/description: minor changes; added my new addon [Auto Discount Repair](https://www.curseforge.com/wow/addons/auto-discount-repair) to the “Other addons” list.

#### 2.3.1 (2025-08-20)

- With Mail Safety enabled: Instead of the generic “no valid destination” message you now get a dedicated message when the mail frame is open but the “Send mail” tab is not active.
    - Reminder: If you make it a habit to always use your MEA modifier key when transferring items to the mail (even if it’s a single item), then it will never happen that you accidentally eat the expensive Augment Rune that you just wanted to send to your AH toon!
- Refactored event handling.

#### 2.3 (2025-08-06)

- Basic compatibility with TWW 11.2 (char bank rework, removal of reagent bank and void storage).
    - So far only (briefly) tested with Blizz Bags/Bank and with Baganator.
    - It’s likely that there comes up a glitch or two; you’ll see an update then in the next days.
    - If you find glitches or incompatibilities with other addons yourself, feel free to open a ticket on the [issue tracker](https://github.com/tflo/Move-em-All/issues) (please do _not_ post issues to the CurseForge comments thread).
- toc: Set interface to `110200`

#### 2.2.4 (2025-06-18)

- toc: Added `AllowAddOnTableAccess: 1`
- toc: Bumped Interface to `110107`

#### 2.2.3 (2025-04-23)

- toc bump to 110105.
    - Seems to work fine, but not done many tests.
    - But let’s face it, get over yourself and tick that damn “Load out of date AddOns” checkbox. This (i.e not ticking this) is a 100% hypocritical assessment. If an addon author isn’t in the mood to do big revisions, he will just bump that toc number anyway. And you’ll end up with the errors, with or w/o checkbox. That’s what hypocritical means (in this context).
    - Blizz could introduce a real check, that is, checking against some crucial API changes in the last release. This would not cost much (but a bit more than now), but yeah it’s Blizz, only the most cheapest and rotten and fake for us customers.
    
#### 2.2.2 (2025-02-26)

- Added category to toc.
- toc bump to 110100.

#### 2.2.1 (2024-12-19)

- toc bump to 110007 (WoW Retail 11.0.7).
- No content changes. If I notice that the addon needs an update for 11.0.7, I will release one.
- I currently do not have much time to play, so if you notice weird/unusual behavior with 11.0.7 and don’t see an update from my part, please let me know [here](https://github.com/tflo/Move-em-All/issues).

#### 2.2.0 (2024-11-07)

- Works now with the Warband Bank (account bank).
    - *From Bags to Warband Bank:* Tested with Blizz UI and Baganator; probably/possibly also works with other addons, but not (yet) tested!
    - *From Warband Bank to Bags:* Tested with Blizz UI; does *not* work with Baganator; not (yet) tested with other addons!
        - Note: Baganator comes with its own mass-transfer functionality. Use this for transfers from Baganator Warband Bank to Bags.
- Some code optimization and cleanup.

#### 2.1.8 (2024-10-23)

- toc bump, docs.
- No content changes.

#### 2.1.7 (2024-07-24)

- Should now work with TWW bank (normal and reagent). Cannot test with Warband Bank as it is currently unavailable in my region.
- Guild bank is fine too.
- More tests will follow.
- toc updated for TWW 110000.

#### 2.1.6 (2024-05-08)

- toc bump only (100207). Addon update will follow as needed.

#### 2.1.5 (2024-03-19)

- toc bump only. If necessary, the addon will be updated in the next days.

#### 2.1.4 (2024-03-13)

- Safer transfers to mailbox: Added a check to make sure we are in the Send Mail frame (not Inbox) when executing. Unfortunately, with this safeguard MEA no longer works with TSM Mail or any other mail addon where the Blizzard Send Mail button is not visible. (Though you can disable it, see below.)
    - Background: If you right-click an item in your bags while the mailbox is open and you're still in the inbox, the item will be _used_ (i.e. consumed or equipped). This is standard Blizz behavior and not a bug in this addon. When you hold down your MEA modifier key, this default behavior is applied to all items with the same ID. So this safety should protect you from accidentally _using_ all items instead of sending them.
    - I added this because the "accident" actually happened to me: I crafted 8 'Draconium Fisherfriend' and wanted to 1-click-move them to the mailbox to send them to my AH toon. Unfortunately, the inbox frame was active and I didn't pay attention, so the result of my click was that I equipped all 8 Fisherfriend, which turned them into garbage, as they are now soulbound...
    - The same problem exists with the TSM mailbox, but I haven't found a reliable way to detect if we are in 'send mode', so this safeguard will effectively disable MEA for TSM mailing.
    - If you are aware of the potential pitfall, you can disable (and re-enable) the safety with `/mea togglemailsafety`, which also restores functionality with TSM. Though I recommend to leave it enabled, and for mass-moving just switch to the Blizz Mail UI.

#### 2.1.3 (2024-01-16)

- Just a toc bump for 10.2.5. Compatibility update will follow if needed.

#### 2.1.2 (2023-11-08)

- toc update 100200; no content changes.

#### 2.1.1 (2023-09-27)

- Added info to the readme that it also works with the TSM (TradeSkillMaster) mailbox, which may not have been obvious.
- Other corrections to the readme.

#### 2.1 (2023-09-07)

- You can now set the guild bank delay with `/mea gb <delay>`. For example `/mea gb 0.45`. Default is 0.6s.
  - The maximum you can set is `1`. `/mea gb 0` (or any number outside the valid range) removes the delay entirely.
- Changed the command to set the global delay (all targets) to `/mea all! <delay>`.
  - The global delay is not enabled by default, and there should be no need to enable it!
  - You may want to try it if you are experiencing significant server lag that is affecting the smooth operation of MEA.
  - If the global delay is longer than the guild bank delay, it will override the guild bank delay.
- Overhauled in-game help (`/mea h`).
- Added help for delays (`/mea h delay`).
- Improved detection of closed target frame during interaction.
- "Aborting" msg when frame gets closed during transfer.
- Preventing nil math if guild bank delay is disabled.
- Different action feedback msg for delayed transfers ("Trying to move…" instead of "Probably moved…").
- Minor optimizaions.
- Updated Readme.
- toc bump to 100107.

#### 2.0.2 (2023-07-23)

- Some code fixes.
- Updated readme.

#### 2.0.1 (2023-07-12)

- Fixed some stuff in the readme.
- toc updated for 10.1.5.
  - I have not yet had a chance to really test the addon with 10.1.5, but as far as I know there are no relevant API changes. If I find any problems, you'll get a content update soon.

#### 2.0 (2023-05-24)

- Quite big version jump for a fresh addon you think?
  - True, but you get a bunch of new stuff, and the addon works pretty well right now, so I don’t think there will be more major version changes in the foreseeable future. So the jump from 1.0 to 2.0 rather marks the addon coming out of its adolescence ;)
- Unlocked Void Storage as target.
- Unlocked Guild Bank as target.
  - For Guild Bank, a delay of currently 0.6s is used.
- Added option to set delays also for regular item moves:
  - For this, just type e.g. `/mea 0.2` for a delay of 0.2 seconds.
  - The allowed range for delays is `0` trough `1`.
  - Any numeric value outside the range will disable the delay. (E.g. `/mea 2` will disable the delay, or `/mea -1` will disable it too.)
  - Typing `/mea 0` is not a way to completely disable the delay, it is just the min value for the C_Timer, possibly a bit below 0.01, depending on your frame rate).
- Updated description

#### 1.0 (2023-05-10)

- Initial CurseForge upload.
- Fixed the Reagent Bank problem.
  - Blizz Reagent Bank frame is now auto-detected.
  - For other bag addons we use a second modifier key to force-send items to the Reagent Bank.
  - Greatly improved help text and chat UI.

#### 0.9 (2023-05-10)

- Initial GH upload.
