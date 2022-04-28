Scriptname SmallsEffect extends ActiveMagicEffect  

SmallsQuest Property rQuest  Auto  


Event OnEffectStart(Actor akTarget, Actor akCaster)
	GoToState("busy")
    if !rQuest.EffectStarted(akTarget, akCaster)
		Dispel()
	EndIf
	GoToState("")
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	Actor target = GetTargetActor()
	GoToState("busy")
    if !rQuest.EffectObjectUnequipped(akBaseObject, akReference, target)
		Dispel()
	endif
	GoToState("")
EndEvent

State busy
	Event OnEffectStart(Actor akTarget, Actor akCaster)
	EndEvent

	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
EndState
