;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__0002413B Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;Set DarkSideContractDialogue.AnoriathThreat to 1
DarkSideContractDialogue DarkSideScript = pSideContractDialogue as DarkSideContractDialogue
DarkSideScript.AnoriathThreat = 1
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property pSideContractDialogue  Auto  
