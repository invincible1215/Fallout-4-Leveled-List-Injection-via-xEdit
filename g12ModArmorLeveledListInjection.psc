ScriptName g12ModArmorLeveledListInjection extends Quest

;-- Structs -----------------------------------------

Struct SingleInjection
	Form ArmorFormID
	{ armor to inject }
	LeveledItem TargetLeveledList
	{ leveled list to inject armor record }
	int Level = 1
	{ level it should show up at }
	int Count = 1
	{ count of item to add }
EndStruct

Struct FormIDListInjection
	FormList ArmorFormList
	{ form id list containing armor records }
	LeveledItem TargetLeveledList
	{ leveled list to inject armor records }
	int Level = 1
	{ level they should show up at }
	int Count = 1
	{ count of items to add }
EndStruct

Struct LeveledListInjection
	LeveledItem ArmorLeveledList
	{ leveled list containing armor records }
	LeveledItem TargetLeveledList
	{ leveled list to inject armor records }
	int Level = 1
	{ level they should show up at }
	int Count = 1
	{ count of items to add }
EndStruct

;-- Properties --------------------------------------

Group Variables
	bool Property bSingleInjection = False Auto Const
	{ set to true if using SingleInjection array }
	bool Property bFormIDListInjection = False Auto Const
	{ set to true if using FormIDListInjection array }
	bool Property bLeveledListInjection = False Auto Const
	{ set to true if using LeveledListInjection array }
EndGroup

Group Properties
	SingleInjection[] Property SingleArmor Auto Const
	{ for injecting single armor record into leveled lists }
    FormIDListInjection[] Property FormIDListArmor Auto Const
	{ for injecting form id list into leveled lists }
    LeveledListInjection[] Property LeveledListArmor Auto Const
	{ for injecting mod added leveled list into leveled lists }
	Message Property InstalledMessage Auto Const
	{ message to show if outfits are injected successfully }
	GlobalVariable Property InjectedGlobal Auto Const
	{ global used to track injection status, gets set to 1 once injected }
	string Property ModName Auto Const
	{ esp name, used for trace logs }
EndGroup

;-- Functions ---------------------------------------

bool Function InjectOutfits()
	If (InjectedGlobal.GetValue() == 0 as float)
		If (bSingleInjection)
			int Single = 0
			While (Single < SingleArmor.length)
            	SingleArmor[Single].TargetLeveledList.AddForm(SingleArmor[Single].ArmorFormID as Form, SingleArmor[Single].Level, SingleArmor[Single].Count)
				Single += 1
			EndWhile
            Debug.Trace(ModName + ": Injected " + Single as string + " Single Armor.", 0)
		EndIf
		If (bFormIDListInjection)
			int Multiple = 0
			int OutfitCount = 0
			While (Multiple < FormIDListArmor.length)
				FormList CurrentList = FormIDListArmor[Multiple].ArmorFormList
				LeveledItem CurrentLL = FormIDListArmor[Multiple].TargetLeveledList
				int CurrentCount = FormIDListArmor[Multiple].Count
				int CurrentLevel = FormIDListArmor[Multiple].Level
				int List = 0
				While (List < CurrentList.GetSize())
					CurrentLL.AddForm(CurrentList.GetAt(List), CurrentLevel, CurrentCount)
					OutfitCount += 1
					List += 1
				EndWhile
				Multiple += 1
			EndWhile
			InstalledMessage.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)
            Debug.Trace(ModName + ": Injected " + Multiple as string + " Armor FormID List.", 0)
		EndIf
        If (bLeveledListInjection)
			int Single = 0
			While (Single < LeveledListArmor.length)
				LeveledListArmor[Single].TargetLeveledList.AddForm(LeveledListArmor[Single].ArmorLeveledList as Form, LeveledListArmor[Single].Level, LeveledListArmor[Single].Count)
				Single += 1
				Debug.Trace(ModName + ": Injected g12")
            EndWhile
            Debug.Trace(ModName + ": Injected g12")
        EndIf
		InjectedGlobal.SetValue(1 as float)
		return True
	Else
		return False
	EndIf
EndFunction

Event OnQuestInit()
	Debug.MessageBox("g12!")
	If (Self.InjectOutfits() == True)
		Utility.Wait(5)
		InstalledMessage.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)
	EndIf
EndEvent
