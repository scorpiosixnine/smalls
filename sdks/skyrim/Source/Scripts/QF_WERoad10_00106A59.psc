;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 15
Scriptname QF_WERoad10_00106A59 Extends Quest Hidden

;BEGIN ALIAS PROPERTY TravelMarker2
;ALIAS PROPERTY TYPE referencealias
referencealias Property Alias_TravelMarker2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myHoldLocation
;ALIAS PROPERTY TYPE locationalias
locationalias Property Alias_myHoldLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myHoldContested
;ALIAS PROPERTY TYPE locationalias
locationalias Property Alias_myHoldContested Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myHoldImperial
;ALIAS PROPERTY TYPE locationalias
locationalias Property Alias_myHoldImperial Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PaintedCow
;ALIAS PROPERTY TYPE referencealias
referencealias Property Alias_PaintedCow Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Trigger
;ALIAS PROPERTY TYPE referencealias
referencealias Property Alias_Trigger Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY GiantCampCenterMarker
;ALIAS PROPERTY TYPE referencealias
referencealias Property Alias_GiantCampCenterMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MarkerInCurrentHold
;ALIAS PROPERTY TYPE referencealias
referencealias Property Alias_MarkerInCurrentHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myHoldSons
;ALIAS PROPERTY TYPE locationalias
locationalias Property Alias_myHoldSons Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY AppropriateLocation
;ALIAS PROPERTY TYPE locationalias
locationalias Property Alias_AppropriateLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY TravelMarker1
;ALIAS PROPERTY TYPE referencealias
referencealias Property Alias_TravelMarker1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Giant
;ALIAS PROPERTY TYPE referencealias
referencealias Property Alias_Giant Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
(Alias_Giant.GetReference() as Actor).startCombat(Alias_PaintedCow.GetReference() as Actor)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN AUTOCAST TYPE WEScript
Quest __temp = self as Quest
WEScript kmyQuest = __temp as WEScript
;END AUTOCAST
;BEGIN CODE
; debug.trace(self + "stage 255, calling ReArmTrigger() on trigger" + Alias_Trigger.GetReference())
(Alias_Trigger.GetReference() as WETriggerScript).ReArmTrigger()

alias_Giant.GetReference().DeleteWhenAble()
alias_PaintedCow.GetReference().DeleteWhenAble()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE WEScript
Quest __temp = self as Quest
WEScript kmyQuest = __temp as WEScript
;END AUTOCAST
;BEGIN CODE
; debug.trace(self + "stage 0")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
