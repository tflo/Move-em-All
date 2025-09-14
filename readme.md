# Move ’em All

This addon, let’s call it MEA, allows you to mass move all items of the same item ID with a single mouse click, e.g. between bank and bags.

The good things about MEA are:

- It is pretty fast.
- It is compatible with many, probably most, bag addons. For Warband Bank see “Warband Bank” in the “Compatibility” section below.

The price for this is a few (minor) caveats, which you can find in the "Caveats" section below.

**Currently the mass moving works from Bags to…**

- Character Bank
- Warband Bank (account bank)
- Mail
- Merchant
- Trade
- Guild Bank

…and from Char/Warband Bank to Bags.

___If you’re having trouble reading this description on CurseForge, you might want to try switching to the [REPO PAGE](https://github.com/tflo/Move-em-All?tab=readme-ov-file#move-em-all). You’ll find the exact same text there, but it’s much easier to read and free from CurseForge’s rendering errors.___

## Usage

To mass move, click an item with the set mouse button while holding the set modifier key down. The __defaults__ are __Right mouse button__ and __Command key__ for __macOS,__ and __Right mouse button__ and __Shift key__ for __Windows.__

You can __customize__ mouse button and modifier keys to your liking with slash commands:

Type `/mea` followed by one of these keywords: For the mouse button `left`, `right`; for the modifier key `shift`,
`command` (macOS), `control`, `option` (macOS), `alt` (Windows).  

Example: `/mea left` sets the mouse button to the left one, `/mea shift` sets the modifier key to Shift.

If you type just `/mea`, it will show you the currently set mouse button and modifier keys. Type `/mea help` for the list of available keywords and other info.

## Caveats

### Dumb

The addon is lightweight, super fast - and dumb. (And I actually plan to keep it more or less that way).

‘Dumb’ means:

- MEA simply applies the default right-click action to all items with the same ID. Of course, it only does this if it detects a valid destination to move the items to (e.g. open bank, merchant, mailbox, …).
- It does not check if the clicked items actually have all arrived (e.g. when the bank is full). So, when it prints “Probably moved 12x [Shrouded Cloth]” to the chat, it means what is says: it’s an optimistic estimation. 
- It doesn’t know or care if a bag slot holds a single item or a stack of 1000, it always reports back the number of slots it has “moved”, which can be stacks or single items.


### Guild bank

With version 1 of MEA, mass moving things to the guild bank was disabled because the guild bank has such a slow response time that I would have to implement a throttling system just for that.

Since v2.0, the Guild Bank is now enabled as mass move target. Using a very primitive throttling, the items are moved with a delay of 0.6s. This seems to work so far, though sometimes it happens that not all items are moved with one click.

You can change the default delay (0.6s) with `/mea gb <delay>` (for example `/mea gb 0.45`). You can set anything > 0 and <= 1. `/mea gb 0` (or any number outside the valid range) removes the delay entirely (not recommended).

The sweet spot seems to be somewhere around 0.5/0.6s. The longer the delay, the more reliable the mass movement will be (fewer failed moves). However, if you usually move a small number of items (less than 10 slots), or the guild bank on your server is faster than mine, you may want to play around with shorter delays.

## Compatibility

MEA works flawlessly with Blizzard’s bags, and – _at least before WoW TWW 11.2_ – with LiteBag, Baganator, very likely also with many other bag addons. I briefly tested it with ArkInventory, Baud Bag, Bagnon, and haven’t noticed any issues. _Under TWW 11.2 only tested with Blizz UI and Baganator._

Note: Baganator comes with its own mass-transfer functionality, which is highly configurable (e.g. by category, by search filters). So if you use Baganator, I recommend using this for _large_ transfers. It also tends to work faster than MEA.

### Mail

MEA works with the Blizz Mail UI and addons that are using the Blizz Mail UI (e.g. EasyMail, probably Postal too). It _can_ work with TSM Mail (see “Mail safety”).

#### Mail safety

For safety reasons, out of the box MEA does not work with TSM Mail or any mail addon that hides the Blizzard Send Mail button. Point of this is to prevent that you accidentally consume or equip an item when you right-click it while the “Inbox” tab is active.

You can disable (and re-enable) the safety with `/mea togglemailsafety`, which will also grant functionality with TSM. 

If you do this, please make sure that the Send Mail UI (not the Inbox!) of Blizz Mail (or whatever Mail addon) is actually active before clicking on an item with MEA. If the Inbox is active (and the safety disabled), the item(s) will be _used_ (consumed or equipped) instead of being sent! (With some item types you may get an “Action Blocked” popup, which is a good thing in this particular case.)

*I recommend to leave the safety enabled,* even if you use TSM, and for mass-moving with MEA just switch to the Blizz Mail UI.

Please note that the described behavior is not a bug in MEA, this is the standard Blizz behavior when you right-click an item against the Mail _Inbox._ The thing is, with MEA, the consequences of such a misclick can be more dire, since it potentially affects multiple items. Hence the protection. 

Actually, with the protection, MEA is safer than Blizz’s default behavior, since a MEA click does absolutely nothing when the Inbox tab is active.

Tip: If you make it a habit to always use your MEA modifier key when transferring items to the mail (even if it’s a single item), then it will never happen that you accidentally eat the expensive Augment Rune that you just wanted to send to your AH toon!
  

## Notes

At its core, MEA works the same way as the old [ShiftRight](https://www.curseforge.com/wow/addons/shift-right) addon, which was abandoned in 2015 but still worked fine in Shadowlands.

My original plan was to "quickly" patch the old ShiftRight addon, but thanks to the Dragonflight API changes, this plan failed miserably. So I basically ended up with a complete rewrite, which is this addon.

I hope you enjoy it!

---

Feel free to share your suggestions or report issues on the [GitHub Issues](https://github.com/tflo/Move-em-All/issues) page of the repository.  
__Please avoid posting suggestions or issues in the comments on Curseforge.__

---

__Other addons by me:__

- [___PetWalker___](https://www.curseforge.com/wow/addons/petwalker): Never lose your pet again (…or randomly summon a new one).
- [___Auto Quest Tracker Mk III___](https://www.curseforge.com/wow/addons/auto-quest-tracker-mk-iii): Continuation of the one and only original. Up to date and tons of new features.
- [___Auto Discount Repair___](https://www.curseforge.com/wow/addons/auto-discount-repair): Automatically repair your gear – where it’s cheap.
- [___Auto-Confirm Equip___](https://www.curseforge.com/wow/addons/auto-confirm-equip): Less (or no) confirmation prompts for BoE gear.
- [___Action Bar Button Growth Direction___](https://www.curseforge.com/wow/addons/action-bar-button-growth-direction): Fix the button growth direction of multi-row action bars to what is was before Dragonflight (top --> bottom).
- [___EditBox Font Improver___](https://www.curseforge.com/wow/addons/editbox-font-improver): Better fonts for your macro/script edit boxes.

__WeakAuras:__

- [___Stats Mini___](https://wago.io/S4023p3Im): A *very* compact but beautiful and feature-loaded stats display: primary/secondary stats, *all* defensive stats (also against target), GCD, speed (rating/base/actual/Skyriding), iLevel (equipped/overall/difference), char level +progress.
