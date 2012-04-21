/****************预编译程序参数******************
[Compiler]
Exe_Ico=
Exe_OutName=
Exe_Bin=
Exe_mpress=1
[Res]
Description=AutoHotkey_L 脚本
Version=1.1.7.3
Copyright=Copyright (C) 2012
首要图标
Del_ICON_Main=
源码脚本图标
Del_ICON_Shortcut=1
挂起图标
Del_ICON_Suspend=
暂停图标
Del_ICON_pause=
同时挂起与暂停图标
Del_ICON_S_P=
Win9x系统托盘首要图标
Del_ICON_Maim9x=1
Win9x系统挂起图标
Del_ICON_Suspend9x=1
托盘首要图标
Del_ICON_Tray=
默认快捷键
Del_key=
默认对话框
Del_Dialog=1
默认菜单
Del_Menu=
*/ ;==============================脚本开始====================================
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
Thread, Interrupt ,0

translateName=谷歌|百度|有道
StringSplit,translateName,translateName,|

Gui, Add, Edit, x1 y3 w598 h159 vEdit1,谷歌:英文→中文`n百度:自动`n有道:自动
;~ Gui, Add, DropDownList, x1 y164 w120 vComboBox1,
;~ Gui, Add, Text, x124 y167 w17 h12 , >>
;~ Gui, Add, DropDownList, x140 y164 w120 vComboBox2

Gui, Add, ListView,NoSort x1 y186 w599 h209 vListView1 gListViewClick, 网站|返回内容 [谷歌:英文→中文`n百度:自动`n有道:自动]
Loop,%translateName0%
{
	x:=10+70*A_index-60
	Name=% translateName%A_index%
	Gui, Add, CheckBox,Checked x%x% y165 h20 vCheckBox%A_index%, %Name%(&%A_index%)
	LV_Add("",Name)
}
Gui, Add, Button, x518 y162 w81 h23 gButton1, 翻译(&f)
Gui, Show, w604 h398, 在线翻译


return

GuiClose:
ExitApp

ListViewClick:
if A_GuiEvent=DoubleClick
{
	LV_GetText(GetText,A_EventInfo,2)
	if GetText!=
		Clipboard:=GetText
}
return

Button1:
Gui,Submit,Nohide

GuiControlGet,Check1,,CheckBox1
GuiControlGet,Check2,,CheckBox2
GuiControlGet,Check3,,CheckBox3
if Check1
	SetTimer,google,On
if Check2
	SetTimer,baidu,On
if Check3
	SetTimer,youdao,On

;~ LV_ModifyCol()
LV_ModifyCol(2,"AutoHdr")
return

google:
LV_Modify(1,"COL2","正在翻译...")
LV_Modify(1,"COL2","")
SetTimer,google,Off
Url=http://translate.google.com/translate_a/t?client=t&text=%Edit1%&sl=en&tl=zh
googlereText:= byteToStr(WinHttp(Url),"utf-8")
NeedleRegEx=O)"(.*?)"
FoundPos:=RegExMatch(googlereText,NeedleRegEx,OutMatch)
googleValue:=(! ErrorLevel) ? OutMatch.Value(1) :""
LV_Modify(1,"COL2",googleValue)
LV_ModifyCol(2,"AutoHdr")
return

baidu:
LV_Modify(2,"COL2","正在翻译...")
SetTimer,baidu,Off
Url=http://fanyi.baidu.com/transcontent
postdata=ie=utf-8&source=txt&query=%Edit1%&from=auto&to=auto
baidureText:= byteToStr(WinHttp(Url,"POST",postdata),"utf-8")

NeedleRegEx=O)dst":"(.*?)"
FoundPos:=RegExMatch(baidureText,NeedleRegEx,OutMatch)
baiduValue:=(! ErrorLevel) ? OutMatch.Value(1) : ""
LV_Modify(2,"COL2",baiduValue)
LV_ModifyCol(2,"AutoHdr")
return


youdao:
LV_Modify(3,"COL2","正在翻译...")
LV_Modify(3,"COL2","")
SetTimer,youdao,Off
Url=http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule&smartresult=ugc&sessionFrom=null
postdata=type=AUTO&i=%Edit1%&doctype=json&xmlVersion=1.4&keyfrom=fanyi.web&ue=UTF-8&typoResult=true&flag=false
youdaoreText:= byteToStr(WinHttp(Url,"POST",postdata),"utf-8")

NeedleRegEx=O)tgt":"(.*?)"
FoundPos:=RegExMatch(youdaoreText,NeedleRegEx,OutMatch)
youdaoValue:=(ErrorLevel) ? :OutMatch.Value(1)
NeedleRegEx=O)entries":\["","(.*?)"
FoundPos:=RegExMatch(youdaoreText,NeedleRegEx,OutMatch)
youdaoValue.=(! ErrorLevel and OutMatch.Value(1)="") ? :" //词典: " OutMatch.Value(1)
LV_Modify(3,"COL2",youdaoValue)
LV_ModifyCol(2,"AutoHdr")
return




WinHttp(Httpurl,Httpmode="GET",Httppostdata=""){
   StringUpper Httpmode,Httpmode
   ;~ XMLHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   XMLHTTP := ComObjCreate("Microsoft.XMLHTTP")
   XMLHTTP.open(Httpmode,Httpurl,false)
   XMLHTTP.setRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20100101 Firefox/11.0")
   if Httpmode=POST 
	{
		XMLHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
		XMLHTTP.send(Httppostdata)
	}else
		XMLHTTP.send()
   ;~ return XMLHTTP.responseText
   return XMLHTTP.ResponseBody
}

;将原始数据流以指定的编码的形式读出
byteToStr(body, charset){
	Stream := ComObjCreate("Adodb.Stream")
	Stream.Type := 1
	Stream.Mode := 3
	Stream.Open()
	Stream.Write(body)
	Stream.Position := 0
	Stream.Type := 2
	Stream.Charset := charset
	str := Stream.ReadText()
	Stream.Close()
	return str
}