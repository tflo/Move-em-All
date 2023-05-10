# Move 'em All

This addon allows you to mass move all items of the same item ID with a single mouse click.

Currently the moving works from Bag to…

- Bank
- Mail
- Merchant
- Trade

…and from Bank to Bag.

## Usage

To mass move, click an item with the set mouse button while holding the set modifier key down. The defaults are Right mouse button and Command key for macOS, and Right mouse button and Shift key for Windows.

You can customize mouse button and modifier key to your liking with slash commands:
Type `/mea` followed by one of these keywords: For the mouse button `left`, `right`; for the modifier key `shift`, `command` (macOS), `control`, `option` (macOS), `alt` (Windows).

If you type just `/mea`, it will show you the currently set mouse button and modifier key, and the list of available keywords.

## Compatibility

It works with Blizz's bags and with AdiBags, very likely also with many other bag addons. Feel free to test it out and let me know.

It seems to work fine with Postal too.

## Notes

Technically, the addon works the same way as the old [ShiftRight](https://www.curseforge.com/wow/addons/shift-right) addon, which was abandoned in 2015 but still worked fine in Shadowlands.

My original plan was to "quickly" patch the old ShiftRight, but the Dragonflight API changes are quite hefty, so I basically ended up with a complete rewrite.

Currently, guild bank moving is disabled because the guild bank is so slow that I would have to implement a throttling system just for that. Not sure if this is worth it.



Feel free to post suggestions or issues in the [GitHub Issues](https://github.com/tflo/MoveEmAll/issues) of the repo!
__Please do not post issues or suggestions in the comments on Curseforge.__
