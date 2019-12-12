Scriptname SmallsMainScript extends ReferenceAlias
{Script with the main stuff in}

SmallsQuest property rQuest  auto

function TargetUpdated()
	if Utility.IsInMenuMode()
		RegisterForMenu("ContainerMenu")
	endif
endFunction

event OnMenuClose(String MenuName)
	if MenuName == "ContainerMenu"
		UnregisterForMenu("ContainerMenu")
		self.clear()
		rQuest.ClearTarget()
	endif
EndEvent

event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	Armor armour = akBaseObject as Armor
	Actor target = rQuest.GetTarget()
	if (armour && target.IsDead() && !AlreadyWearingSmalls(target))
		int mask = armour.getSlotMask()
		if (rQuest.IsInSlot(armour, rQuest.kBodySlot) && !rQuest.IsSmalls(armour))
			rQuest.Debug("Unequipped armour")
			int gender = target.GetLeveledActorBase().GetSex()
			rQuest.Debug("gender is " + gender)
			if !rQuest.IsSmalls(armour)
				EquipSmalls(target, gender)
			endif
		else
			rQuest.Debug("Uneqipped slotmask: " + armour.getSlotMask())
		endif
	endif
endEvent

bool function AlreadyWearingSmalls(Actor target)
	int count = target.GetNumItems()
	int n = 0
	int items = 0
	while(n < count)
		Form item = target.GetNthForm(n)
		if target.IsEquipped(item) && rQuest.IsSmalls(item as Armor)
			return true
		endif
		n += 1
	endWhile
	return false
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
	if rQuest.pReplaceMales
		Armor item = rQuest.GetRandomSmall(rQuest.pMale)
		if (item)
			rQuest.Debug("Adding smalls " + item.GetName())
			akActor.EquipItem(item, true, false)
		endif
	endif
EndFunction

function EquipFemaleSmalls(Actor akActor)
	if rQuest.pReplaceFemales
		Armor bottom = rQuest.GetRandomSmall(rQuest.pFemale)
		if (bottom)
			rQuest.Debug("Adding smalls " + bottom.GetName())
			akActor.EquipItem(bottom, true, false)
			if rQuest.IsInSlot(bottom , rQuest.kPelvisUnderwearSlot) && !rQuest.IsInSlot(bottom , rQuest.kTorsoUnderwearSlot)
				Form top = rQuest.GetRandomSmall(rQuest.pTops)
				rQuest.Debug("Adding top " + top.GetName())
				akActor.EquipItem(top, true, false)
			endif
		endif
	endif
EndFunction
