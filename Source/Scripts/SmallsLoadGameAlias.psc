Scriptname SmallsLoadGameAlias extends ReferenceAlias

event OnPlayerLoadGame()
    Debug.Notification("load game called" )
	(GetOwningQuest() as SKI_QuestBase).OnGameReload()
endEvent
