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
	; Armor armour = akBaseObject as Armor
	; Actor target = rQuest.GetTarget()
	; if (armour && target.IsDead())
	; 	int mask = armour.getSlotMask()
	; 	if (rQuest.IsInSlot(armour, rQuest.kBodySlot) && !rQuest.IsSmalls(armour))
	; 		rQuest.Debug("Unequipped armour")
	; 		int gender = target.GetLeveledActorBase().GetSex()
	; 		rQuest.Debug("gender is " + gender)
	; 		if !rQuest.IsSmalls(armour)
	; 			EquipSmalls(target, gender)
	; 		endif
	; 	else
	; 		rQuest.Debug("Uneqipped slotmask: " + armour.getSlotMask())
	; 	endif
	; endif
endEvent


