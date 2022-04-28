Scriptname SmallsQuest extends Quest
{Main smalls quest script}

FormList property rDefaults auto
FormList property pTops auto
FormList property pFemale auto
FormList property pMale auto

bool property pEnabled auto
bool property pReplaceMales auto
bool property pReplaceFemales auto

int property kBodySlot = 0x000004 AutoReadOnly ; BODY 32 
int property kPelvisUnderwearSlot = 0x00400000 AutoReadOnly ; Underwear pelvis 52
int property kTorsoUnderwearSlot  = 0x04000000 AutoReadOnly ; Underwear chest  56
int property kMiscSlot = 0x040000 AutoReadOnly ; Misc slot 48 (used by CBBE standalone top, and maybe others?)

int property kModeUnisex = 0 AutoReadOnly
int property kModeMale = 1 AutoReadOnly
int property kModeFemale = 2 AutoReadOnly
int property kModeFemaleBottom = 2 AutoReadOnly ; TODO: treat this differently from Female
int property kModeFemaleTop = 3 AutoReadOnly
int property kModeDisabled = 4 AutoReadOnly
int property kModeRemove = 5 AutoReadOnly

event OnInit()
  Debug.Notification("Smalls " + GetFullVersionString() + " Initialising.")
  UpdatedEnabled()
  ResetDefaultSmalls()
endEvent

String function AppendName(String sLabel, Form akTarget)
  String name
  if akTarget
    name = akTarget.GetName()
    if !name
      ObjectReference ref = akTarget as ObjectReference
      name = ref.GetBaseObject().GetName()
    endif
  endif
  if !name
    name = "<none>"
  endif

  return sLabel + name
endFunction

Bool function EffectStarted(Actor akTarget, Actor akCaster)
  bool shouldMonitor = IsPotentialTarget(akTarget)
  if shouldMonitor 
    Debug(AppendName("Monitoring " , akTarget))
    if !AlreadyHasSmalls(akTarget)
      GiveSmalls(akTarget)
    endif
  else
    Debug(AppendName("Ignoring " , akTarget))
  endif

  return !shouldMonitor
endfunction

function EffectObjectUnequipped(Form akBaseObject, ObjectReference akReference, Actor target)
  Debug("EffectObjectUnequipped")

  if !IsPotentialTarget(target)
    Debug(AppendName("Effect Running on non-potential target ", target))
  endif

  Armor armour = akBaseObject as Armor
  if armour && IsEligibleTarget(target)
    Debug(AppendName("Target is ", target))
    Debug(AppendName("Base is ", akBaseObject))
    Debug("Removed " + akBaseObject.GetName() + " from " + target.GetName())

    int mask = armour.getSlotMask()
    if (IsInSlot(armour, kBodySlot) && !IsSmalls(armour))
      Debug("Unequipped armour")
      EquipSmalls(target)
    else
      Debug("Uneqipped slotmask: " + armour.getSlotMask())
    endif
  endif
endfunction

Bool function IsPotentialTarget(Actor akTarget)
  return akTarget && (akTarget != Game.GetPlayer()) && !akTarget.IsPlayerTeammate()
endfunction

Bool function IsEligibleTarget(Actor akTarget)
  return akTarget && akTarget.IsDead() && !AlreadyWearingSmalls(akTarget) && (akTarget != Game.GetPlayer()) && !akTarget.IsPlayerTeammate()
endfunction


function GiveSmalls(Actor akActor)
  int gender = akActor.GetLeveledActorBase().GetSex()
  Debug("gender is " + gender)

  if gender == 0
		GiveMaleSmalls(akActor)
	else
		GiveFemaleSmalls(akActor)
	endif
EndFunction

function GiveMaleSmalls(Actor akActor)
	if pReplaceMales
		Armor item = GetRandomSmall(pMale)
		if (item)
			Debug("Adding smalls " + item.GetName())
      if !IsInSlot(item , kBodySlot)
        akActor.EquipItem(item, true, false)
      else
        akActor.AddItem(item, 1, false)
      endif
		endif
	endif
EndFunction

function GiveFemaleSmalls(Actor akActor)
	if pReplaceFemales
		Armor bottom = GetRandomSmall(pFemale)
		if (bottom)
			Debug("Adding smalls " + bottom.GetName())
      if !IsInSlot(bottom, kBodySlot)
        akActor.EquipItem(bottom, true, false)
      else
  			akActor.AddItem(bottom, 1, false)
      endif
			if !IsInSlot(bottom , kBodySlot)
				Armor top = GetRandomSmall(pTops)
        if top
          Debug("Adding top " + top.GetName())
          if !IsInSlot(top, kBodySlot)
            akActor.EquipItem(top, true, false)
          else
            akActor.AddItem(top, 1, false)
          endif
        endif
			endif
		endif
	endif
EndFunction

function EquipSmalls(Actor akActor)
  int gender = akActor.GetLeveledActorBase().GetSex()
  Debug("gender is " + gender)

  if gender == 0
		EquipMaleSmalls(akActor)
	else
		EquipFemaleSmalls(akActor)
	endif
	if !akActor.IsOnMount()
		akActor.QueueNiNodeUpdate()
	endif
EndFunction

function EquipMaleSmalls(Actor target)
	if pReplaceMales
    int count = target.GetNumItems()
    int n = 0
    int items = 0
    while(n < count)
      Form item = target.GetNthForm(n)
      Armor itemAsArmor = item as Armor
      if !target.IsEquipped(item) && itemAsArmor && pMale.HasForm(item)
        Debug("Equipping " + item.GetName())
        target.EquipItem(item)
        return
      endif
      n += 1
    endWhile
  endif
EndFunction

function EquipFemaleSmalls(Actor target)
	if pReplaceFemales
    int count = target.GetNumItems()
    int n = 0
    int items = 0
    int doneTop = 0
    int doneBottom = 0

    while(n < count)
      Form item = target.GetNthForm(n)
      Armor itemAsArmor = item as Armor
      if !target.IsEquipped(item) && itemAsArmor && (pFemale.HasForm(item) || pTops.HasForm(item))
        Debug("Equipping " + item.GetName())
        target.EquipItem(item)
      endif
      n += 1
    endWhile
	endif
EndFunction

bool function AlreadyHasSmalls(Actor target)
  int count = target.GetNumItems()
  int n = 0
  int items = 0
  while(n < count)
    Form item = target.GetNthForm(n)
    Armor itemAsArmor = item as Armor
    if itemAsArmor
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
  if (pEnabled)
    Debug.Notification("Smalls " + GetFullVersionString() + " enabled.")
  else
    Debug.Notification("Smalls " + GetFullVersionString() + " disabled.")
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

  LoadDefaults()
EndFunction

function LoadDefaults()
  int defaultsFile = JValue.readFromFile("Data/SmallsDefaults.json")
  String mod = JMap.nextKey(defaultsFile)
  while mod 
    LoadDefaultsForMod(mod, defaultsFile)
    mod = JMap.nextKey(defaultsFile, mod)
  endwhile
endfunction

function LoadDefaultsForMod(String mod, int file)
  int values = JMap.getObj(file, mod)
  int added = 0
  added += LoadDefaultsWithKey(values, "female", kModeFemale, mod)
  added += LoadDefaultsWithKey(values, "femaleTop", kModeFemaleTop, mod)
  added += LoadDefaultsWithKey(values, "femaleBottom", kModeFemaleBottom, mod)
  added += LoadDefaultsWithKey(values, "male", kModeMale, mod)
  added += LoadDefaultsWithKey(values, "unisex", kModeUnisex, mod)
  if added > 0
    Log("Added " + added + " defaults from " + mod + ".")
  endif
endfunction

int function LoadDefaultsWithKey(int values, String k, int mode, String mod)
  int added = 0
  int list = JMap.getObj(values, k)
  int i = JValue.count(list)
  while i > 0
    i -= 1
    String idStr
    int itemRecord = JArray.getObj(list, i)
    if itemRecord
      idStr = JMap.getStr(itemRecord, "id")
    else
      idStr = JArray.getStr(list, i)
    endif

    if idStr
      String data = "__formData|" + mod + "|" + idStr
      Armor item = JString.decodeFormStringToForm(data) as Armor
      if item
        AddSmall(item)
        SetModeForSmall(item, mode)
        Trace("added " + item.GetName() + " (" + mod + ") slots: " + SlotsDescription(item))
        added += 1
      endif
    endif
  endwhile
  return added
endfunction

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

  if (value == kModeUnisex) || (value == kModeFemale) || (value == kModeFemaleBottom)
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
