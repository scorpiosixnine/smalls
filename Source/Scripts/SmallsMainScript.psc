Scriptname SmallsMainScript extends ReferenceAlias
{Script with the main stuff in}

SmallsQuest property rQuest  auto

function TargetUpdated()
	RegisterForMenu("ContainerMenu")
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
	Actor player = rQuest.GetTarget()
	if (armour)
		int mask = armour.getSlotMask()
		if (rQuest.IsInSlot(armour, rQuest.kBodySlot) && !rQuest.IsSmalls(armour))
			rQuest.Debug("Unequipped armour")
			int gender = player.GetLeveledActorBase().GetSex()
			rQuest.Debug("gender is " + gender)
			if !rQuest.IsSmalls(armour)
				EquipSmalls(player, gender)
			endif
		else
			rQuest.Debug("Uneqipped slotmask: " + armour.getSlotMask())
		endif
	endif
endEvent

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
	Armor item = rQuest.GetRandomSmall(rQuest.pMale)
	if (item)
		rQuest.Debug("Adding smalls " + item.GetName())
		akActor.EquipItem(item, true, false)
	endif
EndFunction

function EquipFemaleSmalls(Actor akActor)
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
EndFunction
