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
