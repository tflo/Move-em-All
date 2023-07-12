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
  - The allowed range for delays is `0` trough `1`
  - Any numeric value outside the range will disable the delay. (E.g. `/mea 2` will disable the delay, or `/mea -1` will disable it too.)
  - Typing `/mea 0` is not a way to completely disable the delay, it is just the min value for the C_Timer, possibly a bit below 0.01, depending on your frame rate).
- Updated description

#### 1.0 (2023-05-10)
- Initial CurseForge upload
- Fixed the Reagent Bank problem
  - Blizz Reagent Bank frame is now auto-detected
  - For other bag addons we use a second modifier key to force-send items to the Reagent Bank
  - Greatly improved help text and chat UI

#### 0.9 (2023-05-10)
- Initial GH upload.

