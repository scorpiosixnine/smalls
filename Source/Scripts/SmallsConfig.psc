Scriptname SmallsConfig extends SKI_ConfigBase

SmallsQuest property pQuest auto

int _inventoryCount = 0
String[] _inventoryNames
bool[] _inventoryEnabled
int[] _inventoryIndexes

String _generalPage = "General"
String _existingPage = "Current Items"
String _addPage = "Add Items"

int kButtonReset = 1

String[] _kinds

event OnConfigInit()
  ResetProperties()
endEvent

function ResetProperties()
  Pages = new string[3]
  Pages[0] = _generalPage
  Pages[1] = _existingPage
  Pages[2] = _addPage
endFunction

function SetupInventoryNames()
  if _inventoryCount == 0
    _inventoryNames = new String[100]
    _inventoryEnabled = new bool[100]
    _inventoryIndexes = new int[100]
    _inventoryCount = ReadInventory()
  endif
endFunction

event OnConfigOpen()
  pQuest.Trace("ConfigOpen")
endEvent

event OnConfigClose()
  pQuest.Debug("ConfigClose")

  AddSmallsFromInventory()
endEvent

int function GetVersion()
  return pQuest.pBuildNumber
endFunction

event OnVersionUpdate(int newVersion)
  pQuest.Log("Smalls updated to version " + pQuest.GetFullVersionString())
  ResetProperties()
endEvent

event OnPageReset(string page)
  {Called when a new page is selected, including the initial empty page}

  pQuest.Debug("PageReset " + page)
  ResetOptions()

  if (page == _generalPage) || (page == "")
    SetupGeneralPage()
  elseif page == _existingPage
    SetupExistingPage()
  elseif page == _addPage
    SetupAddPage()
  endif
endEvent

function ButtonClicked(int index, int tag, int option)
  if tag == kButtonReset
    SetTextOptionValue(option, "Resetting...")
    pQuest.ResetDefaultSmalls()
    SetTextOptionValue(option, "Reset")
  endif
endFunction


function UpdateToggle(String identifier, bool value, int tag)
  if identifier == "ReplaceMales"
    pQuest.pReplaceMales = value
  elseif identifier == "ReplaceFemales"
    pQuest.pReplaceFemales = value
  elseif identifier == "Enabled"
    pQuest.pEnabled = value
    pQuest.SetupPerks()
  elseif identifier == "Inventory"
    _inventoryEnabled[tag] = value
  endif
endFunction

function SetupGeneralPage()
  SetCursorFillMode(TOP_TO_BOTTOM)

  AddHeaderOption("Smalls " + pQuest.GetFullVersionString())
  AddTextOption("\"Proudly preserving the decency of the", "")
  AddTextOption("citizens of Skyrim since 4E 201.\"", "")
  AddEmptyOption()
  AddTextOption("By scorpiosixnine.", "")

  SetCursorPosition(1)
  AddHeaderOption("Settings")
  SetupToggle("Enabled", "Enabled", pQuest.pEnabled)
  SetupToggle("ReplaceMales", "Use for males.", pQuest.pReplaceMales)
  SetupToggle("ReplaceFemales", "Use for females.", pQuest.pReplaceFemales)
  AddEmptyOption()
  SetupButton("Reset", "Revert to default item list. Any custom items will be removed.", kButtonReset)

  AddHeaderOption("Debug Options")
  SetupToggle("Debugging", "Enable Logging", pQuest.pDebugMode)
endFunction

function SetupExistingPage()
  _kinds = pQuest.ModeNames()

  SetCursorFillMode(TOP_TO_BOTTOM)

  FormList defaults = pQuest.rDefaults
  int itemNo = 0
  int itemCount = defaults.GetSize()
  while (itemNo < itemCount)
    Armor item = defaults.GetAt(itemNo) as Armor
    int mode = pQuest.ModeForSmall(item)
    SetupMenu(item.GetName(), _kinds, mode)
    itemNo += 1
  endWhile
endFunction

function SetupAddPage()
  SetupInventoryNames()

  SetTitleText("Add Items")
  SetCursorFillMode(TOP_TO_BOTTOM)
  AddHeaderOption("Inventory")
  SetupSettingsFor("Inventory", _inventoryCount, _inventoryNames, _inventoryEnabled)
endFunction

function SetupSettingsFor(String identifier, int count, String[] names, bool[] values)
  int n = 0
  while(n < count)
    SetupToggle(identifier, names[n], values[n], n)
    ; AddMenuOption("Kind", identifier)
    n += 1
  endWhile
endFunction

function MenuChanged(int index, int tag, int value)
  Armor item = pQuest.rDefaults.GetAt(index) as Armor
  if item
    pQuest.SetModeForSmall(item, value)
  endif
endFunction

int function ReadInventory()
  ObjectReference player = Game.GetPlayer()
  int count = player.GetNumItems()
  int n = 0
  int items = 0
  while(n < count)
    Form item = player.GetNthForm(n) as Armor
    if item
      _inventoryNames[items] = item.GetName()
      _inventoryEnabled[items] = false
      _inventoryIndexes[items] = n
      items += 1
    endif
    n += 1
  endWhile
  return items
endFunction

function AddSmallsFromInventory()
  ObjectReference player = Game.GetPlayer()
  int n =  0
  while(n < _inventoryCount)
    if _inventoryEnabled[n]
      Armor small = player.GetNthForm(_inventoryIndexes[n]) as Armor
      pQuest.AddSmall(small)
    endif
    n += 1
  endWhile
endFunction
