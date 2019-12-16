Scriptname SmallsLoadGameAlias extends ReferenceAlias

event OnPlayerLoadGame()
  Debug.Trace("load game called" )
	(GetOwningQuest() as SKI_QuestBase).OnGameReload()
endEvent
