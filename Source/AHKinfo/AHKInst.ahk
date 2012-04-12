#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#NoTrayIcon
Full_ico=Full.ico
Null_ico=Null.ico
Cross_CUR=Cross.CUR
DetectHiddenText,on

Gui, Add, GroupBox, x7 y10 w341 h72 , 窗口识别
Gui, Add, CheckBox, x115 y11 w48 h14 , 标题
Gui, Add, CheckBox, x185 y10 w51 h15 , 类名
Gui, Add, CheckBox, x250 y11 w63 h14 , 进程名

Gui, Add, Text, x16 y31 w37 h14 , 标题:
Gui, Add, Edit, x56 y29 w281 h18 vControl1, 
Gui, Add, Text, x18 y52 w37 h14 , 文本:
Gui, Add, ComboBox, x56 y50 w281 vControl2,
Gui, Add, Picture, x362 y29 w32 h32 gPic vPic,
GuiControl,,Pic,%Full_ico%

Gui, Add, GroupBox, x6 y85 w400 h57 , 窗口命令
Gui, Add, Text, x13 y107 w43 h18 , 命令:
Gui, Add, DropDownList, x56 y106 w280 h21 vControl3,
Gui, Add, Button, x346 y106 w55 h24 , 插入

Gui, Add, GroupBox, x5 y145 w401 h403 , 控件列表
Gui, Add, ListView, Checked x8 y163 w395 h333 vControl4, 控件类名|文本

Gui, Add, Edit,vControl5, 

Gui, Show, w415 h556, Untitled GUI
return

GuiClose:
ExitApp

Pic:
CursorHandle := DllCall( "LoadCursorFromFile", Str,Cross_CUR )
DllCall( "SetSystemCursor", Uint,CursorHandle, Int,32512 )
;设置为空图标
GuiControl,,Pic,%Null_ico%
KeyWait,LButton
DllCall( "SystemParametersInfo", UInt,0x57, UInt,0, UInt,0, UInt,0 )
;图标设置为原样
GuiControl,,Pic,%Full_ico%
;=====================
;清空内容
Loop,4
	GuiControl,,Control%A_index%,|

;====================
MouseGetPos,OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, 0
;标题
WinGetTitle,OutputWinTitle,ahk_id %OutputVarWin%
GuiControl,,Control1,%OutputWinTitle%
;文本
WinGetText,OutputWinText,ahk_id %OutputVarWin%
StringSplit,WinTextArray,OutputWinText,`r`n
Loop,%WinTextArray0%
{
	WinText:=WinTextArray%A_index%
	GuiControl,,Control2,%WinText%

}
GuiControl, Choose, Control2,1
;控件
WinGet,ControlList,ControlList,ahk_id %OutputVarWin%
LV_Delete()
Loop, Parse,ControlList,`n
{
	ControlGetText,ControlListText,%A_LoopField%,ahk_id %OutputVarWin%
	LV_Add("",A_LoopField,ControlListText)
}
LV_ModifyCol()
return