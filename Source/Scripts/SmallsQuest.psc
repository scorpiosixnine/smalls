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
  AddDefaultSmall(0x1875, "Shino_Traveling Magician.esp")
  AddDefaultSmall(0x1876, "Shino_Traveling Magician.esp")
  AddDefaultSmall(0x1877, "Shino_Traveling Magician.esp")
  AddDefaultSmall(0x1878, "Shino_Traveling Magician.esp")
  AddDefaultSmall(0x1879, "Shino_Traveling Magician.esp")
  AddDefaultSmall(0x187A, "Shino_Traveling Magician.esp")

  AddDefaultSmall(0xC803, "CBBE Standalone Underwear.esp")
  AddDefaultSmall(0xC804, "CBBE Standalone Underwear.esp")
  AddDefaultSmall(0xC805, "CBBE Standalone Underwear.esp")

  AddDefaultSmall(0x790C, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC56, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC5F, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC60, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC61, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC62, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC63, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC64, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC65, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC6F, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC94, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC95, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC98, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC99, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC9A, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC9B, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC9C, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC9D, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC9E, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBC9F, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCA0, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCA1, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCA2, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCB6, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCB7, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCB8, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCB9, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCC2, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCC3, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCD2, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCD4, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCD6, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCD8, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCDA, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCDC, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCDE, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCE0, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCE2, "Remodeled Armor - Underwear.esp")
  AddDefaultSmall(0xBCEE, "Remodeled Armor - Underwear.esp")

  AddDefaultSmall(0xA9EC, "[SunJeong] Nausicaa Lingerie.esp")
  AddDefaultSmall(0xA9EF, "[SunJeong] Nausicaa Lingerie.esp")
  AddDefaultSmall(0xB4D9, "[SunJeong] Nausicaa Lingerie.esp")
  AddDefaultSmall(0xB4DF, "[SunJeong] Nausicaa Lingerie.esp")
EndFunction

function AddDefaultSmall(int formID, String filename)
  Armor item = Game.GetFormFromFile(formID, filename) as Armor
  if item
    Trace(filename + " " + formID + " found as " + item.GetName())
    if !rDefaults.HasForm(item)
      rDefaults.AddForm(item)
    endif
  else
    Trace(filename + " " + formID + " missing")
  endif
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
