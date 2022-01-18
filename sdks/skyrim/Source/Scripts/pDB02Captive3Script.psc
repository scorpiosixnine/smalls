Scriptname pDB02Captive3Script extends ObjectReference  

Quest Property pDB02  Auto  

Event OnDeath(Actor aThisGuyKilledMe)

DB02Script Script = pDB02 as DB02Script

if pDB02.GetStage () < 30
	Script.pCaptivesKilled = Script.pCaptivesKilled +1
	pDB02.SetStage (30)
endif	 

Script.Captive3Dead = 1

EndEvent

