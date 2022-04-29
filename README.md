# Smalls

> “Smalls”: _noun, plural noun: 1. informal, british -- small items of clothing, especially underwear._

Whilst adventuring in Skyrim SE, you tend to run across all sorts of bandits, ruffians and ne'er-do-wells. Typically it all goes south, you end up in a big fight, and then you loot the bodies for armour and treasure.

If you're running with [a mod that replaces the default skin with a naked one](https://www.nexusmods.com/skyrimspecialedition/mods/198), it's a bit disconcerting to discover that everyone whose armour you loot seems to be going commando. What's up with that? Didn't their mothers warn them that they might meet a sticky end one day and thus clearly ought to pack some clean underwear for their trip just in case?

This mod attempts to fix this problem in the least intrusive way possible.

## How It Works

Smalls keeps a list of male and female underwear items to use (which can be configured - see below).

When a new NPC is encountered, it is checked to see if its inventory includes known items of underwear, or if it is wearing an item which occupies a body slot typically used for underwear.

If not, an item of underwear is randomly assigned to it, and added to its inventory.

If you later kill the NPC and open its inventory to loot it, you should find that the NPC has an item of underwear. 

If the underwear is equipped already, there's nothing more to do.

If not, Smalls will monitor what you remove. If you remove the main clothing item (the one that occupies the body slot), Smalls will equip the underwear to replace it.

## Armour, Clothing, Underwear and Slots

Any piece of armour/clothing in Skyrim is tagged as occupying one or more body slots. 

Most armours and outfits use the main body slot (32), which roughly means that the item covers the torso and legs.

When you equip an item, anything else using the same slot is unequipped. This is why you can't wear two sets of armour at the same time.

Smaller items - gloves, shoes, hats, etc - use different slots. Hence you can wear a hat, gloves, and boots, along with your main armour. Again though, only one item can be in each of the slots so if you equip a second pair of boots using the feet slot, the first pair will be unequipped.

So what about underwear?

In the vanilla Skyrim experience underwear is built into the actual skin of the body, so it isn't really accounted for at all. It doesn't occupy a slot, and is always magically "worn" under the armour.

Body replacement mods that make the skin naked instead effectively remove this fake underwear. To add something back, you have to equip an additional item of clothing.

Many of the mods which add underwear are simply designed to provide a skimpy outfit which is worn instead of armour/clothing. For this reason, they use the main body slot, and if you equip an item like this, any other armour or clothing in that slot is removed. 

### Immersion, Layering & Dressing Up

Having underwear items that occupy the main body slot works fine if the objective is just to have the character in question parade around in their undies. You equip the underwear, and the outerwear is automatically unequipped. 

This is how a lot of the mods that provide underwear are set up.

Unfortunately this isn't very immersive. 

If you are aiming for something a bit more realistic, what you really want is to allow the character to wear one or more underwear items along with their main clothing items. Ideally they should be covered by the main clothes, but show through any holes or semi-transparent areas.

This isn't just true for underwear of course, but for any sort of layered clothing. You might want a character to have an undershirt, with a shirt over it, a coat over that, and a cloak on top!

This is where the other body slots come in to play. In theory each of these items could have a different slot, and then they can all be equipped together. A few underwear sets have been designed with this in mind. With underwear sets this is generally so that you can mix-and-match different tops, bottoms, accessories, etc.

However, being able to equip multiple items in different slots doesn't guarantee that they actually render in the right order. Each item is modelled differently, and different sets have been modelled independently by different people. 

Unfortunately there is nothing intelligent going on behind the scenes, so if you equip some underwear and some outerwear, and the underwear was modelled to poke out further from the body than the outwear was, that's what will happen. Typically this isn't an all-or-nothing situation, but instead you'll see bits of one item poking through or clipping bits of another item.

### How Smalls Deals With This

Ultimately Smalls can't solve these problems, and in general it can't know for sure whether any given piece of underwear is going to work with any other bit of clothing.

What it can do is look at the body slots assigned to an item, and make some guesses.

When it first examines an NPC (which will be when you get fairly close to them, but before you encounter them), it looks for items that are using body slots generally reserved for underwear. Unfortunately even which slots to use isn't standardised completely, but it makes a best guess.

If it finds that the NPC has something tagged as underwear, it doesn't give them any more. Otherwise it gives an a randomly selected item from the list it has been configured with.

If the randomly selected item is using underwear slots, then Smalls will try to equip it right away. This is better in theory as it means that the NPC will be wearing the item along with the rest of their gear when you encounter them. It may look bad though if the item clips. There's nothing that Smalls can do to detect this, so eventually I will add some options to turn this behaviour off, either for invidual kinds of items, or for all items.

If on the other hand the randomly selected item is using the main body slot, then Smalls can't equip it right away. If it did, the NPC's outer clothing would be replaced and everyone would be walking around in their underwear the whole time (maybe you want an mod like that... but it isn't what Smalls is trying to achieve).

So what it does in this situation is just add the item to the NPC's inventory. Later when you are looting the NPC, Smalls watches for you removing the main piece of clothing, and quickly equips the underwear item when you do. This works, but can result in a brief flash where the NPC appears to be naked. This isn't ideal, but it's the best that can be managed in this situation.

### 










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
