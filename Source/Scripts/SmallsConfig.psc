Scriptname SmallsConfig extends SKI_ConfigBase

; Properties

SmallsQuest property pQuest auto


; Constants

String kGeneralPage = "General"
String kExistingPage = "Current Items"
String kAddPage = "Add Items"

int kButtonReset = 1


; Variables

int _inventoryCount = 0
String[] _inventoryNames
bool[] _inventoryEnabled
int[] _inventoryIndexes

bool _updateInventory = false
String[] _kinds

; Events

event OnConfigInit()
  pQuest.Trace("ConfigInit")
  ResetPageNames()
endEvent

event OnConfigClose()
  pQuest.Debug("ConfigClose")

  AddSmallsFromInventory()
endEvent

event OnVersionUpdate(int newVersion)
  pQuest.Log("Smalls updated to version " + pQuest.GetFullVersionString())
  ResetPageNames()
  if (newVersion >= 75) && (CurrentVersion < 75)
    pQuest.ResetDefaultSmalls()
  endif
endEvent

event OnPageReset(string page)
  {Called when a new page is selected, including the initial empty page}

  pQuest.Debug("PageReset " + page)
  ConfigResetOptions()

  AddSmallsFromInventory()

  if (page == kGeneralPage) || (page == "")
    SetupGeneralPage()
  elseif page == kExistingPage
    SetupExistingPage()
  elseif page == kAddPage
    SetupAddPage()
  endif
endEvent

; Pages

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
  if _kinds == None
    _kinds = pQuest.ModeNames()
  endif

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

; Config Handlers

function ConfigButtonClicked(int index, int tag, int option)
  if tag == kButtonReset
    SetTextOptionValue(option, "Resetting...")
    pQuest.ResetDefaultSmalls()
    SetTextOptionValue(option, "Reset")
  endif
endFunction

function ConfigToggleChanged(String identifier, bool value, int tag)
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

function ConfigMenuChanged(int index, int tag, int value)
  Armor item = pQuest.rDefaults.GetAt(index) as Armor
  if item
    pQuest.SetModeForSmall(item, value)
  endif
endFunction

; Utilities

function ResetPageNames()
  Pages = new string[3]
  Pages[0] = kGeneralPage
  Pages[1] = kExistingPage
  Pages[2] = kAddPage
endFunction

function SetupInventoryNames()
  if _inventoryCount == 0
    _inventoryNames = new String[100]
    _inventoryEnabled = new bool[100]
    _inventoryIndexes = new int[100]
    _inventoryCount = ReadInventory()
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
  if _updateInventory
    ObjectReference player = Game.GetPlayer()
    int n =  0
    while(n < _inventoryCount)
      if _inventoryEnabled[n]
        Armor small = player.GetNthForm(_inventoryIndexes[n]) as Armor
        pQuest.AddSmall(small)
        pQuest.SetModeForSmall(small, pQuest.DefaultModeForSmall(small))
      endif
      n += 1
    endWhile
    _updateInventory = false
  endif
endFunction
