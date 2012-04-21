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
Del_key=1
默认对话框
Del_Dialog=1
默认菜单
Del_Menu=
*/ ;==============================脚本开始====================================
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, ToolTip
CoordMode, Mouse
Thread, Interrupt ,0

~MButton::
ToolTip,正在翻译: %Clipboard%,A_ScreenWidth,A_ScreenHeight-50
SetTimer,translate,On
return

translate:
SetTimer,translate,Off

Url=http://translate.google.com/translate_a/t?client=t&text=%Clipboard%&hl=zh-CN&sl=en&tl=zh-CN&multires=1&otf=1&pc=1&ssel=0&tsel=0&sc=1
reText:= byteToStr(WinHttp(Url),"utf-8")
RegEx=O)"(.*?)"
RegExMatch(reText,RegEx , SubPat)
if ! ErrorLevel
{
Clipboard:=SubPat.Value(1)

ToolTip,翻译结果: %Clipboard%,A_ScreenWidth,A_ScreenHeight-50
} else
	ToolTip,各种原因!我不知道怎么回事!,A_ScreenWidth,A_ScreenHeight-50
SetTimer, RemoveToolTip, 2000
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
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