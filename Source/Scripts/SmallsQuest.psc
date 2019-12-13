Scriptname SmallsQuest extends Quest
{Main smalls quest script}

ReferenceAlias property rTarget auto
Perk property rPerk auto
FormList property rDefaults auto
FormList property pTops auto
FormList property pFemale auto
FormList property pMale auto

bool property pEnabled auto
bool property pReplaceMales auto
bool property pReplaceFemales auto

int property kBodySlot = 0x000004 AutoReadOnly ; BODY
int property kPelvisUnderwearSlot = 0x400000 AutoReadOnly ; Underwear pelvis
int property kTorsoUnderwearSlot = 0x04000000 AutoReadOnly ; Underwear chest
int property kMiscSlot = 0x040000 AutoReadOnly ; Misc slot (used by CBBE standalone top, and maybe others?)

int property kModeUnisex = 0 AutoReadOnly
int property kModeMale = 1 AutoReadOnly
int property kModeFemale = 2 AutoReadOnly
int property kModeFemaleTop = 3 AutoReadOnly
int property kModeDisabled = 4 AutoReadOnly
int property kModeRemove = 5 AutoReadOnly

event OnInit()
  Debug.Notification("Smalls " + GetFullVersionString() + " Initialising.")
  ResetDefaultSmalls()
  SetupPerks()
endEvent

Actor function GetTarget()
  return rTarget.GetActorReference()
endFunction

function SetTarget(ObjectReference ref)
  Actor target = ref as Actor
  if target
    if AlreadyWearingSmalls(target)
      Trace("ignoring target as already wearing smalls " + target.GetName())
    else
      rTarget.ForceRefTo(target)
      (rTarget as SmallsMainScript).TargetUpdated()
      Trace("target set to " + target.GetName() + target.GetFormID())
    endif
  endif
endFunction

function ClearTarget()
  rTarget.Clear()
  Debug("target cleared")
endFunction

bool function AlreadyWearingSmalls(Actor target)
	int count = target.GetNumItems()
	int n = 0
	int items = 0
	while(n < count)
		Form item = target.GetNthForm(n)
		Armor itemAsArmor = item as Armor
		if target.IsEquipped(item) && itemAsArmor
      if rDefaults.HasForm(item)
        Trace(item.GetName() + " is in the item list")
        return true
      elseif IsInTopSlot(itemAsArmor)
        Trace(item.GetName() + " is in a slot used for tops " + SlotsDescription(itemAsArmor))
        return true
      elseif IsInBottomSlot(itemAsArmor)
        Trace(item.GetName() + " is in a slot used for bottoms " + SlotsDescription(itemAsArmor))
			  return true
      endif
		endif
		n += 1
	endWhile
	return false
endFunction

function UpdatedEnabled()
  if pEnabled
    SetupPerks()
  endif
endFunction

function SetupPerks()
  if (pEnabled)
    Debug.Notification("Smalls " + GetFullVersionString() + " enabled.")
    Game.GetPlayer().AddPerk(rPerk)
  else
    Debug.Notification("Smalls " + GetFullVersionString() + " disabled.")
    Game.GetPlayer().RemovePerk(rPerk)
  endif
endfunction

function ResetDefaultSmalls()
  Trace("Resetting default smalls list.")

  if !pFemale || !pMale || !pTops || !rDefaults
    Warning("failed to load lists")
  endif

  rDefaults.Revert()
  pFemale.Revert()
  pMale.Revert()
  pTops.Revert()

  AddDefaultSmall(0x1875, "Shino_Traveling Magician.esp", kModeFemale)
  AddDefaultSmall(0x1876, "Shino_Traveling Magician.esp", kModeFemale)
  AddDefaultSmall(0x1877, "Shino_Traveling Magician.esp", kModeFemale)
  AddDefaultSmall(0x1878, "Shino_Traveling Magician.esp", kModeFemale)
  AddDefaultSmall(0x1879, "Shino_Traveling Magician.esp", kModeFemale)
  AddDefaultSmall(0x187A, "Shino_Traveling Magician.esp", kModeFemale)

  AddDefaultSmall(0xC804, "CBBE Standalone Underwear.esp", kModeFemale)
  AddDefaultSmall(0xC805, "CBBE Standalone Underwear.esp", kModeFemaleTop)

  AddDefaultSmall(0x00790C, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC56, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC5F, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC60, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC61, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC62, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC63, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC64, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC65, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC6F, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC94, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC95, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC98, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC99, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC9A, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC9B, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC9C, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC9D, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC9E, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BC9F, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCA0, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCA1, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCA2, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCB6, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCB7, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCB8, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCB9, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCC2, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCC3, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCD2, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCD4, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCD6, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCD8, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCDA, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCDC, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCDE, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCE0, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCE2, "Remodeled Armor - Underwear.esp", kModeFemale)
  AddDefaultSmall(0x02BCEE, "Remodeled Armor - Underwear.esp", kModeFemale)

  AddDefaultSmall(0xA9EC, "[SunJeong] Nausicaa Lingerie.esp", kModeFemale)
  AddDefaultSmall(0xA9EF, "[SunJeong] Nausicaa Lingerie.esp", kModeFemaleTop)
  AddDefaultSmall(0xB4D9, "[SunJeong] Nausicaa Lingerie.esp", kModeFemaleTop)
  AddDefaultSmall(0xB4DF, "[SunJeong] Nausicaa Lingerie.esp", kModeFemale)

  AddDefaultSmall(0x012DA, "Schlongs of Skyrim.esp", kModeMale)

  AddDefaultSmall(0x02FFF7, "Apachii_DivineEleganceStore.esm", kModeFemale)
  AddDefaultSmall(0x02FFF9, "Apachii_DivineEleganceStore.esm", kModeFemale)
  AddDefaultSmall(0x02FFFB, "Apachii_DivineEleganceStore.esm", kModeFemale)
  AddDefaultSmall(0x02FFFD, "Apachii_DivineEleganceStore.esm", kModeFemale)
  AddDefaultSmall(0x02FFFF, "Apachii_DivineEleganceStore.esm", kModeFemale)
  AddDefaultSmall(0x030001, "Apachii_DivineEleganceStore.esm", kModeFemale)
  AddDefaultSmall(0x03056A, "Apachii_DivineEleganceStore.esm", kModeFemale)
  AddDefaultSmall(0x03103B, "Apachii_DivineEleganceStore.esm", kModeFemale)
  AddDefaultSmall(0x03103E, "Apachii_DivineEleganceStore.esm", kModeFemale)

  AddDefaultSmall(0x0B031B19, "Apachii_DivineEleganceStore.esm", kModeMale)
  AddDefaultSmall(0x0B031B1B, "Apachii_DivineEleganceStore.esm", kModeMale)
  AddDefaultSmall(0x0B031B1B, "Apachii_DivineEleganceStore.esm", kModeMale)
  AddDefaultSmall(0x0B031B1D, "Apachii_DivineEleganceStore.esm", kModeMale)
  AddDefaultSmall(0x0B031B1F, "Apachii_DivineEleganceStore.esm", kModeMale)
  AddDefaultSmall(0x0B031B21, "Apachii_DivineEleganceStore.esm", kModeMale)
  AddDefaultSmall(0x0B031B23, "Apachii_DivineEleganceStore.esm", kModeMale)
  AddDefaultSmall(0x0B031B25, "Apachii_DivineEleganceStore.esm", kModeMale)
  AddDefaultSmall(0x0B031B27, "Apachii_DivineEleganceStore.esm", kModeMale)
  AddDefaultSmall(0x0B031B29, "Apachii_DivineEleganceStore.esm", kModeMale)
  AddDefaultSmall(0x0B031B2B, "Apachii_DivineEleganceStore.esm", kModeMale)
  AddDefaultSmall(0x0B031B2D, "Apachii_DivineEleganceStore.esm", kModeMale)

  AddDefaultSmall(0x0B0320A5, "Apachii_DivineEleganceStore.esm", kModeFemale)
  AddDefaultSmall(0x0B0320A7, "Apachii_DivineEleganceStore.esm", kModeFemale)

  AddDefaultSmall(0x75000D69, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x75000D7E, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x75000D7F, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x75000D80, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x75000D81, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x75000D8C, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x75000D8D, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x75000D8E, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x75000D8F, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x75000D90, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x75006F7B, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x75006F7C, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x750074E6, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x750074E7, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x750074E8, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x750074E9, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x750074EA, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x750074EB, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x750074EC, "CuteMinidressCollection.esp", kModeFemale)
  AddDefaultSmall(0x750074ED, "CuteMinidressCollection.esp", kModeFemale)

EndFunction

function AddDefaultSmall(int formID, String filename, int mode = -1)
  Armor item = Game.GetFormFromFile(formID, filename) as Armor
  if item
    Trace("added default: " + item.GetName() + " (" + filename + ") slots: " + SlotsDescription(item))
    AddSmall(item)
    if mode == -1
      mode = DefaultModeForSmall(item)
    endif
    SetModeForSmall(item, mode)
  else
    Trace(filename + " " + formID + " missing")
  endif
endFunction

function AddSmall(Armor item)
  if !rDefaults.HasForm(item)
    rDefaults.AddForm(item)
  endif
endFunction

int function DefaultModeForSmall(Armor item)
  bool isTop = IsInTopSlot(item)
  bool isBottom = IsInBottomSlot(item)
  if (isTop && !isBottom)
    ; definitely a top
    return kModeFemaleTop
  else
    if HasMesh(item, false)
      return kModeMale
    endif
    if HasMesh(item, true)
      return kModeFemale
    endif
  endif
  return kModeDisabled
endFunction

int function ModeForSmall(Armor item)
  bool inMale = pMale.HasForm(item)
  bool inTops = pTops.HasForm(item)
  bool inFemale = pFemale.HasForm(item)

  if inMale && inFemale
    return kModeUnisex
  elseif inMale
    return kModeMale
  elseif inFemale
    return kModeFemale
  elseif inTops
    return kModeFemaleTop
  else
    return kModeDisabled
  endif
endFunction

function SetModeForSmall(Armor item, int value)
  pMale.RemoveAddedForm(item)
  pFemale.RemoveAddedForm(item)
  pTops.RemoveAddedForm(item)
  if (value == kModeUnisex) || (value == kModeMale)
    pMale.AddForm(item)
  endif
  if (value == kModeUnisex) || (value == kModeFemale)
    pFemale.AddForm(item)
  endif
  if (value == kModeFemaleTop)
    pTops.AddForm(item)
  endif
endFunction

String[] function ModeNames()
  String[] names = new String[6]
  names[kModeUnisex] = "Unisex"
  names[kModeMale] = "Male"
  names[kModeFemale] = "Female"
  names[kModeFemaleTop] = "Female Top"
  names[kModeDisabled] = "Disable"
  names[kModeRemove] = "Remove"
  return names
endFunction

int function GetRandomSmallsIndex(FormList list)
  return Utility.RandomInt(0, list.GetSize() - 1)
endFunction

Armor function GetRandomSmall(FormList list)
  int index = Utility.RandomInt(0, list.GetSize() - 1)
  return list.GetAt(index) as Armor
endFunction

bool function IsSmalls(Armor akArmour)
  if akArmour
    return pMale.HasForm(akArmour) || pFemale.HasForm(akArmour) || pTops.HasForm(akArmour)
  else
    return false
  endif
endFunction

String function SlotsDescription(Armor item)
  int itemMask = item.getSlotMask()
  int n = 30
  int mask = 1
  string result = ""
  while n < 64
    if Math.LogicalAnd(itemMask , mask)
      result += n + ", "
    endif
    mask *= 2
    n += 1
  endWhile
  return result
endFunction

bool function IsInSlot(Armor akArmour, int slot)
  if Math.LogicalAnd(akArmour.getSlotMask() , slot)
    return true
  endif

  return false
endFunction

bool function HasMesh(Armor akArmour, bool checkFemale)
  int count = akArmour.GetNumArmorAddons()
  int n = 0
  while (n < count)
    ArmorAddon addon = akArmour.GetNthArmorAddon(n)
    String path = addon.GetModelPath(false, checkFemale)
    if path != ""
      self.Debug(akArmour.GetName() + " " + checkFemale + " " + path)
      return true
    endif
    n += 1
  endwhile
  return false
endFunction

bool function IsInTopSlot(Armor akArmour)
  return IsInSlot(akArmour, kTorsoUnderwearSlot + kMiscSlot)
endfunction

bool function IsInBottomSlot(Armor akArmour)
  return IsInSlot(akArmour, kPelvisUnderwearSlot)
endFunction

bool function IsInSpecificSlot(Armor akArmour)
  return IsInSlot(akArmour, kTorsoUnderwearSlot + kPelvisUnderwearSlot + kMiscSlot)
endFunction
