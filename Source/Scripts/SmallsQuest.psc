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
int property kModeFemaleBottom = 2 AutoReadOnly ; TODO: treat this differently from Female
int property kModeFemaleTop = 3 AutoReadOnly
int property kModeDisabled = 4 AutoReadOnly
int property kModeRemove = 5 AutoReadOnly

String _defaultMod = ""

event OnInit()
  Debug.Notification("Smalls " + GetFullVersionString() + " Initialising.")
  SetupPerks()
  ResetDefaultSmalls()
endEvent

Actor function GetTarget()
  return rTarget.GetActorReference()
endFunction

function SetTarget(ObjectReference ref)
  Actor target = ref as Actor
  if target
    if !target.IsDead()
      Trace("ignoring target as it is alive " + target.GetName())
    elseif AlreadyWearingSmalls(target)
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
      elseif IsInSpecificSlot(itemAsArmor)
        Trace(item.GetName() + " is in a non-body slot used for underwear " + SlotsDescription(itemAsArmor))
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

Bool function GotDefaultMod(String name)
  if Game.GetModByName(name) != 255
    _defaultMod = name
    return true
  endif

  return false
endFunction

function ResetDefaultSmalls()
  Trace("Resetting default smalls list.")

  if !pFemale || !pMale || !pTops || !rDefaults
    Warning("failed to load lists")
  endif

  rDefaults.Revert()
  pFemale.Revert()
  pMale.Revert()
  pTops.Revert()

  ; if GotDefaultMod()
  ;   AddDefaultSmall(ref, kModeFemale)
  ; endif

  int defaultsFile = JValue.readFromFile("Data/SmallsDefaults.json")
  string mod = JMap.nextKey(defaultsFile)
  while mod 
    Log(mod)
    mod = JMap.nextKey(defaultsFile)
  endwhile
  
  if GotDefaultMod("[Melodic] Angels Secrets.esp")
    AddDefaultSmall(0x400012D0, kModeFemaleTop)
    AddDefaultSmall(0x400012D1, kModeFemale)
    AddDefaultSmall(0x400012D5, kModeFemaleBottom)
    AddDefaultSmall(0x400012D6, kModeFemaleBottom)
  endif

  if GotDefaultMod("Apachii_DivineEleganceStore.esm")
    AddDefaultSmall(0x02FFF7, kModeFemale)
    AddDefaultSmall(0x02FFF9, kModeFemale)
    AddDefaultSmall(0x02FFFB, kModeFemale)
    AddDefaultSmall(0x02FFFD, kModeFemale)
    AddDefaultSmall(0x02FFFF, kModeFemale)
    AddDefaultSmall(0x030001, kModeFemale)
    AddDefaultSmall(0x03056A, kModeFemale)
    AddDefaultSmall(0x03103B, kModeFemale)
    AddDefaultSmall(0x03103E, kModeFemale)

    AddDefaultSmall(0x0B031B19, kModeMale)
    AddDefaultSmall(0x0B031B1B, kModeMale)
    AddDefaultSmall(0x0B031B1B, kModeMale)
    AddDefaultSmall(0x0B031B1D, kModeMale)
    AddDefaultSmall(0x0B031B1F, kModeMale)
    AddDefaultSmall(0x0B031B21, kModeMale)
    AddDefaultSmall(0x0B031B23, kModeMale)
    AddDefaultSmall(0x0B031B25, kModeMale)
    AddDefaultSmall(0x0B031B27, kModeMale)
    AddDefaultSmall(0x0B031B29, kModeMale)
    AddDefaultSmall(0x0B031B2B, kModeMale)
    AddDefaultSmall(0x0B031B2D, kModeMale)

    AddDefaultSmall(0x0B0320A5, kModeFemale)
    AddDefaultSmall(0x0B0320A7, kModeFemale)
  endif

  if GotDefaultMod("CBBE Standalone Underwear.esp")
    AddDefaultSmall(0xC804, kModeFemale)
    AddDefaultSmall(0xC805, kModeFemaleTop)
  endif

  if GotDefaultMod("Celes Tarot Outfit Cloth UNP.esp")
    AddDefaultSmall(0x2B052192, kModeFemale)
  endif

  if GotDefaultMod("CuteMinidressCollection.esp")
    AddDefaultSmall(0x75000D69, kModeFemale)
    AddDefaultSmall(0x75000D7E, kModeFemale)
    AddDefaultSmall(0x75000D7F, kModeFemale)
    AddDefaultSmall(0x75000D80, kModeFemale)
    AddDefaultSmall(0x75000D81, kModeFemale)
    AddDefaultSmall(0x75000D8C, kModeFemale)
    AddDefaultSmall(0x75000D8D, kModeFemale)
    AddDefaultSmall(0x75000D8E, kModeFemale)
    AddDefaultSmall(0x75000D8F, kModeFemale)
    AddDefaultSmall(0x75000D90, kModeFemale)
    AddDefaultSmall(0x75006F7B, kModeFemale)
    AddDefaultSmall(0x75006F7C, kModeFemale)
    AddDefaultSmall(0x750074E6, kModeFemale)
    AddDefaultSmall(0x750074E7, kModeFemale)
    AddDefaultSmall(0x750074E8, kModeFemale)
    AddDefaultSmall(0x750074E9, kModeFemale)
    AddDefaultSmall(0x750074EA, kModeFemale)
    AddDefaultSmall(0x750074EB, kModeFemale)
    AddDefaultSmall(0x750074EC, kModeFemale)
    AddDefaultSmall(0x750074ED, kModeFemale)
  endif

  if GotDefaultMod("Gwelda Red Riding Hood.esp")
    AddDefaultSmall(0x47037180, kModeFemaleBottom)
    AddDefaultSmall(0x470505EC, kModeFemaleBottom)
    AddDefaultSmall(0x470505EE, kModeFemaleBottom)
  endif

  if GotDefaultMod("Remodeled Armor - Underwear.esp")
    AddDefaultSmall(0x00790C, kModeFemale)
    AddDefaultSmall(0x02BC56, kModeFemale)
    AddDefaultSmall(0x02BC5F, kModeFemale)
    AddDefaultSmall(0x02BC60, kModeFemale)
    AddDefaultSmall(0x02BC61, kModeFemale)
    AddDefaultSmall(0x02BC62, kModeFemale)
    AddDefaultSmall(0x02BC63, kModeFemale)
    AddDefaultSmall(0x02BC64, kModeFemale)
    AddDefaultSmall(0x02BC65, kModeFemale)
    AddDefaultSmall(0x02BC6F, kModeFemale)
    AddDefaultSmall(0x02BC94, kModeFemale)
    AddDefaultSmall(0x02BC95, kModeFemale)
    AddDefaultSmall(0x02BC98, kModeFemale)
    AddDefaultSmall(0x02BC99, kModeFemale)
    AddDefaultSmall(0x02BC9A, kModeFemale)
    AddDefaultSmall(0x02BC9B, kModeFemale)
    AddDefaultSmall(0x02BC9C, kModeFemale)
    AddDefaultSmall(0x02BC9D, kModeFemale)
    AddDefaultSmall(0x02BC9E, kModeFemale)
    AddDefaultSmall(0x02BC9F, kModeFemale)
    AddDefaultSmall(0x02BCA0, kModeFemale)
    AddDefaultSmall(0x02BCA1, kModeFemale)
    AddDefaultSmall(0x02BCA2, kModeFemale)
    AddDefaultSmall(0x02BCB6, kModeFemale)
    AddDefaultSmall(0x02BCB7, kModeFemale)
    AddDefaultSmall(0x02BCB8, kModeFemale)
    AddDefaultSmall(0x02BCB9, kModeFemale)
    AddDefaultSmall(0x02BCC2, kModeFemale)
    AddDefaultSmall(0x02BCC3, kModeFemale)
    AddDefaultSmall(0x02BCD2, kModeFemale)
    AddDefaultSmall(0x02BCD4, kModeFemale)
    AddDefaultSmall(0x02BCD6, kModeFemale)
    AddDefaultSmall(0x02BCD8, kModeFemale)
    AddDefaultSmall(0x02BCDA, kModeFemale)
    AddDefaultSmall(0x02BCDC, kModeFemale)
    AddDefaultSmall(0x02BCDE, kModeFemale)
    AddDefaultSmall(0x02BCE0, kModeFemale)
    AddDefaultSmall(0x02BCE2, kModeFemale)
    AddDefaultSmall(0x02BCEE, kModeFemale)
  endif

  if GotDefaultMod("Schlongs of Skyrim.esp")
    AddDefaultSmall(0x012DA, kModeMale)
  endif

  if GotDefaultMod("Shino_Traveling Magician.esp")
    AddDefaultSmall(0x1875, kModeFemale)
    AddDefaultSmall(0x1876, kModeFemale)
    AddDefaultSmall(0x1877, kModeFemale)
    AddDefaultSmall(0x1878, kModeFemale)
    AddDefaultSmall(0x1879, kModeFemale)
    AddDefaultSmall(0x187A, kModeFemale)
  endif

  if GotDefaultMod("[SunJeong] Nausicaa Lingerie.esp")
    AddDefaultSmall(0xA9EC, kModeFemaleBottom)
    AddDefaultSmall(0xA9EF, kModeFemaleTop)
    AddDefaultSmall(0xB4D9, kModeFemaleTop)
    AddDefaultSmall(0xB4DF, kModeFemaleBottom)
  endif

  if GotDefaultMod("Sweet&Sexy Lingerie.esp")
    AddDefaultSmall(0x76001DE2, kModeFemale)
    AddDefaultSmall(0x76001DE4, kModeFemale)
    AddDefaultSmall(0x76001DEA, kModeFemale)
    AddDefaultSmall(0x76006052, kModeFemale)
    AddDefaultSmall(0x7600CCF5, kModeFemale)
    AddDefaultSmall(0x7600CCF7, kModeFemale)
    AddDefaultSmall(0x7600CCF9, kModeFemale)
  endif


  if GotDefaultMod("UNP Undies.esp")
    AddDefaultSmall(0x02001D8E, kModeFemale)
    AddDefaultSmall(0x02004E14, kModeFemale)
    AddDefaultSmall(0x020063A4, kModeFemale)
    AddDefaultSmall(0x020063A5, kModeFemale)
  endif

EndFunction

function AddDefaultSmall(int formID, int mode = -1)
  Armor item = Game.GetFormFromFile(formID, _defaultMod) as Armor
  if item
    Trace("added default: " + item.GetName() + " (" + _defaultMod + ") slots: " + SlotsDescription(item))
    AddSmall(item)
    if mode == -1
      mode = DefaultModeForSmall(item)
    endif
    SetModeForSmall(item, mode)
  else
    Trace(_defaultMod + " " + formID + " missing")
  endif
endFunction

function AddSmall(Armor item)
  if !rDefaults.HasForm(item)
    Trace("added " + item.GetName())
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
    Trace("added as male " + item.GetName())
    pMale.AddForm(item)
  endif
  if (value == kModeUnisex) || (value == kModeFemale)
    Trace("added as female " + item.GetName())
    pFemale.AddForm(item)
  endif
  if (value == kModeFemaleTop)
    Trace("added as top " + item.GetName())
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
  return IsInSlot(akArmour, kTorsoUnderwearSlot + kPelvisUnderwearSlot + kMiscSlot) && !IsInSlot(akArmour, kBodySlot)
endFunction
