# Smalls

Whilst adventuring in Skyrim SE, you tend to run across all sorts of bandits, ruffians and ne'er-do-wells. Typically it all goes south, you end up in a big fight, and then you loot the bodies for armour and treasure.

If you're running with [a mod that replaces the default skin with a naked one](https://www.nexusmods.com/skyrimspecialedition/mods/198), it's a bit disconcerting to discover that everyone whose armour you loot seems to be going commando. What's up with that? Didn't their mothers warn them that they might meet a sticky end one day and thus clearly ought to pack some clean underwear for their trip just in case?

This mod attempts to fix this problem in the least intrusive way possible.

## How It Works

There are two basic approaches to this problem.

One (as used by [Equipable Underwear For Everyone](https://www.nexusmods.com/skyrimspecialedition/mods/17183)) is to patch up all-the-things, so that all characters and NPCs already have underwear on by the time you meet them.

This is a bit complicated, and has some inherent problems. It also really needs to be done at the start of the game, and it's tricky to add or remove the mod at other times without leaving things in a bit of a mess.

The other approach is much simpler - I call it "Just In Time Underwear". We leave absolutely everything in the game world alone, until you interract with a dead character. At that point, if you steal their clothes, we quickly add back some underwear, so that they appear to be modestly dressed.

There are some problems with this approach too. The main one is that the immersion is imperfect, since you usually get a brief flash of them naked before the underwear appears. On the other hand, it is minimally intrusive and can be enabled/disabled at any point.

As you have probably guessed, Smalls takes the second approach.

## Configuration

By default, Smalls uses underwear from a few mods that it knows about, if they are installed.

However, you can edit the underwear list to add your own items, via an MCM configuration panel.

Each item that Smalls knows about can be set to one of the following modes:

- unisex; used for males and females
- male; used for males only
- female; used for females only
- female top; used for females only, where the first item added appears to be bottom-only
- ignore; smalls knows that this is underwear, but doesn't use it
- remove; when you close Smalls, this item will be removed from the list of known underwear

If you have more than one item in a category, a random choice is made. If the female item appears to cover the whole body, it is used on its own. If not, a female top item is added too.

This is not very sophisticated, and does not yet try to match tops & bottoms, or pick appropriate underwear for specific profession, races, tribes, etc. All of these considerations are things I'd like to improve, but... you've got to start somewhere.

Smalls tries to detect the type of an item automatically, but the detection is based on the slot flags set by the armor author. These flags are often inconsistent, and underwear armor is often not designed to be worn along with other items, which means that sometimes the slot flags are just set as "body".

### How To Add Armour

Make sure that the armour you want to add is in your inventory.

Open up the Smalls / Add Item panel in MCM.

Tick the items you want to add, then switch back to the Current Items panel. The item you've added should now be in the list. By default it will

Smalls has to guess which lists to add the item to, based on the slot positions it's marked for, and whether it has meshes set for male, female or both. This information isn't always reliable, so sometimes underwear will be added to the wrong lists. You can fix this yourself by removing the armour from some lists.

### How To Remove Armour

Open up the Smalls / Current Items panel in MCM.

Set the items you want to remove to "remove", then dismiss MCM (or switch away from the Smalls panel).


## Dependencies

The only dependency is SkyUI, which is used for the configuration menu.

Smalls is compatible with UNP, CBBE, etc. Just use whatever underwear you want.

Smalls knows about certain mods that add underwear, and it pre-populates its list if it detects that they are present. If you have a favourite mod you'd like Smalls to know about, please let me know and I will add it.

## Known Issues

Smalls used to contain custom underwear items, but no longer does. If you were using a previous version of Smalls, some underwear items may disappear when you upgrade. This should be a one-time problem.

Smalls makes new underwear when it needs it, so you could obviously use this mod in theory to farm underwear. If that floats your boat, then go for it. You weirdo ;). However, since the basic point of the mod is to add immersion / realism (of a sort), I'm just going to assume that anyone using it is unlikely to feel that particular urge, and I'm not going to treat it as a problem.

## Improvements

If anyone is interested, I'd like to expand this mod. Things I'm considering:

- a way to tag underwear sets so that they are applied together
- a way to tag underwear to be used for a particular race, class, or wealth level
- a way to apply specific underwear to known NPCs, so that their underwear matches their outerwear
- (possibly) a way to use this mod when interacting with followers (whilst they are still alive!), in order to automatically outfit them with underwear

## Installation

Use a mod manager. You know it makes sense.


## Source Code

The source for this mod can be found on [github](https://github.com/scorpiosixnine/smalls).



## Credits

I came up with approach after getting into a mess with [Equipable Underwear For Everyone](https://www.nexusmods.com/skyrimspecialedition/mods/17183).

I later discovered [Underpants](https://www.loverslab.com/files/file/1878-underpants/), which works the same way. I wasn't sure whether it was ported to SE yet, and in any case I wanted to learn how to mod, so I decided to make my own. Whilst I didn't copy any of the Underpants code, taking a look at how it worked was invaluable. So props to [periselene](https://www.loverslab.com/profile/786664-periselene/) for making the source available.

Thanks also to [CBBE](https://www.nexusmods.com/skyrimspecialedition/mods/198), [Tempered Skins For Males](https://www.nexusmods.com/skyrimspecialedition/mods/7902), SOS, etc, for making this mod necessary in the first place.
