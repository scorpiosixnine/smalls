;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIF__00053320 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
akspeaker.RemoveItem(MarkarthExcavationSiteKey, 1)
Game.GetPlayer().AddItem(MarkarthExcavationSiteKey, 1)
FreeformMarkarthO.SetStage(10)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Key Property MarkarthExcavationSiteKey  Auto  

quest Property FreeformMarkarthO  Auto  
