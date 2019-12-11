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

int property kBodySlot = 0x00000004 AutoReadOnly ; BODY
int property kPelvisUnderwearSlot = 0x00400000 AutoReadOnly ; Underwear pelvis
int property kTorsoUnderwearSlot = 0x04000000 AutoReadOnly ; Underwear chest
int property kMiscSlot = 0x00040000 AutoReadOnly ; Misc slot (used by CBBE standalone top, and maybe others?)


event OnInit()
  Debug.Notification("Smalls " + GetFullVersionString() + " Initialising.")
  SetupDefaultSmalls()
  SetupPerks()
endEvent

Actor function GetTarget()
  return rTarget.GetActorReference()
endFunction

function SetTarget(ObjectReference akTargetRef)
  rTarget.ForceRefTo(akTargetRef)
  (rTarget as SmallsMainScript).TargetUpdated()
  Debug("target set to " + akTargetRef.GetName() + akTargetRef.GetFormID())
endFunction

function ClearTarget()
  rTarget.Clear()
  Debug("target cleared")
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
  AddDefaultSmall(0x01875, "Shino_Traveling Magician.esp")
  AddDefaultSmall(0x01876, "Shino_Traveling Magician.esp")
  AddDefaultSmall(0x01877, "Shino_Traveling Magician.esp")
  AddDefaultSmall(0x01878, "Shino_Traveling Magician.esp")
  AddDefaultSmall(0x01879, "Shino_Traveling Magician.esp")
  AddDefaultSmall(0x0187A, "Shino_Traveling Magician.esp")

  AddDefaultSmall(0x01C803, "CBBE Standalone Underwear.esp")
  AddDefaultSmall(0x01C804, "CBBE Standalone Underwear.esp")
  AddDefaultSmall(0x01C805, "CBBE Standalone Underwear.esp")

  AddDefaultSmall(0x00790C, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC56, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC5F, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC60, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC61, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC62, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC63, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC64, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC65, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC6F, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC94, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC95, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC98, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC99, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC9A, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC9B, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC9C, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC9D, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC9E, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BC9F, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCA0, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCA1, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCA2, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCB6, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCB7, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCB8, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCB9, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCC2, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCC3, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCD2, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCD4, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCD6, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCD8, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCDA, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCDC, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCDE, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCE0, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCE2, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0x00BCEE, "Remodeled Armor - Underwear.esp")
EndFunction

function AddDefaultSmall(int formID, String filename)
  Armor item = Game.GetFormFromFile(formID, filename) as Armor
  Trace(filename + " " + formID + " found as " + item.GetName())
  AddSmall(item)
endFunction

function SetupDefaultSmalls()
  if !pFemale || !pMale || !pTops || !rDefaults
    Warning("failed to load lists")
  endif

  pFemale.Revert()
  pTops.Revert()
  pMale.Revert()

  int itemNo = 0
  int itemCount = rDefaults.GetSize()
  while (itemNo < itemCount)
    Armor item = rDefaults.GetAt(itemNo) as Armor
    AddSmall(item)
    itemNo += 1
  endWhile

  Trace("Female: " + pFemale.GetSize())
  Trace("Tops: " + pTops.GetSize())
  Trace("Male: " + pMale.GetSize())
endFunction

function AddSmall(Armor item)
  if (item)
    bool isTop = IsInTopSlot(item)
    bool isBottom = IsInBottomSlot(item)
    if (isTop && !isBottom)
      ; definitely a top
      pTops.AddForm(item)
    else
      if HasMesh(item, false)
        pMale.AddForm(item)
      endif
      if HasMesh(item, true)
        pFemale.AddForm(item)
        if !isBottom ; isn't marked as a top or a bottom, so might be an all-in-one, or a top, or a bottom - add it to both lists just in case
          pTops.AddForm(item)
        endif
      endif
    endif
  endif
endFunction

int function GetRandomSmallsIndex(FormList list)
  return Utility.RandomInt(0, list.GetSize() - 1)
endFunction

Armor function GetRandomSmall(FormList list)
  int index = Utility.RandomInt(0, list.GetSize() - 1)
  return list.GetAt(index) as Armor
endFunction

bool function IsSmalls(Armor akArmour)
  return pMale.HasForm(akArmour) || pFemale.HasForm(akArmour) || pTops.HasForm(akArmour)
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
