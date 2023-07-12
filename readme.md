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

To mass move, click an item with the set mouse button while holding the set modifier key down. The defaults are Right mouse button and Command key for macOS, and Right mouse button and Shift key for Windows.

You can customize mouse button and modifier keys to your liking with slash commands:

Type `/mea` followed by one of these keywords: For the mouse button `left`, `right`; for the modifier key `shift`, `command` (macOS), `control`, `option` (macOS), `alt` (Windows).

In addition, MEA has a modifier key for moving stuff to the Reagent Bank. You can customize it with `/mea rea`, for example `/mea rea control`. By default, it’s set to Alt/Option. More on that in the Caveats section below.

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

Currently, mass moving things to the guild bank is disabled because the guild bank has such a slow response time that I would have to implement a throttling system just for that. And with that, moving items individually probably wouldn’t be much slower. Not sure if this is worth it.

New _and experimental_: With v2.0, I have enabled the Guild Bank as mass move target. Using a very primitive throttling, the items are moved with a delay of 0.6s. This seems to work so far, though sometimes it happens that not all items are moved with one click.


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
