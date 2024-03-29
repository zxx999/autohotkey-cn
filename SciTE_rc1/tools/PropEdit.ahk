;
; File encoding:  UTF-8
; Platform:  Windows XP/Vista/7
; Author:    A.N.Other <myemail@nowhere.com>
;
; Script description:
;	Template script
;

#NoEnv
#NoTrayIcon
#SingleInstance Ignore
SendMode Input
SetWorkingDir, %A_ScriptDir%

Menu, Tray, Icon, ..\toolicon.icl, 17

IsPortable := FileExist(A_ScriptDir "\..\$PORTABLE")
if !IsPortable
	LocalSciTEPath = %A_MyDocuments%\AutoHotkey\SciTE
else
	LocalSciTEPath = %A_ScriptDir%\..\user

scite := GetSciTEInstance()
if !scite
{
	MsgBox, 16, SciTE properties editor, Can't find SciTE!
	ExitApp
}

UserPropsFile = %LocalSciTEPath%\_config.properties

IfNotExist, %UserPropsFile%
{
	MsgBox, 16, SciTE properties editor, Can't find user properties file!
	ExitApp
}

FileEncoding, UTF-8
FileRead, UserProps, %UserPropsFile%

cplist_v := "0|65001|932|936|949|950|1361"
cplist_n := "System default|UTF-8|Shift-JIS|Chinese GBK|Korean Wansung|Chinese Big5|Korean Johab"

p_style  := FindProp("import Styles\\(.*)\.style", "Classic")
p_locale := FindProp("locale\.properties=locales\\(.*)\.locale\.properties", "English")
p_encoding := FindProp("code\.page=(" cplist_v ")", 0)
p_backup := FindProp("make\.backup=([01])", 1)
p_savepos := FindProp("save\.position=([01])", 1)
p_zoom := FindProp("magnification=(-?\d+)", -1)

org_locale := p_locale
org_zoom := p_zoom

stylelist := CountStylesAndChoose(ch1)
localelist := CountLocalesAndChoose(ch2)
p_encoding := FindInList(cplist_v, p_encoding)

Gui, +ToolWindow +AlwaysOnTop

Gui, Add, Text, Section +Right w70, 语言:
Gui, Add, DDL, ys R10 Choose%ch2% vp_locale, %localelist%

Gui, Add, Text, xs Section +Right w70, 配色方案:
Gui, Add, DDL, ys Choose%ch1% vp_style, %stylelist%

Gui, Add, Text, xs Section +Right w70, 文件编码:
Gui, Add, DDL, ys +AltSubmit Choose%p_encoding% vp_encoding, %cplist_n%

Gui, Add, Text, xs Section +Right w70, 默认缩放:
Gui, Add, Edit, ys w50
Gui, Add, UpDown, vp_zoom Range-10-10, %p_zoom%

Gui, Add, Text, xs Section +Right w70, 自动备份:
Gui, Add, CheckBox, ys Checked%p_backup% vp_backup

Gui, Add, Text, xs Section +Right, 记住窗口的位置:
Gui, Add, CheckBox, ys Checked%p_savepos% vp_savepos

Gui, Add, Button, xs+70 gUpdate, 更新
Gui, Show,, SciTE 设置
return

GuiClose:
ExitApp

Update:
Gui, Submit, NoHide

p_encoding := GetItem(cplist_v, p_encoding)

UserProps =
(
# THIS FILE IS SCRIPT-GENERATED - DON'T TOUCH
locale.properties=locales\%p_locale%.locale.properties
make.backup=%p_backup%
code.page=%p_encoding%
output.code.page=%p_encoding%
save.position=%p_savepos%
magnification=%p_zoom%
import Styles\%p_style%.style
import _extensions
)

FileDelete, %UserPropsFile%
FileAppend, %UserProps%, *%UserPropsFile%

; Reload properties
scite.ReloadProps()

if scite && (p_locale != org_locale || p_zoom != org_zoom)
{
	Gui, +OwnDialogs
	MsgBox, 52, SciTE properties editor, Changing the language or the zoom value requires restarting SciTE.`nReopen SciTE?
	IfMsgBox, Yes
	{
		Gui, Destroy
		;WinClose, ahk_id %scite%
		WinClose, % "ahk_id " scite.GetSciTEHandle()
		WinWaitClose,,, 10
		if !ErrorLevel
			Run, %A_ScriptDir%\..\SciTE.exe
		ExitApp
	}
}

return

FindProp(regex, default="")
{
	global UserProps
	return RegExMatch(UserProps, "`am)^" regex "$", o) ? o1 : default
}

ReplaceProp(regex, repl)
{
	global UserProps
	UserProps := RegExReplace(UserProps, "`am)^" regex "$", repl)
}

CountStylesAndChoose(ByRef choosenum)
{
	global p_style, LocalSciTEPath
	i := 1
	
	Loop, %LocalSciTEPath%\Styles\*.properties
	{
		if !RegExMatch(A_LoopFileName, "\.style\.properties$")
			continue
		style := RegExReplace(A_LoopFileName, "\.style\.properties$")
		if(style = p_style)
			choosenum := i
		list .= "|" Style
		i ++
	}
	StringTrimLeft, list, list, 1
	return list
}

CountLocalesAndChoose(ByRef choosenum)
{
	global p_locale
	i := 1
	
	Loop, %A_ScriptDir%\..\locales\*.properties
	{
		if !RegExMatch(A_LoopFileName, "\.locale\.properties$")
			continue
		locale := RegExReplace(A_LoopFileName, "\.locale\.properties$")
		if (locale = p_locale)
			choosenum := i
		list .= "|" locale
		i ++
	}
	StringTrimLeft, list, list, 1
	return list
}

FindInList(ByRef list, item, delim="|")
{
	Loop, Parse, list, %delim%
		if (A_LoopField = item)
			return A_Index
}

GetItem(ByRef list, id, delim="|")
{
	Loop, Parse, list, %delim%
		if (A_Index = id)
			return A_LoopField
}

Util_Is64bitWindows()
{
	DllCall("IsWow64Process", "ptr", DllCall("GetCurrentProcess", "ptr"), "uint*", retval)
	if ErrorLevel
		return 0
	else
		return retval
}

Util_Is64bitProcess(pid)
{
	if !Util_Is64bitWindows()
		return 0
	
	proc := DllCall("OpenProcess", "uint", 0x0400, "uint", 0, "uint", pid, "ptr")
	DllCall("IsWow64Process", "ptr", proc, "uint*", retval)
	DllCall("CloseHandle", "ptr", proc)
	return retval ? 0 : 1
}
