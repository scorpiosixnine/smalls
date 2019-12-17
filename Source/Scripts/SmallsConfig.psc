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
Armor[] _inventoryItems

bool _updateInventory = false
bool _removeMarked = false

String[] _kinds

; Events

event OnConfigInit()
  pQuest.Trace("ConfigInit")
  ResetPageNames()
endEvent

event OnConfigOpen()
  pQuest.Trace("ConfigOpen")
  _inventoryCount = 0
endEvent

event OnConfigClose()
  pQuest.Debug("ConfigClose")

  AddSmallsFromInventory()
  RemoveMarkedItems()
endEvent

event OnVersionUpdate(int newVersion)
  pQuest.Log("Smalls updated to version " + pQuest.GetFullVersionString())
  ResetPageNames()
  if (newVersion >= 75) && (CurrentVersion < 75)
    pQuest.Trace("Version update from " + CurrentVersion + " to " + newVersion)
    pQuest.ResetDefaultSmalls()
  endif
endEvent

event OnPageReset(string page)
  {Called when a new page is selected, including the initial empty page}

  pQuest.Debug("PageReset " + page)
  RemoveMarkedItems()
  AddSmallsFromInventory()
  ConfigResetOptions()

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
  SetupButton("Reset items list to defaults.", "Reset", "Revert to the default item list. Any custom items that you have added will be removed.", kButtonReset)

  AddHeaderOption("Debug Options")
  SetupToggle("Debugging", "Enable Logging", pQuest.pDebugMode)
endFunction

function SetupExistingPage()
  if !_kinds
    _kinds = pQuest.ModeNames()
  endif

  SetCursorFillMode(TOP_TO_BOTTOM)

  FormList defaults = pQuest.rDefaults
  int itemNo = 0
  int itemCount = defaults.GetSize()
  pQuest.Trace("defaults list size " + itemCount)
  while (itemNo < itemCount)
    Armor item = defaults.GetAt(itemNo) as Armor
    int mode = pQuest.ModeForSmall(item)
    SetupMenu(item.GetName(), _kinds, mode)
    itemNo += 1
    if itemNo == 64
      SetCursorPosition(1)
    endif
  endWhile
endFunction

function SetupAddPage()
  SetupInventoryNames()

  SetTitleText("Add Items")
  SetCursorFillMode(TOP_TO_BOTTOM)
  AddHeaderOption("Inventory")
  SetupToggles("Inventory", _inventoryCount, _inventoryNames, _inventoryEnabled)
endFunction

; Config Handlers

function ConfigButtonClicked(int index, int tag, int option)
  if tag == kButtonReset
    SetTextOptionValue(option, "Resetting...")
    pQuest.ResetDefaultSmalls()
    SetTextOptionValue(option, "Done")
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
    _updateInventory = true
  endif
endFunction

function ConfigMenuChanged(int index, int tag, int value)
  Armor item = pQuest.rDefaults.GetAt(index) as Armor
  if item
    pQuest.SetModeForSmall(item, value)
    if value == pQuest.kModeRemove
      _removeMarked = true
    endif
  endif
endFunction

; Utilities

function ResetPageNames()
  ModName = pQuest.pName
  Pages = new string[3]
  Pages[0] = kGeneralPage
  Pages[1] = kExistingPage
  Pages[2] = kAddPage
endFunction

function SetupInventoryNames()
  if _inventoryCount == 0
    _inventoryNames = new String[100]
    _inventoryEnabled = new bool[100]
    _inventoryItems = new Armor[100]
    _inventoryCount = ReadInventory()
  endif
endFunction

int function ReadInventory()
  pQuest.Trace("Reading inventory")
  ObjectReference player = Game.GetPlayer()
  int count = player.GetNumItems()
  int n = 0
  int items = 0
  while(n < count)
    Armor item = player.GetNthForm(n) as Armor
    if item
      string name = item.GetName()
      pQuest.Trace("found armor " + name)
      _inventoryNames[items] = name
      _inventoryEnabled[items] = false
      _inventoryItems[items] = item
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
        Armor item = _inventoryItems[n]
        if item
          pQuest.AddSmall(item)
          pQuest.SetModeForSmall(item, pQuest.DefaultModeForSmall(item))
        else
          pQuest.Trace("error adding from inventory " + item.GetName() + " " + n)
        endif
      endif
      n += 1
    endWhile
    _updateInventory = false
  endif
endFunction

function RemoveMarkedItems()
  if _removeMarked
    FormList defaults = pQuest.rDefaults
    int itemNo =  defaults.GetSize()
    while (itemNo > 0)
      itemNo -= 1
      if _menuValues[itemNo] == pQuest.kModeRemove
        Armor item = defaults.GetAt(itemNo) as Armor
        defaults.RemoveAddedForm(item)
        pQuest.Trace("removed item " + item.GetName())
      endif
    endWhile
    _removeMarked = false
  endif
endFunction
