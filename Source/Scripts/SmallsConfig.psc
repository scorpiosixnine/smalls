Scriptname SmallsConfig extends SKI_ConfigBase

SmallsQuest property rQuest auto

int[] _toggles
bool[] _toggleValues
int[] _toggleTags
String[] _toggleIDs
int _toggleCount = 0
int _toggleMax = 0

int _topsCount = 0
String[] _topNames
bool[] _topEnabled

int _femaleCount = 0
String[] _femaleNames
bool[] _femaleEnabled

int _maleCount = 0
String[] _maleNames
bool[] _maleEnabled

int _inventoryCount = 0
String[] _inventoryNames
bool[] _inventoryEnabled
int[] _inventoryIndexes

String _generalPage = "General"
String _existingPage = "Current Items"
String _addPage = "Add Items"

String[] _kinds

event OnConfigInit()
  Pages = new string[3]
  Pages[0] = _generalPage
  Pages[1] = _existingPage
  Pages[2] = _addPage
endEvent

event OnConfigOpen()
  rQuest.Trace("ConfigOpen")

  _topNames = new String[100]
  _topEnabled = new bool[100]
  _topsCount = ReadSmallsForList(rQuest.pTops, _topNames, _topEnabled)

  _femaleNames = new String[100]
  _femaleEnabled = new bool[100]
  _femaleCount = ReadSmallsForList(rQuest.pFemale, _femaleNames, _femaleEnabled)

  _maleNames = new String[100]
  _maleEnabled = new bool[100]
  _maleCount = ReadSmallsForList(rQuest.pMale, _maleNames, _maleEnabled)

  _inventoryNames = new String[100]
  _inventoryEnabled = new bool[100]
  _inventoryIndexes = new int[100]
  _inventoryCount = ReadInventory()

  _kinds = new String[3]
  _kinds[0] = "Bottom"
  _kinds[1] = "Top"
  _kinds[2] = "Both"
  _kinds[3] = "Remove"
endEvent

event OnConfigClose()
  rQuest.Debug("ConfigClose")

  WriteSmallsForPosition(rQuest.pFemale, _femaleEnabled)
  WriteSmallsForPosition(rQuest.pTops, _topEnabled)
  WriteSmallsForPosition(rQuest.pMale, _maleEnabled)
  AddSmallsFromInventory()
endEvent

int function GetVersion()
  return rQuest.pBuildNumber
endFunction

event OnVersionUpdate(int newVersion)
  rQuest.Log("Smalls updated to version " + rQuest.GetFullVersionString())
endEvent

event OnPageReset(string page)
  {Called when a new page is selected, including the initial empty page}

  rQuest.Debug("PageReset " + page)

  _toggleMax = 100
  _toggles = new int[100]
  _toggleValues = new bool[100]
  _toggleTags = new int[100]
  _toggleIDs = new String[100]
  _toggleCount = 0

  if (page == _generalPage) || (page == "")
    SetupGeneralPage()
  elseif page == _existingPage
    SetupExistingPage()
  elseif page == _addPage
    SetupAddPage()
  endif
endEvent

event OnOptionSelect(int option)
  int n = 0
  while(n < _toggleCount)
    if option == _toggles[n]
      bool newValue = !_toggleValues[n]
      _toggleValues[n] = newValue
      SetToggleOptionValue(_toggles[n], newValue)
      UpdateToggle(_toggleIDs[n], newValue, _toggleTags[n])
    endif
    n += 1
  endWhile
endEvent

event OnOptionMenuOpen(int option)
	{Called when the user selects a menu option}

	SetMenuDialogStartIndex(0)
	SetMenuDialogDefaultIndex(0)
	SetMenuDialogOptions(_kinds)
endEvent

function UpdateToggle(String identifier, bool value, int tag)
  if identifier == "Debugging"
    rQuest.debugMode = value
  elseif identifier == "ReplaceMales"
    rQuest.pReplaceMales = value
  elseif identifier == "pReplaceFemales"
    rQuest.pReplaceFemales = value
  elseif identifier == "Top"
    _topEnabled[tag] = value
  elseif identifier == "Bottom"
    _femaleEnabled[tag] = value
  elseif identifier == "Male"
    _maleEnabled[tag] = value
  elseif identifier == "Enabled"
    rQuest.pEnabled = value
    rQuest.SetupPerks()
  elseif identifier == "Inventory"
    _inventoryEnabled[tag] = value
  endif
endFunction

function SetupGeneralPage()
  SetCursorFillMode(TOP_TO_BOTTOM)

  AddHeaderOption("Smalls " + rQuest.GetFullVersionString())
  AddTextOption("Proudly preserving the decency of the", "")
  AddTextOption("citizens of Skyrim since 4E 201.", "")
  AddEmptyOption()
  AddTextOption("By scorpiosixnine.", "")


  SetupToggle("Enabled", "Enabled", rQuest.pEnabled)
  SetupToggle("ReplaceMales", "Use for males.", rQuest.pReplaceMales)
  SetupToggle("ReplaceFemales", "Use for females.", rQuest.pReplaceFemales)

  AddEmptyOption()
  AddHeaderOption("Debugging")
  SetupToggle("Debugging", "Enable Logging", rQuest.debugMode)
endFunction

function SetupExistingPage()
  SetCursorFillMode(TOP_TO_BOTTOM)
  AddHeaderOption("Female")
  SetupSettingsFor("Bottom", _femaleCount, _femaleNames, _femaleEnabled)

  AddHeaderOption("Female Tops")
  SetupSettingsFor("Top", _topsCount, _topNames, _topEnabled)

  SetCursorPosition(1)
  AddHeaderOption("Male")
  SetupSettingsFor("Male", _maleCount, _maleNames, _maleEnabled)
endFunction

function SetupAddPage()
  SetTitleText("Add Items")
  SetCursorFillMode(TOP_TO_BOTTOM)
  AddHeaderOption("Inventory")
  SetupSettingsFor("Inventory", _inventoryCount, _inventoryNames, _inventoryEnabled)
endFunction

function SetupToggle(String identifier, String name, bool initialState, int tag = 0)
  if _toggleCount < _toggleMax
    _toggles[_toggleCount] = AddToggleOption(name, initialState)
    _toggleValues[_toggleCount] = initialState
    _toggleIDs[_toggleCount] = identifier
    _toggleTags[_toggleCount] = tag
    _toggleCount += 1
  endif
endFunction

function SetupSettingsFor(String identifier, int count, String[] names, bool[] values)
  int n = 0
  while(n < count)
    SetupToggle(identifier, names[n], values[n], n)
    ; AddMenuOption("Kind", identifier)
    n += 1
  endWhile
endFunction

int function ReadSmallsForList(FormList list, String[] namesArray, bool[] enabledArray)
  int count = list.GetSize()
  int n = 0
  while(n < count)
    Form item = list.GetAt(n)
    namesArray[n] = item.GetName()
    enabledArray[n] = true
    n += 1
  endWhile
  return count
endfunction

function WriteSmallsForPosition(FormList list, bool[] enabledArray)
  int n =  list.GetSize()
  while(n > 0) ; go backwards so that deletions don't change the indexes
    n -= 1
    if !enabledArray[n]
      Form small = list.GetAt(n)
      list.RemoveAddedForm(small)
      rQuest.Debug("removed " + small.GetName())
    endif
  endWhile
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
      rQuest.AddSmall(small)
    endif
    n += 1
  endWhile
endFunction
