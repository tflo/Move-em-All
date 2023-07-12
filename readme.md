# Move ’em All

This addon, let’s call it MEA, allows you to mass move all items of the same item ID with a single mouse click, e.g. between bank and bags.

The good things about MEA are:

- It is pretty fast.
- It is compatible with many, probably most, bag addons.

The price for this is a few (minor) caveats, which you can find in the "Caveats" section below.

Currently the mass moving works from Bag to…

- Bank
- Mail
- Merchant
- Trade
- Guild Bank (new since v2.0)
- Void Storage  (new since v2.0)

…and from Bank to Bag.

## Usage

To mass move, click an item with the set mouse button while holding the set modifier key down. The __defaults__ are __Right mouse button__ and __Command key__ for __macOS,__ and __Right mouse button__ and __Shift key__ for __Windows.__

You can __customize__ mouse button and modifier keys to your liking with slash commands:

Type `/mea` followed by one of these keywords: For the mouse button `left`, `right`; for the modifier key `shift`,
`command` (macOS), `control`, `option` (macOS), `alt` (Windows).  

Example: `/mea left` sets the mouse button to the left one, `/mea shift` sets the modifier key to Shift.

In addition, MEA has a modifier key for moving stuff to the __Reagent Bank.__ You can customize it with `/mea rea`, for example `/mea rea control`. By __default,__ it’s set to __Alt/Option.__ More on that in the Caveats section below.

If you type just `/mea`, it will show you the currently set mouse button and modifier keys. Type `/mea help` for the list of available keywords and other info.

## Caveats

### Dumb

The addon is lightweight, super fast - and dumb. (And I actually plan to keep it more or less that way).

‘Dumb’ means:

- It does not check if the clicked items actually have all arrived (e.g. when the bank is full). So, when it prints “Probably moved 12x [Shrouded Cloth]” to the chat, this is actually an optimistic estimation. Hence the “probably” word ;)
- It doesn’t know or care if a bag slot holds a single item or a stack of 1000, it always reports back the number of slots it has “moved”, which can be stacks or single items.

### Reagent Bank

When moving stuff from the bags to the bank, by default, the addon moves reagents to the regular bank bags, not to the Reagent Bank. With the Blizz standard bank, it recognizes the Reagent Bank frame and moves the items there if the frame is visible.

However, this does not work if a bag/bank addon replaces the Blizz Reagent Bank frame with its own. Unfortunately, the vast majority of bag addons does this. This is where the aforementioned _Reagent Bag modifier key_ comes into play: To mass move your items to the Reagent Bank, you have to hold down that additional modifier key.

While intended as a workaround, this modifier key actually has a useful side effect: When the key is down, MEA moves items to the Reagent Bag even when the frame is not visible. This allows you to distribute items between the Reagent Bag and the normal bank without having to switch between the two frames.

### Guild bank

With version 1 of MEA, mass moving things to the guild bank was disabled because the guild bank has such a slow response time that I would have to implement a throttling system just for that.

New _and experimental:_ With v2.0, the Guild Bank is now enabled as mass move target. Using a very primitive throttling, the items are moved with a delay of 0.6s. This seems to work so far, though sometimes it happens that not all items are moved with one click.

## Compatibility

MEA works flawlessly with _Blizzard’s bags_ and with _AdiBags,_ very likely also with many other bag addons. I briefly tested it with: _ArkInventory, Baud Bag, LiteBag, Bagnon,_ and haven’t noticed any issues. (By the way, LiteBag uses the standard Blizz Reagent Bank frame, which is an advantage here.)

It works fine with _Easy Mail_ and _Postal_ too.

## Notes

At its core, MEA works the same way as the old [ShiftRight](https://www.curseforge.com/wow/addons/shift-right) addon, which was abandoned in 2015 but still worked fine in Shadowlands.

My original plan was to "quickly" patch the old ShiftRight addon, but thanks to the Dragonflight API changes, this plan failed miserably. So I basically ended up with a complete rewrite, which is this addon.

I hope you enjoy it!

---

Feel free to post suggestions or issues in the [GitHub Issues](https://github.com/tflo/Move-em-All/issues) of the repo!
__Please do not post issues or suggestions in the comments on Curseforge.__

---

__My other addons:__

- [___PetWalker___](https://www.curseforge.com/wow/addons/petwalker): Never lose your pet again (…or randomly summon a
  new one).
- [___Auto Quest Tracker Mk III___](https://www.curseforge.com/wow/addons/auto-quest-tracker-mk-iii): Continuation of
  the one and only original. Up to date and new features.
- [___Auto-Confirm Equip___](https://www.curseforge.com/wow/addons/auto-confirm-equip): Less (or no) confirmation
  prompts for BoE gear.
- [___Action Bar Button Growth Direction___](https://www.curseforge.com/wow/addons/action-bar-button-growth-direction):
  Fix the button growth direction of multi-row action bars to what is was before Dragonflight (top --> bottom).
- [___EditBox Font Improver___](https://www.curseforge.com/wow/addons/editbox-font-improver): Better fonts for
  your macro/script edit boxes.
