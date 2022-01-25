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

function LoadModSettings(String mod, int file)
  int values = JMap.getObj(file, mod)
  Log("Reading defaults for " + mod)
  LoadSettings(values, "female", kModeFemale, mod)
  LoadSettings(values, "femaleTop", kModeFemaleTop, mod)
  LoadSettings(values, "male", kModeMale, mod)
  LoadSettings(values, "unisex", kModeUnisex, mod)
endfunction

function LoadSettings(int values, String k, int mode, String mod)
  int list = JMap.getObj(values, k)
  int i = JValue.count(list)
  while i > 0
    i -= 1
    String idStr = JArray.getStr(list, i)
    String data = "__formData|" + mod + "|" + idStr
    Armor item = JString.decodeFormStringToForm(data) as Armor
    if item
      AddSmall(item)
      SetModeForSmall(item, mode)
      Log("added default: " + item.GetName() + " (" + mod + ") slots: " + SlotsDescription(item))
    endif
  endwhile
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

  ; if GotDefaultMod()
  ;   AddDefaultSmall(ref, kModeFemale)
  ; endif

  int defaultsFile = JValue.readFromFile("Data/SmallsDefaults.json")
  String mod = JMap.nextKey(defaultsFile)
  while mod 
    LoadModSettings(mod, defaultsFile)
    mod = JMap.nextKey(defaultsFile, mod)
  endwhile
  

EndFunction

function AddDefaultSmall(int formID, int mode = -1)
  Armor item = Game.GetFormFromFile(formID, _defaultMod) as Armor
  if item
    AddDefaultSmallItem(item, mode)
  else
    Trace(_defaultMod + " " + formID + " missing")
  endif
endfunction

function AddDefaultSmallItem(Armor item, int mode)
  Trace("added default: " + item.GetName() + " (" + _defaultMod + ") slots: " + SlotsDescription(item))
  AddSmall(item)
  if mode == -1
    mode = DefaultModeForSmall(item)
  endif
  SetModeForSmall(item, mode)
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
