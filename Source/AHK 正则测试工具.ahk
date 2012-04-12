Gui, Add, Edit, x6 y7 w533 h140 vEdit1 gMatch
Gui, Add, Text, x6 y155  h15 , 表达式: O)
Gui, Add, Edit,-Multi x66 y151 w438  vEdit2 gMatch 
Gui, Add, Edit,-Multi Number Center x508 y151 w30 vEdit3,1
Gui, Add, Tab2,Buttons Left x5 y174 w534 h179,预览|代码
Gui, Tab,1
Gui, Add, ListView,NoSort x25 y174 w515 h179 ,序号|子字符串(Value)
Gui, Tab,2
Gui, Add, Edit,x25 y174 w515 h179 vEdit4
Gui, Show, w546 h362, AHK 正则测试工具 [对象模式]

return

GuiClose:
ExitApp

Match:
Gui,Submit,Nohide
LV_Delete()
FoundPos:=RegExMatch(Edit1,"O)" Edit2,OutMatch)
if ErrorLevel =0
{
	Count:=OutMatch.Count()
	Loop,%Count%
		LV_Add("",A_Index,OutMatch.Value(A_Index))
	GuiControlGet,NeedleRegEx,,Edit2
	MatchText=
	(
	Haystack=这里为源字符串,请自行修改
	NeedleRegEx=O)%NeedleRegEx%
	FoundPos:=RegExMatch(Haystack,NeedleRegEx,OutMatch)
	MsgCount:=OutMatch.Count()
	Msg1:=OutMatch.Value(1)
	MsgBox,匹配数量: `%MsgCount`%``n其中第一个为: `%Msg1`%
	)
	StringReplace,MatchText,MatchText,%A_Tab% ,,All
	GuiControl,,Edit4,%MatchText%
}else
	LV_Add("",-1,ErrorLevel)