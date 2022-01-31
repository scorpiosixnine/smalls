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
  SetupPerks()
  ResetDefaultSmalls()
endEvent

Bool function EffectStarted(Actor akTarget, Actor akCaster)
  Debug("EffectStarted")
  if akTarget
    Debug("Target is " + akTarget.GetName())
  else
    Debug("Target is None")
  endif
  if akCaster
    Debug("Caster is " + akCaster.GetName())
  else
    Debug("Caster is None")
  endif

  return false
endfunction

function EffectObjectUnequipped(Form akBaseObject, ObjectReference akReference, Actor target)
  Debug("EffectObjectUnequipped")

  if IsEligibleTarget(target)
    Debug("Removed " + akBaseObject.GetName() + " from " + target.GetName())

    Armor armour = akBaseObject as Armor
    if armour
      int mask = armour.getSlotMask()
      if (IsInSlot(armour, kBodySlot) && !IsSmalls(armour))
        Debug("Unequipped armour")
        int gender = target.GetLeveledActorBase().GetSex()
        Debug("gender is " + gender)
        if !IsSmalls(armour)
          EquipSmalls(target, gender)
        endif
      else
        Debug("Uneqipped slotmask: " + armour.getSlotMask())
      endif
	  endif
  endif
endfunction

Actor function GetTarget()
  return rTarget.GetActorReference()
endFunction

Bool function IsEligibleTarget(Actor akTarget)
  return akTarget && (akTarget != Game.GetPlayer()) && !akTarget.IsPlayerTeammate()
endfunction

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

function EquipSmalls(Actor akActor, int gender)
	if gender == 0
		EquipMaleSmalls(akActor)
	else
		EquipFemaleSmalls(akActor)
	endif
	if !akActor.IsOnMount()
		akActor.QueueNiNodeUpdate()
	endif
EndFunction

function EquipMaleSmalls(Actor akActor)
	if pReplaceMales
		Armor item = GetRandomSmall(pMale)
		if (item)
			Debug("Adding smalls " + item.GetName())
			akActor.EquipItem(item, true, false)
		endif
	endif
EndFunction

function EquipFemaleSmalls(Actor akActor)
	if pReplaceFemales
		Armor bottom = GetRandomSmall(pFemale)
		if (bottom)
			Debug("Adding smalls " + bottom.GetName())
			akActor.EquipItem(bottom, true, false)
			if IsInSlot(bottom , kPelvisUnderwearSlot) && !IsInSlot(bottom , kTorsoUnderwearSlot)
				Form top = GetRandomSmall(pTops)
				Debug("Adding top " + top.GetName())
				akActor.EquipItem(top, true, false)
			endif
		endif
	endif
EndFunction

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
  Log("Reading defaults for " + mod)
  LoadDefaultsWithKey(values, "female", kModeFemale, mod)
  LoadDefaultsWithKey(values, "femaleTop", kModeFemaleTop, mod)
  LoadDefaultsWithKey(values, "femaleBottom", kModeFemaleBottom, mod)
  LoadDefaultsWithKey(values, "male", kModeMale, mod)
  LoadDefaultsWithKey(values, "unisex", kModeUnisex, mod)
endfunction

function LoadDefaultsWithKey(int values, String k, int mode, String mod)
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
      endif
    endif
  endwhile
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
