;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__0003AA7A Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
DarkBrotherhood DBScript = GetOwningQuest() as DarkBrotherhood
AKSpeaker.SetPlayerTeammate(False)
PlayerFollowerCount.SetValue(0)
DBScript.Initiate1Follower = 0
DBScript.Initiate1State = 1
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property PlayerFollowerCount  Auto  
